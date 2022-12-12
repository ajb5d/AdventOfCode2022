import Foundation
import ArgumentParser
import Parsing
import Collections

extension AdventOfCode2022 {
    struct Day12: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay12()
            
            solution.Part1(input:d.dataAsString())
            solution.Part2(input:d.dataAsString())
        }
    }
}

struct SolutionDay12 {
    
    static let lineParser = Parse {
        Many { Prefix(1) { $0.isLetter }.map { String($0)} } terminator: { "\n" }
    }
    static let inputParser = Parse {
        Many { lineParser } terminator: { Whitespace(.vertical) }
    }
    
    struct Location : CustomStringConvertible, Equatable, Hashable {
        var description: String {
            return "Loc: \(x),\(y)"
        }
        
        var x : Int
        var y : Int
        
        func neighbors(_ extent:[[Int]]) -> [Location] {
            let result : [Location] = [
                Location(x: self.x - 1, y: self.y),
                Location(x: self.x + 1, y: self.y),
                Location(x: self.x, y: self.y - 1),
                Location(x: self.x, y: self.y + 1)]
            
            let t = result.filter { $0.x >= 0 && $0.y >= 0 && $0.x < extent.count && $0.y < extent[0].count }
            
            return t
        }
    }
    
    func charToHeight(_ c : Character) -> Int {
        switch c {
        case "S": return 1
        case "E": return 26
        default: return Int(c.asciiValue! - Character("a").asciiValue! + 1)
        }
    }
    
    func Part1(input:String) {
        let grid = try! SolutionDay12.inputParser.parse(input)
        let heights = grid.map { $0.map { self.charToHeight($0.first!)}}
        

        let startX = grid.firstIndex { $0.contains("S")}!
        let startY = grid[startX].firstIndex { $0 == "S"}!
        let start = Location(x: startX, y: startY)

        let endX = grid.firstIndex { $0.contains("E")}!
        let endY = grid[endX].firstIndex { $0 == "E"}!
        let end = Location(x: endX, y: endY)
        
        let width = grid.count
        let height = grid[0].count

        var prev : [Location:Location] = [:]
        var queue = (0..<width).flatMap({ x in (0..<height).map {Location(x: x, y: $0)} })
        var dist : [Location:Int] = [:]

        for element in queue {
            dist[element] = Int.max
        }

        dist[start] = 0

        while queue.count > 0 {
            queue = queue.sorted(by: {dist[$0] ?? Int.max < dist[$1] ?? Int.max})

            let u = queue.removeFirst()
            let currentHeight = heights[u.x][u.y]
            let currentDist = dist[u]!
            
            if currentDist == Int.max {
                break
            }

            for neighbor in u.neighbors(heights) {
                if heights[neighbor.x][neighbor.y] <= currentHeight + 1 && currentDist + 1 < dist[neighbor]! {
                    dist[neighbor] = currentDist + 1
                    prev[neighbor] = u
                }
            }
        }

        print(dist[end]!)
    }
    
    func Part2(input:String) {
        let grid = try! SolutionDay12.inputParser.parse(input)
        let heights = grid.map { $0.map { self.charToHeight($0.first!)}}
        

        let startX = grid.firstIndex { $0.contains("S")}!
        let startY = grid[startX].firstIndex { $0 == "S"}!
        let start = Location(x: startX, y: startY)

        let endX = grid.firstIndex { $0.contains("E")}!
        let endY = grid[endX].firstIndex { $0 == "E"}!
        let end = Location(x: endX, y: endY)
        
        let width = grid.count
        let height = grid[0].count

        var prev : [Location:Location] = [:]
        var queue = (0..<width).flatMap({ x in (0..<height).map {Location(x: x, y: $0)} })
        var dist : [Location:Int] = [:]

        for element in queue {
            dist[element] = Int.max
        }

        dist[start] = 0
        for x in 0..<width {
            for y in 0..<height {
                if heights[x][y] == 1 {
                    dist[Location(x: x, y: y)] = 0
                }
            }
        }

        while queue.count > 0 {
            queue = queue.sorted(by: {dist[$0] ?? Int.max < dist[$1] ?? Int.max})

            let u = queue.removeFirst()
            let currentHeight = heights[u.x][u.y]
            let currentDist = dist[u]!
            
            if currentDist == Int.max {
                break
            }

            for neighbor in u.neighbors(heights) {
                if heights[neighbor.x][neighbor.y] <= currentHeight + 1 && currentDist + 1 < dist[neighbor]! {
                    dist[neighbor] = currentDist + 1
                    prev[neighbor] = u
                }
            }
        }

        print(dist[end]!)
    }
}
