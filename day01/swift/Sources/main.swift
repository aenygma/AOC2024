// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation 

struct ListReader {
    private(set) var lhs: [Int] = []
    private(set) var rhs: [Int] = []

    mutating func addToList(_ lhsValue: Int, _ rhsValue: Int) {
        lhs.append(lhsValue)
        rhs.append(rhsValue)
    }

    // parseData read a given filename and unmarshalls them into lhs, and rhs arrays respectively
    mutating func parseData(filename: URL) throws {
        
        // slurp data
        if let contents = try? String(contentsOf: filename) {
            let lines = contents.split(separator:"\n")
            for line in lines {
                let values = line.split(separator: " ").compactMap {Int($0)}

                // catch odd cases where parsing failed
                if values.count != 2 {
                    print(values)
                    throw ListReaderError.failedToUnpackData
                }
                addToList(values[0], values[1])
            }
        } else {
            throw ListReaderError.failedToReadData
        }
    }

    func part1() -> Int {
        // how distance is calculated
        func distance(i: Int, j: Int) -> Int {
            return abs(i - j)
        }

        let l = lhs.sorted(by: <)
        let r = rhs.sorted(by: <)

        let answer = zip(l, r).compactMap(distance).sum()
        return answer

    }

    func part2() -> Int {
        // how distance is calculated
        func distance(needle: Int) -> Int {
            return needle * rhs.filter{$0 == needle}.count
        }

        let answer = lhs.map(distance).sum()
        return answer
    }

    init(filename: URL) throws {
        try parseData(filename: filename)
    }
}

extension ListReader {
    enum ListReaderError: Error, LocalizedError {
        case failedToReadData
        case failedToUnpackData

        public var errorDescription: String? {
            switch self {
                case .failedToReadData:
                    return "Failed to read data"
                case .failedToUnpackData:
                    return "Failed to unpack data"
            }
        }
    }
}

extension Sequence where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

let testData = URL(fileURLWithPath: #file).baseURL?.appendingPathComponent("../data")
var l = try ListReader(filename: testData!)
print("Part1 answer: ", l.part1())
print("Part2 answer: ", l.part2())
