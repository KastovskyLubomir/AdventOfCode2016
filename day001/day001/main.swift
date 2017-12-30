//
//  main.swift
//  day001
//
//  Created by Lubomír Kaštovský on 29/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 1: No Time for a Taxicab ---
 
 Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars. Unfortunately, the stars have been stolen... by the Easter Bunny. To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.
 
 Collect stars by solving puzzles. Two puzzles will be made available on each day in the advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!
 
 You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.
 
 The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.
 
 There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?
 
 For example:
 
 Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
 R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
 R5, L5, R5, R3 leaves you 12 blocks away.
 How many blocks away is Easter Bunny HQ?
 
 Your puzzle answer was 252.
 
 --- Part Two ---
 
 Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny HQ is actually at the first location you visit twice.
 
 For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East.
 
 How many blocks away is the first location you visit twice?
 
 Your puzzle answer was 143.
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


