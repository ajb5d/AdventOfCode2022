import Foundation
import ArgumentParser
import Collections

extension AdventOfCode2022 {
    struct Day13: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay13()
            
            solution.Part1(input:d.dataAsStringArray(omittingEmptySubsequences: false))
            solution.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: false))
        }
    }
}

struct SolutionDay13 {
    enum ListElement {
        case literal(Int)
        case list([ListElement])
    }
    
    func parse(_ line:String) -> [ListElement]{
        let opening = line.startIndex
        let closing = line.lastIndex(of: "]")!
    
        assert(line[opening] == "[")
        let parsedLine = line[line.index(after: opening)..<closing]
        var index = parsedLine.startIndex
        var result : [ListElement] = []
        
        while(index < parsedLine.endIndex) {
            switch parsedLine[index]{
            case "[":
                var endIndex = parsedLine.index(after: index)
                var nestingLevel = 1
                while endIndex < parsedLine.endIndex {
                    if parsedLine[endIndex] == "[" {
                        nestingLevel += 1
                    }
                    
                    if parsedLine[endIndex] == "]" {
                        nestingLevel -= 1
                        if nestingLevel == 0 {
                            break
                        }
                    }
                    endIndex = parsedLine.index(after: endIndex)
                }
                let subStr = String(parsedLine[index...endIndex])
                result.append(ListElement.list(self.parse(subStr)))
                index = parsedLine.index(after: endIndex)
                if index < parsedLine.endIndex && line[index] == "," {
                    index = parsedLine.index(after: index)
                }
                
            default:
                var endIndex = index
                while true {
                    endIndex = parsedLine.index(after: endIndex)
                    if endIndex == parsedLine.endIndex || parsedLine[endIndex] == "," {
                        break
                    }
                }
                
                result.append(ListElement.literal(Int(parsedLine[index..<endIndex])!))
                index = endIndex
                if index < parsedLine.endIndex && line[index] == "," {
                    index = parsedLine.index(after: index)
                }
            }
        }
        
        return result
    }
    
    enum CompareResult {
        case rightOrder, leftOrder, inconclusive
    }
    
    func compareList(l:[ListElement], r:[ListElement]) -> CompareResult {
        var i = 0
        while i < max(l.count, r.count) {
            if i >= r.count {
                return .leftOrder
            }
            if i >= l.count {
                return .rightOrder
            }
            
            switch (l[i], r[i]) {
                
            case let(.literal(lv), .literal(rv)):
                if lv < rv {
                    return .rightOrder
                }
                
                if rv < lv {
                    return .leftOrder
                }

                
            case let(.list(lv), .list(rv)):
                let r = compareList(l: lv, r: rv)
                if r != .inconclusive {
                    return r
                }

            case let(.list(lv), .literal(_)):
                let r = compareList(l: lv, r: [r[i]])
                if r != .inconclusive {
                    return r
                }

            case let(.literal(_), .list(rv)):
                let r = compareList(l: [l[i]], r: rv)
                if r != .inconclusive {
                    return r
                }
            }
            
            i += 1
        }
        return .inconclusive
    }
    
    func Part1(input:[String]) {
        var sum = 0
        for (idx, block) in input.chunks(ofCount: 3).enumerated() {
            
            let left = self.parse(block[block.startIndex])
            let right = self.parse(block[block.index(after: block.startIndex)])
            
            let r = self.compareList(l: left, r: right)
            assert(r != .inconclusive)
            
            if r == .rightOrder {
                sum += (idx + 1)
            }
        }
        print(sum)
    }
    
    func Part2(input:[String]) {
        var i = input.filter({$0 != ""})
        i.append("[[2]]")
        i.append("[[6]]")
        
        i = i.sorted {
            let lv = parse($0)
            let rv = parse($1)
            
            return compareList(l: lv, r: rv) == .rightOrder
        }
        
        let d1 = i.firstIndex(of: "[[2]]")! + 1
        let d2 = i.firstIndex(of: "[[6]]")! + 1
        
        print(d1*d2)

    }
}
