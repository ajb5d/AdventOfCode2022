import Foundation
import ArgumentParser
import Parsing
import DequeModule


extension AdventOfCode2022 {
    struct Day6: ParsableCommand {
        @Option(name: .shortAndLong, help: "Input File")
        var inputFile: String?
        
        @Flag
        var input = false
        
        func run() {
            let d = DataReader(inputPath: inputFile,
                               taskName: String(describing: type(of: self)),
                               scenario: (input == false ? .test : .input))
            
            let solution = SolutionDay6()
            
            solution.Part1(input:d.dataAsStringArray(omittingEmptySubsequences: true))
            solution.Part2(input:d.dataAsStringArray(omittingEmptySubsequences: true))
        }
    }
}

struct SolutionDay6 {

    func processLine(_ line:[Character], withUnqiueCharacters:Int = 4) -> Int {
        var marker : Deque<Character> = Deque(line.prefix(withUnqiueCharacters))
        for i in withUnqiueCharacters..<line.count {
            if Set(marker).count == withUnqiueCharacters {
                return i
            }
            
            marker.removeFirst()
            marker.append(line[i])
        }
        return -1
    }

    func Part1(input:[String]) {
        for line in input {
            let r = self.processLine(Array(line))
            print("\(r) \(line)")
        }
    }
    
    func Part2(input:[String]) {
        for line in input {
            let r = self.processLine(Array(line), withUnqiueCharacters: 14)
            print("\(r) \(line)")
        }
    }
    


}
