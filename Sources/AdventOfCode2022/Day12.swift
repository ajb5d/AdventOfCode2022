import Foundation
import ArgumentParser
import Parsing
import Collections

extension AdventOfCode2022 {
    struct Day12: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay12()
            
            solution.Part1(input:d.dataAsString())
        }
    }
}

struct SolutionDay12 {
    
    static let lineParser = Parse {
        Many { Prefix(1) { $0.isLetter }.map { String($0)} } terminator: { "\n" }
    }
    static let inputParser = Parse {
        Many { lineParser } terminator: { Whitespace(.vertical) }
    }
    
    struct Location : CustomStringConvertible, Equatable {
        
        var description: String {
            return "Loc: \(x),\(y)" + ((cost < Int.max) ? " Cost: \(cost)": "")
        }
        
        var x : Int
        var y : Int
        var cost : Int = Int.max
        
        
    }
    
    func charToHeight(_ c : Character) -> Int {
        switch c {
        case "S": return 1
        case "E": return 26
        default: return Int(c.asciiValue! - Character("a").asciiValue! + 1)
        }
    }
    
    func Part1(input:String) {
        let grid = try! SolutionDay12.inputParser.parse(input)
        
        let startX = grid.firstIndex { $0.contains("S")}!
        let startY = grid[startX].firstIndex { $0 == "S"}!
        
        let start = Location(x: startX, y: startY, cost: 0)
        
        let endX = grid.firstIndex { $0.contains("E")}!
        let endY = grid[endX].firstIndex { $0 == "E"}!
        
        let end = Location(x: endX, y: endY)

        
        print("Start    \(start)")
        print("End      \(end)")
        
        var costs = Array(repeating: Array(repeating: Int.max, count: grid.count), count: grid.count)
        var heights = grid.map { $0.map { self.charToHeight($0.first!)}}

        print(heights)
    }
}
