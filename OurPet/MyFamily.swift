//
//  MyFamily.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 2/2/19.
//  Copyright © 2019 Lurein Perera. All rights reserved.
//

import UIKit

class MyFamily: UIViewController {
    
    var OPuser : OPUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if OPuser == nil {
            OPuser = OPUser()
        }
        
        // Creates the navigation bar gradient
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
        assignbackground()
    }
    
    // MARK: Functions
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func assignbackground(){
        let patternBackground = UIImage(named: "bgImage.pdf")
        
        var patternImageView : UIImageView!
        patternImageView = UIImageView(frame: view.bounds)
        patternImageView.contentMode =  UIViewContentMode.scaleAspectFill
        patternImageView.clipsToBounds = true
        patternImageView.image = patternBackground
        patternImageView.center = patternImageView.center
        view.addSubview(patternImageView)
        self.view.sendSubview(toBack: patternImageView)
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255 ,
                  green: CGFloat(green)/255,
                  blue: CGFloat(blue)/255,
                  alpha: 1.0)
    }
}

