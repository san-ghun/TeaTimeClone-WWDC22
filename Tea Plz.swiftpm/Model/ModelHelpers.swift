import SwiftUI

func loadTeas() -> [Tea]{
    var generatedTeas: [Tea] = []
    let teaNames: [String] = [
        "Jasmine Green",
        "English Breakfast",
        "Byte's Oolong",
        "Golden Tippy Assam",
        "Matt P's Tea Party",
        "Darjeeling",
        "Genmaicha",
        "Vanilla Rooibos"
    ]
    
    for (i, teaName) in teaNames.enumerated() {
        
        var tea = Tea(id: i)
        
        tea.name = teaName
        tea.steepTime = Int.random(in: 1...4)
        tea.temperature = Int.random(in: 90...100)
        
        generatedTeas.append(tea)
    }
    
    return generatedTeas
}
