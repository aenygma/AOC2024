// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation 

let data = "/Users/uttie/Projects/advent_of_code/1/data"

struct ListReader {
    private(set) var lhs: [Int] = []
    private(set) var rhs: [Int] = []

    mutating func addToList(_ lhsValue: Int, _ rhsValue: Int) {
        lhs.append(lhsValue)
        rhs.append(rhsValue)
    }

    mutating func main() throws {
        print("main world")
        
        if let contents = try? String(contentsOfFile: data) {
            let lines = contents.components(separatedBy: "\n")
            for line in lines {
                let values = line.split(separator: " ").map {Int($0)}
                // TODO: make better
                if values.count != 2 {
                    throw ListReaderError.failedToUnpackData
                }
                addToList(values[0] as Int, values[1]? as Int)
            }
        } else {
            throw ListReaderError.failedToReadData
        }
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

try ListReader().main()
