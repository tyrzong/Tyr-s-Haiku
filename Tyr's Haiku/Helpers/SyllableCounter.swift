//
//  SyllableCounter.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 12/1/22.
//

import Foundation
import SyllableCounter

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

func countSyllable(word: String) -> Int{
    var count = 0
    var wordArray = [String]()
    // turn letters into consonant vowels and special cases
    for i in 0..<word.count{
        if word[i] == "a" || word[i] == "i" || word[i] == "o" || word[i] == "u"{
            wordArray.append("v")
        }
        else if word[i] == "e"{
            wordArray.append("e")
        }else if word[i] == "y"{
            wordArray.append("y")
        }else{
            wordArray.append("c")
        }
    }
    for i in 0..<wordArray.count{
        // vowel group counts as 1 syllable
        if wordArray[i] == "v"{
            var j = i+1
            while j < wordArray.count{
                if wordArray[j] == "v"{
                    wordArray[j] = "_v"
                }else if wordArray[j] == "y"{
                    wordArray[j] = "c"
                    break
                }else if wordArray[j] == "e"{
                    wordArray[j] = "v"
                    break
                }else {
                    break
                }
                j = j+1
            }
        }
        // special case y
        if wordArray[i] == "y"{
            let j = i+1
            if j < wordArray.count{
                if wordArray[j] == "v"{
                    wordArray[j] = "_v"
                    wordArray[i] = "v"
                }
            }else{
                wordArray[i] = "v"
            }
        }
        // special case e
        if wordArray[i] == "e"{
            let j = i-2
            let k = i-1
            if j < 0 || k < 0{
                wordArray[i] = "v"
            }else if wordArray[k] == "v"{
                wordArray[i] = "_v"
            }else if wordArray[k] == "_v"{
                wordArray[i] = "_v"
            }else if wordArray[k] == "c"{
                if i == word.count - 1{
                    if wordArray[k] == "c" && wordArray[j] == "c"{
                        wordArray[i] = "v"
                    }else {
                        wordArray[i] = "c"
                    }
                }else{
                    wordArray[i] = "v"
                }
            }else{
                wordArray[i] = "c"
            }
        }
    }
    
    for c in wordArray{
        if c == "v"{
            count += 1
        }
    }
    return count
}

func countSyllables(line: String) -> Int{
    let lowercasedLine = line.lowercased()
    let words = lowercasedLine.components(separatedBy: " ")
    var count = 0
    for w in words{
        count += w.syllables
    }
    return count
}
