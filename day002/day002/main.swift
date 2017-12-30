//
//  main.swift
//  day002
//
//  Created by Lubomír Kaštovský on 29/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 2: Bathroom Security ---
 
 You arrive at Easter Bunny Headquarters under cover of darkness. However, you left in such a rush that you forgot to use the bathroom! Fancy office buildings like this one usually have keypad locks on their bathrooms, so you search the front desk for the code.
 
 "In order to improve security," the document you find says, "bathroom codes will no longer be written down. Instead, please memorize and follow the procedure below to access the bathrooms."
 
 The document goes on to explain that each button to be pressed can be found by starting on the previous button and moving to adjacent buttons on the keypad: U moves up, D moves down, L moves left, and R moves right. Each line of instructions corresponds to one button, starting at the previous button (or, for the first line, the "5" button); press whatever button you're on at the end of each line. If a move doesn't lead to a button, ignore it.
 
 You can't hold it much longer, so you decide to figure out the code as you walk to the bathroom. You picture a keypad like this:
 
 1 2 3
 4 5 6
 7 8 9
 Suppose your instructions are:
 
 ULL
 RRDDD
 LURDL
 UUUUD
 You start at "5" and move up (to "2"), left (to "1"), and left (you can't, and stay on "1"), so the first button is 1.
 Starting from the previous button ("1"), you move right twice (to "3") and then down three times (stopping at "9" after two moves and ignoring the third), ending up with 9.
 Continuing from "9", you move left, up, right, down, and left, ending with 8.
 Finally, you move up four times (stopping at "2"), then down once, ending with 5.
 So, in this example, the bathroom code is 1985.
 
 Your puzzle input is the instructions from the document you found at the front desk. What is the bathroom code?
 
 Your puzzle answer was 78293.
 
 --- Part Two ---
 
 You finally arrive at the bathroom (it's a several minute walk from the lobby so visitors can behold the many fancy conference rooms and water coolers on this floor) and go to punch in the code. Much to your bladder's dismay, the keypad is not at all like you imagined it. Instead, you are confronted with the result of hundreds of man-hours of bathroom-keypad-design meetings:
 
 1
 2 3 4
 5 6 7 8 9
 A B C
 D
 You still start at "5" and stop when you're at an edge, but given the same instructions as above, the outcome is very different:
 
 You start at "5" and don't move at all (up and left are both edges), ending at 5.
 Continuing from "5", you move right twice and down three times (through "6", "7", "B", "D", "D"), ending at D.
 Then, from "D", you move five more times (through "D", "B", "C", "C", "B"), ending at B.
 Finally, after five more moves, you end at 3.
 So, given the actual keypad layout, the code would be 5DB3.
 
 Using the same instructions in your puzzle input, what is the correct bathroom code?
 
 Your puzzle answer was AC8C8.
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

let inputLines = readLinesRemoveEmpty(str: str)

print(inputLines)

func typeCode(moveInstructions: Array<String>) -> String {
    
    var position = "5"
    var result = ""
    for line in inputLines {
        let arr = Array(line)
        for x in arr {
            switch x {
            case "U":
                switch position {
                case "9": position = "6"
                case "8": position = "5"
                case "7": position = "4"
                case "6": position = "3"
                case "5": position = "2"
                case "4": position = "1"
                default:break
                }
                break
            case "D":
                switch position {
                case "1": position = "4"
                case "2": position = "5"
                case "3": position = "6"
                case "4": position = "7"
                case "5": position = "8"
                case "6": position = "9"
                default:break
                }
                break
            case "L":
                switch position {
                case "2": position = "1"
                case "5": position = "4"
                case "8": position = "7"
                case "3": position = "2"
                case "6": position = "5"
                case "9": position = "8"
                default:break
                }
                break
            case "R":
                switch position {
                case "1": position = "2"
                case "4": position = "5"
                case "7": position = "8"
                case "2": position = "3"
                case "5": position = "6"
                case "8": position = "9"
                default:break
                }
                break
            default: break
            }
        }
        result += position
    }
    
    return result
}

print(typeCode(moveInstructions: inputLines))


func typeCode2(moveInstructions: Array<String>) -> String {
    
    var position = "5"
    var result = ""
    for line in inputLines {
        let arr = Array(line)
        for x in arr {
            switch x {
            case "U":
                switch position {
                case "3": position = "1"
                case "6": position = "2"
                case "7": position = "3"
                case "8": position = "4"
                case "A": position = "6"
                case "B": position = "7"
                case "C": position = "8"
                case "D": position = "B"
                default:break
                }
                break
            case "D":
                switch position {
                case "1": position = "3"
                case "2": position = "6"
                case "3": position = "7"
                case "4": position = "8"
                case "6": position = "A"
                case "7": position = "B"
                case "8": position = "C"
                case "B": position = "D"
                default:break
                }
                break
            case "L":
                switch position {
                case "3": position = "2"
                case "4": position = "3"
                case "6": position = "5"
                case "7": position = "6"
                case "8": position = "7"
                case "9": position = "8"
                case "B": position = "A"
                case "C": position = "B"
                default:break
                }
                break
            case "R":
                switch position {
                case "2": position = "3"
                case "3": position = "4"
                case "5": position = "6"
                case "6": position = "7"
                case "7": position = "8"
                case "8": position = "9"
                case "A": position = "B"
                case "B": position = "C"
                default:break
                }
                break
            default: break
            }
        }
        result += position
    }
    
    return result
}

print(typeCode2(moveInstructions: inputLines))

