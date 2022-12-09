import Foundation
import ArgumentParser
import Parsing
import Algorithms

extension AdventOfCode2022 {
    struct Day9: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay9()
            
            solution.Part1(input:d.dataAsString())
            solution.Part2(input:d.dataAsString())
        }
    }
}

struct SolutionDay9 {
    enum Direction : String {
        case right = "R"
        case up = "U"
        case left = "L"
        case down = "D"
    }
    
    struct Instruction : CustomStringConvertible {
        var description: String {
            return "== \(direction.rawValue) \(distance) =="
        }
        let direction : Direction
        let distance : Int
    }
    
    static let lineParser = Parse {
        Prefix(1) { $0.isLetter }.map {String($0)}
        Whitespace()
        Int.parser()
    }.map { Instruction(direction: Direction(rawValue: $0)!, distance: $1)}
    
    static let inputParser = Parse {
        Many {
            lineParser
        } separator: {
            "\n"
        } terminator: {
            "\n"
        }
    }
    
    struct Position : Hashable, Equatable {
        var x : Int
        var y : Int
        
        func near(_ other:Position) -> Bool {
                return abs(self.y - other.y) <= 1 && abs(self.x - other.x) <= 1
        }
    }
    
    func adjustTail(head:Position, tail:Position) -> Position {
        if head.near(tail) {
            return tail
        }

        if tail.x == head.x {
            if head.y > tail.y {
                return Position(x: head.x, y: head.y - 1)
            } else {
                return Position(x: head.x, y: head.y + 1)
            }
        }
        
        if tail.y == head.y {
            if head.x > tail.x {
                return Position(x: head.x - 1, y: head.y)
            } else {
                return Position(x: head.x + 1, y: head.y)
            }
        }
        
        let tailYMove = (tail.y<head.y) ? 1: -1
        let tailXMove = (tail.x<head.x) ? 1: -1

        return Position(x: tail.x + tailXMove, y: tail.y + tailYMove)
    }
    
    func printState(_ knots:[Position]) {
        let minX = min(0, knots.map {$0.x}.min() ?? 0)
        let minY = min(0, knots.map {$0.y}.min() ?? 0)
        let maxX = max(5, knots.map {$0.x}.max() ?? 0)
        let maxY = max(5, knots.map {$0.y}.max() ?? 0)
        
        for y in (minY...maxY).reversed() {
            let line = (minX...maxX).map {
                let current = Position(x: $0, y: y)
                for j in 0..<knots.count {
                    if knots[j] == current {
                        if j == 0 {
                            return "H"
                        }
                        return "\(j)"
                    }
                }
                
                return "."
            }.joined()
            print(line)
        }
        
        print("")
    }
    
    func Part1(input:String) {
        let steps = try! SolutionDay9.inputParser.parse(input)

        var head = Position(x: 0, y: 0)
        var tail = Position(x: 0, y: 0)
        
        var visited = Set<Position>()
        
        for step in steps {
            for _ in 0..<step.distance {
                switch step.direction {
                case .right:
                    head.x += 1
                case .left:
                    head.x -= 1
                case .up:
                    head.y += 1
                case.down:
                    head.y -= 1
                }
                tail = self.adjustTail(head: head, tail: tail)
                visited.insert(tail)
            }
        }
        
        print(visited.count)
    }
    
    func Part2(input:String) {
        let steps = try! SolutionDay9.inputParser.parse(input)
        
        var knots = Array(repeating: Position(x: 0, y: 0), count: 10)
        
        var visited = Set<Position>()
        
        for step in steps {
            for _ in 0..<step.distance {
                switch step.direction {
                case .right:
                    knots[0].x += 1
                case .left:
                    knots[0].x -= 1
                case .up:
                    knots[0].y += 1
                case.down:
                    knots[0].y -= 1
                }

                for i in 1..<knots.count {
                    knots[i] = self.adjustTail(head: knots[i-1], tail: knots[i])
                }

                visited.insert(knots[9])
            }
        }
        
        print(visited.count)
    }
}
