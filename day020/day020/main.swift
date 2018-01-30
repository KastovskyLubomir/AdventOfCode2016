//
//  main.swift
//  day020
//
//  Created by Lubomír Kaštovský on 30/01/2018.
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

//let input = Array(inputLines.reduce("", { result, element in return result + element}))
//let striped = input.filter( { c in !CharacterSet.whitespaces.contains(c.unicodeScalars.first!)} )
//let compressed = String(striped)

var ranges = [(Int,Int)]()
for line in inputLines {
    let args = line.components(separatedBy: "-")
    ranges.append((Int(args[0])!, Int(args[1])!))
}

func findIntersectInterval(x: (Int, Int), ranges: Array<(Int,Int)>) -> Int {
    var i = 0
    for r in ranges {
        if (x.0 <= r.0) && (x.1 >= r.0) && (x.1 <= r.1) {
            return i
        }
        i += 1
    }
    return i
}

func findFollowingInterval(rightBound: Int, ranges: Array<(Int,Int)>) -> Int {
    var i = 0
    for r in ranges {
        if (rightBound+1) == r.0 {
            return i
        }
        i += 1
    }
    return i
}

func lowestAllowedIP(ranges: Array<(Int, Int)>) -> Int {
    var lowestIndex = 0
    var i = 0
    for r in ranges {
        if r.0 < ranges[lowestIndex].0 {
            lowestIndex = i
        }
        else {
            if (r.0 == ranges[lowestIndex].0) && (r.1 > ranges[lowestIndex].1) {
                lowestIndex = i
            }
        }
        i += 1
    }
    
    var rr = ranges
    var w = rr[lowestIndex]
    rr.remove(at: lowestIndex)
    while true {
        i = findIntersectInterval(x: w, ranges: rr)
        if i == rr.count {
            i = findFollowingInterval(rightBound: w.1, ranges: rr)
            if i == rr.count {
                break
            }
        }
        w = rr[i]
        lowestIndex = i
        rr.remove(at: lowestIndex)
    }
        
    return w.1+1
    
}

print(lowestAllowedIP(ranges: ranges))
