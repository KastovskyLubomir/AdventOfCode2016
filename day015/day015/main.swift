//
//  main.swift
//  day015
//
//  Created by Lubomír Kaštovský on 14/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
--- Day 15: Timing is Everything ---

The halls open into an interior plaza containing a large kinetic sculpture. The sculpture is in a sealed enclosure and seems to involve a set of identical spherical capsules that are carried to the top and allowed to bounce through the maze of spinning pieces.

Part of the sculpture is even interactive! When a button is pressed, a capsule is dropped and tries to fall through slots in a set of rotating discs to finally go through a little hole at the bottom and come out of the sculpture. If any of the slots aren't aligned with the capsule as it passes, the capsule bounces off the disc and soars away. You feel compelled to get one of those capsules.

The discs pause their motion each second and come in different sizes; they seem to each have a fixed number of positions at which they stop. You decide to call the position with the slot 0, and count up for each position it reaches next.

Furthermore, the discs are spaced out so that after you push the button, one second elapses before the first disc is reached, and one second elapses as the capsule passes from one disc to the one below it. So, if you push the button at time=100, then the capsule reaches the top disc at time=101, the second disc at time=102, the third disc at time=103, and so on.

The button will only drop a capsule at an integer time - no fractional seconds allowed.

For example, at time=0, suppose you see the following arrangement:

Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
If you press the button exactly at time=0, the capsule would start to fall; it would reach the first disc at time=1. Since the first disc was at position 4 at time=0, by time=1 it has ticked one position forward. As a five-position disc, the next position is 0, and the capsule falls through the slot.

Then, at time=2, the capsule reaches the second disc. The second disc has ticked forward two positions at this point: it started at position 1, then continued to position 0, and finally ended up at position 1 again. Because there's only a slot at position 0, the capsule bounces away.

If, however, you wait until time=5 to push the button, then when the capsule reaches each disc, the first disc will have ticked forward 5+1 = 6 times (to position 0), and the second disc will have ticked forward 5+2 = 7 times (also to position 0). In this case, the capsule would fall through the discs and come out of the machine.

However, your situation has more than two discs; you've noted their positions in your puzzle input. What is the first time you can press the button to get a capsule?

Your puzzle answer was 400589.

--- Part Two ---

After getting the first capsule (it contained a star! what great fortune!), the machine detects your success and begins to rearrange itself.

When it's done, the discs are back in their original configuration as if it were time=0 again, but a new disc with 11 positions and starting at position 0 has appeared exactly one second below the previously-bottom disc.

With this new disc, and counting again starting from time=0 with the configuration in your puzzle input, what is the first time you can press the button to get another capsule?

Your puzzle answer was 3045959.
*/

/*
 Disc #1 has 17 positions; at time=0, it is at position 15.
 Disc #2 has 3 positions; at time=0, it is at position 2.
 Disc #3 has 19 positions; at time=0, it is at position 4.
 Disc #4 has 13 positions; at time=0, it is at position 2.
 Disc #5 has 7 positions; at time=0, it is at position 2.
 Disc #6 has 5 positions; at time=0, it is at position 0.
 */
import Foundation

struct Disc {
    var size: Int
    var pos: Int
}


var input = [Disc(size: 17, pos: 15), Disc(size: 3, pos: 2), Disc(size: 19, pos: 4), Disc(size: 13, pos: 2), Disc(size: 7, pos: 2), Disc(size: 5, pos: 0)]

//let input = [Disc(size: 5, pos: 4), Disc(size: 2, pos: 1)]

func findStartTime(discs: Array<Disc>) -> Int {
    var i = 0
    var dArr = discs
    while true {
        for j in 0..<dArr.count {
            if dArr[j].pos+1 == dArr[j].size {
                dArr[j].pos = 0
            }
            else {
                dArr[j].pos += 1
            }
        }
        
        var j = 0
        while j < dArr.count {
            if ((dArr[j].pos + j) % dArr[j].size) != 0 {
                break
            }
            j += 1
        }
        
        if j == dArr.count {
            break
        }
        
        i += 1
    }
    
    return i
}

print("Part 1: " + String(findStartTime(discs: input)))

input.append(Disc(size: 11, pos: 0))

print("Part 2: " + String(findStartTime(discs: input)))


