//
//  SieveOfEratosthenses.swift
//  SieveOfEratosthenes
//
//  Created by Akash Ungarala on 11/4/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import Foundation
import UIKit

class SieveOfEratosthenses {
    
    let UP_TO_NUM_DEFAULT = 500
    private var upToNum: Int!
    private var listOfNums: Array<Bool>! // TRUE: Not prime; FALSE: Prime
    private var listOfPrimeNums: Array<Int>! // A listing of all prime numbers
    private var listOfCompositeNums:Array<Int>! // A listing of all non-prime numbers
    
    // Init method to set upToNum upon creation
    init(newUpToNum: Int) {
        if (newUpToNum <= 0) {
            upToNum = UP_TO_NUM_DEFAULT // Set back to default state of UP_TO_NUM_DEFAULT
        } else {
            upToNum = newUpToNum
        }
        generateNewListOfNums(upToNum: upToNum) // Generate a new list for private class variable, listOfNums
        listOfPrimeNums = Array<Int>()
        listOfCompositeNums = Array<Int>()
    }
    
    // Method to change upToNum. Will also change array (only if necessary)
    func setUpToNum(newUpToNum: Int) {
        if (newUpToNum <= 0) {
            upToNum = UP_TO_NUM_DEFAULT // Set back to default state of UP_TO_NUM_DEFAULT
        } else if (newUpToNum < upToNum) { // If the new upToNum is less than the old upToNum, truncate from the list
            let numTruncIndices = upToNum - newUpToNum // Calculate the number of indices we must truncate
            for _ in 0..<numTruncIndices {
                listOfNums.removeLast()
            }
            upToNum = newUpToNum
        } else if (newUpToNum > upToNum) {
            // We need to allocate more space
            // note: This does not wipe current array, so true/false values will remain the same unless the array is re-generated
            // Calculate the number of new indices we have to add to the array
            let numNewIndices = newUpToNum - upToNum
            for _ in 0..<numNewIndices {
                self.listOfNums.append(true)
            }
            upToNum = newUpToNum
        }
    }
    
    // Implementation of the algorithm using the initialized array
    func computeSieveOfEratosthenses() {
        let size:Int = listOfNums.count
        let sqrtSize:Int = Int(sqrt(Float(size)))
        // Iterate through array of boolean values. Stop after the square root of the size of the array because we can't eliminate any other numbers in the range i.e; If size = 30, then sqrtSize = 5. 6 * 6 is out range for our inner loop.
        for i in 2...sqrtSize {
            // If the indexed boolean value is true, it is prime. So we take this prime number and set all of its multiples to false
            if (listOfNums[i]) {
                // Start at the first multiple of number i (i^2), set it to false. Then proceed to set all other multiples of this prime number to false. Ex: If i is 2, we set index 4 to false, index 6 to false, index 8 to false, and so on.
                for j in stride(from: i*i, to: size, by: i) {
                    listOfNums[j] = false
                }
            }
        }
    }
    
    // Wrapper class for the algorithm
    func computeSieveOfEratosthenses(newUpToNum: Int) {
        setUpToNum(newUpToNum: newUpToNum)
        computeSieveOfEratosthenses()
    }
    
    // Return a boolean array
    func returnListOfNums() -> Array<Bool> {
        return listOfNums
    }
    
    func returnListOfPrimeNums() -> Array<Int> {
        let size:Int = listOfNums.count
        // Fill up other arrays on the fly, ignore the number 0
        for i in 1..<size {
            if (listOfNums[i]) { // If true, it is prime
                listOfPrimeNums.append(i)
            }
        }
        return listOfPrimeNums
    }
    
    func returnListOfCompositeNums() -> Array<Int> {
        let size:Int = listOfNums.count
        // Fill up other arrays on the fly, ignore the number 0
        for i in 1..<size {
            if (!listOfNums[i]) { // If false, it is composite
                listOfCompositeNums.append(i)
            }
        }
        return listOfCompositeNums
    }
    
    private func generateNewListOfNums(upToNum: Int) {
        listOfNums = Array<Bool>(repeating: true, count: upToNum) // Initialize array of upToNum boolean values
        // Set 0 and 1 to be not prime, because our algorithm does not involve these indices
        if (upToNum > 0) {
            listOfNums[0] = false
        }
        if (upToNum > 1) {
            listOfNums[1] = false
        }
    }
    
}
