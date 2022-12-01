import Foundation

struct DataReader {
    let inputPath : String
    
    var inputUrl : URL? {
        let url = Bundle.module.url(forResource: inputPath, withExtension: "txt")
        return url
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
