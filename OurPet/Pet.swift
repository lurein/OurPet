//
//  Pet.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 4/28/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import Foundation
import Firebase

class Pet  {
    var petName: String
    var walkedToday: String
    var morningFedStatus: String
    var morningFedBy: String
    var postingUserID: String
    var eveningFedStatus: String
    var eveningFedBy: String
    var documentID: String
    
    
    var dictionary: [String: Any] {
        return ["petName": petName, "walkedToday": walkedToday, "morningFedStatus": morningFedStatus,
                "morningFedBy": morningFedBy, "eveningFedStatus": eveningFedStatus, "eveningFedBy": eveningFedBy,  "postingUserID": postingUserID]
    }
    
    init(petName: String, walkedToday: String,
         morningFedStatus: String, morningFedBy: String, eveningFedStatus: String, postingUserID: String, eveningFedBy: String, documentID: String) {
        self.petName = petName
        self.walkedToday = walkedToday
        self.morningFedStatus = morningFedStatus
        self.morningFedBy = morningFedBy
        self.eveningFedStatus = eveningFedStatus
        self.postingUserID = postingUserID
        self.eveningFedBy = eveningFedBy
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(petName: "", walkedToday: "", morningFedStatus: "", morningFedBy: "", eveningFedStatus: "", postingUserID: "", eveningFedBy: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let petName = dictionary["petName"] as! String? ?? ""
        let walkedToday = dictionary["walkedToday"] as! String? ?? ""
        let morningFedStatus = dictionary["morningFedStatus"] as! String? ?? ""
        let morningFedBy = dictionary["morningFedBy"] as! String? ?? ""
        let eveningFedStatus = dictionary["eveningFedStatus"] as! String? ?? ""
        let eveningFedBy = dictionary["eveningFedBy"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(petName: petName, walkedToday: walkedToday, morningFedStatus: morningFedStatus, morningFedBy: morningFedBy, eveningFedStatus: eveningFedStatus, postingUserID: postingUserID, eveningFedBy: eveningFedBy, documentID: "")
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
        if self.documentID != "" {
            let ref = db.collection("pets").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    self.documentID = ref.documentID
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("pets").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
    
}

