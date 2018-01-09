//
//  main.swift
//  day011
//
//  Created by Lubomír Kaštovský on 06/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

/*
 --- Day 11: Radioisotope Thermoelectric Generators ---
 
 You come upon a column of four floors that have been entirely sealed off from the rest of the building except for a small dedicated lobby. There are some radiation warnings and a big sign which reads "Radioisotope Testing Facility".
 
 According to the project status board, this facility is currently being used to experiment with Radioisotope Thermoelectric Generators (RTGs, or simply "generators") that are designed to be paired with specially-constructed microchips. Basically, an RTG is a highly radioactive rock that generates electricity through heat.
 
 The experimental RTGs have poor radiation containment, so they're dangerously radioactive. The chips are prototypes and don't have normal radiation shielding, but they do have the ability to generate an electromagnetic radiation shield when powered. Unfortunately, they can only be powered by their corresponding RTG. An RTG powering a microchip is still dangerous to other microchips.
 
 In other words, if a chip is ever left in the same area as another RTG, and it's not connected to its own RTG, the chip will be fried. Therefore, it is assumed that you will follow procedure and keep chips connected to their corresponding RTG when they're in the same room, and away from other RTGs otherwise.
 
 These microchips sound very interesting and useful to your current activities, and you'd like to try to retrieve them. The fourth floor of the facility has an assembling machine which can make a self-contained, shielded computer for you to take with you - that is, if you can bring it all of the RTGs and microchips.
 
 Within the radiation-shielded part of the facility (in which it's safe to have these pre-assembly RTGs), there is an elevator that can move between the four floors. Its capacity rating means it can carry at most yourself and two RTGs or microchips in any combination. (They're rigged to some heavy diagnostic equipment - the assembling machine will detach it for you.) As a security measure, the elevator will only function if it contains at least one RTG or microchip. The elevator always stops on each floor to recharge, and this takes long enough that the items within it and the items on that floor can irradiate each other. (You can prevent this if a Microchip and its Generator end up on the same floor in this way, as they can be connected while the elevator is recharging.)
 
 You make some notes of the locations of each component of interest (your puzzle input). Before you don a hazmat suit and start moving things around, you'd like to have an idea of what you need to do.
 
 When you enter the containment area, you and the elevator will start on the first floor.
 
 For example, suppose the isolated area has the following arrangement:
 
 The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
 The second floor contains a hydrogen generator.
 The third floor contains a lithium generator.
 The fourth floor contains nothing relevant.
 As a diagram (F# for a Floor number, E for Elevator, H for Hydrogen, L for Lithium, M for Microchip, and G for Generator), the initial state looks like this:
 
 F4 .  .  .  .  .
 F3 .  .  .  LG .
 F2 .  HG .  .  .
 F1 E  .  HM .  LM
 Then, to get everything up to the assembling machine on the fourth floor, the following steps could be taken:
 
 Bring the Hydrogen-compatible Microchip to the second floor, which is safe because it can get power from the Hydrogen Generator:
 
 F4 .  .  .  .  .
 F3 .  .  .  LG .
 F2 E  HG HM .  .
 F1 .  .  .  .  LM
 Bring both Hydrogen-related items to the third floor, which is safe because the Hydrogen-compatible microchip is getting power from its generator:
 
 F4 .  .  .  .  .
 F3 E  HG HM LG .
 F2 .  .  .  .  .
 F1 .  .  .  .  LM
 Leave the Hydrogen Generator on floor three, but bring the Hydrogen-compatible Microchip back down with you so you can still use the elevator:
 
 F4 .  .  .  .  .
 F3 .  HG .  LG .
 F2 E  .  HM .  .
 F1 .  .  .  .  LM
 At the first floor, grab the Lithium-compatible Microchip, which is safe because Microchips don't affect each other:
 
 F4 .  .  .  .  .
 F3 .  HG .  LG .
 F2 .  .  .  .  .
 F1 E  .  HM .  LM
 Bring both Microchips up one floor, where there is nothing to fry them:
 
 F4 .  .  .  .  .
 F3 .  HG .  LG .
 F2 E  .  HM .  LM
 F1 .  .  .  .  .
 Bring both Microchips up again to floor three, where they can be temporarily connected to their corresponding generators while the elevator recharges, preventing either of them from being fried:
 
 F4 .  .  .  .  .
 F3 E  HG HM LG LM
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring both Microchips to the fourth floor:
 
 F4 E  .  HM .  LM
 F3 .  HG .  LG .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Leave the Lithium-compatible microchip on the fourth floor, but bring the Hydrogen-compatible one so you can still use the elevator; this is safe because although the Lithium Generator is on the destination floor, you can connect Hydrogen-compatible microchip to the Hydrogen Generator there:
 
 F4 .  .  .  .  LM
 F3 E  HG HM LG .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring both Generators up to the fourth floor, which is safe because you can connect the Lithium-compatible Microchip to the Lithium Generator upon arrival:
 
 F4 E  HG .  LG LM
 F3 .  .  HM .  .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring the Lithium Microchip with you to the third floor so you can use the elevator:
 
 F4 .  HG .  LG .
 F3 E  .  HM .  LM
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring both Microchips to the fourth floor:
 
 F4 E  HG HM LG LM
 F3 .  .  .  .  .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 In this arrangement, it takes 11 steps to collect all of the objects at the fourth floor for assembly. (Each elevator stop counts as one step, even if nothing is added to or removed from it.)
 
 In your situation, what is the minimum number of steps required to bring all of the objects to the fourth floor?
 
 Your puzzle answer was 47.
 
 --- Part Two ---
 
 You step into the cleanroom separating the lobby from the isolated area and put on the hazmat suit.
 
 Upon entering the isolated containment area, however, you notice some extra parts on the first floor that weren't listed on the record outside:
 
 An elerium generator.
 An elerium-compatible microchip.
 A dilithium generator.
 A dilithium-compatible microchip.
 These work just like the other generators and microchips. You'll have to get them up to assembly as well.
 
 What is the minimum number of steps required to bring all of the objects, including these four new ones, to the fourth floor?
 
 Your puzzle answer was 71.
 */

