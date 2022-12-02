import ArgumentParser

extension AdventOfCode2022 {
    struct Day1: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile : String?
        
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            SolutionDay1.Day1(input:d.dataAsStringArray())
        }
    }
}

struct SolutionDay1 {
    static func Day1(input: [String]) {
        var elfLists:[[Int]] = []
        var tempList:[Int] = []
        
        for element in input {
            if element == "" {
                elfLists.append(tempList)
                tempList = []
            } else {
                tempList.append(Int(element)!)
            }
        }
        
        let totals = elfLists.map { $0.reduce(0, +) }
        
        print("Part 1")
        print(totals.max()!)
        print("Part 2")
        print(totals.sorted().suffix(3).reduce(0, +))
    }
}
