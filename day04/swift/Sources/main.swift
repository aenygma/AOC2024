// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

struct Ceres {
    let filename: URL

    private func readFile() throws -> [String] {
        return try String(contentsOf: filename).split(separator: "\n").map {String($0)}
    }

    func transpose(rows: [String]) -> [String] {
        var cols = [String]()
        for rowNum in 0...rows.count-1 {
            cols.append(rows.compactMap {String($0)[rowNum]}.joined(separator: "") )
        }
		return cols
    }

	func rotateCW(rows: [String]) -> [String] {
		var result = [String]()
		for trace in 0...2*rows.count-1 {
			var tmp = String()
			for row in 0...rows.count-1 {
				let col = trace - row
				tmp.append(rows[row][col])
			}
			result.append(tmp)
		}
		return result
	}

	func flipVertical(rows: [String]) -> [String] {
		return rows.map{ String($0.reversed()) }
	}


	func findCountOf(needle: String, haystack: String) -> Int {
		let left = haystack.numberOfOccurrencesOf(string: needle)
		let right = String(haystack.reversed()).numberOfOccurrencesOf(string: needle)
		return left + right
	}

	enum direction {
		case horizontal
		case vertical
		case diagonalLeading
		case diagonalLagging
	}

	func find(_ dir: direction, matrix: [String]) -> Int {
		switch dir {
		case .horizontal:
			return matrix.map { findCountOf(needle: "XMAS", haystack: $0)}.sum()
		case .vertical:
			// vertical is just sideways horizontal
			let t = transpose(rows: matrix)
			return find(.horizontal, matrix: t)
		case .diagonalLeading:
			let r = rotateCW(rows: matrix)
			return find(.horizontal, matrix: r)
		case .diagonalLagging:
			let t = flipVertical(rows: matrix)
			return find(.diagonalLeading, matrix: t)
		}
	}

    func part1() throws -> Int {
        let matrix = try readFile()
		return find(.horizontal, matrix: matrix) 
				+ find(.vertical, matrix: matrix)
				+ find(.diagonalLeading, matrix: matrix)
				+ find(.diagonalLagging, matrix: matrix)
    }

	func trace(matrix: [String]) -> [String] {
		var result = [String]()
		for row in 0...matrix.count-1 {
			result.append(matrix[row][row])
		}
		//print("trace:")
		//print(result.joined(separator: ""))
		return result
	}

	func testXMAS(survey: [String]) throws -> Bool {
		//trace(matrix: survey)
		//let f = flipVertical(rows: survey)
		//trace(matrix: f)
        let one = trace(matrix: survey).joined(separator: "")
        guard (one == "MAS" || one == "SAM") else { return false }
        let f = flipVertical(rows: survey)
        let two = trace(matrix: f).joined(separator: "")
        guard (two == "MAS" || two == "SAM") else { return false }
        return true
	}

	func part2() throws {
		let matrix = try readFile()
		let searchString = "MAS"
        var survey = [String]()

        var count = 0
		for row in 0...matrix.count - searchString.count { 
			for col in 0...matrix.count - searchString.count {

                let tmpRows = matrix[row...row+2]
                survey = tmpRows.map{ 
                    $0.map { String($0) }[col...col+2].joined(separator: "")
                }
				print(survey)
		        count += try testXMAS(survey:survey).intValue
			}
		}
        print("Found: \(count)")
	}
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

	// count
	func numberOfOccurrencesOf(string: String) -> Int {
		return self.components(separatedBy:string).count - 1 
	}
}

extension Collection where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

let testData = URL(fileURLWithPath: #file).baseURL?.appendingPathComponent("../data")
let m = Ceres(filename: testData!)
//let part1 = try m.part1()
//print("Part1 | Found combos: \(part1)")
let part2 = try m.part2()

//try m.part2()
