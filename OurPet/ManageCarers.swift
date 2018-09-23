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
    
    // MARK: Outlets and Declarations
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var carersLabel: UILabel!
    @IBOutlet weak var searchCardView: CardView!
    
    
    var pet: Pet!
    var foundUserID = ""
    var userPets = [""]
    
    // MARK: View Setup
    
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
        
        searchLabel.text = "Who else cares for \(pet.petName)?"
        
        // This creates the tap dismisser for the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        assignbackground()
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
    
    // MARK: Bar Buttons
    
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

    // MARK: Username Field Code
    
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
    func removeCarer(carer: String){
        // needs to be done
    }
}

// MARK: Extensions

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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
            pet.carers.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
}

