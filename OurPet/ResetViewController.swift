//
//  ResetViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 9/23/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: false, completion: nil)
            
        }
    }
}
