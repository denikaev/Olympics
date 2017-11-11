//
//  UserCell.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    
    var message = String() {
        didSet {
            UpdateUI()
        }
    }
    
    func UpdateUI() {
        messageLabel.text = message
    }
}
