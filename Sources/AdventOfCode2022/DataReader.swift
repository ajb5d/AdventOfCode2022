import Foundation

struct DataReader {
    let inputPath : String
    
    var inputUrl : URL? {
        let url = Bundle.module.url(forResource: inputPath, withExtension: "txt")
        return url
    }
    
    func dataAsIntArray() -> [Int] {
        do {
            let contents = try String(contentsOf: self.inputUrl!)
            let result = contents.split(separator: "\n").map
            { (s) -> Int in
                return Int(s) ?? -1
            }
            return result
        } catch {
            print("Error: \(error)")
        }
        return []
    }
    
    func dataAsString() -> String {
        do {
            let result = try String(contentsOf: self.inputUrl!)
            return result
        } catch {
            print("Error: \(error)")
        }
        return ""
    }
    
    func dataAsStringArray() -> [String] {
        do {
            let contents = try String(contentsOf: self.inputUrl!)
            let result = contents
                .split(separator: "\n")
                .map {
                    String($0)
                }
            
            return result
        } catch {
            print("Error: \(error)")
        }
        return []
    }
}
