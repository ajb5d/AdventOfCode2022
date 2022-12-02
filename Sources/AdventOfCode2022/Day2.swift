import Foundation
import ArgumentParser

extension AdventOfCode2022 {
    struct Day2: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        var input = true
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            SolutionDay2.Day2Part1(input:d.dataAsStringArray(omittingEmptySubsequences: true))
            SolutionDay2.Day2Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
        }
    }
}

struct SolutionDay2 {
    enum GameSide {
        case paper, scissors, rock
        
        func willDominate() -> GameSide {
            switch self {
            case .paper: return .rock
            case .scissors: return .paper
            case .rock: return .scissors
            }
        }
        
        func willBeDominatedBy() -> GameSide {
            switch self {
            case .paper: return .scissors
            case .scissors: return .rock
            case .rock: return .paper
            }
        }
        
        func gameScore(other: GameSide) -> Int {
            if self == other { return 3 }
            if other == self.willDominate() { return 6 }
            return 0
        }
    }
    
    static func scoreRound(them : GameSide, you : GameSide) -> Int {
        switch you {
        case .paper: return 2 + you.gameScore(other: them)
        case .scissors: return 3 + you.gameScore(other: them)
        case .rock: return 1 + you.gameScore(other: them)
        }
    }
    
    static func Day2Part1(input:[String]) {
        var totalScore = 0
        for round in input {
            let parts = round.split(separator: " ")
            var lhs : GameSide?, rhs : GameSide?
            
            switch parts[0] {
            case "A": lhs = .rock
            case "B": lhs = .paper
            case "C": lhs = .scissors
            default: break
            }
            
            switch parts[1] {
            case "X": rhs = .rock
            case "Y": rhs = .paper
            case "Z": rhs = .scissors
            default: break
            }
            
            totalScore += SolutionDay2.scoreRound(them: lhs!, you: rhs!)
        }
        
        print(totalScore)
        
    }
    
    static func Day2Part2(input:[String]) {
        var totalScore = 0
        for round in input {
            let parts = round.split(separator: " ")
            
            var lhs : GameSide?
            var rhs : GameSide?
            
            switch parts[0] {
            case "A": lhs = .rock
            case "B": lhs = .paper
            case "C": lhs = .scissors
            default: break
            }
            
            switch parts[1] {
            case "X": rhs = lhs?.willDominate()
            case "Y": rhs = lhs
            case "Z": rhs = lhs?.willBeDominatedBy()
            default: break
            }
            
            print(lhs!, rhs!)
            
            totalScore += SolutionDay2.scoreRound(them: lhs!, you: rhs!)
        }
        
        print(totalScore)
        
    }
}
