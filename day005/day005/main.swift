//
//  main.swift
//  day005
//
//  Created by Lubomír Kaštovský on 02/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 5: How About a Nice Game of Chess? ---
 
 You are faced with a security door designed by Easter Bunny engineers that seem to have acquired most of their security knowledge by watching hacking movies.
 
 The eight-character password for the door is generated one character at a time by finding the MD5 hash of some Door ID (your puzzle input) and an increasing integer index (starting with 0).
 
 A hash indicates the next character in the password if its hexadecimal representation starts with five zeroes. If it does, the sixth character in the hash is the next character of the password.
 
 For example, if the Door ID is abc:
 
 The first index which produces a hash that starts with five zeroes is 3231929, which we find by hashing abc3231929; the sixth character of the hash, and thus the first character of the password, is 1.
 5017308 produces the next interesting hash, which starts with 000008f82..., so the second character of the password is 8.
 The third time a hash starts with five zeroes is for abc5278568, discovering the character f.
 In this example, after continuing this search a total of eight times, the password is 18f47a30.
 
 Given the actual Door ID, what is the password?
 
 Your puzzle answer was d4cd2ee1.
 
 --- Part Two ---
 
 As the door slides open, you are presented with a second door that uses a slightly more inspired security mechanism. Clearly unimpressed by the last version (in what movie is the password decrypted in order?!), the Easter Bunny engineers have worked out a better solution.
 
 Instead of simply filling in the password from left to right, the hash now also indicates the position within the password to fill. You still look for hashes that begin with five zeroes; however, now, the sixth character represents the position (0-7), and the seventh character is the character to put in that position.
 
 A hash result of 000001f means that f is the second character in the password. Use only the first result for each position, and ignore invalid positions.
 
 For example, if the Door ID is abc:
 
 The first interesting hash is from abc3231929, which produces 0000015...; so, 5 goes in position 1: _5______.
 In the previous method, 5017308 produced an interesting hash; however, it is ignored, because it specifies an invalid position (8).
 The second interesting hash is at index 5357525, which produces 000004e...; so, e goes in position 4: _5__e___.
 You almost choke on your popcorn as the final character falls into place, producing the password 05ace8e3.
 
 Given the actual Door ID and this new method, what is the password? Be extra proud of your solution if it uses a cinematic "decrypting" animation.
 
 Your puzzle answer was f2c730e5.
 */

import Foundation

/*
func md5(_ string: String) -> String {
    
    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5_Init(context)
    CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
    CC_MD5_Final(&digest, context)
    context.deallocate(capacity: 1)
    var hexString = ""
    for byte in digest {
        hexString += String(format:"%02x", byte)
    }
    
    return hexString
}
*/

func printHash(hash:Array<UInt8>) {
	var hexString = ""
	for byte in hash {
		hexString += String(format:"%02x", byte)
	}
	print(hexString)
}

func passwordPart1(inputString: String) -> String {
    var digits = 0
    var i = 0
    var password = ""
    var hashInput = ""

    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))

    while digits < 8 {
        hashInput = inputString + String(i)
        CC_MD5_Init(context)
        CC_MD5_Update(context, hashInput, CC_LONG(hashInput.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        if (digest[0] == 0) && (digest[1] == 0) && (digest[2] < 16) {
			printHash(hash: digest)
            password += String(format:"%x", digest[2])
            digits += 1
        }
        
        digest = digest.map({x in return 0})
        i += 1
    }
    context.deallocate(capacity: 1)
    return password
}

func passwordPart2(inputString: String) -> String {
    var digits = 0
    var i = 0
    var password = Array<String>(repeatElement("", count: 8))
    var hashInput = ""
    
    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    
    while digits < 8 {
        hashInput = inputString + String(i)
        CC_MD5_Init(context)
        CC_MD5_Update(context, hashInput, CC_LONG(hashInput.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        if (digest[0] == 0) && (digest[1] == 0) && (digest[2] < 8) {
            if password[Int(digest[2])].isEmpty {
				printHash(hash: digest)
                var letters = String(format:"%02x", digest[3])
                letters.removeLast()
                password[Int(digest[2])] = letters
                digits += 1
            }
        }
        
        digest = digest.map({x in return 0})
        i += 1
    }
    context.deallocate(capacity: 1)
    return password.joined()
}

let inputString = "ugkcyxxp"

let start = DispatchTime.now() // <<<<<<<<<< Start time

print("Part 1 password: " + passwordPart1(inputString: inputString))

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval) seconds\n")


let start2 = DispatchTime.now() // <<<<<<<<<< Start time

print("Part 2 password: " + passwordPart2(inputString: inputString))

let end2 = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval2) seconds\n")

