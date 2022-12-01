import UIKit

func countSyllable(word: String) -> Int{
    var count = 0
    for char in word{
        if char == "a" || char == "e" || char == "i" || char == "o" || char == "u"{
            count += 1
        }
    }
    return count
}

let line = "this is a haiku"
let words = line.components(separatedBy: " ")

for w in words{
    print(countSyllable(word: w))
}
