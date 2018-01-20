//
//  main.swift
//  day017
//
//  Created by Lubomír Kaštovský on 14/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 17: Two Steps Forward ---
 
 You're trying to access a secure vault protected by a 4x4 grid of small rooms connected by doors. You start in the top-left room (marked S), and you can access the vault (marked V) once you reach the bottom-right room:
 
 #########
 #S| | | #
 #-#-#-#-#
 # | | | #
 #-#-#-#-#
 # | | | #
 #-#-#-#-#
 # | | |
 ####### V
 Fixed walls are marked with #, and doors are marked with - or |.
 
 The doors in your current room are either open or closed (and locked) based on the hexadecimal MD5 hash of a passcode (your puzzle input) followed by a sequence of uppercase characters representing the path you have taken so far (U for up, D for down, L for left, and R for right).
 
 Only the first four characters of the hash are used; they represent, respectively, the doors up, down, left, and right from your current position. Any b, c, d, e, or f means that the corresponding door is open; any other character (any number or a) means that the corresponding door is closed and locked.
 
 To access the vault, all you need to do is reach the bottom-right room; reaching this room opens the vault and all doors in the maze.
 
 For example, suppose the passcode is hijkl. Initially, you have taken no steps, and so your path is empty: you simply find the MD5 hash of hijkl alone. The first four characters of this hash are ced9, which indicate that up is open (c), down is open (e), left is open (d), and right is closed and locked (9). Because you start in the top-left corner, there are no "up" or "left" doors to be open, so your only choice is down.
 
 Next, having gone only one step (down, or D), you find the hash of hijklD. This produces f2bc, which indicates that you can go back up, left (but that's a wall), or right. Going right means hashing hijklDR to get 5745 - all doors closed and locked. However, going up instead is worthwhile: even though it returns you to the room you started in, your path would then be DU, opening a different set of doors.
 
 After going DU (and then hashing hijklDU to get 528e), only the right door is open; after going DUR, all doors lock. (Fortunately, your actual passcode is not hijkl).
 
 Passcodes actually used by Easter Bunny Vault Security do allow access to the vault if you know the right path. For example:
 
 If your passcode were ihgpwlah, the shortest path would be DDRRRD.
 With kglvqrro, the shortest path would be DDUDRLRRUDRD.
 With ulqzkmiv, the shortest would be DRURDRUDDLLDLUURRDULRLDUUDDDRR.
 Given your vault's passcode, what is the shortest path (the actual path, not just the length) to reach the vault?
 
 Your puzzle answer was RDRLDRDURD.
 
 --- Part Two ---
 
 You're curious how robust this security solution really is, and so you decide to find longer and longer paths which still provide access to the vault. You remember that paths always end the first time they reach the bottom-right room (that is, they can never pass through it, only end in it).
 
 For example:
 
 If your passcode were ihgpwlah, the longest path would take 370 steps.
 With kglvqrro, the longest path would be 492 steps long.
 With ulqzkmiv, the longest path would be 830 steps long.
 What is the length of the longest path that reaches the vault?
 
 Your puzzle answer was 596.
 
 Both parts of this puzzle are complete! They provide two gold stars: **
 
 At this point, you should return to your advent calendar and try another puzzle.
 
 Your puzzle input was pgflpeqp.
 */

import Foundation

let openDoors: Set<Character> = ["b", "c", "d", "e", "f"]
let closedDoors: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a"]

let meshWidth = 4
let meshHeight = 4

struct Node {
    var positionX: Int
    var positionY: Int
    var path: String
}

func printHash(hash:Array<UInt8>) {
    var hexString = ""
    for byte in hash {
        hexString += String(format:"%02x", byte)
    }
    print(hexString)
}

func canGoUp(hash: String) -> Bool {
    return openDoors.contains(hash[hash.startIndex])
}

func canGoDown(hash: String) -> Bool {
    return openDoors.contains(hash[hash.index(after: hash.startIndex)])
}

func canGoLeft(hash: String) -> Bool {
    return openDoors.contains(hash[hash.index(hash.startIndex, offsetBy: 2)])
}

func canGoRight(hash: String) -> Bool {
    return openDoors.contains(hash[hash.index(hash.startIndex, offsetBy: 3)])
}

func hashToString(digest: Array<UInt8>) -> String {
    return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15] )
}

