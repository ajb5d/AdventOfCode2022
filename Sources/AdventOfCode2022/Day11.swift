import Foundation
import ArgumentParser
import Parsing
import Algorithms

extension AdventOfCode2022 {
    struct Day11: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay11()
            
            solution.Part1(input:d.dataAsString())
            solution.Part2(input:d.dataAsString())
        }
    }
}

struct SolutionDay11 {
    
    struct Monkey : CustomStringConvertible {
        enum Operation {
            case mult(Int), add(Int), power
        }
        
        var id : Int
        var items : [Int]
        let operation : Operation
        let condition : Int
        let trueTarget : Int
        let falseTarget : Int
        
        var itemsInspected = 0
        
        func process(_ old:Int) -> Int {
            switch self.operation {
            case let .add(i):
                return old + i
            case let .mult(i):
                return old * i
            case .power:
                return old * old
            }
        }
        
        var description: String {
            return "Monkey \(self.id) \(self.items)"
        }
        
        func target(_ value:Int) -> Int {
            return  (value % condition == 0) ? trueTarget: falseTarget
        }
    }
    
    static let monkeyIdLine = Parse { "Monkey "; Int.parser(); ":\n" }
    static let startingItemsLine = Parse {
        "  Starting items: "
        Many{ Int.parser() } separator: { ", " } terminator: { "\n" }
    }
    
    static let operationLine = Parse {
        "  Operation: new = old "
        OneOf {
            Parse {"+ "; Int.parser()}.map {Monkey.Operation.add($0)}
            Parse {"* "; Int.parser()}.map {Monkey.Operation.mult($0)}
            "* old".map {Monkey.Operation.power}
        }
        "\n"
    }
    
    static let conditionLine = Parse {
        OneOf {
            "    If true: throw to monkey "
            "    If false: throw to monkey "
        }
        Int.parser()
        "\n"
    }
    
    static let testBlock = Parse {
        "  Test: divisible by "
        Int.parser()
        "\n"
        conditionLine
        conditionLine
    }

    static let monkeyParser = Parse {
        monkeyIdLine
        startingItemsLine
        operationLine
        testBlock
    }.map {
        Monkey(id: $0, items: $1, operation: $2, condition: $3.0, trueTarget: $3.1, falseTarget: $3.2)
    }
    
    static let inputParser = Parse {
        Many { monkeyParser } separator: {
            "\n"
        }
    }
    
    func Part1(input:String) {
        var monkeys = try! SolutionDay11.inputParser.parse(input)
        
        
        for _ in 1...20 {
            for i in 0..<monkeys.count {
                while monkeys[i].items.count > 0 {
                    var item = monkeys[i].items.removeFirst()
                    monkeys[i].itemsInspected += 1
                    item = monkeys[i].process(item) / 3
                    monkeys[monkeys[i].target(item)].items.append(item)
                }
            }
        }
        
        print(monkeys.map(\.itemsInspected).sorted().suffix(2).reduce(1, *))
    }
    
    func Part2(input:String) {
        var monkeys = try! SolutionDay11.inputParser.parse(input)
        let modulo = monkeys.map(\.condition).reduce(1, *)
        
        for _ in 1...10000 {
            for i in 0..<monkeys.count {
                while monkeys[i].items.count > 0 {
                    var item = monkeys[i].items.removeFirst()
                    monkeys[i].itemsInspected += 1
                    item = monkeys[i].process(item) % modulo
                    monkeys[monkeys[i].target(item)].items.append(item)
                }
            }
        }
        
        print(monkeys.map(\.itemsInspected).sorted().suffix(2).reduce(1, *))
    }
}
