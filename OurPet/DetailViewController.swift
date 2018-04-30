//
//  DetailViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 4/27/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var petNameField: UITextField!
    @IBOutlet weak var walkedTodaySegment: UISegmentedControl!
    @IBOutlet weak var morningFedSegment: UISegmentedControl!
    @IBOutlet weak var morningFedByField: UITextField!
    @IBOutlet weak var eveningFedSegment: UISegmentedControl!
    @IBOutlet weak var eveningFedByField: UITextField!
    var pet: Pet!
    
    @IBOutlet weak var saveButtonPressed: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pet == nil {
            pet = Pet()
        }
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
        } else {
            updateUserInterface()
        }
        
    }
    
    func updateUserInterface() {
        petNameField.text = pet.petName
        walkedTodaySegment.selectedSegmentIndex = Int(pet.walkedToday)!
        morningFedSegment.selectedSegmentIndex = Int(pet.morningFedStatus)!
        morningFedByField.text = pet.morningFedBy
        eveningFedSegment.selectedSegmentIndex = Int(pet.eveningFedStatus)!
        eveningFedByField.text = pet.eveningFedBy
    }
    
    func leaveViewController() {
        let isPrestingInAddMode = presentingViewController is UINavigationController
        if isPrestingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        pet.petName = petNameField.text!
        pet.walkedToday = String(walkedTodaySegment.selectedSegmentIndex)
        pet.morningFedStatus = String(morningFedSegment.selectedSegmentIndex)
        pet.morningFedBy = morningFedByField.text!
        pet.eveningFedStatus = String(eveningFedSegment.selectedSegmentIndex)
        pet.eveningFedBy = eveningFedByField.text!
        pet.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn’t saved.")
            }
        }
    }
    
}
