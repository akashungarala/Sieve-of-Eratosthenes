//
//  ResultViewController.swift
//  SieveOfEratosthenes
//
//  Created by Akash Ungarala on 11/2/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit

class SimpleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detectPrimeButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loading: UILabel!
    
    var limit:NSInteger = NSInteger()
    var objectToPrimeify:Primes = Primes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userCollection = [Bool]()
        for _ in self.objectToPrimeify.adjustIndexForFirstPrime...limit {
            userCollection.append(true)
        }
        self.activityIndicator.isHidden = true
        self.loading.isHidden = true
        self.objectToPrimeify = Primes.init(userUpperLimit: limit, userCollection: userCollection)
        self.detectPrimeButton.setTitle("Sweep for \(self.objectToPrimeify.currentSmallestPrime)", for: UIControlState.normal)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func detectPrimeButtonClicked(_ sender: UIButton) {
        sweep()
        self.tableView.reloadData()
    }
    
    @IBAction func fastButtonClicked(_ sender: UIButton) {
        self.detectPrimeButton.isEnabled = false
        self.fastButton.isEnabled = false
        self.detectPrimeButton.isHidden = true
        self.fastButton.isHidden = true
        self.activityIndicator.isHidden = false
        self.loading.isHidden = false
        DispatchQueue.global(qos: .background).async {
            repeat {
                self.sweep()
            } while self.objectToPrimeify.currentSmallestPrime != self.objectToPrimeify.lastSmallestPrime
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.loading.isHidden = true
                self.detectPrimeButton.isEnabled = true
                self.fastButton.isEnabled = true
                self.detectPrimeButton.isHidden = false
                self.fastButton.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objectToPrimeify.primeCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! Cell
        let currentCellNumber = self.objectToPrimeify.primeCollection[indexPath.row]
        let actualNumber = self.objectToPrimeify.getAcutalNumberForIndexRow(row: indexPath.row)
        cell.numberLabel.text = String(actualNumber)
        if(currentCellNumber == false) {
            cell.statusLabel.text = "Not Prime"
            cell.statusLabel.textColor = UIColor.black
            cell.numberLabel.textColor = UIColor.black
        } else if(actualNumber <= self.objectToPrimeify.lastSmallestPrime) {
            cell.statusLabel.text = "Prime"
            cell.statusLabel.textColor = UIColor.green
            cell.numberLabel.textColor = UIColor.green
        } else {
            cell.statusLabel.text = "Not Evaluated"
            cell.statusLabel.textColor = UIColor.white
            cell.numberLabel.textColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func sweep() {
        self.objectToPrimeify.primeCollection = self.objectToPrimeify.runPrimeSweep(collectionOfNumbers: self.objectToPrimeify.primeCollection, currentSmallestActualNumber: self.objectToPrimeify.currentSmallestPrime)
        self.objectToPrimeify.getNewSmallestPrime()
        self.detectPrimeButton.setTitle("Sweep for \(self.objectToPrimeify.currentSmallestPrime)", for: UIControlState.normal)
    }

}
