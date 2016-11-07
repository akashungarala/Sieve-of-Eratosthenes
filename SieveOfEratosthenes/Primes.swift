//
//  Primes.swift
//  SieveOfEratosthenes
//
//  Created by Akash Ungarala on 11/2/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import Foundation
import UIKit

class Primes: NSObject {
    
    var primeCollection = [Bool]()
    var primeUpperLimit = NSInteger()
    var lastSmallestPrime:NSInteger = 0
    var currentSmallestPrime:NSInteger = 2
    let adjustIndexForFirstPrime:NSInteger = 2
    
    override init() {}
    
    init(userUpperLimit:NSInteger, userCollection:[Bool]) {
        self.primeUpperLimit = userUpperLimit
        self.primeCollection = userCollection
    }
    
    func runPrimeSweep(collectionOfNumbers: [Bool], currentSmallestActualNumber: NSInteger) -> [Bool] {
        var collectionOfNumbers = collectionOfNumbers
        var x = currentSmallestActualNumber - self.adjustIndexForFirstPrime
        repeat {
            if ((x+2) % currentSmallestActualNumber == 0) {
                collectionOfNumbers[x] = false
            }
            x += 1
        } while x < collectionOfNumbers.count
        //to mark the current number that we use to compare as prime since we marked it as false earlier
        collectionOfNumbers[currentSmallestActualNumber - self.adjustIndexForFirstPrime] = true
        return collectionOfNumbers
    }
    
    func getNewSmallestPrime() {
        self.lastSmallestPrime = self.currentSmallestPrime
        if(self.currentSmallestPrime < self.primeUpperLimit) {
            var x = self.currentSmallestPrime - self.adjustIndexForFirstPrime + 1
            repeat {
                if(self.primeCollection[x] == true) {
                    self.currentSmallestPrime = x + self.adjustIndexForFirstPrime
                    return
                }
                x += 1
            } while (x < self.primeUpperLimit - 1)
        }
    }
    
    func getAcutalNumberForIndexRow(row:NSInteger)->NSInteger{
        let actualNumber = row + self.adjustIndexForFirstPrime
        return actualNumber
    }
    
}
