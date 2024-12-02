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

    func part1() {

        func eval(entry: [Int]) -> Bool {
            var differenceArray = [Int]()
            for (idx, each) in entry[1...entry.count-1].enumerated() {
                let difference = (each - entry[idx])
                differenceArray.append(difference)

                // validate bounds 
                if abs(difference) < 1 {
                    return false
                } else if abs(difference) > 3 {
                    return false
                }
            }

            // validate monotonicity
            return differenceArray.allSatisfy {$0 > 0} || differenceArray.allSatisfy{$0 < 0}
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

                // validate bounds 
                if abs(difference) < 1 {
                    faults += 1
                } else if abs(difference) > 3 {
                    faults += 1
                }
            }

            // "Problem Dampener" - checkpoint 1
            // bail early if more than one fault
            if faults > 1 {
                return false
            }

            // validate monotonicity
            // count how many out of the entire list are monotonic increasing
            let increaseFault = differenceArray.count - differenceArray.map {$0 > 0}.count
            let decreaseFault = differenceArray.count - differenceArray.map {$0 < 0}.count

            // "Problem Dampener" - checkpoint 2
            if ((faults + increaseFault) > 1) || ((faults + decreaseFault > 1)) {
                print("\(entry) - false")
                return false
            }
            print("\(entry) - true - \(faults) - \(increaseFault) - \(decreaseFault)")
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

var l = try ListReader(filename: data)
l.part1()
