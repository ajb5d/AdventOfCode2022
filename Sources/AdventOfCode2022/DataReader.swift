import Foundation

struct DataReader {
    enum DataScenario : String {
        case test, input
    }
    
    var inputUrl : URL?
    
    init(inputPath: String?, taskName: String, scenario: DataScenario = .test) {
        if let inputPath = inputPath {
            self.inputUrl = URL(fileURLWithPath: inputPath)
        } else {
            let bundlePath = "Data/" + taskName + "/" + scenario.rawValue
            self.inputUrl = Bundle.module.url(forResource: bundlePath, withExtension: "txt")
        }
        
    }
    
    func dataAsIntArray() -> [Int] {
        do {
            return try String(contentsOf: self.inputUrl!)
                .split(separator: "\n")
                .map{ Int($0) ?? -1 }
        } catch {
            print("Error: \(error)")
        }
        return []
    }
    
    func dataAsString() -> String {
        do {
            return try String(contentsOf: self.inputUrl!)
        } catch {
            print("Error: \(error)")
        }
        return ""
    }
    
    func dataAsStringArray(omittingEmptySubsequences:Bool = false) -> [String] {
        do {
            return try String(contentsOf: self.inputUrl!)
                .split(separator: "\n", omittingEmptySubsequences: omittingEmptySubsequences)
                .map { String($0) }
        } catch {
            print("Error: \(error)")
        }
        return []
    }
}
