//
//  main.swift
//  day021
//
//  Created by Lubomír Kaštovský on 01/02/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 21: Scrambled Letters and Hash ---
 
 The computer system you're breaking into uses a weird scrambling function to store its passwords. It shouldn't be much trouble to create your own scrambled password so you can add it to the system; you just have to implement the scrambler.
 
 The scrambling function is a series of operations (the exact list is provided in your puzzle input). Starting with the password to be scrambled, apply each operation in succession to the string. The individual operations behave as follows:
 
 swap position X with position Y means that the letters at indexes X and Y (counting from 0) should be swapped.
 swap letter X with letter Y means that the letters X and Y should be swapped (regardless of where they appear in the string).
 rotate left/right X steps means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
 rotate based on position of letter X means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.
 reverse positions X through Y means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
 move position X to position Y means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.
 For example, suppose you start with abcde and perform the following operations:
 
 swap position 4 with position 0 swaps the first and last letters, producing the input for the next step, ebcda.
 swap letter d with letter b swaps the positions of d and b: edcba.
 reverse positions 0 through 4 causes the entire string to be reversed, producing abcde.
 rotate left 1 step shifts all letters left one position, causing the first letter to wrap to the end of the string: bcdea.
 move position 1 to position 4 removes the letter at position 1 (c), then inserts it at position 4 (the end of the string): bdeac.
 move position 3 to position 0 removes the letter at position 3 (a), then inserts it at position 0 (the front of the string): abdec.
 rotate based on position of letter b finds the index of letter b (1), then rotates the string right once plus a number of times equal to that index (2): ecabd.
 rotate based on position of letter d finds the index of letter d (4), then rotates the string right once, plus a number of times equal to that index, plus an additional time because the index was at least 4, for a total of 6 right rotations: decab.
 After these steps, the resulting scrambled password is decab.
 
 Now, you just need to generate a new scrambled password and you can access the system. Given the list of scrambling operations in your puzzle input, what is the result of scrambling abcdefgh?
 
 Your puzzle answer was bdfhgeca.
 
 --- Part Two ---
 
 You scrambled the password correctly, but you discover that you can't actually modify the password file on the system. You'll need to un-scramble one of the existing passwords by reversing the scrambling process.
 
 What is the un-scrambled version of the scrambled password fbgdceah?
 
 Your puzzle answer was gdfcabeh.
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

// can be used in reverse swap
func swapPositions(a: Int, b: Int, s: String) -> String {
    var arr = Array(s)
    let x = arr[a]
    arr[a] = arr[b]
    arr[b] = x
    return String(arr)
}

// can be used in reverse swap
func swapLetters(a: Character, b: Character, s: String) -> String {
    var arr = Array(s)
    let x = arr.index(of: a)!
    let y = arr.index(of: b)!
    let q = arr[x]
    arr[x] = arr[y]
    arr[y] = q
    return String(arr)
}

func rotateLeft(x: Int, s: String) -> String {
    var arr = Array(s)
    for _ in 0..<x {
        arr.append(arr.first!)
        arr.removeFirst()
    }
    return String(arr)
}

func revertRotateLeft(x: Int, s: String) -> String {
    var arr = Array(s)
    for _ in 0..<x {
        arr.insert(arr.last!, at: 0)
        arr.removeLast()
    }
    return String(arr)
}

func rotateRight(x: Int, s: String) -> String {
    var arr = Array(s)
    for _ in 0..<x {
        arr.insert(arr.last!, at: 0)
        arr.removeLast()
    }
    return String(arr)
}

func revertRotateRight(x: Int, s: String) -> String {
    var arr = Array(s)
    for _ in 0..<x {
        arr.append(arr.first!)
        arr.removeFirst()
    }
    return String(arr)
}

func rotateBased(x: Character, s: String) -> String {
    var arr = Array(s)
    let i = arr.index(of: x)!
    arr.insert(arr.last!, at: 0)
    arr.removeLast()
    for _ in 0..<i {
        arr.insert(arr.last!, at: 0)
        arr.removeLast()
    }
    if i >= 4 {
        arr.insert(arr.last!, at: 0)
        arr.removeLast()
    }
    return String(arr)
}

