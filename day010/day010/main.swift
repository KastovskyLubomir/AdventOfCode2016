//
//  main.swift
//  day010
//
//  Created by Lubomir Kastovsky on 05/01/2018.
//  Copyright © 2018 Avast. All rights reserved.
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

let inputLines = readLinesRemoveEmpty(str: str)
inputLines.forEach({ x in print(x)})

struct Bot {
	var id: Int
	var a: Int
	var b: Int
	var lowToBot: Int
	var highToBot: Int
	var lowToOut: Int
	var highToOut: Int
}

func constructFactory(instructions: Array<String>) -> Array<Bot> {
	var factory = [Bot]()
	for ins in instructions.sorted() {
		let args = ins.components(separatedBy: " ")
		if args[0] == "bot" {
			var bot = Bot(id:-1, a:-1, b:-1, lowToBot:-1, highToBot:-1, lowToOut:-1, highToOut:-1)
			bot.id = Int(args[1])!
			if args[5] == "bot" {
				bot.lowToBot = Int(args[6])!
			}
			else {
				bot.lowToOut = Int(args[6])!
			}
			if args[10] == "bot" {
				bot.highToBot = Int(args[11])!
			}
			else {
				bot.highToOut = Int(args[11])!
			}
		}
		if args[0] == "value" {
			
		}
	}
	return factory
}



