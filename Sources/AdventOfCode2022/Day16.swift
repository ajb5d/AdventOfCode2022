import Foundation
import ArgumentParser
import Collections
import Parsing

extension AdventOfCode2022 {
    struct Day16: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            

            
            let c = ContinuousClock()
            
            let elapsed = c.measure {
                var solution = SolutionDay16(input:d.dataAsString())
                solution.Part1()
            }
            print(elapsed)
            
//            elapsed = c.measure {
//                solution.Part2(input:d.dataAsString())
//            }
//            print(elapsed)

        }
        
    }
}

struct SolutionDay16 {
    struct Node : CustomStringConvertible {
        let id : String
        let flowRate : Int
        let neighbors : [String]
        
        var bestOption : [Int:String] = [:]
        
        var description: String {
            return "Node: \(id) flowRate: \(flowRate) connectsTo: \(neighbors)"
        }
    }
    
    enum Parsers {
        static let valve = Parse {
            CharacterSet.uppercaseLetters
        }.map { String($0) }
        
        static let line = Parse {
            "Valve "; valve; " has flow rate="; Int.parser()
            OneOf {
                "; tunnels lead to valves "
                "; tunnel leads to valve "
            }
            Many { valve } separator: { ", " }
            "\n"
        }.map { Node(id: $0, flowRate: $1, neighbors: $2) }
        
        static let input = Parse {
            Many { line }
        }
    }

    enum PuzzleStateStep : CustomStringConvertible {
        case noop
        case move(Int)
        case open(Int)
        
        var description: String {
            switch self {
            case .noop: return ".noop"
            case .move(let v): return ".mv(\(v))"
            case .open(let v): return ".open(\(v)"
            }
        }
    }
    
    struct PuzzleState : Hashable {
        let currentNode : Int
        let remainingTime : Int
        let openedValves : Set<Int>
        
        func stateFollowing(opening:Int) -> PuzzleState {
            return PuzzleState(currentNode: currentNode, remainingTime: remainingTime - 1, openedValves: openedValves.union([opening]))
        }
        
        func stateFollowing(move:Int, cost:Int) -> PuzzleState {
            return PuzzleState(currentNode: move, remainingTime: remainingTime - cost , openedValves: openedValves)
        }
    }
    
    let nodeState : [Node]
    let nodeIds : [String]
    let distances : [[Int]]
    let targetNodeIds : Set<Int>
    
    init(input:String) {
        nodeState = try! Parsers.input.parse(input)
        nodeIds = nodeState.map {$0.id}
        targetNodeIds = Set(nodeState.enumerated().filter { $0.element.flowRate > 0 }.map {$0.offset})
        var distances = Array(repeating: Array(repeating: Int.max / 10, count: nodeIds.count), count: nodeIds.count)
        
        for (index, _) in nodeIds.enumerated() {
            distances[index][index] = 0
            for neighbor in nodeState[index].neighbors {
                let otherSideId = nodeIds.firstIndex(of: neighbor)!
                distances[index][otherSideId] = 1
                distances[otherSideId][index] = 1
            }
        }
        
        for k in 0..<nodeIds.count {
            for i in 0..<nodeIds.count {
                for j in 0..<nodeIds.count {
                    distances[i][j] = min(distances[i][j], distances[i][k] + distances[k][j])
                }
            }
        }
        
        self.distances = distances
    }
    
    var scoreCache : [PuzzleState:Int] = [:]
    
    mutating func score(state:PuzzleState) -> Int {
        
        if let score = scoreCache[state] {
            return score
        }
        
        if state.remainingTime <= 0 {
            // We are out of time
            return 0
        }
        
        if state.openedValves.count == targetNodeIds.count {
            // All valves open
            return 0
        }
        
        
        if !state.openedValves.contains(state.currentNode) && nodeState[state.currentNode].flowRate > 0 {
            // not open yet
            let newState = state.stateFollowing(opening: state.currentNode)
            let newScore = score(state: newState) +  nodeState[state.currentNode].flowRate * (state.remainingTime - 1)
                        
            scoreCache[state] = newScore
            return newScore
        }

        var possibleStates : [PuzzleState] = []
        
        let remainingValves = targetNodeIds.subtracting(state.openedValves)
        let minDistance = remainingValves.map { distances[state.currentNode][$0] }.min()!
        if state.remainingTime < minDistance {
            return 0
        }
        
        for target in remainingValves {
            let newState = state.stateFollowing(move: target, cost: distances[state.currentNode][target])
            possibleStates.append(newState)
        }
        
        if possibleStates.count == 0 {
            return 0
        }
        
        let scores = possibleStates.map {score(state:$0)}
        
        let maxScoreIndex = scores.firstIndex(of: scores.max()!)!
        
        scoreCache[state] = scores[maxScoreIndex]
        return scores[maxScoreIndex]
    }
    
    mutating func Part1() {
        let startingState = PuzzleState(currentNode: nodeIds.firstIndex(of: "AA")!, remainingTime: 30, openedValves: [])
        print(score(state:startingState))
    }
    

}
