import Foundation
import ArgumentParser

extension AdventOfCode2022 {
    struct Day3: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            SolutionDay3.Part1(input:d.dataAsStringArray(omittingEmptySubsequences: true))
            SolutionDay3.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
        }
    }
}

struct SolutionDay3 {
    static let allLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    static func letterValue(_ needle: Character) -> Int {
        let haystack = Array(allLetters)
        return haystack.firstIndex(of: needle)! + 1
    }
    
    static func Part1(input:[String]) {
        let bags = input.map {Array($0)}
        var result : [Int] = []
        
        for bag in bags {            
            let left = Set(bag.prefix(bag.count / 2))
            let right = Set(bag.suffix(bag.count / 2))
            
            let common = left.intersection(right)
            
            result.append(contentsOf: (common.map { letterValue($0)}))
        }
        print(result.reduce(0, +))
    }
    
    static func Part2(input:[String]) {
        let bags = input.map {Array($0)}
        var result : [Int] = []
        
        for start in stride(from: 0, to: input.count, by: 3) {
            let groupCommon = (0..<3).map ({
                Set(bags[start + $0])
            }).reduce(Set(allLetters), {$0.intersection($1)})
                .map {letterValue($0)}
            
            result.append(contentsOf: groupCommon)
        }
        print(result.reduce(0, +))
    }
}
