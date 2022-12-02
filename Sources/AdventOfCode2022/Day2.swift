import Foundation
import ArgumentParser

extension AdventOfCode2022 {
    struct Day2: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        var input = false
        
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
    }
    
    static func scoreRound(them : GameSide, you : GameSide) -> Int {
        var score = 0;
        
        switch you {
        case .paper:
            score += 2
            switch them {
            case .paper:
                score += 3
            case .scissors: break
            case .rock:
                score += 6
            }
        case .scissors:
            score += 3
            switch them {
            case .paper:
                score += 6
            case .scissors:
                score += 3
            case .rock: break
            }
        case .rock:
            score += 1
            switch them  {
            case .paper: break
            case .scissors:
                score += 6
            case .rock:
                score += 3
            }
        }
        return score
    }
    
    static func Day2Part1(input:[String]) {
        var totalScore = 0
        for round in input {
            let parts = round.split(separator: " ")
            
            var lhs : GameSide?
            var rhs : GameSide?
            
            switch parts[0] {
            case "A":
                lhs = .rock
            case "B":
                lhs = .paper
            case "C":
                lhs = .scissors
            default: break
            }
            
            switch parts[1] {
            case "X":
                rhs = .rock
            case "Y":
                rhs = .paper
            case "Z":
                rhs = .scissors
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
            case "A":
                lhs = .rock
            case "B":
                lhs = .paper
            case "C":
                lhs = .scissors
            default: break
            }
            
            switch parts[1] {
            case "X":
                switch lhs! {
                case .paper:
                    rhs = .rock
                case .scissors:
                    rhs = .paper
                case .rock:
                    rhs = .scissors
                }
            case "Y":
                rhs = lhs
            case "Z":
                switch lhs! {
                case .paper:
                    rhs = .scissors
                case .scissors:
                    rhs = .rock
                case .rock:
                    rhs = .paper
                }
            default: break
            }
            
            totalScore += SolutionDay2.scoreRound(them: lhs!, you: rhs!)
        }
        
        print(totalScore)
        
    }
}
