//
//  main.swift
//  day013
//
//  Created by Lubomír Kaštovský on 13/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 13: A Maze of Twisty Little Cubicles ---
 
 You arrive at the first floor of this new building to discover a much less welcoming environment than the shiny atrium of the last one. Instead, you are in a maze of twisty little cubicles, all alike.
 
 Every location in this area is addressed by a pair of non-negative integers (x,y). Each such coordinate is either a wall or an open space. You can't move diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward positive x and y; negative values are invalid, as they represent a location outside the building. You are in a small waiting area at 1,1.
 
 While it seems chaotic, a nearby morale-boosting poster explains, the layout is actually quite logical. You can determine whether a given x,y coordinate will be a wall or an open space using a simple system:
 
 Find x*x + 3*x + 2*x*y + y + y*y.
 Add the office designer's favorite number (your puzzle input).
 Find the binary representation of that sum; count the number of bits that are 1.
 If the number of bits that are 1 is even, it's an open space.
 If the number of bits that are 1 is odd, it's a wall.
 For example, if the office designer's favorite number were 10, drawing walls as # and open spaces as ., the corner of the building containing 0,0 would look like this:
 
 0123456789
 0 .#.####.##
 1 ..#..#...#
 2 #....##...
 3 ###.#.###.
 4 .##..#..#.
 5 ..##....#.
 6 #...##.###
 Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as O:
 
 0123456789
 0 .#.####.##
 1 .O#..#...#
 2 #OOO.##...
 3 ###O#.###.
 4 .##OO#OO#.
 5 ..##OOO.#.
 6 #...##.###
 Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current location, 1,1).
 
 What is the fewest number of steps required for you to reach 31,39?
 
 Your puzzle answer was 86.
 
 --- Part Two ---
 
 How many locations (distinct x,y coordinates, including your starting location) can you reach in at most 50 steps?
 
 Your puzzle answer was 127.
 
 Both parts of this puzzle are complete! They provide two gold stars: **
 
 At this point, you should return to your advent calendar and try another puzzle.
 
 Your puzzle input was 1364.
 */

import Foundation

typealias Position = UInt64

let xMask: UInt64 = 0xffffffff00000000
let yMask: UInt64 = 0xffffffff

func getX(_ p: Position) -> UInt64 {
    return ((p & xMask) >> 32)
}

func getY(_ p:Position) -> UInt64 {
    return (p & yMask)
}

func position(_ x: UInt64, _ y: UInt64) -> Position {
    return (x << 32 | y)
}

func isEmpty(_ x: UInt64, _ y: UInt64, _ number: UInt64) -> Bool {
    
    var a: UInt64 = (x*x) + (3*x)
    a += (2*x*y) + y + (y*y) + number
    return ((a.nonzeroBitCount % 2) == 0)
}

func getPossibleNodes(p: Position, forbiddenP: Position, number: UInt64) -> Array<Position> {
    var res = [Position]()
    let x = getX(p)
    let y = getY(p)
    let fx = getX(forbiddenP)
    let fy = getY(forbiddenP)
    if isEmpty(x+1,y,number) {
        if !((x+1 == fx) && (y == fy)) {
            res.append(position(x+1, y))
        }
    }
    if x > 0 {
        if isEmpty(x-1, y, number) {
            if !((x-1 == fx) && (y == fy)) {
                res.append(position(x-1, y))
            }
        }
    }
    if isEmpty(x, y+1, number) {
        if !((x == fx) && (y+1 == fy)) {
            res.append(position(x, y+1))
        }
    }
    if y > 0 {
        if isEmpty(x, y-1, number) {
            if !((x == fx) && (y-1 == fy)) {
                res.append(position(x, y-1))
            }
        }
    }
    return res
}

typealias BFSNodes = Dictionary<Position,Position>

func generateNewVariants(keyRange: inout Array<Position>, nodesToProcess: inout BFSNodes, endP: Position, number: UInt64) -> (found: Bool, newNodes: BFSNodes) {
    var newNodes: BFSNodes = [Position():Position()]
    //print("Key range size: " + String(keyRange.count) + /*" Nodes in array: " + String(nodesToProcess.first!.value.count) +*/ " Number of arrays: " + String(nodesToProcess.count))
    var found = false
    for nodeKey in keyRange {
        let moves = getPossibleNodes(p: nodeKey, forbiddenP: nodesToProcess[nodeKey]!, number: number)
        for m in moves {
            if (getX(m) == getX(endP)) && (getY(m) == getY(endP)) {
                found = true
                break
            }
            if nodesToProcess[nodeKey]! != m {
                if newNodes[m] == nil {
                    newNodes[m] = nodeKey
                }
            }
        }
        if found {
            break
        }
    }
    return (found, newNodes)
}


func breadthFirstSearchParallel(startP: Position, endP: Position, number: UInt64, threads: Int) {

    var queues = [DispatchQueue]()
    var results = [(found: Bool, newNodes: BFSNodes)]()
    for i in 0..<threads {
        let queue = DispatchQueue(label: String("bfs.") + String(i))
        queues.append(queue)
        let result: (found: Bool, newNodes: BFSNodes) = (false, BFSNodes())
        results.append(result)
    }
    
    var keysArr: Array<Array<Position>> = [[Position]]()
    var keys: Array<Position> = []
    
    let group = DispatchGroup()
    var nodesToProcess = [startP:Position()]
    var steps = 0
    var found = false
    while !found {
        steps += 1
        print("Step: " + String(steps) + " Number of arrays: " + String(nodesToProcess.count))
        
        keysArr = [[Position]]()
        keys = Array(nodesToProcess.keys)
        if nodesToProcess.count > threads {
            for i in 0..<threads {
                let a = (i*(keys.count/threads))
                var b = 0
                if i < (threads-1) {
                    b = ((i+1)*(keys.count/threads))
                }
                else {
                    b = keys.count
                }
                let k = Array(keys[a..<b])
                keysArr.append(k)
            }
            
            for i in 0..<threads {
                group.enter()
                queues[i].async(group: group) {
                    // TODO: sometimes crashes here, fix?
                    results[i] = generateNewVariants(keyRange: &keysArr[i], nodesToProcess: &nodesToProcess, endP: endP, number: number)
                    group.leave()
                }
            }
            group.wait()
            
            for i in 0..<threads {
                if results[i].found {
                    found = true
                    break
                }
                if i != 0 {
                    nodesToProcess.merge(results[i].newNodes, uniquingKeysWith: { (a,b) in return a } )
                }
                else {
                    nodesToProcess = results[i].newNodes
                }
            }
        }
        else {
            var kk = Array(nodesToProcess.keys)
            let result = generateNewVariants(keyRange: &kk, nodesToProcess: &nodesToProcess, endP: endP, number: number)
            nodesToProcess = result.newNodes
            if result.found {
                found = true
            }
        }
    }
    print("Steps: " + String(steps))
}

// Part 1

let start3 = DispatchTime.now() // <<<<<<<<<< Start time
breadthFirstSearchParallel(startP: position(1, 1), endP: position(31,39), number: 1364, threads: 4)
//breadthFirstSearchParallel(startP: position(1, 1), endP: position(7,4), number: 10, threads: 4)
let end3 = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime3 = end3.uptimeNanoseconds - start3.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval3 = Double(nanoTime3) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval3) seconds\n")

// Part 2
// Number of arrays in step 50 (see printed in console)




