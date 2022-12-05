import Foundation
import ArgumentParser
import Parsing


extension AdventOfCode2022 {
    struct Day4: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay4()
            
            solution.Part1(input:d.dataAsStringArray(omittingEmptySubsequences: true))
            solution.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
        }
    }
}

struct SolutionDay4 {
    
    struct ElfRange{
        var lower : Int
        var upper : Int

        func totallyContains(_ other:ElfRange) -> Bool {
            return other.lower >= self.lower && other.upper <= self.upper
        }
        
        func overlaps(_ other:ElfRange) -> Bool {
            //(StartA <= EndB) and (EndA >= StartB)
            return self.lower <= other.upper && self.upper >= other.lower
        }
        
    }
    
    static let elfrange = Parse { Int.parser(); "-"; Int.parser() }.map {ElfRange(lower: $0.0, upper: $0.1)}
    static let lineparser = Parse { elfrange; ","; elfrange}
    
    func Part1(input:[String]) {
        let result = input.map {
            let t = try! SolutionDay4.lineparser.parse($0)
            return t.0.totallyContains(t.1) || t.1.totallyContains(t.0)
        }
        print(result.filter({$0}).count)
    }
    
    func Part2(input:[String]) {
        let result = input.map {
            let t = try! SolutionDay4.lineparser.parse($0)
            return t.0.overlaps(t.1)
        }
        print(result.filter({$0}).count)
    }
}
