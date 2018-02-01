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

func indexOfLowest(ranges: Array<(Int, Int)>) -> Int {
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
    return lowestIndex
}

func lowestAllowedIP(ranges: Array<(Int, Int)>) -> Int {
    var lowestIndex = indexOfLowest(ranges: ranges)
    var i = 0
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

/*
 a0     b0          a1          b1
 b0         a0   b1       a1
 a0 b0     b1       a1
 b0      a0   a1     b1
 */
func isIntersect(a: (Int, Int), b:(Int, Int)) -> Bool {
    return (((a.0 <= b.0) && (b.0 <= a.1)) || ((a.0 <= b.1) && (b.1 <= a.1)) ||
        ((a.0<=b.0) && (b.1<=a.1)) || ((b.0<=a.0) && (a.1<=b.1)))
}

/*
 a0   a1 b0   b1
 b0   b1 a0   a1
 */
func isConnected(a: (Int, Int), b:(Int, Int)) -> Bool {
    return (((a.1+1) == b.0) || ((b.1+1) == a.0))
}

func combine(a: (Int, Int), b:(Int, Int)) -> (Int, Int) {
    let low = (a.0<=b.0) ? a.0 : b.0
    let high = (a.1<=b.1) ? b.1 : a.1
    return (low, high)
}

func allowedIPCount(ranges: Array<(Int, Int)>) -> Int {
    var ips = 0
    var rr = ranges
    var i = 0
    while (i < rr.count) {
        var j = i+1
        while j < rr.count {
            if isIntersect(a: rr[i], b: rr[j]) {
                let q = combine(a: rr[i], b: rr[j])
                rr.remove(at: j)
                rr.remove(at: i)
                rr.append(q)
                i = -1
                break
            }
            else {
                if isConnected(a: rr[i], b: rr[j]) {
                    let q = combine(a: rr[i], b: rr[j])
                    rr.remove(at: j)
                    rr.remove(at: i)
                    rr.append(q)
                    i = -1
                    break
                }
            }
            j += 1
        }
        i += 1
    }
    
    i = 0
    while (i < rr.count) {
        var j = i+1
        var lowest = i
        while (j < rr.count) {
            if rr[j].0 < rr[lowest].0 {
                lowest = j
            }
            j += 1
        }
        let x = rr[i]
        rr[i] = rr[lowest]
        rr[lowest] = x
        i += 1
    }
    
    for k in 0..<rr.count-1 {
        ips += (rr[k+1].0) - (rr[k].1+1)
    }
    
    return ips
}

print("Part 1: " + String(lowestAllowedIP(ranges: ranges)))
print("Part 2: " + String(allowedIPCount(ranges: ranges)))


