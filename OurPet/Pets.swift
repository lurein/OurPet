//
//  Pets.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 4/28/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import Foundation
import Firebase

class Pets {
    var petArray: [Pet] = []
    var db: Firestore!
    var userPetsArray2 : [String] = []
    var OPuser = OPUser()
   
    
    init() {
        db = Firestore.firestore()
   
    }
    
    func loadData(completed: @escaping () -> ()) {
//        db.collection("pets").addSnapshotListener { (querySnapshot, error) in
//            self.petArray = []
//            guard error == nil else {
//                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
//                return completed()
//            }
//            // there are querySnapshot!.documents.count documents
//            for document in querySnapshot!.documents {
//                let pet = Pet(dictionary: document.data())
//                print(pet)
//                pet.documentID = document.documentID
//                self.petArray.append(pet)
//                print(self.petArray)
//            }
//            completed()
//        }
        let docRef = db.collection("opusers").document((Auth.auth().currentUser?.uid)!)
        self.petArray = []
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let OPuser2 = OPUser(dictionary: document.data()!)
                self.OPuser = OPuser2
                var userPetsArray = document.get("userPets")
                self.userPetsArray2 = userPetsArray as! [String]
                for userPet in self.userPetsArray2 {
                    let petRef = self.db.collection("pets").document(userPet)
                    petRef.getDocument { (document2, error) in
                        if let petDetails = document2, document2!.exists {
                            let petDescription = document2!.data()
                            print(petDescription!)
                            let pet = Pet(dictionary: petDescription!)
                            print(pet)
                            pet.documentID = document2!.documentID
                            self.petArray.append(pet)
                            print(self.petArray)
                        }
                    }
                }
                

            } else {
                print("Document does not exist")
            }
        }
        
        completed()

    }
}
