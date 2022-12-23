import Foundation
import ArgumentParser
import Collections
import Parsing

extension AdventOfCode2022 {
    struct Day17: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
//            let elapsed1 = ContinuousClock().measure {
//                let solution = SolutionDay17(input:d.dataAsString())
//                solution.Part1(rounds: 2023)
//            }
//            print(elapsed1)
            
//            let elapsed2 = ContinuousClock().measure {
//                let solution = SolutionDay17(input:d.dataAsString())
//                solution.Part2(maxRounds: 100000)
//            }
//            print(elapsed2)
            
            var target = 1000000000000
            target -= 12800
            print(target)
            print(target / 22400 )
            print(target % 22400 )

        }
        
    }
}

struct SolutionDay17 {
    enum Direction : String {
        case left  = "<"
        case right = ">"
    }
    enum Parsers {
        static let direction = Parse {
            Prefix(1) {$0 == "<" || $0 == ">"}
        }.map { Direction(rawValue: String($0))! }
        
        static let input = Parse {
            Many { direction } terminator: {
                Whitespace()
            }
        }
    }
    
    struct Rock {
        enum Shape : CaseIterable {
            case  hbar, plus, l, vbar, square
            
            func next() -> Shape {
                switch self {
                case .hbar: return .plus
                case .plus: return .l
                case .l: return .vbar
                case .vbar: return .square
                case .square: return .hbar
                }
            }
        }
        
        let shape : Shape
        var leftEdge : Int
        var bottomHeight : Int
        
        mutating func move(direction:Direction) {
            switch direction {
            case .left:
                leftEdge = max(0, leftEdge - 1)
            case .right:
                switch shape {
                case .hbar:
                    leftEdge = min(3, leftEdge + 1)
                case .plus:
                    leftEdge = min(4, leftEdge + 1)
                case .l:
                    leftEdge = min(4, leftEdge + 1)
                case .vbar:
                    leftEdge = min(6, leftEdge + 1)
                case .square:
                    leftEdge = min(5, leftEdge + 1)
                }
            }
        }

        func canFall(world:[[Bool]]) -> Bool {
            if bottomHeight == 0 {
                return false
            }
            for p in mark() {
                if world[p.height-1][p.left] {
                    return false
                }
            }
            return true
        }
        
        func canMove(direction:Direction, world:[[Bool]]) -> Bool {
            let delta = (direction == .left) ? -1 : 1
            let newMarks = mark().map { (height: $0.height, left: $0.left + delta)}
            
            for p in newMarks {
                if p.left < 0 || p.left > 6 {
                    return false
                }
                if world[p.height][p.left] {
                    return false
                }
            }
            return true
        }
        
        func mark() -> [(height: Int, left: Int)] {
            switch shape {
            case .hbar:
                return (0..<4).map { (bottomHeight, leftEdge + $0) }
            case .vbar:
                return (0..<4).map { (bottomHeight + $0, leftEdge)}
            case .plus:
                return [(bottomHeight, leftEdge+1), (bottomHeight+1, leftEdge),
                        (bottomHeight+1, leftEdge + 1), (bottomHeight+1, leftEdge+2),
                        (bottomHeight+2, leftEdge+1)]
            case .l:
                return [(bottomHeight, leftEdge), (bottomHeight, leftEdge+1), (bottomHeight, leftEdge+2),
                        (bottomHeight+1, leftEdge+2), (bottomHeight+2, leftEdge+2)]
            case .square:
                return [(bottomHeight, leftEdge), (bottomHeight, leftEdge+1),
                        (bottomHeight+1, leftEdge), (bottomHeight+1, leftEdge+1)]
            }
        }
    }

    let directions : [Direction]
    init(input:String) {
        directions = try! Parsers.input.parse(input)
    }

    func Part1(rounds:Int) {
        let BIG = 10000
        
        var startHeight = 3
        var worldState = Array(repeating: Array(repeating: false, count: 7), count: BIG)
        var currentShape = Rock.Shape.hbar
        var directionPosition = 0
        
        for _ in 1..<rounds {
            var r = Rock(shape: currentShape, leftEdge: 2, bottomHeight: startHeight)
            
//            printWorld(world: worldState, rock: r)
            
            while true {
                
                if r.canMove(direction: directions[directionPosition], world: worldState) {
                    r.move(direction: directions[directionPosition])
                }
                
                directionPosition = (directionPosition + 1) % directions.count
                
                if r.canFall(world: worldState) {
                    r.bottomHeight -= 1
                } else {
                    break
                }
            }
            
            for pt in r.mark() {
                worldState[pt.height][pt.left] = true
            }
            
            let stackTop = worldState.lastIndex {
                row -> Bool in
                row.filter({$0}).count > 0
            }
            
            startHeight = (stackTop ?? 0) + 4
//            printWorld(world: worldState)
            
            currentShape = currentShape.next()
        }
        
        let stackTop = worldState.lastIndex {
            row -> Bool in
            row.filter({$0}).count > 0
        }
        
        print(stackTop! + 1)
    }
    
    func Part2(maxRounds:Int) {
        let BIG = 100000
        let m = directions.count * Rock.Shape.allCases.count
        
        var startHeight = 3
        var last = 0
        var worldState = Array(repeating: Array(repeating: false, count: 7), count: BIG)
        var currentShape = Rock.Shape.hbar
        var directionPosition = 0
        
        for rounds in 1..<maxRounds {
            var r = Rock(shape: currentShape, leftEdge: 2, bottomHeight: startHeight)
            
            while true {
                
                if r.canMove(direction: directions[directionPosition], world: worldState) {
                    r.move(direction: directions[directionPosition])
                }
                
                directionPosition = (directionPosition + 1) % directions.count
                
                if r.canFall(world: worldState) {
                    r.bottomHeight -= 1
                } else {
                    break
                }
            }
            
            for pt in r.mark() {
                worldState[pt.height][pt.left] = true
            }
            
            let stackTop = worldState.lastIndex {
                row -> Bool in
                row.filter({$0}).count > 0
            }
            
            startHeight = (stackTop ?? 0) + 4

            if rounds % (1600*2) == 0 {
                let v = worldState[stackTop!].map { $0 ? "#" : "." }.joined()
                let r = String(format: "%4d", rounds)
                print("\(r)  \(v) \(stackTop!) \(stackTop! - last) \(rounds / 1600) \(rounds % 1600)")
                last = stackTop!
            }
            currentShape = currentShape.next()
        }
        
        let stackTop = worldState.lastIndex {
            row -> Bool in
            row.filter({$0}).count > 0
        }
        
        print(stackTop! + 1)
    }
    
    
    
    func printWorld(world:[[Bool]], rock:Rock? = nil) {
        print()
        
        let rockPositions = rock?.mark()
        let rockLevels = rockPositions?.map({$0.height}).uniqued()
        
        for r in (0..<world.count).reversed() {
            let rowId = String(format: "%3d", r)
            
            if let rockLevels {
                if rockLevels.contains(r) {
                    let v = (0..<7).map {
                        let testPoint = (height: r, left: $0)
                        if rockPositions!.first(where: {$0 == testPoint}) != nil {
                            return "@"
                        } else {
                            return "."
                        }
                    }.joined()
                    
                    print("\(rowId)  |\(v)|")
                    continue
                }
            }
            
            if world[r].allSatisfy({!$0}) {
                continue
            }
            

            let v = world[r].map {$0 ? "#": "."}.joined()
            
            print("\(rowId)  |\(v)|")
        }
    }
}
