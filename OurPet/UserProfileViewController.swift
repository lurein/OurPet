//
//  UserProfileViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 6/14/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var OPuser : OPUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if OPuser == nil {
            OPuser = OPUser()
        }
        updateUserInterface()
        }
        
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    func loadData(){
        let db = Firestore.firestore()
        let ref = db.collection("opusers").document((Auth.auth().currentUser?.uid)!)
    }
    
    func updateUserInterface(){
        nameField.text = OPuser.fullName
        usernameField.text = OPuser.userName
    }
}
