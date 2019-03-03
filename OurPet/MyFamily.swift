//
//  MyFamily.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 2/2/19.
//  Copyright © 2019 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase

class MyFamily: UIViewController {
    
    @IBOutlet weak var familyLabel: UILabel!
    
    var OPuser : OPUser!
    var family : Family!
    @IBOutlet weak var searchField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    struct member {
        var fullName: String
        var userName: String
    }
    
    var members = [member]()
    var foundUserID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        
        if OPuser == nil {
            OPuser = OPUser()
        }
        addButton.isEnabled = false
        messageLabel.isHidden = true
        let fRef = db.collection("families").document(OPuser.family)
        fRef.getDocument { (document, error) in
            if let doc = document, doc.exists {
                self.family = Family(familyName: doc.get("familyName") as! String, familyPets: doc.get("familyPets") as! [String], familyMembers: doc.get("familyMembers") as! [String], documentID: self.OPuser.family as! String)
            }
            let carers = self.family.familyMembers
            self.familyLabel.text = "The \(self.family.familyName) Family"
            for carer in carers {
                print("carer " + carer)
                let docRef = db.collection("opusers").document(carer)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        var carerFullName = document.get("fullName") as! String
                        var carerUsername = document.get("userName") as! String
                        self.members.append(member(fullName: carerFullName, userName: carerUsername))
                    }
                }
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Creates the navigation bar gradient
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
        assignbackground()
        
        // Stylises the search field
        searchField.layer.cornerRadius = 8.0
       searchField.layer.masksToBounds = true
        var lilac = UIColor(red:0.67, green:0.22, blue:0.96, alpha:1.0)
        searchField.layer.borderColor = lilac.cgColor
       searchField.layer.borderWidth = 1.0
        
        // This creates the tap dismisser for the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        print("destination is \(self.OPuser.postingUserID)")
        
        
        
        loadFamilyData {
            self.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.tableView.reloadData()
                print(self.family.familyMembers)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.tableView.reloadData()
                print(self.family.familyMembers)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.tableView.reloadData()
                print(self.family.familyMembers)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    @IBAction func usernameFieldChanged(_ sender: UITextField) {
       
        let db = Firestore.firestore()
        let username = searchField.text
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
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        var newMember = member(fullName: "", userName: "")
        let db = Firestore.firestore()
        // Here we update the found users family and userPets fields
        db.collection("opusers").document(self.foundUserID).updateData(["family" : self.OPuser.family, "userPets" : self.OPuser.userPets])
        
        // Here we update each of the family's pet's carers array (from the OPusers userPets array)
        for eachPet in self.OPuser.userPets{
            var carersArray : [String] = []
           db.collection("pets").document(eachPet).getDocument { (document, error) in
                if let document = document, document.exists {
                   carersArray = document.get("carers") as! [String]
                }
            carersArray.append(self.foundUserID)
            db.collection("pets").document(eachPet).updateData(["carers" : carersArray])
            }
            
        }
        
        // Here we update the family collection to include the found user
        var newArray: [String]
        self.family.familyMembers.append(self.foundUserID)
        newArray = self.family.familyMembers
        db.collection("families").document(self.OPuser.family).updateData(["familyMembers" : newArray])
        
        // Here we get the users 
        let uRef = db.collection("opusers").document(self.foundUserID)
        uRef.getDocument { (document, error) in
            if let document = document, document.exists {
                newMember.fullName = document.get("fullName") as! String
               newMember.userName = document.get("userName") as! String
                self.members.append(newMember)
                self.tableView.reloadData()
            }
        }

    }
    
    @IBAction func inviteButtonPressed(_ sender: UITapGestureRecognizer) {
        generateContentLink()
    }
    
    
    
    //MARK: Class Functions
    func generateContentLink() {
        // This block generates the website URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "ourpet.app"
        components.path = "/"
        let familyIDQueryItem = URLQueryItem(name: "familyID", value: self.OPuser.family)
        components.queryItems = [familyIDQueryItem]
        let linkParameter = components.url!
        
        let linkBuilder = DynamicLinkComponents(link: linkParameter, domain: "ourpet.page.link")
        if let myBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        linkBuilder.iOSParameters?.appStoreID = "1435861045"
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "Join the \(self.family.familyName) family on OurPet"
        linkBuilder.socialMetaTagParameters?.descriptionText = "Join my family on OurPet to make our family pet care a WHOLE lot easier!"
        
        // Fall back to the base url if we can't generate a dynamic link.
        linkBuilder.shorten { (url, warnings, error) in
            if let error = error {
                print("Oh no! Got an error! \(error)" )
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("FDL Warnings (NonCrit): \(warning)")
                }
            }
            guard let url = url else {return}
            print("short url: \(url.absoluteString)")
            self.showShareSheet(url: url)
        }
        
    }
    func showShareSheet(url: URL) {
        let promoText = "Join the \(self.family.familyName) family on OurPet!"
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    func loadFamilyData(completed: @escaping () -> ()) {
       let db = Firestore.firestore()
        let docRef = db.collection("families").document(OPuser.family)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.family = Family(dictionary: document.data()!)
            } else {
                print("Document does not exist")
            }
        }
        
        completed()
        
    }
    
}

// MARK: Extensions

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255 ,
                  green: CGFloat(green)/255,
                  blue: CGFloat(blue)/255,
                  alpha: 1.0)
    }
}

extension MyFamily: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // change zero below to appropriate datasource.count
        return members.count
    }
    
    // you don't want to do your database calls from here
    // cellForRowAt gets called a lot
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        
        cell.textLabel?.text = members[indexPath.row].fullName
        cell.detailTextLabel?.text = members[indexPath.row].userName
        
        return cell
    }
   
}



