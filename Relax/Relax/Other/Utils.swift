//
//  Utils.swift
//  VK Quick Messager
//
//  Created by Sergey Bizunov on 05.10.17.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class Utils {
    let description = "Utility class for everyday use. Developed by Sergey Bizunov ©2017"
    
    // Get image online
    func getImageOnline(imageURLString url: String, completion: @escaping (UIImage)->() ) {
        if let imageURL = URL(string: url) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let photo = UIImage(data: imageData) {
                        completion(photo)
                    }
                }
            }
        }
    }
}

