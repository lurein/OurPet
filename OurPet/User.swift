//
//  User.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 6/11/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import Foundation
import Firebase

class User  {
    var fullName: String
    var userName: String
    var postingUserID: String
    var coCarers: [String]
    var userPets: [String]
    
    
    var dictionary: [String: [String]] {
        return ["fullName": [fullName], "userName": [userName], "coCarers": coCarers, "userPets": userPets]
    }
    
//    var dictionary2: [String: [String]] {
//        return ["coCarers": coCarers, "userPets": userPets]
//    }
    
    init(fullName: String, userName: String,
         coCarers: [String], userPets: [String], postingUserID: String) {
        self.fullName = fullName
        self.userName = userName
        self.coCarers = coCarers
        self.userPets = userPets
        self.postingUserID = postingUserID
    }
    
    convenience init() {
        self.init(fullName: "", userName: "", coCarers: [""], userPets: [""], postingUserID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let fullName = dictionary["fullName"] as! String? ?? ""
        let userName = dictionary["userName"] as! String? ?? ""
        let coCarers = dictionary["coCarers"] as! [String]? ?? [""]
        let userPets = dictionary["morningFedBy"] as! [String]? ?? [""]

        self.init(fullName: fullName, userName: userName, coCarers: coCarers, userPets: userPets, postingUserID: "")
    }
    
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
        let ref = db.collection("users").document(self.postingUserID)
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
        
//        else {
//            var ref: DocumentReference? = nil // Let firestore create the new documentID
//            ref = db.collection("pets").addDocument(data: dataToSave) { error in
//                if let error = error {
//                    print("*** ERROR: creating new document \(error.localizedDescription)")
//                    completed(false)
//                } else {
//                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
//                    self.documentID = ref!.documentID
//                    completed(true)
//                }
//            }
//        }
    }
    
}


