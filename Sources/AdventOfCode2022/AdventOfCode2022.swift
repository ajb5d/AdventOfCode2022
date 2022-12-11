import ArgumentParser

@main
struct AdventOfCode2022 : ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "AOC2022",
                                                    subcommands: commands,
                                                    defaultSubcommand: commands[commands.endIndex - 1])
    
    static let commands : [ParsableCommand.Type] = [
        Day1.self,
        Day2.self,
        Day3.self,
        Day4.self,
        Day5.self,
        Day6.self,
        Day7.self,
        Day8.self,
        Day9.self,
        Day10.self,
        Day11.self
    ]
}
