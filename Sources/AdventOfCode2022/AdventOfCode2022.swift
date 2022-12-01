import ArgumentParser

@main
struct AdventOfCode2022 : ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "AOC2022",
                                                    subcommands: commands,
                                                    defaultSubcommand: commands[commands.endIndex - 1])
    
    static let commands = [Day1.self]
}

extension AdventOfCode2022 {
    struct Day1: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile = "Data/Day1/input"
        
        func run() {
            let d = DataReader(inputPath: inputFile)
            SolutionDay1.Day1Part1(input:d.dataAsString())
        }
    }
}
