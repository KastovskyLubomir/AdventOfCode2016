//
//  main.swift
//  day004
//
//  Created by Lubomír Kaštovský on 31/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 4: Security Through Obscurity ---
 
 Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.
 
 Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.
 
 A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:
 
 aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
 a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
 not-a-real-room-404[oarel] is a real room.
 totally-real-room-200[decoy] is not.
 Of the real rooms from the list above, the sum of their sector IDs is 1514.
 
 What is the sum of the sector IDs of the real rooms?
 
 Your puzzle answer was 361724.
 
 --- Part Two ---
 
 With all the decoy data out of the way, it's time to decrypt this list and get moving.
 
 The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software. However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like yourself.
 
 To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.
 
 For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.
 
 What is the sector ID of the room where North Pole objects are stored?
 
 Your puzzle answer was 482.
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

func parseInput(inputLines: Array<String>) -> Array<(name: String, sectorId: Int, checksum: String)> {
    var result = [(name: String, sectorId: Int, checksum: String)]()
    for line in inputLines {
        let args = line.components(separatedBy: ["-", "[", "]"])
        let filtered = args.filter({ (str:String) -> Bool in return !str.isEmpty })
        var i = 0
        var s = ""
        while Int(filtered[i]) == nil {
            s += filtered[i]
            i += 1
        }
        let id = Int(filtered[i])!
        i += 1
        result.append((name:s, sectorId: id, checksum: filtered[i]))
    }
    return result
}

let parsed = parseInput(inputLines: inputLines)

func realName(str:String) -> String {
    var result = ""
    // get counts
    let arr = Array(str)
    let counts = arr.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
    // sort
    let sorted = counts.sorted { if $0.1 == $1.1 { return $0.0 < $1.0 } else { return $0.1 > $1.1 } }
    // first five
    let arr2 = sorted[sorted.startIndex...sorted.index(sorted.startIndex, offsetBy: 4)]
    result = arr2.reduce(into: result, { result, element in result += String(element.key) })
    return result
}

let res = parsed.filter({ x in return realName(str: x.name) == x.checksum })
let idSum = res.reduce(into: 0, { idSum, element in idSum += element.sectorId})
print("Real name sectorId sum: " + String(idSum))


// Part 2

func parseInput2(inputLines: Array<String>) -> Array<(name: Array<String>, sectorId: Int, checksum: String)> {
    var result = [(name: [String], sectorId: Int, checksum: String)]()
    for line in inputLines {
        let args = line.components(separatedBy: ["-", "[", "]"])
        let filtered = args.filter({ (str:String) -> Bool in return !str.isEmpty })
        var i = 0
        var s = [String]()
        while Int(filtered[i]) == nil {
            s.append(filtered[i])
            i += 1
        }
        let id = Int(filtered[i])!
        i += 1
        result.append((name:s, sectorId: id, checksum: filtered[i]))
    }
    return result
}

func decodeRealName(element: (name: Array<String>, sectorId: Int, checksum: String)) -> Array<String> {
    var result = [String]()
    let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
    let count = alphabet.count
    for str in element.name {
        let arr = Array(str)
        var decoded = ""
        for c in arr {
            let posC = alphabet.index(of: c)!
            let newPos = posC + element.sectorId % count
            if newPos >= count {
                decoded += String(alphabet[newPos - count])
            }
            else {
                decoded += String(alphabet[newPos])
            }
        }
        result.append(decoded)
    }
    return result
}

let parsed2 = parseInput2(inputLines: inputLines)
let res2 = parsed2.filter({ x in return realName(str: x.name.joined()) == x.checksum })

for x in res2 {
    let d = decodeRealName(element: x)
    if d.contains("northpole") {
        print("SectorId: " + String(x.sectorId) + " " +  d.description )
    }
}
