//
//  main.swift
//  day008
//
//  Created by Lubomír Kaštovský on 03/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 8: Two-Factor Authentication ---
 
 You come across a door implementing what you can only assume is an implementation of two-factor authentication after a long game of requirements telephone.
 
 To get past the door, you first swipe a keycard (no problem; there was one on a nearby desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then, presumably, the door unlocks.
 
 Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart and figured out how it works. Now you just have to work out what the screen would have displayed.
 
 The magnetic strip on the card you swiped encodes a series of instructions for the screen; these instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which start off, and is capable of three somewhat peculiar operations:
 
 rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide and B tall.
 rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B pixels. Pixels that would fall off the right end appear at the left end of the row.
 rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B pixels. Pixels that would fall off the bottom appear at the top of the column.
 For example, here is a simple sequence on a smaller screen:
 
 rect 3x2 creates a small rectangle in the top-left corner:
 
 ###....
 ###....
 .......
 rotate column x=1 by 1 rotates the second column down by one pixel:
 
 #.#....
 ###....
 .#.....
 rotate row y=0 by 4 rotates the top row right by four pixels:
 
 ....#.#
 ###....
 .#.....
 rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top:
 
 .#..#.#
 #.#....
 .#.....
 As you can see, this display technology is extremely powerful, and will soon dominate the tiny-code-displaying-screen market. That's what the advertisement on the back of the display tries to convince you, anyway.
 
 There seems to be an intermediate check of the voltage used by the display: after you swipe your card, if the screen did work, how many pixels should be lit?
 
 Your puzzle answer was 128.
 
 --- Part Two ---
 
 You notice that the screen is only capable of displaying capital letters; in the font it uses, each letter is 5 pixels wide and 6 tall.
 
 After you swipe your card, what code is the screen trying to display?
 
 Your puzzle answer was EOARGPHYAO.
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

typealias Display = Array<Array<Character>>

func turnOnRect(wideA: Int, tallB: Int, display: Display) -> Display {
    var result = display
    for row in 0..<tallB {
        for col in 0..<wideA {
            result[row][col] = Character("#")
        }
    }
    return result
}

func rotateRow(rowY: Int, pixelsB: Int, display: Display) -> Display {
    var result = display
    let row = result[rowY]
    let position = pixelsB % row.count
    let beginning = row[row.startIndex..<row.index(row.startIndex, offsetBy: row.count - position)]
    let end = row[row.index(row.startIndex, offsetBy: row.count - position)..<row.endIndex]
    let newRow = Array(end + beginning)
    result[rowY] = newRow
    return result
}

func rotateColumn(colX: Int, pixelsB: Int, display: Display) -> Display {
    var result = display
    var column = [Character]()
    for row in 0..<display.count {
        column.append(result[row][colX])
    }
    let position = pixelsB % column.count
    let beginning = column[column.startIndex..<column.index(column.startIndex, offsetBy: column.count - position)]
    let end = column[column.index(column.startIndex, offsetBy: column.count - position)..<column.endIndex]
    let newColumn = Array(end + beginning)
    var row = 0
    for c in newColumn {
        result[row][colX] = c
        row += 1
    }
    return result
}

func printDisplay(display: Display) -> Int{
    var counter = 0
    for row in display {
        for c in row {
            if c == "#" {
                counter += 1
            }
            print(c, terminator: "")
        }
        print("")
    }
    return counter
}

func performOperations(operations: Array<String>, display: Display) -> Display {
    var result = display
    
    for operation in operations {
        let args = operation.components(separatedBy: " ")
        if args[0] == "rect" {  // rect AxB
            let nums = args[1].components(separatedBy: "x")
            let A = Int(nums[0])!
            let B = Int(nums[1])!
            result = turnOnRect(wideA: A, tallB: B, display: result)
        }
        if args[0] == "rotate" {
            if args[1] == "row" {   // rotate row y=A by B
                let B = Int(args[4])!
                let strA = String(args[2][args[2].index(args[2].startIndex, offsetBy: 2)..<args[2].endIndex])
                let A = Int(strA)!
                result = rotateRow(rowY: A, pixelsB: B, display: result)
            }
            if args[1] == "column" { // rotate column x=A by B
                let B = Int(args[4])!
                let strA = String(args[2][args[2].index(args[2].startIndex, offsetBy: 2)..<args[2].endIndex])
                let A = Int(strA)!
                result = rotateColumn(colX: A, pixelsB: B, display: result)
            }
        }
    }
    return result
}

let initialRow = [Character](repeatElement(".", count: 50))

var display = Display()
for _ in 0..<6 {
    display.append(initialRow)
}

print("")

let result = performOperations(operations: inputLines, display: display)
print("Set pixels: " + String(printDisplay(display: result)))
