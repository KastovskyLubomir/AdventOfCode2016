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

func indexOfRemoved(array: inout Array<Int>, curentPos: Int) -> Int {
    var newPos = (curentPos + (array.count/2))
    if newPos >= array.count {
        newPos = newPos - array.count
    }
    return newPos
}

func stealing2(startCount: Int) -> Int {
    var array = Array<Int>(repeating: 0, count: startCount)
    for i in 0..<startCount {
        array[i] = i+1
    }
    print(array.count)
    var i = 0
    var removeIndex = 0
    while array.count > 1 {
        removeIndex =  (i+(array.count/2)) % array.count //indexOfRemoved(array: &array, curentPos: i)
        array.remove(at: removeIndex)
        if (i+1) >= array.count {
            i = (i+1) - array.count
        }
        else {
            i = i+1
        }
        if (array.count % 1000) == 0 {
            print(array.count)
        }
    }
    
    return array.index(of: 1)!+1
}

func stealing3(startCount: Int) -> Int {
    var dic = [Int:Int]()
    for i in 0..<startCount {
        dic[i] = i+1
    }
    print(dic.count)
    var i = 0
    var removeIndex = 0
    while dic.count > 1 {
        removeIndex =  (i+(dic.count/2)) % dic.count //indexOfRemoved(array: &array, curentPos: i)
        dic[dic.keys] = nil
        if (i+1) >= dic.count {
            i = (i+1) - dic.count
        }
        else {
            i = i+1
        }
        if (dic.count % 1000) == 0 {
            print(dic.count)
        }
    }
    
    return dic[dic.keys[0]]
}



//print("Part 1: " + String(stealing(startCount: startCount)))
print("Part 2: " + String(stealing2(startCount: startCount)))
