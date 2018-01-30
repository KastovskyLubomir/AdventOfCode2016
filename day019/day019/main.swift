//
//  main.swift
//  day019
//
//  Created by Lubomír Kaštovský on 20/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 19: An Elephant Named Joseph ---
 
 The Elves contact you over a highly secure emergency channel. Back at the North Pole, the Elves are busy misunderstanding White Elephant parties.
 
 Each Elf brings a present. They all sit in a circle, numbered starting with position 1. Then, starting with the first Elf, they take turns stealing all the presents from the Elf to their left. An Elf with no presents is removed from the circle and does not take turns.
 
 For example, with five Elves (numbered 1 to 5):
 
 1
 5   2
 4 3
 Elf 1 takes Elf 2's present.
 Elf 2 has no presents and is skipped.
 Elf 3 takes Elf 4's present.
 Elf 4 has no presents and is also skipped.
 Elf 5 takes Elf 1's two presents.
 Neither Elf 1 nor Elf 2 have any presents, so both are skipped.
 Elf 3 takes Elf 5's three presents.
 So, with five Elves, the Elf that sits starting in position 3 gets all the presents.
 
 With the number of Elves given in your puzzle input, which Elf gets all the presents?
 
 Your puzzle answer was 1808357.
 
 --- Part Two ---
 
 Realizing the folly of their present-exchange rules, the Elves agree to instead steal presents from the Elf directly across the circle. If two Elves are across the circle, the one on the left (from the perspective of the stealer) is stolen from. The other rules remain unchanged: Elves with no presents are removed from the circle entirely, and the other elves move in slightly to keep the circle evenly spaced.
 
 For example, with five Elves (again numbered 1 to 5):
 
 The Elves sit in a circle; Elf 1 goes first:
 1
 5   2
 4 3
 Elves 3 and 4 are across the circle; Elf 3's present is stolen, being the one to the left. Elf 3 leaves the circle, and the rest of the Elves move in:
 1           1
 5   2  -->  5   2
 4 -          4
 Elf 2 steals from the Elf directly across the circle, Elf 5:
 1         1
 -   2  -->     2
 4         4
 Next is Elf 4 who, choosing between Elves 1 and 2, steals from Elf 1:
 -          2
 2  -->
 4          4
 Finally, Elf 2 steals from Elf 4:
 2
 -->  2
 -
 So, with five Elves, the Elf that sits starting in position 2 gets all the presents.
 
 With the number of Elves given in your puzzle input, which Elf now gets all the presents?
 
 Your puzzle answer was 1407007.
 
 Both parts of this puzzle are complete! They provide two gold stars: **
 
 At this point, you should return to your advent calendar and try another puzzle.
 
 Your puzzle input was 3001330.
 */

import Foundation

var startCount = 3001330
//var startCount = 5

func stealing(startCount: Int) -> Int {
    var array = Array<UInt8>(repeating: 1, count: startCount)
    print(array.count)
    var i = 0
    var count = array.filter({ (x: UInt8) -> Bool in return (x == 1) }).count
    while count > 1 {
        if (array[i] == 1) {
            if (i+1) == array.count {
                i = 0
            }
            else {
                i += 1
            }
            while array[i] == 0 {
                i += 1
                if i == array.count {
                    i = 0
                }
            }
            array[i] = 0
        }
        i += 1
        if i == array.count {
            i = 0
            count = array.filter({ (x: UInt8) -> Bool in return (x == 1) }).count
            print(count)
        }
    }

    return array.index(of: 1)!+1
}

func defrag(array: inout Array<Int>) {
	var i = 0
	var j = 0
	while i < array.count {
		if array[i] == -1 {
			if j == 0 {
				j = i
			}
			while (j < array.count) && (array[j] == -1) {
				j += 1
			}
			if j == array.count {
				break
			}
			array[i] = array[j]
			array[j] = -1
		}
		i += 1
	}
	array.removeSubrange(i..<array.count)
}

func find(x: Int, startPos: Int, array: inout Array<Int>) -> Int {
    var i = startPos + 1
    if i >= array.count {
        i = 0
    }
    var c = 0
    while c < array.count {
        if array[i] == x {
            return i
        }
        i += 1
        c += 1
        if i == array.count {
            i = 0
        }
    }
    return -1
}

func nextNonEmpty(startPos: Int, array: inout Array<Int>) -> Int {
    var i = startPos + 1
    if i >= array.count {
        i = 0
    }
    var c = 0
    while c < array.count {
        if array[i] != -1 {
            return i
        }
        i += 1
        c += 1
        if i == array.count {
            i = 0
        }
    }
    return -1
}

func stealing2(startCount: Int) -> Int {
    var array = Array<Int>(repeating: 0, count: startCount)
    for i in 0..<startCount {
        array[i] = i+1
    }
    var i = 0
    var nextI = 0
    var nextVal = 0
    var removeIndex = 0
	var removed = 0
    while array.count > 1 {
        removeIndex =  ((i+((array.count-removed)/2)) + removed) % array.count
        array[removeIndex] = -1
		removed += 1
        nextI = nextNonEmpty(startPos: i, array: &array)
        nextVal = array[nextI]
        i = nextI
        if removed >= (array.count/2) {
			defrag(array: &array)
			removed = 0
            i = find(x: nextVal, startPos: nextI, array: &array)
        }
    }
    
    return array[0]
}

func stealing3(startCount: Int) -> Int {
	var array = Array<Int>(repeating: 0, count: startCount)
	for i in 0..<startCount {
		array[i] = i+1
	}
	print(array.count)
	var i = 0
	var removeIndex = 0
	while array.count > 1 {
		removeIndex =  (i+(array.count/2)) % array.count
		print("r:" + String(array[removeIndex]))
		array.remove(at: removeIndex)
		if(removeIndex < i) {
			i -= 1
		}
		i += 1
		if i == array.count {
			i = 0
		}
	}
	return array[0]
}

print("Part 1: " + String(stealing(startCount: startCount)))
print("Part 2: " + String(stealing2(startCount: startCount)))
//print("Test: " + String(stealing3(startCount: 5)))

