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
