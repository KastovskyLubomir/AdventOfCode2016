//
//  main.swift
//  day009
//
//  Created by Lubomír Kaštovský on 04/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 9: Explosives in Cyberspace ---
 
 Wandering around a secure area, you come across a datalink port to a new part of the network. After briefly scanning it for interesting files, you find one file in particular that catches your attention. It's compressed with an experimental format, but fortunately, the documentation for the format is nearby.
 
 The format compresses a sequence of characters. Whitespace is ignored. To indicate that some sequence should be repeated, a marker is added to the file, like (10x2). To decompress this marker, take the subsequent 10 characters and repeat them 2 times. Then, continue reading the file after the repeated data. The marker itself is not included in the decompressed output.
 
 If parentheses or other characters appear within the data referenced by a marker, that's okay - treat it like normal data, not a marker, and then resume looking for markers after the decompressed section.
 
 For example:
 
 ADVENT contains no markers and decompresses to itself with no changes, resulting in a decompressed length of 6.
 A(1x5)BC repeats only the B a total of 5 times, becoming ABBBBBC for a decompressed length of 7.
 (3x3)XYZ becomes XYZXYZXYZ for a decompressed length of 9.
 A(2x2)BCD(2x2)EFG doubles the BC and EF, becoming ABCBCDEFEFG for a decompressed length of 11.
 (6x1)(1x3)A simply becomes (1x3)A - the (1x3) looks like a marker, but because it's within a data section of another marker, it is not treated any differently from the A that comes after it. It has a decompressed length of 6.
 X(8x2)(3x3)ABCY becomes X(3x3)ABC(3x3)ABCY (for a decompressed length of 18), because the decompressed data from the (8x2) marker (the (3x3)ABC) is skipped and not processed further.
 What is the decompressed length of the file (your puzzle input)? Don't count whitespace.
 
 Your puzzle answer was 112830.
 
 --- Part Two ---
 
 Apparently, the file actually uses version two of the format.
 
 In version two, the only difference is that markers within decompressed data are decompressed. This, the documentation explains, provides much more substantial compression capabilities, allowing many-gigabyte files to be stored in only a few kilobytes.
 
 For example:
 
 (3x3)XYZ still becomes XYZXYZXYZ, as the decompressed section contains no markers.
 X(8x2)(3x3)ABCY becomes XABCABCABCABCABCABCY, because the decompressed data from the (8x2) marker is then further decompressed, thus triggering the (3x3) marker twice for a total of six ABC sequences.
 (27x12)(20x12)(13x14)(7x10)(1x12)A decompresses into a string of A repeated 241920 times.
 (25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN becomes 445 characters long.
 Unfortunately, the computer you brought probably doesn't have enough memory to actually decompress the file; you'll have to come up with another way to get its decompressed length.
 
 What is the decompressed length of the file using this improved format?
 
 Your puzzle answer was 10931789799
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

let input = Array(inputLines.reduce("", { result, element in return result + element}))
let striped = input.filter( { c in !CharacterSet.whitespaces.contains(c.unicodeScalars.first!)} )
let compressed = String(striped)


func decompress(compressed: String) -> String {
    let input = Array(compressed)
    var i = 0
    var decompressed = ""
    var number = ""
    var sq = ""
    while i < input.count {
        if input[i] == "(" {
            i += 1
            number = ""
            while input[i] != "x" {
                number.append(input[i])
                i += 1
            }
            let seq = Int(number)!
            i += 1
            number = ""
            while input[i] != ")" {
                number.append(input[i])
                i += 1
            }
            let rep = Int(number)!
            i += 1
            sq = String(input[input.index(input.startIndex, offsetBy: i)..<input.index(input.startIndex, offsetBy: i+seq)])
            for _ in 0..<rep {
                decompressed += sq
            }
            i += seq
            continue
        }
        decompressed.append(input[i])
        i += 1
    }
    
    return decompressed
}

let test1 = "ADVENT"
let test2 = "A(1x5)BC"
let test3 = "(3x3)XYZ"
let test4 = "A(2x2)BCD(2x2)EFG"
let test5 = "(6x1)(1x3)A"
let test6 = "X(8x2)(3x3)ABCY"

/*
print(decompress(compressed: test1))
print(decompress(compressed: test1).count)
print(decompress(compressed: test2))
print(decompress(compressed: test2).count)
print(decompress(compressed: test3))
print(decompress(compressed: test3).count)
print(decompress(compressed: test4))
print(decompress(compressed: test4).count)
print(decompress(compressed: test5))
print(decompress(compressed: test5).count)
print(decompress(compressed: test6))
print(decompress(compressed: test6).count)
*/

func decompressLength(compressed: Array<Character>) -> Int64 {
    var counter: Int64 = 0
    var i = 0
    var number = ""
    var sq = [Character]()
    while i < compressed.count {
        if compressed[i] == "(" {
            i += 1
            number = ""
            while compressed[i] != "x" {
                number.append(compressed[i])
                i += 1
            }
            let seq = Int(number)!
            i += 1
            number = ""
            while compressed[i] != ")" {
                number.append(compressed[i])
                i += 1
            }
            let rep = Int64(number)!
            i += 1
            sq = Array(compressed[i..<i+seq])
            counter += rep * decompressLength(compressed: sq)
            i += seq
            continue
        }
        counter += 1
        i += 1
    }
    return counter
}

let test7 = "(3x3)XYZ"
let test8 = "X(8x2)(3x3)ABCY"
let test9 = "(27x12)(20x12)(13x14)(7x10)(1x12)A"
let test10 = "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"

//print(decompressLength(compressed: Array(test7)))
//print(decompressLength(compressed: Array(test8)))
//print(decompressLength(compressed: Array(test9)))
//print(decompressLength(compressed: Array(test10)))


print("\nPart 1 decompressed size: " + String(decompress(compressed: compressed).count))
print("\nPart 2 decompressed size: " + String(decompressLength(compressed: striped)))




