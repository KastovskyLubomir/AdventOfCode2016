//
//  main.swift
//  day006
//
//  Created by Lubomír Kaštovský on 02/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

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

