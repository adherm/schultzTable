//
// Permutating the array of numbers.
// Random variables come from one of two sources:
//  . pseudo-random number from arc4random_uniform function
//  .   true-random number from random.org service
//
// Created by Adalbert Hermann
//

import Foundation

func randPerm(_ set: inout [Int?], isRealRand: Bool = false) {
    var transs = [Int](repeatElement(0, count: set.count))
    if isRealRand == false {
        for max in 0 ..< set.count {
            transs[max] = Int(arc4random_uniform(UInt32(max + 1)))
        }
    } else {
        let adjTransCount = (set.count - 1) * set.count / 2
        let realRandServ = "https://www.random.org/integers/?num="
            + String(adjTransCount)
            + "&min=0&max=1&col=1&base=2&format=plain&rnd=new"
        let url = URL(string: realRandServ)
        do {
            let rawRealRandAdjTrans = try String(contentsOf: url!, encoding: .ascii)
            func joinAdjTrans(_ str: String) -> [Int] {
                var list = [Int]()
                var grpCont = 0
                var jump = 0
                for step in str
                    where step == "1" || step == "0" {
                        jump += Int(String(step))!
                        if grpCont == list.count {
                            list.append(jump)
                            jump = 0
                            grpCont = 0
                        }
                        grpCont += 1
                }
                return [0] + list
            }
            transs = joinAdjTrans(rawRealRandAdjTrans)
            // joinAdjTrans("000b000c0000") ==> [0,0,0,0,0]
            // joinAdjTrans("1-11111*1111") ==> [0,1,2,3,4]
            
        } catch let error {
            print("I can't use data from www.random.org")
            print("pseudo-random numbers will be used:\n\(error)")
            randPerm(&set)
        }
    }
    func perm(_ set: [Int?], transpositions transs: [Int]) -> [Int?] {
        var outSet = [Int?]()
        for (trans,elem) in zip(transs,set) {
            outSet.insert(elem, at: trans)
        }
        return outSet
    }
    // perm([nil,1,2,3,4,5],[0,0,0,0,0,0]) == [5,4,3,2,1,nil]
    // perm([nil,1,2,3,4,5],[0,1,2,3,4,5]) == [nil,1,2,3,4,5]
    set = perm(set, transpositions: transs)
}

let gapCount = 5 * 5
let symbolCount = 6
let asciiA = 97 // "a"
//test that: 0 <= symbolCount <= gapCount
var schultz5x5Table = [Int?](repeating: nil, count: gapCount)

for index in 0 ..< symbolCount {
    schultz5x5Table[index] = asciiA + index
}

//randPerm(&schultz5x5Table, isRealRand: true)
randPerm(&schultz5x5Table)
print(schultz5x5Table)
print(schultz5x5Table.count)
