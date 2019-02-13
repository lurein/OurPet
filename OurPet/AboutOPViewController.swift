//
//  AboutOPViewController.swift
//  
//
//  Created by Enoka Jayamanne on 6/22/18.
//

import UIKit

class AboutOPViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates the navigation bar gradient
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