/*
 The first floor contains a polonium generator, a thulium generator, a thulium-compatible microchip, a promethium generator, a ruthenium generator, a ruthenium-compatible microchip, a cobalt generator, and a cobalt-compatible microchip.
 The second floor contains a polonium-compatible microchip and a promethium-compatible microchip.
 The third floor contains nothing relevant.
 The fourth floor contains nothing relevant.

    0   1   2   3   4   5   6   7   8   9   10
 F4 .   .   .   .   .   .   .   .   .   .   .
 F3 .   .   .   .   .   .   .   .   .   .   .
 F2 .   .   PLM .   .   .   PRM .   .   .   .
 F1 E   PLG .   TG  TM  PRG .   RG  RM  CG  CM
 
 */

typealias House = UInt64

let floor0Mask: UInt64 = 0xffff
let floor1Mask: UInt64 = 0xffff0000
let floor2Mask: UInt64 = 0xffff00000000
let floor3Mask: UInt64 = 0xffff000000000000

let maxFloor = 3
let minFloor = 0

let floorMasks: Array<UInt64> = [floor0Mask, floor1Mask, floor2Mask, floor3Mask]

func getFloor(floor: Int, house: House) -> UInt64 {
    return (house & floorMasks[floor]) >> (floor*16)
}

func setFloor(floor: Int, data: UInt64, house: House) -> UInt64 {
    return (house & ~(floorMasks[floor])) | (data << (floor*16))
}

let elevMask: UInt64 = 1
let gen1Mask: UInt64 = 1 << 1
let mic1Mask: UInt64 = 1 << 2
let gen2Mask: UInt64 = 1 << 3
let mic2Mask: UInt64 = 1 << 4
let gen3Mask: UInt64 = 1 << 5
let mic3Mask: UInt64 = 1 << 6
let gen4Mask: UInt64 = 1 << 7
let mic4Mask: UInt64 = 1 << 8
let gen5Mask: UInt64 = 1 << 9
let mic5Mask: UInt64 = 1 << 10
let gen6Mask: UInt64 = 1 << 11
let mic6Mask: UInt64 = 1 << 12
let gen7Mask: UInt64 = 1 << 13
let mic7Mask: UInt64 = 1 << 14

