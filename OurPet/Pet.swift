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
    // MARK: Declarations
    
    var petName: String
    var walkedToday: String
    var morningFedStatus: String
    var morningFedBy: String
    var postingUserID: String
    var eveningFedStatus: String
    var eveningFedBy: String
    var documentID: String
    var carers: [String]
    var userPets : [String] = [""]
    var hasImage : Int
    var lastReset : String
    
    var dictionary: [String: Any] {
        return ["petName": petName, "walkedToday": walkedToday, "morningFedStatus": morningFedStatus,
                "morningFedBy": morningFedBy, "eveningFedStatus": eveningFedStatus, "eveningFedBy": eveningFedBy,  "postingUserID": postingUserID, "carers": carers, "hasImage": hasImage, "lastReset": lastReset]
    }
    
    //MARK: Initializers
    
    init(petName: String, walkedToday: String,
         morningFedStatus: String, morningFedBy: String, eveningFedStatus: String, postingUserID: String, eveningFedBy: String, documentID: String, carers: [String], hasImage: Int, lastReset: String) {
        self.petName = petName
        self.walkedToday = walkedToday
        self.morningFedStatus = morningFedStatus
        self.morningFedBy = morningFedBy
        self.eveningFedStatus = eveningFedStatus
        self.postingUserID = postingUserID
        self.eveningFedBy = eveningFedBy
        self.documentID = documentID
        self.carers = carers
        self.hasImage = hasImage
        self.lastReset = lastReset
    }
    
    
    convenience init() {
        self.init(petName: "", walkedToday: "", morningFedStatus: "", morningFedBy: "", eveningFedStatus: "", postingUserID: "", eveningFedBy: "", documentID: "", carers: [(Auth.auth().currentUser?.uid)!], hasImage: 0, lastReset: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let petName = dictionary["petName"] as! String? ?? ""
        let walkedToday = dictionary["walkedToday"] as! String? ?? ""
        let morningFedStatus = dictionary["morningFedStatus"] as! String? ?? ""
        let morningFedBy = dictionary["morningFedBy"] as! String? ?? ""
        let eveningFedStatus = dictionary["eveningFedStatus"] as! String? ?? ""
        let eveningFedBy = dictionary["eveningFedBy"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let carers = dictionary["carers"] as! [String]? ?? [(Auth.auth().currentUser?.uid)!]
        let hasImage = dictionary["hasImage"] as! Int? ?? 0
        let lastReset = dictionary["lastReset"] as! String? ?? ""
        self.init(petName: petName, walkedToday: walkedToday, morningFedStatus: morningFedStatus, morningFedBy: morningFedBy, eveningFedStatus: eveningFedStatus, postingUserID: postingUserID, eveningFedBy: eveningFedBy, documentID: "", carers: carers, hasImage: hasImage, lastReset: lastReset)
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
        var dataToSave = self.dictionary
        
        dataToSave["lastReset"] = dateStringer()
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("pets").document(self.documentID)
            ref.updateData(dataToSave) { (error) in
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
                    
                    // Beginning of Helper Block
                    var family = Family()
                    let db = Firestore.firestore()
                    let uRef = db.collection("opusers").document((Auth.auth().currentUser?.uid)!)
                    var familyID = ""
                    var hasFamily = false
                    uRef.getDocument{ (document, error) in
                        if let doc = document, doc.exists{
                            if doc.get("family") == nil {
                            } else {
                                familyID = doc.get("family") as! String
                                hasFamily = true
                            }
                            
                            if hasFamily {
                                let fRef = db.collection("families").document(familyID)
                                fRef.getDocument { (document, error) in
                                    if let doc2 = document, doc2.exists {
                                        family = Family(familyName: doc2.get("familyName") as! String, familyPets: doc2.get("familyPets") as! [String], familyMembers: doc2.get("familyMembers") as! [String], documentID: familyID as! String)
                                        
                                        family.familyPets.append(self.documentID)
                                        fRef.updateData(["familyPets" : family.familyPets])
                                        
                                        let pRef = db.collection("pets").document(self.documentID)
                                        pRef.updateData(["carers" : family.familyMembers])

                                        for member in family.familyMembers {
                                            if member != (Auth.auth().currentUser?.uid)! {
                                                var userPetArray : [String]
                                                userPetArray = []
                                                let mRef = db.collection("opusers").document(member)
                                                mRef.getDocument { (document, error) in
                                                    if let doc3 = document, doc3.exists {
                                                        userPetArray = doc3.get("userPets") as! [String]
                                                        userPetArray.append(self.documentID)
                                                    }
                                                    mRef.updateData(["userPets" : userPetArray])
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    }
                    // End of Helper Block
                    
                    
                    let userDocRef = db.collection("opusers").document((Auth.auth().currentUser?.uid)!)
                    userDocRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.userPets = document.get("userPets") as! [String]
                            
                            self.userPets.append(self.documentID)
                            userDocRef.updateData(["userPets" : self.userPets])
                        }
                    }
                    completed(true)
                }
            }
        }
    }
    
    func dateStringer() -> String {
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        return dateformatter.string(from: currentDate)
        
    }
}

