// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation 

let data = "/Users/uttie/Projects/advent_of_code/day01/data"

struct ListReader {
    private(set) var entries: [[Int]] = []

    mutating private func addToList(_ entry: [Int]) {
        entries.append(entry)
    }

    // parseData read a given filename and unmarshalls them into lhs, and rhs arrays respectively
    mutating func parseData(filename: String) throws {
        // slurp data
        if let contents = try? String(contentsOfFile: filename) {
            let lines = contents.split(separator:"\n")
            for line in lines {
                let values = line.split(separator: " ").compactMap {Int($0)}
                addToList(values)
            }
        } else {
            throw ListReaderError.failedToReadData
        }
    }

    // Monotonic helpers
    private func isPositive(_ val: Int) -> Bool { return (val > 0) }
    private func isNegative(_ val: Int) -> Bool { return (val < 0) }

    // validate monotonicity
    private func isMonotonic(arr: [Int]) -> Bool {
        return arr.allSatisfy {isPositive($0)} || arr.allSatisfy{isNegative($0)}
    }

    private func howManyNonMonotonic(arr: [Int]) -> Int {
        return [ arr.count - arr.count{isPositive($0)}, arr.count - arr.count{isNegative($0)}].min()! 
    }

    // validate bounds
    private func isBounded(_ val: Int, lower: Int, upper: Int) -> Bool {
        return (abs(val) >= lower) && (abs(val) <= upper)
    }

    private func isBounded(arr: [Int], lower: Int, upper: Int) -> Bool {
        return arr.allSatisfy { isBounded($0, lower:lower, upper:upper) }
    }

    private func howManyNonBounded(arr: [Int], lower: Int, upper: Int) -> Int {
        return arr.count - arr.count{isBounded($0, lower: lower, upper:upper)}
    }

    func part1() {

        func eval(entry: [Int]) -> Bool {
            var differenceArray = [Int]()
            for (idx, each) in entry[1...entry.count-1].enumerated() {
                let difference = (each - entry[idx])
                differenceArray.append(difference)
            }
            return isBounded(arr: differenceArray, lower: 1, upper: 3) && isMonotonic(arr: differenceArray)
        }

        let count = entries.map(eval).filter{$0 == true}.count
        print("Found total safe: \(count)")
    }

    func part2() {

        func eval(entry: [Int]) -> Bool {
            var faults: Int = 0
            var differenceArray = [Int]()
            for (idx, each) in entry[1...entry.count-1].enumerated() {
                let difference = (each - entry[idx])
                differenceArray.append(difference)
            }

            // Use part 1 to bail early if satisfied
            if isBounded(arr: differenceArray, lower: 1, upper: 3) && isMonotonic(arr: differenceArray){
                return true
            }

            if howManyNonMonotonic(arr: differenceArray) > 1 {
                return false
            }

            if differenceArray.filter({ abs($0) > 3 }).count > 0 {
                return false 
            }

            print(entry)
            print(differenceArray)

            print(howManyNonMonotonic(arr: differenceArray))
            return true
        }

        //let count = entries.map(eval).filter{$0 == true}.count
        let results = entries.map(eval).filter{$0 == true}
        print("Found total safe: \(results.count)")
    }

    init(filename: String) throws {
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

extension Collection {
    func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}

var l = try ListReader(filename: data)
l.part1()
l.part2()
