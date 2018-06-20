//
//  ManageCarers.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 6/17/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase
class ManageCarers: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var carersLabel: UILabel!
    var pet: Pet!
    var foundUserID = ""
    var userPets = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        messageLabel.isHidden = true
        if pet == nil{
            pet = Pet()
        }
        addButton.isEnabled = false
        
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
        usernameField.layer.cornerRadius = 8.0
        usernameField.layer.masksToBounds = true
        var lilac = UIColor(red:0.67, green:0.22, blue:0.96, alpha:1.0)
        usernameField.layer.borderColor = lilac.cgColor
        usernameField.layer.borderWidth = 1.0
        searchLabel.backgroundColor = UIColor(patternImage: UIImage(named: "moon_purple.jpg")!)
        carersLabel.backgroundColor = UIColor(patternImage: UIImage(named: "moon_purple.jpg")!)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        usernameField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let db = Firestore.firestore()
        let username = usernameField.text
        pet.carers.append(foundUserID)
        db.collection("pets").document(self.pet.documentID).updateData(["carers" : pet.carers])
        
        let docRef = db.collection("opusers").document(foundUserID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userPets = document.get("userPets") as! [String]
                self.userPets.append(self.pet.documentID)
                docRef.updateData(["userPets" : self.userPets])
            }
        }
        tableView.reloadData()
        messageLabel.text = "Successfully added \(username)"
        messageLabel.isHidden = false
        usernameField.resignFirstResponder()
    }

        
    
    @IBAction func usernameEditingChanged(_ sender: UITextField) {
        let db = Firestore.firestore()
        let username = usernameField.text
        db.collection("opusers").whereField("userName", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.count == 0 {
                        print("Carer does not exist")
                        self.addButton.isEnabled = false
                        self.messageLabel.text = "Carer does not exist"
                        self.messageLabel.isHidden = false
                        
                    }
                    else{
                        print("Carer found")
                        self.addButton.isEnabled = true
                        self.messageLabel.isHidden = true
                        for document in (querySnapshot?.documents)!{
                            self.foundUserID = document.documentID
                        }
                        
                        
                    }
                }
    }
    
}
}

extension ManageCarers: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // change zero below to appropriate datasource.count
        print(pet.carers.count)
        return pet.carers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let db = Firestore.firestore()
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        let carer = pet.carers[indexPath.row]
        let docRef = db.collection("opusers").document(carer)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var carerFullName = document.get("fullName") as! String
                var carerUsername = document.get("userName") as! String
            
        cell.textLabel?.text = "\(carerFullName)"
        cell.detailTextLabel?.text = "\(carerUsername)"
        }
    }
        return cell
}
}
