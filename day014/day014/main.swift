//
//  main.swift
//  day014
//
//  Created by Lubomír Kaštovský on 13/01/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 14: One-Time Pad ---
 
 In order to communicate securely with Santa while you're on this mission, you've been using a one-time pad that you generate using a pre-agreed algorithm. Unfortunately, you've run out of keys in your one-time pad, and so you need to generate some more.
 
 To generate keys, you first get a stream of random data by taking the MD5 of a pre-arranged salt (your puzzle input) and an increasing integer index (starting with 0, and represented in decimal); the resulting MD5 hash should be represented as a string of lowercase hexadecimal digits.
 
 However, not all of these MD5 hashes are keys, and you need 64 new keys for your one-time pad. A hash is a key only if:
 
 It contains three of the same character in a row, like 777. Only consider the first such triplet in a hash.
 One of the next 1000 hashes in the stream contains that same character five times in a row, like 77777.
 Considering future hashes for five-of-a-kind sequences does not cause those hashes to be skipped; instead, regardless of whether the current hash is a key, always resume testing for keys starting with the very next hash.
 
 For example, if the pre-arranged salt is abc:
 
 The first index which produces a triple is 18, because the MD5 hash of abc18 contains ...cc38887a5.... However, index 18 does not count as a key for your one-time pad, because none of the next thousand hashes (index 19 through index 1018) contain 88888.
 The next index which produces a triple is 39; the hash of abc39 contains eee. It is also the first key: one of the next thousand hashes (the one at index 816) contains eeeee.
 None of the next six triples are keys, but the one after that, at index 92, is: it contains 999 and index 200 contains 99999.
 Eventually, index 22728 meets all of the criteria to generate the 64th key.
 So, using our example salt of abc, index 22728 produces the 64th key.
 
 Given the actual salt in your puzzle input, what index produces your 64th one-time pad key?
 
 Your puzzle answer was 25427.
 
 --- Part Two ---
 
 Of course, in order to make this process even more secure, you've also implemented key stretching.
 
 Key stretching forces attackers to spend more time generating hashes. Unfortunately, it forces everyone else to spend more time, too.
 
 To implement key stretching, whenever you generate a hash, before you use it, you first find the MD5 hash of that hash, then the MD5 hash of that hash, and so on, a total of 2016 additional hashings. Always use lowercase hexadecimal representations of hashes.
 
 For example, to find the stretched hash for index 0 and salt abc:
 
 Find the MD5 hash of abc0: 577571be4de9dcce85a041ba0410f29f.
 Then, find the MD5 hash of that hash: eec80a0c92dc8a0777c619d9bb51e910.
 Then, find the MD5 hash of that hash: 16062ce768787384c81fe17a7a60c7e3.
 ...repeat many times...
 Then, find the MD5 hash of that hash: a107ff634856bb300138cac6568c0f24.
 So, the stretched hash for index 0 in this situation is a107ff.... In the end, you find the original hash (one use of MD5), then find the hash-of-the-previous-hash 2016 times, for a total of 2017 uses of MD5.
 
 The rest of the process remains the same, but now the keys are entirely different. Again for salt abc:
 
 The first triple (222, at index 5) has no matching 22222 in the next thousand hashes.
 The second triple (eee, at index 10) hash a matching eeeee at index 89, and so it is the first key.
 Eventually, index 22551 produces the 64th key (triple fff with matching fffff at index 22859.
 Given the actual salt in your puzzle input and using 2016 extra MD5 calls of key stretching, what index now produces your 64th one-time pad key?
 
 Your puzzle answer was 22045.
 
 Both parts of this puzzle are complete! They provide two gold stars: **
 
 At this point, you should return to your advent calendar and try another puzzle.
 
 Your puzzle input was yjdafjpo.
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

func passwordCandidate(digest: Array<UInt8>) -> (Bool, UInt8) {
    var digits = [UInt8]()
    for x in digest {
        digits.append((x & 0xf0) >> 4)
        digits.append(x & 0x0f)
    }
    for i in 0..<digits.count-2 {
        if (digits[i] == digits[i+1]) && (digits[i] == digits[i+2]) {
            return (true, digits[i])
        }
    }
    return (false, 0)
}

func passwordConfirm(digest: Array<UInt8>, a: UInt8) -> Bool {
    var digits = [UInt8]()
    for x in digest {
        digits.append((x & 0xf0) >> 4)
        digits.append(x & 0x0f)
    }
    for i in 0..<digits.count-4 {
        if (digits[i] == digits[i+1]) && (digits[i] == digits[i+2]) &&
            (digits[i] == digits[i+3]) && (digits[i] == digits[i+4]) &&
            (digits[i] == a)
        {
            return true
        }
    }
    return false
}

func keySearch(inputString: String) -> Int {
    var i = 0
    var hashInput = ""
    
    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    
    var digestArr = [[UInt8]]()
    
    while i < 1001  {
        hashInput = inputString + String(i)
        CC_MD5_Init(context)
        CC_MD5_Update(context, hashInput, CC_LONG(hashInput.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        digestArr.append(digest)
        digest = digest.map({x in return 0})
        i += 1
    }
    
    var keyIndex = 0
    var digestIndex = 0
    while keyIndex < 64  {
        let res = passwordCandidate(digest: digestArr[0])
        if res.0 {
            var j = 1
            while j < 1001 {
                if passwordConfirm(digest: digestArr[j], a: res.1) {
                    var hexString = ""
                    for byte in digestArr[0] {
                        hexString += String(format:"%02x", byte)
                    }
                    print("Key: " + String(keyIndex) + " Index: " + String(digestIndex) +  " Key: " + hexString)
                    hexString = ""
                    for byte in digestArr[j] {
                        hexString += String(format:"%02x", byte)
                    }
                    print("Key: " + String(keyIndex) + " Index: " + String(digestIndex+j) +  " Key: " + hexString)
                    keyIndex += 1
                    break
                }
                j += 1
            }
        }
        
        digestIndex += 1
        digestArr.removeFirst()
        while digestArr.count < 1001 {
            hashInput = inputString + String(i)
            CC_MD5_Init(context)
            CC_MD5_Update(context, hashInput, CC_LONG(hashInput.lengthOfBytes(using: String.Encoding.utf8)))
            CC_MD5_Final(&digest, context)
            digestArr.append(digest)
            digest = digest.map({x in return 0})
            i += 1
        }
    }
    
    context.deallocate(capacity: 1)
    return (digestIndex-1)
}

func hashToString(digest: Array<UInt8>) -> String {
    return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15] )
}

func md5WithStretching(inputString: String, index: Int, stretching: Int) -> Array<UInt8> {
    var hashInput = inputString + String(index)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5(hashInput, CC_LONG(hashInput.lengthOfBytes(using: String.Encoding.utf8)), &digest)
    hashInput = hashToString(digest: digest)
    for _ in 0..<stretching {
        digest = digest.map({x in return 0})
        CC_MD5(hashInput, CC_LONG(hashInput.lengthOfBytes(using: String.Encoding.utf8)), &digest)
        hashInput = hashToString(digest: digest)
    }
    return digest
}

func keySearch2(inputString: String, hashStretching: Int) -> Int {
    var i = 0
    var digestArr = [[UInt8]]()
    print("Generating first 1000 hashes ...")
    while i < 1001  {
        if i % 100 == 0 {
            print(String(i/10) + "%")
        }
        let digest = md5WithStretching(inputString: inputString, index: i, stretching: hashStretching)
        digestArr.append(digest)
        i += 1
    }
    print("Searching for keys ...")
    var keyIndex = 0
    var digestIndex = 0
    while keyIndex < 64  {
        let res = passwordCandidate(digest: digestArr[0])
        if res.0 {
            var j = 1
            while j < 1001 {
                if passwordConfirm(digest: digestArr[j], a: res.1) {
                    var hexString = ""
                    for byte in digestArr[0] {
                        hexString += String(format:"%02x", byte)
                    }
                    print("Key: " + String(keyIndex) + " Index: " + String(digestIndex) +  " Key: " + hexString)
                    hexString = ""
                    for byte in digestArr[j] {
                        hexString += String(format:"%02x", byte)
                    }
                    print("Key: " + String(keyIndex) + " Index: " + String(digestIndex+j) +  " Key: " + hexString)
                    keyIndex += 1
                    break
                }
                j += 1
            }
        }
        
        digestIndex += 1
        digestArr.removeFirst()
        while digestArr.count < 1001 {
            let digest = md5WithStretching(inputString: inputString, index: i, stretching: hashStretching)
            digestArr.append(digest)
            i += 1
        }
    }
    
    return (digestIndex-1)
}

let input = "yjdafjpo"
//let input = "abc"
print("Part 1: Index of 64th one-time pad key: " + String(keySearch(inputString: input)))

print("Part 2: Index of 64th one-time pad key: " + String(keySearch2(inputString: input, hashStretching: 2016)))

//printHash(hash: md5WithStretching(inputString: "abc", index: 0, stretching: 2016))

