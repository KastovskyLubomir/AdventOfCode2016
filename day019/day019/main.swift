//
//  main.swift
//  day019
//
//  Created by Lubomír Kaštovský on 20/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

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
	print("Defragment")
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
			print(j)
			array[i] = array[j]
			array[j] = -1
		}
		i += 1
		if (i % 100000) == 0 {
			print(i)
		}
	}
	array.removeSubrange(i..<array.count)
}

func stealing2(startCount: Int) -> Int {
    var array = Array<Int>(repeating: 0, count: startCount)
    for i in 0..<startCount {
        array[i] = i+1
    }
    print(array.count)
    var i = 0
    var removeIndex = 0
	var removed = 0
    while array.count > 1 {
        removeIndex =  ((i+((array.count-removed)/2)) + removed) % array.count
        array[removeIndex] = -1
		removed += 1
        if removed >= (array.count/2) {
			defrag(array: &array)
			removed = 0
        }
		if (removed % 1000) == 0 {
			print(removed)
		}
		if(removeIndex < i) {
			i -= 1
		}
		i += 1
		if i == (array.count - removed) {
			i = 0
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
		//print("r:" + String(array[removeIndex]))
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

//print("Part 1: " + String(stealing(startCount: startCount)))
print("Part 2: " + String(stealing2(startCount: 10)))
print("Test: " + String(stealing3(startCount: 10)))

