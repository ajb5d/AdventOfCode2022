import Foundation
import ArgumentParser
import Parsing

extension AdventOfCode2022 {
    struct Day7: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay7()
            
            solution.Part1(input:d.dataAsString())
//            solution.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
        }
    }
}

struct SolutionDay7 {
    enum CommandOptions {
        case cd(String)
        case ls
    }
    
    enum DirectoryEntry : Hashable {
        case directory(Directory)
        case file(String)
    }
    
    struct Directory : Hashable {
        var files : [DirectoryEntry:Int] = [:]
    }
    
    enum ResponseOptions {
        case directory
        case size(Int)
    }
    
    struct ResponseLine {
        let responseType : ResponseOptions
        let name : String
    }
    
    static let inputLine = Parse {
        "$"
        Whitespace()
        OneOf {
            Parse {
                "cd"
                Whitespace()
                Prefix { !$0.isNewline }
            }.map {CommandOptions.cd(String($0))}
            "ls".map { CommandOptions.ls }
        }
        "\n"
    }
    
    static let responseLine = Parse {
        OneOf {
            Int.parser().map { ResponseOptions.size($0)}
            "dir".map { ResponseOptions.directory }
        }
        Whitespace()
        Prefix { !$0.isNewline }
    }.map { ResponseLine(responseType: $0, name: String($1))}
    
    static let command = Parse {
        inputLine
        Optionally {
            Many { responseLine } separator: {
                "\n"
            }
        }
        Skip { Optionally { Whitespace() } }
    }.map { (command: $0, response: $1 )}
    static let inputFile = Parse {
        Many { command }
    }
    
    func path(_ input:[String]) -> String {
        if input.count == 0 {
            return "/root/"
        }
        return "/root/" + input.joined(separator: "/") + "/"
    }
    
    func Part1(input:String) {
        let r = try! SolutionDay7.inputFile.parse(input)
        var path: [String] = []
        var data : [String:Int] = [:]
        
        for e in r {
            switch e.command {
            case let .cd(dirElement):
                switch dirElement {
                case "/":
                    path = []
                case "..":
                    path.removeLast()
                default:
                    path.append(dirElement)
                }
            case .ls:
                let response = e.response!
                
                for element in response {
                    switch element.responseType {
                    case .directory:
                        break
                    case let .size(size):
                        data[self.path(path) + element.name] = size
                    }
                }
            }
        }
        
        
        var sizes : [String:Int] = [:]
        
        for (key, value) in data {
            let pathElements = key.split(separator: "/").dropLast(1)
            for endIndex in 1...pathElements.count {
                let path = pathElements.prefix(endIndex).joined(separator: "/")
                sizes[path] = value + (sizes[path] ?? 0)
            }
        }
        
        print(sizes.filter({$0.value < 100000}).map{$0.value}.reduce(0, +))
        
        let freeSpace = 70000000 - sizes["root"]!
        let needSize = 30000000 - freeSpace
        print(freeSpace)
        print(needSize)
        
        let options = sizes.filter({$0.value > needSize})
        
        print(options.sorted(by: {$0.value < $1.value}).prefix(1))
    }
    
}
