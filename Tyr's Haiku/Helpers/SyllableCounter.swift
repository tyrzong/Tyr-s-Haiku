import Foundation

func loadCmudict() -> [String: String] {
    let cmudictPath = Bundle.main.path(forResource: "cmudict", ofType: "txt")!
    let cmudictString = try! String(contentsOfFile: cmudictPath)
    
    var cmudict = [String: String]()
    let lines = cmudictString.components(separatedBy: .newlines)
    
    for line in lines {
        if !line.hasPrefix(";;;") && !line.isEmpty {
            let lineParts = line.components(separatedBy: "  ")
            let word = lineParts[0].lowercased()
            let pronunciation = lineParts[1]
            cmudict[word] = pronunciation
        }
    }
    
    return cmudict
}

let cmudict = loadCmudict()

func countSyllables(in word: String) -> Int {
    if word.isEmpty{
        return 0
    }
    let pronunciation = cmudict[word.lowercased()]
    if let pronunciation = pronunciation {
        let syllables = pronunciation.components(separatedBy: .whitespaces).filter { $0.rangeOfCharacter(from: .decimalDigits) != nil }.count
        return syllables
    }
    return 1
}

func countSyllablesInLine(_ line: String) -> Int {
    let words = line.components(separatedBy: " ")
    let syllableCounts = words.map { countSyllables(in: $0) }
    let totalSyllables = syllableCounts.reduce(0, +)
    if line.isEmpty{
        return 0
    }
    return totalSyllables
}

