import Foundation
import ArgumentParser
import Parsing
import Algorithms

extension AdventOfCode2022 {
    struct Day8: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay8()
            
            solution.Part1(input:d.dataAsString())
            solution.Part2(input:d.dataAsString())
        }
    }
}

struct SolutionDay8 {
    
    static let lineParser = Parse { Many { Prefix(1) { $0.isNumber }.map{Int($0)!} } }
    static let inputParser = Many { lineParser} separator: { "\n" }
    func Part1(input:String) {

        let inputMatrix = try! SolutionDay8.inputParser.parse(input).filter {$0.count > 0}
        let size = inputMatrix.count
        var visibilityMatrix = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        for x in 0..<size {
            for y in 0..<size {
                // Four Ranges: [0..<x][y] [x+1..<size][y] [x][0..<y] [x][y+1..<size]
                //True if not blocking
                if inputMatrix[0..<x].allSatisfy({$0[y] < inputMatrix[x][y]}) ||
                    inputMatrix[x+1..<size].allSatisfy({$0[y] < inputMatrix[x][y]}) {
                    visibilityMatrix[x][y] = 1
                }
                
                if inputMatrix[x][0..<y].allSatisfy({$0 < inputMatrix[x][y]}) ||
                    inputMatrix[x][y+1..<size].allSatisfy({$0 < inputMatrix[x][y]}) {
                    visibilityMatrix[x][y] = 1
                }
            }
        }
        print(visibilityMatrix.map { $0.reduce(0, +)}.reduce(0, +))
    }
    
    func scoreDirection(view:[Int], height:Int) -> Int {
        var visibility = 0
        for tree in view {
            if tree >= height {
                return visibility + 1
            }
            visibility += 1
        }
        return visibility
    }
    
    func Part2(input:String) {

        let inputMatrix = try! SolutionDay8.inputParser.parse(input).filter {$0.count > 0}
        let size = inputMatrix.count
        var visibilityMatrix = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        for x in 0..<size {
            for y in 0..<size {
                let scores : [Int] = [
                    self.scoreDirection(view: inputMatrix[(0..<x)].reversed().map{$0[y]}, height: inputMatrix[x][y]),
                    self.scoreDirection(view: inputMatrix[x+1..<size].map{$0[y]}, height: inputMatrix[x][y]),
                    self.scoreDirection(view: inputMatrix[x][0..<y].reversed(), height: inputMatrix[x][y]),
                    self.scoreDirection(view: inputMatrix[x][y+1..<size].map{$0}, height: inputMatrix[x][y]),
                ]
                
                visibilityMatrix[x][y] = scores.reduce(1, *)
            }
        }
        print(visibilityMatrix.map { $0.max()!}.max()!)
    }
    
}
