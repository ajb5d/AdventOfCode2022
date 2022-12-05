import ArgumentParser
import Algorithms

extension AdventOfCode2022 {
    struct Day1: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile : String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: DataReader.DataScenario.useInput(input))
            
            let solution = SolutionDay1()
            
            solution.Day1(input:d.dataAsStringArray())
        }
    }
}

struct SolutionDay1 {
    func Day1(input: [String]) {
        let result = input
            .map {Int($0) ?? 0}
            .chunked(by: {$1 != 0})
            .map {
                $0.reduce(0, +)
            }
        
        print(result.max()!)
        print(result.max(count: 3).reduce(0, +))
    }
}
