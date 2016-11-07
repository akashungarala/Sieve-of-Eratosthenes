//
//  InfoViewController.swift
//  SieveOfEratosthenes
//
//  Created by Akash Ungarala on 11/3/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit

// Constants for segmented control, raw type of Int
enum SegmentedControlEnum: Int {
    case PRIME_NUM_SEGMENT
    case ALL_NUM_SEGMENT
}

class CreativeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // 2 different collection views to switch between
    @IBOutlet weak var numberCollectionView: UICollectionView!
    @IBOutlet weak var primeCollectionView: UICollectionView!
    @IBOutlet weak var numberSegmentedControl: UISegmentedControl!
    
    // Constants
    let reusableCellIdentifier = "CollectionCell"
    let minCellSpacing   = CGFloat(0)
    let numCellPerRow    =  CGFloat(10)
    let minNumCellPerRow = CGFloat(5)
    let collectionViewPadding = CGFloat(40)
    let partitionMax  = 100000    // Partitions display by 100000 elements at a time.
    
    // Variables
    var limit:NSInteger = NSInteger()
    var sieveObj: SieveOfEratosthenses!
    var receivedNum: Int!
    var sieveArray: Array<Bool>!
    var primeNumsArray: Array<Int>!
    var collectionViewWidth: CGFloat!
    var calcCellSize: CGFloat!
    var numPartitionsSet: Int = 1
    var segmentedControlType : SegmentedControlEnum = .ALL_NUM_SEGMENT // Display all numbers by default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receivedNum = limit
        // If the given limit is less than the partition maximum, just perform the algorithm with the limit number
        if (receivedNum <= partitionMax) {
            sieveObj = SieveOfEratosthenses(newUpToNum: receivedNum)
            sieveObj.computeSieveOfEratosthenses()
            updateAllSieveArrays() // Update numbers, primes, and composite arrays
        } else { // Partition the work accordingly, but perform first partition right now.
            //Pre-thread operations
            sieveObj = SieveOfEratosthenses(newUpToNum: partitionMax)
            sieveObj.computeSieveOfEratosthenses()
            updateAllSieveArrays() // Update numbers, primes, and composite arrays
            numPartitionsSet = 1
            // Compute rest asynchronously on background thread, immediately after the first partition
            DispatchQueue.global(qos: .background).async {
                self.sieveObj.computeSieveOfEratosthenses(newUpToNum: self.receivedNum)
                self.updateAllSieveArrays()
                self.numberCollectionView.collectionViewLayout.invalidateLayout()
                self.primeCollectionView.collectionViewLayout.invalidateLayout()
                DispatchQueue.main.async {}
            }
        }
        // Store the width of the collection view so that we can programatically enforce 10 numbers per row
        collectionViewWidth = UIScreen.main.bounds.width - collectionViewPadding
        // Enforce 10 cells per row by calculating how much space there is for each cell
        calcCellSize = (collectionViewWidth - numCellPerRow * minCellSpacing) / numCellPerRow
        // If the circles are too small, re-calculate with only 5 cells per row
        if (calcCellSize < 30) {
            calcCellSize = (collectionViewWidth - numCellPerRow * minCellSpacing) / minNumCellPerRow
        }
        // Since default segment is "All Numbers", make sure the other collectionView is hidden
        primeCollectionView.isHidden = true
    }
    
    // Tell the collection view about the size of our cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: calcCellSize, height: calcCellSize) // Set the default size of the cell so that we can have 10 cells per row
    }
    
    // Denote how many cells we need to make for each view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sizeNum:Int!
        if (collectionView.isEqual(numberCollectionView)) {
            // We need a collection of n-1 cells (the aglorithm does not include last digit of the specified limit)
            // We also want to start from index 1 (so, take out a cell)
            if (receivedNum <= partitionMax * numPartitionsSet) {
                sizeNum = receivedNum - 1
            } else {
                sizeNum = partitionMax * numPartitionsSet
            }
        } else if (collectionView.isEqual(primeCollectionView)) {
            sizeNum = primeNumsArray.count
        }
        return sizeNum;
    }
    
    // Tell the collection view about the cell we want to use at a particular index of the collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var borderThickness: CGFloat = 0.0 // Border thickness will vary. Thicker border => prime.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellIdentifier, for: indexPath) as! CollectionCell // Reference the storyboard cell
        cell.layer.shouldRasterize = true // Rasterize the cell to increase FPS when scrolling
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.cellLabel.font = cell.cellLabel.font.withSize(12)
        let themeColor = UIColor(red: 25/255, green: 148/255, blue: 252/255, alpha: 1.0)
        if (collectionView.isEqual(numberCollectionView)) {
            let cellIndex = indexPath.item+1 // Start from 1, not 0 (ignore the number 0)
            // If we hit the partitionmax, load more cells and increment our count of partitions
            if (cellIndex+1 == (partitionMax * numPartitionsSet)) {
                numPartitionsSet += 1
                numberCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet) // Reset number of cells
            }
            cell.cellLabel.text = String(cellIndex) // Set the visible cell number
            cell.backgroundColor = UIColor.white
            if (sieveArray[cellIndex]) {
                cell.cellLabel.textColor = UIColor.black
                borderThickness = 0.0
            } else {
                cell.cellLabel.textColor = themeColor
            }
        } else if (collectionView.isEqual(primeCollectionView)) {
            let cellIndex = indexPath.item
            cell.cellLabel.text = String(primeNumsArray[cellIndex]) // Store next prime number
            cell.cellLabel.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            borderThickness = 0.0
        }
        // Modify cell attributes further
        cell.layer.cornerRadius = cell.frame.size.height / 2 // Make cells circular
        cell.layer.borderColor = UIColor.black.cgColor// Set border color to black
        cell.layer.borderWidth = borderThickness // Border width varies on the number
        return cell
    }
    
    @IBAction func onSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        segmentedControlType = SegmentedControlEnum(rawValue: numberSegmentedControl.selectedSegmentIndex)!
        switch segmentedControlType {
        case .PRIME_NUM_SEGMENT:
            numberCollectionView.isHidden = true
            primeCollectionView.isHidden = false
            break
        case .ALL_NUM_SEGMENT:
            numberCollectionView.isHidden = false
            primeCollectionView.isHidden = true
            break
        }
    }
    
    func updateAllSieveArrays() {
        // Generate the sieveArray that holds all true/false values (information whether an index/number is prime or not)
        sieveArray = sieveObj.returnListOfNums()
        primeNumsArray = sieveObj.returnListOfPrimeNums() // Store prime numbers array
    }

}
