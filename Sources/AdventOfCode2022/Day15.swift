import Foundation
import ArgumentParser
import Collections
import Parsing

extension AdventOfCode2022 {
    struct Day15: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay15()
            
            let c = ContinuousClock()
            
            var elapsed = c.measure {
                solution.Part1(input:d.dataAsString(), targetRow: input ? 2000000 : 10 )
            }
            print(elapsed)
            
            elapsed = c.measure {
                solution.Part2(input:d.dataAsString(), extent: input ? 4000000 : 20 )
            }
            print(elapsed)

        }
        
    }
}

struct SolutionDay15 {
    struct Point : CustomStringConvertible, Equatable {
        var description: String {
            return "(\(x),\(y))"
        }
        
        var x : Int
        var y : Int
        
        func distanceFrom(other:Point) -> Int {
            return abs(other.x - x) + abs(other.y - y)
        }
    }
    
    struct Observation {
        let sensor : Point
        let beacon : Point
        
        var distance : Int {
            return sensor.distanceFrom(other: beacon)
        }
        
        func widthAtRow(row:Int) -> Range<Int> {
            if abs(sensor.y - row) > distance {
                return 0..<0
            }
            let offset = abs(sensor.y - row)
            let width = abs(distance - offset)
            
            return (sensor.x - width)..<(sensor.x + width + 1)
        }
    }
    
    enum Parsers {
        static let coordinate = Parse { "x="; Int.parser(); ", y="; Int.parser() }.map { Point(x: $0, y: $1)}
        static let line = Parse {
            "Sensor at "
            coordinate
            ": closest beacon is at "
            coordinate
            "\n"
        }.map { Observation(sensor: $0, beacon: $1) }
        static let input = Parse { Many { line } terminator: { End() } }
    }
    
    func printWorld(_ observations:[Observation], highlight:Int? = nil, extentX:(min:Int,max:Int)? = nil, extentY:(min:Int,max:Int)? = nil) {
        let extentX = extentX ?? observations.flatMap({[$0.sensor.x + $0.distance, $0.sensor.x - $0.distance]}).minAndMax()!
        let extentY = extentY ?? observations.flatMap({[$0.sensor.y + $0.distance, $0.sensor.y - $0.distance]}).minAndMax()!
        
        for p in [10, 1] {
            let v = (extentX.min...extentX.max).map {
                let d = abs(($0 / p) % 10)
                return (d == 0 && p > 1) || ($0 % 5 != 0) ? " " : String(d)
            }.joined()
            
            print("    \(v)")
        }
        for y in extentY.min...extentY.max {
            let label = String(format: "%2d ", y)
            
            var highlightRange = [0..<0]
            if let highlight {
                if highlight >= 0 {
                    highlightRange = [observations[highlight].widthAtRow(row: y)]
                } else {
                    highlightRange = observations.map {$0.widthAtRow(row: y)}
                }
            }
            
            let v = (extentX.min...extentX.max).map { x in
                let target = Point(x: x, y: y)
                
                if !observations.filter({$0.sensor == target}).isEmpty {
                    return "S"
                }
                
                if !observations.filter({$0.beacon == target}).isEmpty {
                    return "B"
                }
                
                if highlightRange.filter({range in range.contains(x)}).count > 0 {
                    return "#"
                }
                
                return "."
            }.joined()
            
            print("\(label) \(v)")
        }
    }
    
    
    func Part1(input:String, targetRow:Int) {
        let observations = try! Parsers.input.parse(input)
        
        let hits = observations.filter({!$0.widthAtRow(row: targetRow).isEmpty})
        let extents  = hits.map{$0.widthAtRow(row: targetRow)}
        let start = extents.map(\.lowerBound).min()!
        let end = extents.map(\.upperBound).max()!
        
        var count = 0
        
        for j in start..<end {
            let target = Point(x: j, y: targetRow)
            let extentsContains = extents.map {$0.contains(j)}.count > 0
            let beaconsContains = hits.filter {$0.beacon == target}.count > 0
            
            if extentsContains && !beaconsContains {
                count += 1
            }
        }
        
        print(count)
        
    }
    
    func Part2(input:String, extent:Int) {
        let observations = try! Parsers.input.parse(input)
        let target = 0..<(extent+1)
        
        for targetRow in target {
            let extents = observations
                .filter {!$0.widthAtRow(row: targetRow).isEmpty}
                .map {$0.widthAtRow(row: targetRow)}
                .map {$0.clamped(to: target)}
            
            var maxContinuousUpper = 0
            for e in extents.sorted(by: {$0.lowerBound < $1.lowerBound}) {
                if e.lowerBound <= maxContinuousUpper && e.upperBound > maxContinuousUpper {
                    maxContinuousUpper = e.upperBound
                }
            }
            
            if maxContinuousUpper != extent + 1 {
                print(targetRow + maxContinuousUpper * 4000000)
                return
            }
        }
    }
}