func createPossibleNodes(password: String, node: Node) -> Array<Node> {
    var nodes: Array<Node> = []
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    let hashInput = password + node.path
    CC_MD5(hashInput, CC_LONG(hashInput.lengthOfBytes(using: String.Encoding.utf8)), &digest)
    let hash = hashToString(digest: digest)
    if node.positionY > 1 {
        if canGoUp(hash: hash) {
            let newNode = Node(positionX: node.positionX, positionY: node.positionY-1, path: (node.path + "U"))
            nodes.append(newNode)
        }
    }
    if node.positionY < meshHeight {
        if canGoDown(hash: hash) {
            let newNode = Node(positionX: node.positionX, positionY: node.positionY+1, path: (node.path + "D"))
            nodes.append(newNode)
        }
    }
    if node.positionX > 1 {
        if canGoLeft(hash: hash) {
            let newNode = Node(positionX: node.positionX-1, positionY: node.positionY, path: (node.path + "L"))
            nodes.append(newNode)
        }
    }
    if node.positionX < meshWidth {
        if canGoRight(hash: hash) {
            let newNode = Node(positionX: node.positionX+1, positionY: node.positionY, path: (node.path + "R"))
            nodes.append(newNode)
        }
    }
    return nodes
}

func findShortestPath(password: String, rootNode: Node, destinationX: Int, destinationY: Int) -> Int {
    var step = 0
    var currentNodes: Array<Node> = [rootNode]
    var newNodes: Array<Node> = [Node]()
    var found = false
    while !found {
        step += 1
        for n in currentNodes {
            let nds = createPossibleNodes(password: password, node: n)
            if !nds.isEmpty {
                for nn in nds {
                    if (nn.positionX == destinationX) && (nn.positionY == destinationY) {
                        found = true
                        print("Shortest path for " + password + ": " + nn.path)
                        break
                    }
                }
                if found {
                    break
                }
                newNodes += nds
            }
        }
        if !found {
            currentNodes = newNodes
            newNodes = [Node]()
        }
    }
    
    return step
}

func findLongestPath(password: String, rootNode: Node, destinationX: Int, destinationY: Int) -> Int {
    var step = 0
    var currentNodes: Array<Node> = [rootNode]
    var newNodes: Array<Node> = [Node]()
    var longest = 0
    while currentNodes.count > 0 {
        step += 1
        for n in currentNodes {
            let nds = createPossibleNodes(password: password, node: n)
            if !nds.isEmpty {
                for nn in nds {
                    if (nn.positionX == destinationX) && (nn.positionY == destinationY) {
                        if nn.path.count > longest {
                            longest = nn.path.count
                        }
                    }
                    else {
                        newNodes.append(nn)
                    }
                }
            }
        }
        currentNodes = newNodes
        newNodes = [Node]()
    }
    
    return longest
}

let input = "pgflpeqp"
let testInput1 = "ihgpwlah"
let testInput2 = "kglvqrro"

let rootNode = Node(positionX: 1, positionY: 1, path: "")
print("Shortest path for " + testInput1 + ": " + String(findShortestPath(password: testInput1, rootNode: rootNode , destinationX: 4, destinationY: 4)))
print("Shortest path for " + testInput2 + ": " + String(findShortestPath(password: testInput2, rootNode: rootNode , destinationX: 4, destinationY: 4)))
print("Shortest path for " + input + ": " + String(findShortestPath(password: input, rootNode: rootNode , destinationX: 4, destinationY: 4)))

print("Longest path for " + testInput1 + ": " + String(findLongestPath(password: testInput1, rootNode: rootNode , destinationX: 4, destinationY: 4)))
print("Longest path for " + testInput2 + ": " + String(findLongestPath(password: testInput2, rootNode: rootNode , destinationX: 4, destinationY: 4)))
print("Longest path for " + input + ": " + String(findLongestPath(password: input, rootNode: rootNode , destinationX: 4, destinationY: 4)))


