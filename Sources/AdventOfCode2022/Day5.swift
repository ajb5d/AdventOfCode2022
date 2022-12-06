import Foundation
import ArgumentParser
import Parsing
import DequeModule


extension AdventOfCode2022 {
    struct Day5: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay5()
            
            solution.Part1(input:d.dataAsStringArray(omittingEmptySubsequences: true))
            solution.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
        }
    }
}

struct SolutionDay5 {
    static let itemLine = OneOf {
        Parse {"["; CharacterSet.uppercaseLetters.map {String($0)} ; "]"}
        "   ".map {""}
    }
    static let lineParser = Many { itemLine } separator: { " " }
    static let commandParser = Parse {"move "; Int.parser(); " from "; Int.parser(); " to "; Int.parser()}
        .map { (rep: $0, from: $1, to: $2) }

    func Part1(input:[String]) {
        let blockEnd = input.firstIndex(where: {$0.starts(with: " 1")})!
        let commandStart = input.firstIndex(where: {$0.starts(with: "move")})!
        var stacks : [Deque<String>] = Array(repeating: Deque(), count: 9)
        
        for line in input.prefix(blockEnd) {
            let r = try! SolutionDay5.lineParser.parse(line)
            for (n,c) in r.enumerated().filter({$0.element != ""}) {
                stacks[n].append(c)
            }
        }

        for command in input.suffix(from: commandStart) {
            let r = try! SolutionDay5.commandParser.parse(command)
            for _ in 0..<r.rep {
                stacks[r.to - 1].prepend(stacks[r.from - 1].popFirst()!)
            }
        }
        print(stacks.map({ return $0.first ?? "" }).joined())
    }
    
    func Part2(input:[String]) {
        let blockEnd = input.firstIndex(where: {$0.starts(with: " 1")})!
        let commandStart = input.firstIndex(where: {$0.starts(with: "move")})!
        var stacks : [Deque<String>] = Array(repeating: Deque(), count: 9)
        
        for line in input.prefix(blockEnd) {
            let r = try! SolutionDay5.lineParser.parse(line)
            for (n,c) in r.enumerated().filter({$0.element != ""}) {
                stacks[n].append(c)
            }
        }

        for command in input.suffix(from: commandStart) {
            let r = try! SolutionDay5.commandParser.parse(command)
            stacks[r.to - 1].prepend(contentsOf: stacks[r.from - 1].prefix(r.rep))
            stacks[r.from - 1].removeFirst(r.rep)
        }
        
        print(stacks.map({ return $0.first ?? "" }).joined())
    }

}
