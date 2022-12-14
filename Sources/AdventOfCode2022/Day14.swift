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
            
            let solution = SolutionDay14()

            solution.Part1(input:d.dataAsString())
//            solution.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: false))
        }
    }
}

struct SolutionDay14 {
    enum CoordinateType : CustomStringConvertible {
        var description: String {
            switch self {
            case .wall:
                return "#"
            case .sand:
                return "o"
            }
        }
        
        case wall, sand
        
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
        var worldData = Array(repeating: Deque<Coordinate>(), count: 1000)
        
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
        }
        
        func has(point:Coordinate) -> CoordinateType? {
            if let p = self.worldData[point.x].first(where: {$0 == point}) {
                return p.type
            }
            return nil
        }
        
        func printWold() {
            let minX = self.worldData.firstIndex(where: {$0.count > 0}) ?? 495
            let maxX = self.worldData.lastIndex(where: {$0.count > 0}) ?? 505
            
            let minY = self.worldData.map { $0.map(\.y).min() ?? 0 }.min() ?? 0
            let maxY = self.worldData.map { $0.map(\.y).max() ?? 0 }.max() ?? 10
            
            for y in stride(from: minY, through: maxY, by: 1) {
                let v = stride(from: minX, through: maxX, by: 1).map {
                    switch self.has(point: Coordinate(x: $0, y: y, type: .sand)) {
                    case .none: return " "
                    case let .some(x): return x.description
                    }
                }.joined()
                print("\(y)    \(v)")
            }
            
        }
        
        func firstHitFrom(point:Coordinate) -> Coordinate? {
            return self.worldData[point.x].filter({$0.y > point.y}).sorted(by: {$0.y < $1.y}).first
        }
        
        func occupied(point:Coordinate) -> Bool {
            return self.worldData[point.x].first(where: {$0.y == point.y}) != nil
        }
    }
    
    func Part1(input:String) {
        let walls = try! Parsers.input.parse(input)
        var w = WorldMap()
        w.buildWalls(walls)
        
        for i in 1...1000 {
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
                        w.addPoint(point: sand)
                        settled = true
                    }
                    
                } else {
                    print("fell into the abyss")
                    print(i-1)
//                    w.printWold()
                    return
                }
            }
            

        }
        w.printWold()
    }
}
