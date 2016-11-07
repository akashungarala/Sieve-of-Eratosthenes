//
//  Cell.swift
//  SieveOfEratosthenes
//
//  Created by Akash Ungarala on 11/2/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