let maskArray = [elevMask, gen1Mask, mic1Mask, gen2Mask, mic2Mask, gen3Mask, mic3Mask, gen4Mask, mic4Mask, gen5Mask, mic5Mask, gen6Mask, mic6Mask, gen7Mask, mic7Mask]

let micMask = mic1Mask | mic2Mask | mic3Mask | mic4Mask | mic5Mask | mic6Mask | mic7Mask
let genMask = gen1Mask | gen2Mask | gen3Mask | gen4Mask | gen5Mask | gen6Mask | gen7Mask

/*
let testfloor2 = gen2Mask
let testfloor1 = gen1Mask
let testfloor0 = elevMask | mic1Mask | mic2Mask

var testHouse: House = 0
testHouse = setFloor(floor: 0, data: testfloor0, house: testHouse)
testHouse = setFloor(floor: 1, data: testfloor1, house: testHouse)
testHouse = setFloor(floor: 2, data: testfloor2, house: testHouse)
*/

func printHouse(house: House, floorSize: Int) {
    let Elevator = "-EE-"
    let Mic = "<MM>"
    let Gen = "*GG*"
    for j in maxFloor...minFloor {
        let floor = getFloor(floor: j, house: house)
        var line = ""
        for i in 0..<floorSize {
            if (maskArray[i] & floor) == 0 {
                line += ".... "
            }
            else {
                if i == 0 {
                    line += Elevator + " "
                }
                else {
                    if i % 2 == 0 {
                        line += Mic + " "
                    }
                    else {
                        line += Gen + " "
                    }
                }
            }
        }
        print(line)
    }
    print("")
}

func moveColumnUp(row: Int, col: Int, house: House) -> House {
    var res = house
    var newFloor = getFloor(floor: row+1, house: res)
    newFloor = newFloor | maskArray[col] | maskArray[0]
    res = setFloor(floor: row+1, data: newFloor, house: house)
    newFloor = getFloor(floor: row, house: res)
    newFloor = (newFloor & ~maskArray[col]) & ~maskArray[0]
    res = setFloor(floor: row, data: newFloor, house: res)
    return res
}

func moveColumnDown(row: Int, col: Int, house: House) -> House {
    var res = house
    var newFloor = getFloor(floor: row-1, house: res)
    newFloor = newFloor | maskArray[col] | maskArray[0]
    res = setFloor(floor: row-1, data: newFloor, house: house)
    newFloor = getFloor(floor: row, house: res)
    newFloor = (newFloor & ~maskArray[col]) & ~maskArray[0]
    res = setFloor(floor: row, data: newFloor, house: res)
    return res
}

func eachMhasG(floor: UInt64, floorSize: Int) -> Bool {
    var i = 1
    while i < floorSize {
        if ((maskArray[i+1] & floor) != 0) && ((maskArray[i] & floor) == 0) {
            return false
        }
        i += 2
    }
    return true
}

func checkRules(house: House, floorSize: Int) -> Bool {
    for i in minFloor...maxFloor {
        let floor = getFloor(floor: i, house: house)
        if ((floor & micMask) != 0) && ((floor & genMask) != 0) {
            if !eachMhasG(floor: floor, floorSize: floorSize) {
                return false
            }
        }
    }
    return true
}

func completed(house: House, completedMask: UInt64) -> Bool {
    return getFloor(floor: maxFloor, house: house) == completedMask
}

