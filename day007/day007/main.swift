//
//  main.swift
//  day007
//
//  Created by Lubomír Kaštovský on 02/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 7: Internet Protocol Version 7 ---
 
 While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).
 
 An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by square brackets.
 
 For example:
 
 abba[mnop]qrst supports TLS (abba outside square brackets).
 abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
 aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
 ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).
 How many IPs in your puzzle input support TLS?
 
 Your puzzle answer was 115.
 
 --- Part Two ---
 
 You would also like to know which IPs support SSL (super-secret listening).
 
 An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence which consists of the same character twice with a different character between them, such as xyx or aba. A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.
 
 For example:
 
 aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
 xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
 aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
 zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).
 How many IPs in your puzzle input support SSL?
 
 Your puzzle answer was 231.
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

func hasABBA(str: String) -> Bool {
    let arr = Array(str)
    var i = 0
    while (i+4) <= arr.count {
        if (arr[i] == arr[i+3]) && (arr[i+1] == arr[i+2]) && (arr[i] != arr[i+1]) {
            return true
        }
        i += 1
    }
    return false
}

func supportTLS(str: String) -> Bool {
    var outside = true  // outside brackets
    var hasABBAOutside = false
    let args = str.components(separatedBy: ["[", "]"])
    for a in args {
        if outside {
            if hasABBA(str: a) {
                hasABBAOutside = true
            }
        }
        else {
            if hasABBA(str: a) {
                return false
            }
        }
        outside = !outside
    }
    return hasABBAOutside
}

let test1 = "abba[mnop]qrst"
let test2 = "abcd[bddb]xyyx"
let test3 = "aaaa[qwer]tyui"
let test4 = "ioxxoj[asdfgh]zxcvbn"

print(supportTLS(str: test1))
print(supportTLS(str: test2))
print(supportTLS(str: test3))
print(supportTLS(str: test4))

func countTLSsupportedIPs(inputLines: Array<String>) -> Int {
    var counter = 0
    for s in inputLines {
        if supportTLS(str: s) {
            counter += 1
        }
    }
    return counter
}

print(countTLSsupportedIPs(inputLines: inputLines))


func getABAs(str: String) -> Array<String> {
    var result = [String]()
    let arr = Array(str)
    var i = 0
    while (i+3) <= arr.count {
        if (arr[i] == arr[i+2]) && (arr[i] != arr[i+1]) {
            let aba = Array(arr[i...i+2])
            result.append(String(aba))
        }
        i += 1
    }
    return result
}

func findBABforABA(aba:String, stringToSearch: String) -> Bool {
    let arr = Array(stringToSearch)
    let abaArr = Array(aba)
    var i = 0
    while (i+3) <= arr.count {
        if (arr[i] == abaArr[1]) && (arr[i+1] == abaArr[0]) && (arr[i+2] == abaArr[1]) {
            return true
        }
        i += 1
    }
    return false
}

func isSSL(input: String) -> Bool {
    let arr = input.components(separatedBy: ["[", "]"])
    var supernet = [String]()
    var hypernet = [String]()
    var outside = true
    for a in arr {
        if outside {
            supernet.append(a)
        }
        else {
            hypernet.append(a)
        }
        outside = !outside
    }
    
    for s in supernet {
        let abas = getABAs(str: s)
        for a in abas {
            for h in hypernet {
                if findBABforABA(aba: a, stringToSearch: h) {
                    return true
                }
            }
        }
    }
    
    return false
}

let test5 = "aba[bab]xyz"
let test6 = "xyx[xyx]xyx"
let test7 = "aaa[kek]eke"
let test8 = "zazbz[bzb]cdb"

print(isSSL(input: test5))
print(isSSL(input: test6))
print(isSSL(input: test7))
print(isSSL(input: test8))


func countSSLsupportedIPs(inputLines: Array<String>) -> Int {
    var counter = 0
    for s in inputLines {
        if isSSL(input: s) {
            counter += 1
        }
    }
    return counter
}

print(countSSLsupportedIPs(inputLines: inputLines))
