import Foundation
import ArgumentParser
import Collections
import Parsing

extension AdventOfCode2022 {
    struct Day14: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let startTime = Date()
            
            let solution = SolutionDay14()
            
            solution.Part1(input:d.dataAsString())
            print(Date().timeIntervalSince(startTime))
            solution.Part1(input:d.dataAsString(), addFloor: true)
            print(Date().timeIntervalSince(startTime))
        }
        
    }
}

struct SolutionDay14 {
    enum CoordinateType : CustomStringConvertible {
        var description: String {
            switch self {
            case .wall: return "#"
            case .sand: return "o"
            case .floor: return "-"
            }
        }
        
        case wall, sand, floor
    }
    
    struct Coordinate : CustomStringConvertible, Equatable {
        var description: String {
            return "\(type)(\(x),\(y))"
        }
        
        var x : Int
        var y : Int
        var type : CoordinateType
        
        static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        func diagonalLeft() -> Coordinate {
            return Coordinate(x: self.x-1, y: self.y+1, type: self.type)
        }
        
        func diagonalRight() -> Coordinate {
            return Coordinate(x: self.x+1, y: self.y+1, type: self.type)
        }
        
        mutating func advanceTo(hitPoint:Coordinate) {
            self.y = hitPoint.y - 1
        }
    }
    
    enum Parsers {
        static let coordinate = Parse { Int.parser(); ","; Int.parser() }.map { Coordinate(x: $0, y: $1, type: .wall)}
        static let line = Parse {
            Many { coordinate } separator: { " -> " } terminator: { Whitespace(1, .vertical) }
        }
        static let input = Parse { Many { line } terminator: { End() } }
    }
    
    struct WorldMap {
        var worldData: [[Coordinate]] = Array(repeating: [], count: 1000)
        var floorDepth : Int? = nil
        
        mutating func buildWalls(_ input: [[Coordinate]]) {
            for wall in input {
                var startPoint = wall[0]
                for endPoint in wall.suffix(from: 1) {
                    if startPoint.x == endPoint.x {
                        let offset = startPoint.y < endPoint.y ? 1 : -1
                        for newY in stride(from: startPoint.y, through: endPoint.y, by: offset) {
                            let newPoint = Coordinate(x: startPoint.x, y: newY, type: .wall)
                            self.addPoint(point: newPoint)
                        }
                    } else {
                        let offset = startPoint.x < endPoint.x ? 1 : -1
                        for newX in stride(from: startPoint.x, through: endPoint.x, by: offset) {
                            let newPoint = Coordinate(x: newX, y: startPoint.y, type: .wall)
                            self.addPoint(point: newPoint)
                        }
                    }
                    startPoint = endPoint
                }
            }
        }
        
        mutating func addPoint(point:Coordinate) {
            self.worldData[point.x].append(point)
            self.worldData[point.x].sort(by: {$0.y < $1.y})
        }
        
        func has(point:Coordinate) -> CoordinateType? {
            if let p = self.worldData[point.x].first(where: {$0 == point}) {
                return p.type
            }
            
            if let floorDepth {
                if point.y == floorDepth {
                    return .floor
                }
            }
            return nil
        }
        
        func printWorld() {
            let minX = (self.worldData.firstIndex(where: {$0.count > 0}) ?? 495) - 5
            let maxX = (self.worldData.lastIndex(where: {$0.count > 0}) ?? 505) + 5
            
            let minY = self.worldData.map { $0.map(\.y).min() ?? 0 }.min() ?? 0
            let maxY = (floorDepth ?? self.worldData.map { $0.map(\.y).max() ?? 0 }.max() ?? 0) + 1
            
            for pow in [100, 10, 1] {
                let r = (minX...maxX).map { String(($0 / pow) % 10) } .joined()
                print("      \(r)")
            }
            
            for y in stride(from: minY, through: maxY, by: 1) {
                let v = stride(from: minX, through: maxX, by: 1).map {
                    switch self.has(point: Coordinate(x: $0, y: y, type: .sand)) {
                    case .none: return " "
                    case let .some(x): return x.description
                    }
                }.joined()
                let ylabel = String(format: "%02d", y)
                print("\(ylabel)    \(v)")
            }
            
        }
        
        func firstHitFrom(point:Coordinate) -> Coordinate? {
            if let hit = self.worldData[point.x].first(where: {$0.y > point.y}) {
                return hit
            }
            
            if let floorDepth {
                return Coordinate(x: point.x, y: floorDepth, type: .wall)
            }
            
            return nil
        }
        
        func occupied(point:Coordinate) -> Bool {
            let hit = self.worldData[point.x].first(where: {$0.y == point.y})
            switch hit {
            case .some(_): return true
            case .none:
                if let floorDepth {
                    return point.y == floorDepth
                }
                return false
            }
        }
    }
    
    func Part1(input:String, maxSteps:Int = 100000, addFloor:Bool = false) {
        let walls = try! Parsers.input.parse(input)
        var w = WorldMap()
        
        w.buildWalls(walls)
        
        if addFloor {
            let maxDepth = walls.map({ $0.map(\.y).max() ?? 0 }).max() ?? 0
            w.floorDepth = maxDepth + 2
        }
        
        for i in 0..<maxSteps {
            var sand = Coordinate(x: 500, y: 0, type: .sand)
            var settled = false
            while !settled {
                if let other = w.firstHitFrom(point: sand) {
                    sand.advanceTo(hitPoint: other)
                    if !w.occupied(point: sand.diagonalLeft()) {
                        sand = sand.diagonalLeft()
                    } else if !w.occupied(point: sand.diagonalRight()) {
                        sand = sand.diagonalRight()
                    } else {
                        if sand == Coordinate(x: 500, y: 0, type: .sand) {
                            print("blocked")
                            print(i+1)
                            return
                        }
                        w.addPoint(point: sand)
                        sand.y = sand.y - 1
                        settled = true
                    }
                    
                } else {
                    print("fell into the abyss")
                    print(i)
                    return
                }
            }
            

        }
        
        print("Simulation did not end after \(maxSteps) steps")
        w.printWorld()
    }
}
