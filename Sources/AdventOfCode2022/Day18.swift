import Foundation
import ArgumentParser
import Collections
import Parsing

extension AdventOfCode2022 {
    struct Day18: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let elapsed1 = ContinuousClock().measure {
                let solution = SolutionDay18(input:d.dataAsString())
                solution.Part1()
            }
            print(elapsed1)

        }
        
    }
}

struct SolutionDay18 {
    enum Parsers {
        static let line = Parse { Int.parser(); ","; Int.parser(); ","; Int.parser() }
        
        static let input = Parse {
            Many { line } separator: { Whitespace(.vertical) } terminator: { Whitespace(.vertical)}
        }
    }
    
    init(input:String) {
        let directions = try! Parsers.input.parse(input)
        print(directions)
    }

    func Part1() {

    }
    

}
