//
//  main.swift
//  day010
//
//  Created by Lubomir Kastovsky on 05/01/2018.
//  Copyright © 2018 Avast. All rights reserved.
//

/*
 --- Day 10: Balance Bots ---
 
 You come upon a factory in which many robots are zooming around handing small microchips to each other.
 
 Upon closer examination, you notice that each bot only proceeds when it has two microchips, and once it does, it gives each one to a different bot or puts it in a marked "output" bin. Sometimes, bots take microchips from "input" bins, too.
 
 Inspecting one of the microchips, it seems like they each contain a single number; the bots must use some logic to decide what to do with each chip. You access the local control computer and download the bots' instructions (your puzzle input).
 
 Some of the instructions specify that a specific-valued microchip should be given to a specific bot; the rest of the instructions indicate what a given bot should do with its lower-value or higher-value chip.
 
 For example, consider the following instructions:
 
 value 5 goes to bot 2
 bot 2 gives low to bot 1 and high to bot 0
 value 3 goes to bot 1
 bot 1 gives low to output 1 and high to bot 0
 bot 0 gives low to output 2 and high to output 0
 value 2 goes to bot 2
 Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2 chip and a value-5 chip.
 Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its higher one (5) to bot 0.
 Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives the value-3 chip to bot 0.
 Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in output 0.
 In the end, output bin 0 contains a value-5 microchip, output bin 1 contains a value-2 microchip, and output bin 2 contains a value-3 microchip. In this configuration, bot number 2 is responsible for comparing value-5 microchips with value-2 microchips.
 
 Based on your instructions, what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips?
 
 Your puzzle answer was 147.
 
 --- Part Two ---
 
 What do you get if you multiply together the values of one chip in each of outputs 0, 1, and 2?
 
 Your puzzle answer was 55637.
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
//inputLines.forEach({ x in print(x)})

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
            factory.append(bot)
		}
		if args[0] == "value" {
			let val = Int(args[1])!
            let botId = Int(args[5])!
            var i = 0
            while i < factory.count {
                if factory[i].id == botId {
                    if factory[i].a == -1 {
                       factory[i].a = val
                    }
                    else {
                        factory[i].b = val
                    }
                }
                i += 1
            }
		}
	}
	return factory
}

func findBotIndex(botId: Int, factory: Array<Bot>) -> Int {
    for i in 0..<factory.count {
        if factory[i].id == botId {
            return i
        }
    }
    return -1
}

func whoCompares(valA: Int, valB: Int, factory: Array<Bot>) -> Int {
    var fac = factory
    var i = 0
    var high = 0
    var low = 0
    while true {
        i = 0
        while i < fac.count {
            if ((fac[i].a != -1) && (fac[i].b != -1)) {
                if ((valA == fac[i].a) && (valB == fac[i].b)) || ((valA == fac[i].b) && (valB == fac[i].a)) {
                    return fac[i].id
                }
                if fac[i].a > fac[i].b {
                    high = fac[i].a
                    low = fac[i].b
                }
                else {
                    high = fac[i].b
                    low = fac[i].a
                }
                if fac[i].highToBot != -1 {
                    let ind = findBotIndex(botId: fac[i].highToBot, factory: fac)
                    if fac[ind].a == -1 {
                        fac[ind].a = high
                    } else {
                        fac[ind].b = high
                    }
                }
                if fac[i].lowToBot != -1 {
                    let ind = findBotIndex(botId: fac[i].lowToBot, factory: fac)
                    if fac[ind].a == -1 {
                        fac[ind].a = low
                    } else {
                        fac[ind].b = low
                    }
                }
                fac[i].a = -1
                fac[i].b = -1
            }
            i += 1
        }
    }
}

func processFactory(factory: Array<Bot>) -> Array<(id: Int, val: Int)> {
    var fac = factory
    var i = 0
    var high = 0
    var low = 0
    var operationDone = false
    var results = [(id: Int, val: Int)]()
    while true {
        operationDone = false
        i = 0
        while i < fac.count {
            if ((fac[i].a != -1) && (fac[i].b != -1)) {
                if fac[i].a > fac[i].b {
                    high = fac[i].a
                    low = fac[i].b
                }
                else {
                    high = fac[i].b
                    low = fac[i].a
                }
                if fac[i].highToBot != -1 {
                    let ind = findBotIndex(botId: fac[i].highToBot, factory: fac)
                    if fac[ind].a == -1 {
                        fac[ind].a = high
                    } else {
                        fac[ind].b = high
                    }
                }
                else {
                    results.append((id: fac[i].highToOut, val: high))
                }
                if fac[i].lowToBot != -1 {
                    let ind = findBotIndex(botId: fac[i].lowToBot, factory: fac)
                    if fac[ind].a == -1 {
                        fac[ind].a = low
                    } else {
                        fac[ind].b = low
                    }
                }
                else {
                    results.append((id: fac[i].lowToOut, val: low))
                }
                fac[i].a = -1
                fac[i].b = -1
                operationDone = true
            }
            i += 1
        }
        if !operationDone {
            return results
        }
    }
}

let factory = constructFactory(instructions: inputLines)
print("Bot which compares 61 and 17: " + String(whoCompares(valA: 61, valB: 17, factory: factory)))

let result = processFactory(factory: factory)
//print(result)
let x = result.reduce(1)  {res, element in
    if (element.id == 0) || (element.id == 1) || (element.id == 2) {
        return res * element.val
    }
    return res
}
print("Mutliplication of outputs 0, 1, 2 is: " + String(x))


