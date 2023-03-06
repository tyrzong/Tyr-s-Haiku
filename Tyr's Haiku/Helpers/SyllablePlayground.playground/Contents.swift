import Foundation

// Create a lookup table of words and their syllable counts
let cmudictFileURL = Bundle.main.url(forResource: "cmudict", withExtension: "txt")!
let cmudictString = try! String(contentsOf: cmudictFileURL)
var wordSyllableCounts: [String: Int] = [:]

for line in cmudictString.components(separatedBy: .newlines) {
    let components = line.components(separatedBy: "  ")
    if components.count == 2 {
        let word = components[0]
        let syllableCount = components[1].components(separatedBy: " ").filter { $0.rangeOfCharacter(from: .decimalDigits) != nil }.count
        wordSyllableCounts[word.lowercased()] = syllableCount
    }
}

func countSyllables(in word: String) -> Int {
    if let syllableCount = wordSyllableCounts[word.lowercased()] {
        return syllableCount
    }

    let vowels: Set<Character> = ["a", "e", "i", "o", "u", "y"]
    var syllableCount = 0
    var lastChar: Character?

    for char in word {
        if vowels.contains(char) {
            if lastChar == nil || !vowels.contains(lastChar!) {
                syllableCount += 1
            }
        }
        lastChar = char
    }

    if word.hasSuffix("e") {
        if syllableCount > 1 {
            syllableCount -= 1
        } else if syllableCount == 1 {
            let trimmed = String(word.dropLast())
            syllableCount = countSyllables(in: trimmed)
            if syllableCount == 1 {
                syllableCount -= 1
            }
        }
    }

    if word.hasSuffix("le") {
        if let lastChar = lastChar, lastChar == "e" {
            syllableCount += 1
        }
    }

    if syllableCount == 0 {
        syllableCount = 1
    }

    return syllableCount
}

func countSyllablesInLine(_ line: String) -> Int {
    let words = line.components(separatedBy: " ")
    let syllableCounts = words.map { countSyllables(in: $0.lowercased()) }
    let totalSyllables = syllableCounts.reduce(0, +)
    return totalSyllables
}

let line = "The quick brown fox jumps over the lazy dog"
let totalSyllables = countSyllablesInLine(line)
print("The line '\(line)' has \(totalSyllables) syllables.")