func createHouseMoves(house: House, floorSize: Int) -> Array<House> {
    var result = [House]()
    var floor = minFloor
    
    // find the elevator
    while floor < maxFloor {
        if (getFloor(floor: floor, house: house) & elevMask) != 0 {
            break
        }
        floor += 1
    }
    
    // start moving up
    if floor < maxFloor {
        // one item
        for col in 1..<floorSize {
            if (getFloor(floor: floor, house: house) & maskArray[col]) != 0 {
                let h = moveColumnUp(row: floor, col: col, house: house)
                if checkRules(house: h, floorSize: floorSize) {
                    result.append(h)
                }
            }
        }
        // two items
        for col in 1..<floorSize {
            if (getFloor(floor: floor, house: house) & maskArray[col]) != 0 {
                let h = moveColumnUp(row: floor, col: col, house: house)
                for cl in col+1..<floorSize {
                    if (getFloor(floor: floor, house: house) & maskArray[cl]) != 0 {
                        let hh = moveColumnUp(row: floor, col: cl, house: h)
                        if checkRules(house: hh, floorSize: floorSize) {
                            result.append(hh)
                        }
                    }
                }
            }
        }
    }

    // moving one item down
    if floor > 0 {
        for col in 1..<floorSize {
            if (getFloor(floor: floor, house: house) & maskArray[col]) != 0 {
                let h = moveColumnDown(row: floor, col: col, house: house)
                if checkRules(house: h, floorSize: floorSize) {
                    result.append(h)
                }
            }
        }
        // two items
        for col in 1..<floorSize {
            if (getFloor(floor: floor, house: house) & maskArray[col]) != 0 {
                let h = moveColumnDown(row: floor, col: col, house: house)
                for cl in col+1..<floorSize {
                    if (getFloor(floor: floor, house: house) & maskArray[cl]) != 0 {
                        let hh = moveColumnDown(row: floor, col: cl, house: h)
                        if checkRules(house: hh, floorSize: floorSize) {
                            result.append(hh)
                        }
                    }
                }
            }
        }
    }
    
    return result
}

/*
 dictionary with nodes
 key            value
 house(UInt64) : house(UInt64)
 
 this should keep the solutions on one level unique, and also should prevent going back one step with rememberin the previous variant
 disadvantage is not possible to recontruct the generation process
 for recontruction the value must be array, but the memmory requirements raise drasticly
 */

typealias BFSNodes = Dictionary<House,House>

func breadthFirstSearch(house: House, floorSize: Int) {
    var completedMask = elevMask
    for i in 1..<floorSize {
        completedMask = completedMask | maskArray[i]
    }
    var nodesToProcess = [house:House()]
    var found = false
	var steps = 0
    while !found {
		steps += 1
		print("Step: " + String(steps) + " Number of arrays: " + String(nodesToProcess.count))
        var newNodes: BFSNodes = [House():House()]
        for nodeKey in nodesToProcess.keys {
            let moves = createHouseMoves(house: nodeKey, floorSize: floorSize)
            for m in moves {
                if completed(house: m, completedMask: completedMask) {
                    found = true
                    break
                }
                if nodesToProcess[nodeKey]! != m {
					if newNodes[m] == nil {
                    	newNodes[m] = nodeKey
					}
                }
            }
            if found {
                break
            }
        }
        nodesToProcess = newNodes
    }
	print("Steps to find solution: " + String(steps))
}

// Part 1
let floorSize1 = 11
var house: House = 0
let inputfloor1 = mic1Mask | mic3Mask
let inputfloor0 = elevMask | gen1Mask | gen2Mask | mic2Mask | gen3Mask | gen4Mask | mic4Mask | gen5Mask | mic5Mask
house = setFloor(floor: 0, data: inputfloor0, house: house)
house = setFloor(floor: 1, data: inputfloor1, house: house)
/*
let start = DispatchTime.now() // <<<<<<<<<< Start time
breadthFirstSearch(house: house, floorSize: floorSize1)
let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval) seconds\n")
*/
// Part 2
let floorSize2 = 15
var house2 : House = 0
let input2floor1 = mic1Mask | mic3Mask
let input2floor0 = elevMask | gen1Mask | gen2Mask | mic2Mask | gen3Mask | gen4Mask | mic4Mask | gen5Mask | mic5Mask | gen6Mask | mic6Mask | gen7Mask | mic7Mask
house2 = setFloor(floor: 0, data: input2floor0, house: house2)
house2 = setFloor(floor: 1, data: input2floor1, house: house2)
/*
let start2 = DispatchTime.now() // <<<<<<<<<< Start time
breadthFirstSearch(house: house2, floorSize: floorSize2)
let end2 = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval2) seconds\n")
*/

