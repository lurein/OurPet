//
//  UserProfileViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 6/14/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore

class UserProfileViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var usernameUnavailableMessage: UILabel!
    var OPuser : OPUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if OPuser == nil {
            OPuser = OPUser()
        }
        updateUserInterface()

        usernameUnavailableMessage.isHidden = true
        saveBarButton.isEnabled = false
        nameField.layer.cornerRadius = 8.0
        nameField.layer.masksToBounds = true
        var lilac = UIColor(red:0.67, green:0.22, blue:0.96, alpha:1.0)
        nameField.layer.borderColor = lilac.cgColor
        nameField.layer.borderWidth = 1.0
        usernameField.layer.cornerRadius = 8.0
        usernameField.layer.masksToBounds = true
        usernameField.layer.borderColor = lilac.cgColor
        usernameField.layer.borderWidth = 1.0
        
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
        }
    
   
    @IBAction func nameEditingChanged(_ sender: UITextField) {
        if usernameUnavailableMessage.isHidden == true {
            saveBarButton.isEnabled = true
        }
    }
    
    @IBAction func usernameEditingDone(_ sender: UITextField) {
        let username = usernameField.text
        let db = Firestore.firestore()
        db.collection("opusers").whereField("userName", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.count == 0 {
                        print("username available")
                        self.saveBarButton.isEnabled = true
                        self.usernameUnavailableMessage.isHidden = true
                        
                    }
                    else{
                        print("username unavailable")
                        self.saveBarButton.isEnabled = false
                        self.usernameUnavailableMessage.isHidden = false
                    }
                }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        usernameField.resignFirstResponder()
        nameField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let db = Firestore.firestore()
        let ref = db.collection("opusers").document((Auth.auth().currentUser?.uid)!)
        ref.updateData([
            "fullName": nameField.text,
            "userName": usernameField.text
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.dismiss(animated: true, completion: nil)
            }
       
        }
    }
    
    

    
    func updateUserInterface(){
        nameField.text = OPuser.fullName
        usernameField.text = OPuser.userName
    }
}
