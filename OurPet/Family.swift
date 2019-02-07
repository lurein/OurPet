//
//  Family.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 2/7/19.
//  Copyright © 2019 Lurein Perera. All rights reserved.
//

import Foundation
import Firebase

class Family  {
    // MARK: Declarations
    var familyName: String
    var familyMembers: [String]
    var familyPets: [String]

    
    
    var dictionary: [String: Any] {
        return ["familyName": familyName, "familyPets": familyPets, "familyMembers": familyMembers]
    }
    
    // MARK: Initializers
    
    init(familyName: String,
         familyPets: [String], familyMembers: [String]) {
        self.familyName = familyName
        self.familyPets = familyPets
        self.familyMembers =  familyMembers
    }
    
    convenience init() {
        self.init(familyName: "", familyPets: [""], familyMembers: [""])
    }
    
    convenience init(dictionary: [String: Any]) {
        let familyName = dictionary["familyName"] as! String? ?? ""
        let familyPets = dictionary["familyPets"] as! [String]? ?? [""]
        let familyMembers = dictionary["familyMembers"] as! [String]? ?? [""]
        
        self.init(familyName: familyName, familyPets: familyPets, familyMembers: familyMembers)
    }
    
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        // Create the dictionary representing the data we want to save
        var dataToSave = self.dictionary

        var ref: DocumentReference? = nil // Let firestore create the new family ID
        ref = db.collection("families").addDocument(data: dataToSave) { error in
            if let error = error {
                print("*** ERROR: creating new document \(error.localizedDescription)")
                completed(false)
            } else {
                print("^^^ new family created with ref ID \(ref?.documentID ?? "unknown")")
                let userDocRef = db.collection("opusers").document((Auth.auth().currentUser?.uid)!)
                userDocRef.updateData(["family" : ref?.documentID])
                completed(true)
            }
        }
    }
}
