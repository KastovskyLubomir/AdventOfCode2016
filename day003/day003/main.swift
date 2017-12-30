//
//  main.swift
//  day003
//
//  Created by Lubomír Kaštovský on 30/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
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


func parseInput(inputLines: Array<String>) -> Array<(a:Int, b:Int, c:Int)> {
    var result = [(a:Int, b:Int, c:Int)]()
    for line in inputLines {
        let args = line.components(separatedBy: CharacterSet.whitespaces)
        let filtered = args.filter({ (str:String) -> Bool in return !str.isEmpty })
        result.append((a:Int(filtered[0])!, b:Int(filtered[1])!, c:Int(filtered[2])!))
    }
    
    return result
}

let triads = parseInput(inputLines: inputLines)

func triangles(triads: Array<(a:Int, b:Int, c:Int)>) -> Array<(a:Int, b:Int, c:Int)> {
    let result = triads.filter({(item) -> Bool in return ((item.a+item.b) > item.c) && ((item.b+item.c) > item.a) && ((item.a+item.c) > item.b) })
    return result
}

print(triangles(triads: triads).count)

func parseInputByColumns(inputLines: Array<String>) -> Array<(a:Int, b:Int, c:Int)> {
    var result = [(a:Int, b:Int, c:Int)]()
    var filtered = [[String]]()
    for line in inputLines {
        let args = line.components(separatedBy: CharacterSet.whitespaces)
        filtered.append(args.filter({ (str:String) -> Bool in return !str.isEmpty }))
    }
    for i in 0..<(filtered.count/3) {
        result.append(( a:Int(filtered[i*3][0])!, b:Int(filtered[(i*3)+1][0])!, c:Int(filtered[(i*3)+2][0])! ))
        result.append(( a:Int(filtered[i*3][1])!, b:Int(filtered[(i*3)+1][1])!, c:Int(filtered[(i*3)+2][1])! ))
        result.append(( a:Int(filtered[i*3][2])!, b:Int(filtered[(i*3)+1][2])!, c:Int(filtered[(i*3)+2][2])! ))
    }
    return result
}

let triads2 = parseInputByColumns(inputLines: inputLines)
print(triangles(triads: triads2).count)

