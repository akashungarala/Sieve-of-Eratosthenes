//
//  InitialViewController.swift
//  SieveOfEratosthenes
//
//  Created by Akash Ungarala on 11/2/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var limit: UITextField!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var goAhead: UIButton!
    @IBOutlet weak var pattern: UISegmentedControl!
    @IBOutlet weak var patternImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.limit.text = nil
        self.goAhead.isHidden = true
        pattern.selectedSegmentIndex = 1
        patternImage.image = UIImage(named: "Creative")
        _ = isValid()
    }
    
    @IBAction func patternChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            patternImage.image = UIImage(named: "Simple")
        } else if sender.selectedSegmentIndex == 1 {
            patternImage.image = UIImage(named: "Creative")
        }
    }
    
    @IBAction func limitChanged(_ sender: UITextField) {
        if (isValid() == true) {
            self.goAhead.isHidden = false
        } else {
            self.goAhead.isHidden = true
        }
    }
    
    @IBAction func goAhead(_ sender: UIButton) {
        if self.pattern.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "Simple", sender: nil)
        } else if self.pattern.selectedSegmentIndex == 1 {
            performSegue(withIdentifier: "Creative", sender: nil)
        }
    }
    
    @IBAction func closeToHome(sender: UIStoryboardSegue) {}
    
    func isValid() -> Bool {
        var isValid = false
        if let text = self.limit.text , !text.isEmpty
        {
            if Int(text) != nil {
                if (Int(text)! > 1) {
                    if(Int(text)! > 100000) {
                        self.message.text = "Too Huge! Enter a number less than 100000!"
                        isValid = false
                    } else if(Int(text)! > 10000) {
                        self.message.text = "Huge! There will be wait times!"
                        isValid = true
                    } else {
                        self.message.text = "Lets Do It!"
                        isValid = true
                    }
                } else {
                    self.message.text = "Please enter a number larger than 1"
                    isValid = false
                }
            } else {
                self.message.text = "Please enter a non-negative integer"
                isValid = false
            }
        } else {
            self.message.text = "Enter a Number"
        }
        return isValid
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Simple" || identifier == "Creative" {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Simple" {
            let destination = segue.destination as! SimpleViewController
            destination.limit = NSInteger(Int(self.limit.text!)!)
        } else if segue.identifier == "Creative" {
            let destination = segue.destination as! CreativeViewController
            destination.limit = NSInteger(Int(self.limit.text!)!)
        }
    }

}
