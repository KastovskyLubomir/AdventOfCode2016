//
//  main.swift
//  day012
//
//  Created by Lubomir Kastovsky on 12/01/2018.
//  Copyright © 2018 Avast. All rights reserved.
//

/*
 --- Day 12: Leonardo's Monorail ---
 
 You finally reach the top floor of this building: a garden with a slanted glass ceiling. Looks like there are no more stars to be had.
 
 While sitting on a nearby bench amidst some tiger lilies, you manage to decrypt some of the files you extracted from the servers downstairs.
 
 According to these documents, Easter Bunny HQ isn't just this building - it's a collection of buildings in the nearby area. They're all connected by a local monorail, and there's another building not far from here! Unfortunately, being night, the monorail is currently not operating.
 
 You remotely connect to the monorail control systems and discover that the boot sequence expects a password. The password-checking logic (your puzzle input) is easy to extract, but the code it uses is strange: it's assembunny code designed for the new computer you just assembled. You'll have to execute the code and get the password.
 
 The assembunny code you've extracted operates on four registers (a, b, c, and d) that start at 0 and can hold any integer. However, it seems to make use of only a few instructions:
 
 cpy x y copies x (either an integer or the value of a register) into register y.
 inc x increases the value of register x by one.
 dec x decreases the value of register x by one.
 jnz x y jumps to an instruction y away (positive means forward; negative means backward), but only if x is not zero.
 The jnz instruction moves relative to itself: an offset of -1 would continue at the previous instruction, while an offset of 2 would skip over the next instruction.
 
 For example:
 
 cpy 41 a
 inc a
 inc a
 dec a
 jnz a 2
 dec a
 The above code would set register a to 41, increase its value by 2, decrease its value by 1, and then skip the last dec a (because a is not zero, so the jnz a 2 skips it), leaving register a at 42. When you move past the last instruction, the program halts.
 
 After executing the assembunny code in your puzzle input, what value is left in register a?
 
 Your puzzle answer was 318117.
 
 --- Part Two ---
 
 As you head down the fire escape to the monorail, you notice it didn't start; register c needs to be initialized to the position of the ignition key.
 
 If you instead initialize register c to be 1, what value is now left in register a?
 
 Your puzzle answer was 9227771.
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
inputLines.forEach({ x in print(x)})

typealias Registers = Dictionary<String, Int>

func getRegisters(program: Array<String>) -> Registers {
	var registers = Registers()
	for line in program {
		let args = line.components(separatedBy: [" "])
		if Int(args[1]) == nil {
			registers[args[1]] = 0
		}
		if args.count > 2 {
			if Int(args[2]) == nil {
				registers[args[2]] = 0
			}
		}
	}
	return registers
}

func getConstantOrRegValue(x: String, registers: Registers) -> Int {
	if Int(x) == nil {
		return registers[x]!
	}
	else {
		return Int(x)!
	}
}

func processCode(program: Array<String>, presetRegisters: Registers) -> Registers {
	var regs = getRegisters(program: program)
	var line = 0
    for key in presetRegisters.keys {
        if regs[key] != nil {
            regs[key] = presetRegisters[key]
        }
    }
	while (line >= 0) && (line < program.count) {
		let args = program[line].components(separatedBy: " ")
		if args[0] == "cpy" {
			let x = getConstantOrRegValue(x: args[1], registers: regs)
			regs[args[2]] = x
		}
		if args[0] == "inc" {
			regs[args[1]] = regs[args[1]]! + 1
		}
		if args[0] == "dec" {
			regs[args[1]] = regs[args[1]]! - 1
		}
		if args[0] == "jnz" {
			let x = getConstantOrRegValue(x: args[1], registers: regs)
			if x != 0 {
				line += getConstantOrRegValue(x: args[2], registers: regs)
				continue
			}
		}
		line += 1
	}
	return regs
}

var presetRegs = [String:Int]()

print("\nPart 1:")
let start = DispatchTime.now() // <<<<<<<<<< Start time
print(processCode(program: inputLines, presetRegisters: presetRegs))
let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval) seconds\n")

presetRegs["c"] = 1
print("Part 2:")
let start2 = DispatchTime.now() // <<<<<<<<<< Start time
print(processCode(program: inputLines, presetRegisters: presetRegs))
let end2 = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval2) seconds\n")


