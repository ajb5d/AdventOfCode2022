import Foundation

struct DataReader {
    let inputPath:String
    
    func dataAsIntArray() -> [Int] {
        do {
            let contents = try String(contentsOfFile: self.inputPath)
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
            let result = try String(contentsOfFile: filePath)
            return result
        } catch {
            print("Error: \(error)")
        }
        return ""
    }
}
