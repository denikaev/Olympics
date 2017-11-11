//
//  ViewController.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: IBActions
    
    @IBAction func infoTap(_ sender: UIButton) {
        showAbout()
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Methods
    
    // Show login controller
    func showAbout() {
        guard let aboutViewController = storyboard?.instantiateViewController(withIdentifier: "AboutViewController")
            else { return }
        
        aboutViewController.modalPresentationStyle = .popover
        aboutViewController.modalTransitionStyle = .flipHorizontal
        present(aboutViewController, animated: true)
    }
}

