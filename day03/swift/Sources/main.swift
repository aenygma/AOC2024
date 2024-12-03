// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(macOS 13, *)
struct Mull {

    let filename: URL
    let regexMul: Regex<(Substring, one: Substring, two: Substring)> 
    let enableToken = "do()"
    let disableToken = "don't()"

    init(filename: URL) {
        regexMul = #/mul\((?<one>\d+),(?<two>\d+)\)/#
        self.filename = filename
    }

    private func parseData() throws -> String {
        return try String(contentsOf: filename)
    }

    private func eval(content: String) -> Int {
        return content.matches(of: regexMul).compactMap { Int($0.one)! * Int($0.two)! }.sum()
    }

    func part1() throws {
        let result = eval(content: try parseData())
        print("result: \(result)")
    }

    func part2() throws {
        let content = try parseData()
        let chunks = content.split(separator: disableToken)

        // By default mul is on, until a "don't"
        // TODO: check if can be optimized
        var result = eval(content: String(chunks[0]))
        for chunk in chunks[1...] {
            // check if this don't chunk has a "do()" that'd enable it
            if let enable = chunk.range(of: enableToken){
                result += eval(content: String(chunk[enable.lowerBound...]))
            }
        }
        print("result: \(result)")
    }
}

extension Collection where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

let testData = URL(fileURLWithPath: #file).baseURL?.appendingPathComponent("data")
if #available(macOS 13, *) {
    let m = Mull(filename: testData!)
    try m.part1()
    try m.part2()
}
