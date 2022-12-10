import Foundation
import ArgumentParser
import Parsing
import Algorithms

extension AdventOfCode2022 {
    struct Day10: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay10()
            
            solution.Part1(input:d.dataAsString())
            solution.Part2(input:d.dataAsString())
        }
    }
}

struct SolutionDay10 {
    enum Instruction {
        case noop
        case addx(Int)
    }

    static let lineParser = Parse {
        OneOf {
            "noop".map { Instruction.noop }
            Parse {"addx"; Whitespace(); Int.parser()}.map {Instruction.addx($0)}
        }
    }
    
    static let inputParser = Parse {
        Many { lineParser } separator: { "\n" } terminator: { "\n" }
    }
    
    func Part1(input:String) {
        let steps = try! SolutionDay10.inputParser.parse(input)
        var values : [Int] = [1]
        for step in steps {
            switch(step) {
            case .noop:
                values.append(values.last!)
            case let .addx(inc):
                values.append(values.last!)
                values.append(values.last! + inc)
            }
        }
        let r = [20, 60, 100, 140, 180, 220].map { values[$0-1] * $0 }
        print(r)
        print(r.reduce(0, +))
    }
    
    func Part2(input:String) {
        let steps = try! SolutionDay10.inputParser.parse(input)
        var values : [Int] = [1]
        for step in steps {
            switch(step) {
            case .noop:
                values.append(values.last!)
            case let .addx(inc):
                values.append(values.last!)
                values.append(values.last! + inc)
            }
        }
        
        let r = values.enumerated().map {
            abs(($0.offset % 40) - $0.element) < 2 ? "#" : "."
        }
        
        for line in r.chunks(ofCount: 40) {
            print(line.joined())
        }
    }
}
