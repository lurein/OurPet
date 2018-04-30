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
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("pets").addSnapshotListener { (querySnapshot, error) in
            self.petArray = []
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            // there are querySnapshot!.documents.count documents
            for document in querySnapshot!.documents {
                let pet = Pet(dictionary: document.data())
                pet.documentID = document.documentID
                self.petArray.append(pet)
            }
            completed()
        }
    }
}
