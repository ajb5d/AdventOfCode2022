import Foundation
import ArgumentParser
import DequeModule

extension AdventOfCode2022 {
    struct Day6: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay6()
            
            solution.Part1(input:d.dataAsStringArray(omittingEmptySubsequences: true))
            solution.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
        }
    }
}

struct SolutionDay6 {
    func processLine(_ line:String, withUnqiueCharacters:Int = 4) -> Int {
        return Array(line).windows(ofCount: withUnqiueCharacters)
            .map {Set($0).count}
            .firstIndex(where: {$0 == withUnqiueCharacters})! + withUnqiueCharacters
    }

    func Part1(input:[String]) {
        print(input.map({self.processLine($0)}))
    }
    
    func Part2(input:[String]) {
        print(input.map({self.processLine($0, withUnqiueCharacters: 14)}))
    }
}
