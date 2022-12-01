struct SolutionDay1 {
    static func Day1Part1(input: String) {
        
        var elfLists:[[Int]] = []
        var tempList:[Int] = []
        
        for element in input.split(separator: "\n", omittingEmptySubsequences: false) {
            if element == "" {
                elfLists.append(tempList)
                tempList = []
            } else {
                tempList.append(Int(element)!)
            }
        }
        
        let totals = elfLists.map {
            $0.reduce(0, +)
        }
        
        print(totals.max()!)
        
        print(totals.sorted().reversed().prefix(3).reduce(0, +))
    }
    
}
