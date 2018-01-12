//
//  main.swift
//  day012
//
//  Created by Lubomir Kastovsky on 12/01/2018.
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

func processCode(program: Array<String>) -> Registers {
	var regs = getRegisters(program: program)
	var line = 0
	regs["c"] = 1
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

print(processCode(program: inputLines))


