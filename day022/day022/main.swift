//
//  main.swift
//  day022
//
//  Created by Lubomír Kaštovský on 07/02/2018.
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

class Node {
    var x: Int
    var y: Int
    var size: Int
    var used: Int
    var avail: Int
    var usePercent: Int
    init() {
        x = 0
        y = 0
        size = 0
        used = 0
        avail = 0
        usePercent = 0
    }
}

let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let str: String = String(data: data!, encoding: String.Encoding.utf8)!

var inputLines = readLinesRemoveEmpty(str: str)
inputLines.removeFirst()
inputLines.removeFirst()

var grid = [[Node]]()

for line in inputLines {
    var args = line.components(separatedBy: " ").filter({$0 != ""})
    var coords = args[0].components(separatedBy: "-")
    coords[1].removeFirst()
    coords[2].removeFirst()
    let x = Int(coords[1])!
    let y = Int(coords[2])!
    while grid.count <= y {
        grid.append([])
    }
    while grid[y].count <= x {
        grid[y].append(Node())
    }
    grid[y][x].x = x
    grid[y][x].x = y
    args[1].removeLast()
    grid[y][x].size = Int(args[1])!
    args[2].removeLast()
    grid[y][x].used = Int(args[2])!
    args[3].removeLast()
    grid[y][x].avail = Int(args[3])!
    args[4].removeLast()
    grid[y][x].usePercent = Int(args[4])!
}

func viablePairs(grid: Array<Array<Node>>) -> Int {
    var result = 0
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            for i in 0..<grid.count {
                for j in 0..<grid[i].count {
                    if !((x == j) && (y == i)) {
                        if (grid[y][x].used != 0) && (grid[y][x].used <= grid[i][j].avail) {
                            //print("Used: " + String(grid[y][x].used) + " Avail: " + String(grid[i][j].avail))
                            result += 1
                        }
                    }
                }
            }
        }
    }
    return result
}

print(viablePairs(grid: grid))