// TODO:
func revertRotateBased(x: Character, s: String) -> String {
    var arr = Array(s)
    let i = arr.index(of: x)!
    var r = 0
    switch i {
    case 0: r = 7; break
    case 1: r = 7; break
    case 2: r = 2; break
    case 3: r = 6; break
    case 4: r = 1; break
    case 5: r = 5; break
    case 6: r = 0; break
    case 7: r = 4; break
    default: break;
    }
    for _ in 0..<r {
        arr.insert(arr.last!, at: 0)
        arr.removeLast()
    }
    return String(arr)
}

// can be used also for revert
func reverse(x: Int, y: Int, s: String) -> String {
    var arr = Array(s)
    let a = arr[0..<x]
    let b = arr[x...y]
    let c = arr[(y+1)..<arr.count]
    arr = a + b.reversed() + c
    return String(arr)
}

func move(x: Int, y: Int, s: String) -> String {
    var arr = Array(s)
    let c = arr[x]
    arr.remove(at: x)
    if y < arr.count {
        arr.insert(c, at: y)
    }
    else {
        arr.append(c)
    }
    return String(arr)
}

func revertMove(x: Int, y: Int, s: String) -> String {
    var arr = Array(s)
    let c = arr[y]
    arr.remove(at: y)
    if x < arr.count {
        arr.insert(c, at: x)
    }
    else {
        arr.append(c)
    }
    return String(arr)
}

func scrambler(input: Array<String>, password: String) -> String {
    var pass = password
    for line in input {
        let args = line.components(separatedBy: " ")
        if args[0] == "swap" {
            if args[1] == "position" {
                pass = swapPositions(a: Int(args[2])!, b: Int(args[5])!, s: pass)
            }
            else {
                pass = swapLetters(a: Character(args[2]), b: Character(args[5]), s: pass)
            }
        }
        if args[0] == "rotate" {
            if args[1] == "right" {
                pass = rotateRight(x: Int(args[2])!, s: pass)
            }
            if args[1] == "left" {
                pass = rotateLeft(x: Int(args[2])!, s: pass)
            }
            if args[1] == "based" {
                pass = rotateBased(x: Character(args[6]), s: pass)
            }
        }
        if args[0] == "reverse" {
            pass = reverse(x: Int(args[2])!, y: Int(args[4])!, s: pass)
        }
        if args[0] == "move" {
            pass = move(x: Int(args[2])!, y: Int(args[5])!, s: pass)
        }
    }
    
    return pass
}

func revertScrambler(input: Array<String>, password: String) -> String {
    var pass = password
    for line in input.reversed() {
        let args = line.components(separatedBy: " ")
        if args[0] == "swap" {
            if args[1] == "position" {
                pass = swapPositions(a: Int(args[2])!, b: Int(args[5])!, s: pass)
            }
            else {
                pass = swapLetters(a: Character(args[2]), b: Character(args[5]), s: pass)
            }
        }
        if args[0] == "rotate" {
            if args[1] == "right" {
                pass = revertRotateRight(x: Int(args[2])!, s: pass)
            }
            if args[1] == "left" {
                pass = revertRotateLeft(x: Int(args[2])!, s: pass)
            }
            if args[1] == "based" {
                pass = revertRotateBased(x: Character(args[6]), s: pass)
            }
        }
        if args[0] == "reverse" {
            pass = reverse(x: Int(args[2])!, y: Int(args[4])!, s: pass)
        }
        if args[0] == "move" {
            pass = revertMove(x: Int(args[2])!, y: Int(args[5])!, s: pass)
        }
    }
    
    return pass
}

let password = "abcdefgh"
print("Part 1: " + scrambler(input: inputLines, password: password))
let scrambled = "fbgdceah"
print("Part 2: " + revertScrambler(input: inputLines, password: scrambled))



