//
//  main.swift
//  day006
//
//  Created by Lubomír Kaštovský on 02/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 6: Signals and Noise ---
 
 Something is jamming your communications with Santa. Fortunately, your signal is only partially jammed, and protocol in situations like this is to switch to a simple repetition code to get the message through.
 
 In this model, the same message is sent repeatedly. You've recorded the repeating message signal (your puzzle input), but the data seems quite corrupted - almost too badly to recover. Almost.
 
 All you need to do is figure out which character is most frequent for each position. For example, suppose you had recorded the following messages:
 
 eedadn
 drvtee
 eandsr
 raavrd
 atevrs
 tsrnev
 sdttsa
 rasrtv
 nssdts
 ntnada
 svetve
 tesnvt
 vntsnd
 vrdear
 dvrsen
 enarar
 The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter.
 
 Given the recording in your puzzle input, what is the error-corrected version of the message being sent?
 
 Your puzzle answer was bjosfbce.
 
 --- Part Two ---
 
 Of course, that would be the message - if you hadn't agreed to use a modified repetition code instead.
 
 In this modified code, the sender instead transmits what looks like random data, but for each character, the character they actually want to send is slightly less likely than the others. Even after signal-jamming noise, you can look at the letter distributions in each column and choose the least common letter to reconstruct the original message.
 
 In the above example, the least common character in the first column is a; in the second, d, and so on. Repeating this process for the remaining characters produces the original message, advent.
 
 Given the recording in your puzzle input and this new decoding methodology, what is the original message that Santa is trying to send?
 
 Your puzzle answer was veqfxzfx.
 */

import Foundation

func readLinesRemoveEmpty(str: String) -> Array<String> {
    var x = str.components(separatedBy: ["\n"])
    for i in x.indices {
        if x[i].isEmpty {
            x.remove(at: i)
        }
    }
    return x
}

// input: "1,2,3,4,5"
func stringNumArrayToArrayOfInt(input:String, separators: CharacterSet) -> Array<Int> {
    var result = [Int]()
    let lenArrStr = input.components(separatedBy: separators)
    for s in lenArrStr {
        if(!s.isEmpty) {
            result.append(Int(s)!)
        }
    }
    return result
}

func getStringBytes(str:String) -> Array<UInt8> {
    let buf1 = [UInt8](str.utf8)
    return buf1
}

let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let str: String = String(data: data!, encoding: String.Encoding.utf8)!

let inputLines = readLinesRemoveEmpty(str: str)

print(inputLines)

func mostCommonInColumns(inputLines: Array<String>) -> Array<Character> {
    var counter = [[Character:Int]]()
    for _ in 0..<inputLines[0].count {
        counter.append([Character:Int]())
    }
    for line in inputLines {
        let arr = Array(line)
        var i = 0
        for c in arr {
            if counter[i][c] == nil {
                counter[i][c] = 1
            }
            else {
                counter[i][c]! += 1
            }
            i += 1
        }
    }
    
    var result = [Character]()
    for x in counter {
        var count = 0
        var c: Character = Character(" ")
        for y in x.keys {
            if (x[y]! > count) {
                c = y
                count = x[y]!
            }
        }
        result.append(c)
    }
    
    return result
}

func leastCommonInColumns(inputLines: Array<String>) -> Array<Character> {
    var counter = [[Character:Int]]()
    for _ in 0..<inputLines[0].count {
        counter.append([Character:Int]())
    }
    for line in inputLines {
        let arr = Array(line)
        var i = 0
        for c in arr {
            if counter[i][c] == nil {
                counter[i][c] = 1
            }
            else {
                counter[i][c]! += 1
            }
            i += 1
        }
    }
    
    var result = [Character]()
    for x in counter {
        var count = Int.max
        var c: Character = Character(" ")
        for y in x.keys {
            if (x[y]! < count) {
                c = y
                count = x[y]!
            }
        }
        result.append(c)
    }
    
    return result
}

print(String(mostCommonInColumns(inputLines: inputLines)))
print(String(leastCommonInColumns(inputLines: inputLines)))