func generateNewVariants(keyRange: inout Array<House>, nodesToProcess: inout BFSNodes, floorSize: Int, completedMask: UInt64) -> (found: Bool, newNodes: BFSNodes) {
	var newNodes: BFSNodes = [House():House()]
	print("Key range size: " + String(keyRange.count) + /*" Nodes in array: " + String(nodesToProcess.first!.value.count) +*/ " Number of arrays: " + String(nodesToProcess.count))
	var found = false
	for nodeKey in keyRange {
		let moves = createHouseMoves(house: nodeKey, floorSize: floorSize)
		for m in moves {
			if completed(house: m, completedMask: completedMask) {
				found = true
				break
			}
			if nodesToProcess[nodeKey]! != m {
				if newNodes[m] == nil {
					newNodes[m] = nodeKey
				}
			}
		}
		if found {
			break
		}
	}
	return (found, newNodes)
}


func breadthFirstSearchParallel(house: House, floorSize: Int, threads: Int) {
	var completedMask = elevMask
	for i in 1..<floorSize {
		completedMask = completedMask | maskArray[i]
	}

	var queues = [DispatchQueue]()
	var results = [(found: Bool, newNodes: BFSNodes)]()
	for i in 0..<threads {
		let queue = DispatchQueue(label: String("bfs.") + String(i))
		queues.append(queue)
		let result: (found: Bool, newNodes: BFSNodes) = (false, BFSNodes())
		results.append(result)
	}

	var keysArr: Array<Array<House>> = [[House]]()
	var keys: Array<House> = []

	let group = DispatchGroup()
	var nodesToProcess = [house:House()]
	var steps = 0
	var found = false
	while !found {
		steps += 1
		print("Step: " + String(steps) + " Number of arrays: " + String(nodesToProcess.count))

		keysArr = [[House]]()
		keys = Array(nodesToProcess.keys)
		if nodesToProcess.count > threads {
			for i in 0..<threads {
				let a = (i*(keys.count/threads))
				var b = 0
				if i < (threads-1) {
					b = ((i+1)*(keys.count/threads))
				}
				else {
					b = keys.count
				}
				let k = Array(keys[a..<b])
				keysArr.append(k)
			}

			for i in 0..<threads {
				group.enter()
				queues[i].async(group: group) {
					results[i] = generateNewVariants(keyRange: &keysArr[i], nodesToProcess: &nodesToProcess, floorSize: floorSize, completedMask: completedMask)
					group.leave()
				}
			}
			group.wait()

			for i in 0..<threads {
				if i != 0 {
					nodesToProcess.merge(results[i].newNodes, uniquingKeysWith: { (a,b) in return a } )
				}
				else {
					nodesToProcess = results[i].newNodes
				}
			}

			for i in 0..<threads {
				if results[i].found {
					found = true
					break
				}
			}
		}
		else {
			var kk = Array(nodesToProcess.keys)
			let result = generateNewVariants(keyRange: &kk, nodesToProcess: &nodesToProcess, floorSize: floorSize, completedMask: completedMask)
			nodesToProcess = result.newNodes
			if result.found {
				found = true
			}
		}
	}
	print("Steps: " + String(steps))
}


let start3 = DispatchTime.now() // <<<<<<<<<< Start time
breadthFirstSearchParallel(house: house, floorSize: floorSize1, threads: 8)
let end3 = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime3 = end3.uptimeNanoseconds - start3.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval3 = Double(nanoTime3) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval3) seconds\n")

let start4 = DispatchTime.now() // <<<<<<<<<< Start time
breadthFirstSearchParallel(house: house2, floorSize: floorSize2, threads: 8)
let end4 = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime4 = end4.uptimeNanoseconds - start4.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval4 = Double(nanoTime4) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval4) seconds\n")

