import ArgumentParser

@main
struct AdventOfCode2022 : ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "AOC2022",
                                                    subcommands: commands,
                                                    defaultSubcommand: commands[commands.endIndex - 1])
    
    static let commands : [ParsableCommand.Type] = [Day1.self, Day2.self]
}
