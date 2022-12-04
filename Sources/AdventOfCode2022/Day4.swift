import Foundation
import ArgumentParser

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
            
            SolutionDay4.Part1(input:d.dataAsStringArray(omittingEmptySubsequences: true))
            SolutionDay4.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
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
    
    static func extractRange(_ input:Substring) -> ElfRange {
        let parts = input.split(separator: "-", maxSplits: 2)
        return ElfRange(lower: Int(parts[0])!, upper: Int(parts[1])!)
        
    }
    
    static func Part1(input:[String]) {
        var count = 0
        for line in input {
            let result = line.split(separator: ",")
                .map {extractRange($0)}
            
            if result[0].totallyContains(result[1]) || result[1].totallyContains(result[0]) {
                count += 1
            }
        }
        
        print(count)
    }
    
    static func Part2(input:[String]) {
        var count = 0
        for line in input {
            let result = line.split(separator: ",")
                .map {extractRange($0)}

            if result[0].overlaps(result[1]) {
                count += 1
            }
        }
        
        print(count)
    }
}
