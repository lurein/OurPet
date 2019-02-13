//
//  OPUser.swift
//  
//
//  Created by Enoka Jayamanne on 6/11/18.
//

import Foundation
import Firebase

class OPUser  {
    // MARK: Declarations
    var fullName: String
    var userName: String
    var postingUserID: String
    var userPets: [String]
    var family: String
    
    
    var dictionary: [String: Any] {
        return ["fullName": fullName, "userName": userName, "userPets": userPets, "family": family]
    }
    
    // MARK: Initializers
    
    init(fullName: String, userName: String,
         userPets: [String], postingUserID: String, family: String) {
        self.fullName = fullName
        self.userName = userName
        self.userPets = userPets
        self.postingUserID = postingUserID
        self.family =  family
    }
    
    convenience init() {
        self.init(fullName: "", userName: "", userPets: [""], postingUserID: "", family: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let fullName = dictionary["fullName"] as! String? ?? ""
        let userName = dictionary["userName"] as! String? ?? ""
        let userPets = dictionary["userPets"] as! [String]? ?? [""]
        let family = dictionary["family"] as! String? ?? ""
        
        self.init(fullName: fullName, userName: userName, userPets: userPets, postingUserID: "", family: family)
    }
    
    // MARK: Class Functions
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        // if we HAVE saved a record, we'll have a documentID
        let ref = db.collection("opusers").document(self.postingUserID)
        ref.setData(dataToSave) { (error) in
            if let error = error {
                print("*** ERROR: updating document \(self.postingUserID) \(error.localizedDescription)")
                completed(false)
            } else {
                print("^^^ Document updated with ref ID \(ref.documentID)")
                //    self.documentID = ref.documentID
                completed(true)
            }
        }
        
    }
    
}



