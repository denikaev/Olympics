//
//  Utils.swift
//  Associations
//
//  Created by Admin on 11.11.2017.
//  Copyright © 2017 Bugs. All rights reserved.
//

import UIKit

class Utils {
    
    // MARK: - Properties
    
    let description = "Utility class for everyday use."
    
    // MARK: - Utils
    
    // Get random float in [min..max]
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
}
