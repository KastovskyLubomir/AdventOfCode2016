//
//  main.swift
//  day001
//
//  Created by Lubomír Kaštovský on 29/12/2017.
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

var inStr = str
inStr.removeLast()

let inputDirections = inStr.components(separatedBy: ", ")

//              north       south       west        east
let direction = [(x:0,y:1), (x:0,y:-1), (x:-1,y:0), (x:1,y:0)]
var startDirIndex = 0

func resultCoordinates(input: Array<String>, direction: Array<(x:Int, y:Int)>, startDirection: Int) -> (x: Int, y:Int) {
    
    var result = (x:0, y:0)
    var dirIndex = startDirection
    for item in input {
        switch dirIndex {
        case 0:  // north
            if item[item.startIndex] == Character("L") { // change to west
                dirIndex = 2
            }
            else { // east
                dirIndex = 3
            }
            break
        case 1:  // south
            if item[item.startIndex] == Character("L") { // change to east
                dirIndex = 3
            }
            else { // west
                dirIndex = 2
            }
            break
        case 2: // west
            if item[item.startIndex] == Character("L") { // change to south
                dirIndex = 1
            }
            else { // north
                dirIndex = 0
            }
            break
        case 3: // east
            if item[item.startIndex] == Character("L") { // change to north
                dirIndex = 0
            }
            else { // south
                dirIndex = 1
            }
            break
        default:
            break
        }
        var d = item
        d.removeFirst()
        let rep = Int(d)!
        for _ in 0..<rep {
            result.x += direction[dirIndex].x
            result.y += direction[dirIndex].y
        }
    }
    return result
}


print(inputDirections)

print(resultCoordinates(input: inputDirections, direction: direction, startDirection: 0))

func firstIntersection(input: Array<String>, direction: Array<(x:Int, y:Int)>, startDirection: Int) -> (x: Int, y:Int) {
    
    var result = (x:0, y:0)
    var dirIndex = startDirection
    var visitedLocations = [(x:Int, y:Int)]()
    for item in input {
        switch dirIndex {
        case 0:  // north
            if item[item.startIndex] == Character("L") { // change to west
                dirIndex = 2
            }
            else { // east
                dirIndex = 3
            }
            break
        case 1:  // south
            if item[item.startIndex] == Character("L") { // change to east
                dirIndex = 3
            }
            else { // west
                dirIndex = 2
            }
            break
        case 2: // west
            if item[item.startIndex] == Character("L") { // change to south
                dirIndex = 1
            }
            else { // north
                dirIndex = 0
            }
            break
        case 3: // east
            if item[item.startIndex] == Character("L") { // change to north
                dirIndex = 0
            }
            else { // south
                dirIndex = 1
            }
            break
        default:
            break
        }
        var d = item
        d.removeFirst()
        let rep = Int(d)!
        for _ in 0..<rep {
            result.x += direction[dirIndex].x
            result.y += direction[dirIndex].y
            for l in visitedLocations {
                if (l.x==result.x) && (l.y==result.y) {
                    return result
                }
            }
            visitedLocations.append(result)
        }
    }
    return result
}

print(firstIntersection(input: inputDirections, direction: direction, startDirection: 0))


