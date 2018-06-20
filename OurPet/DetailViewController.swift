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
    
    @IBOutlet weak var morningLabel: UILabel!
    
    @IBOutlet weak var eveningLabel: UILabel!
    
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
        morningLabel.backgroundColor = UIColor(patternImage: UIImage(named: "moon_purple.jpg")!)
        eveningLabel.backgroundColor = UIColor(patternImage: UIImage(named: "moon_purple.jpg")!)
        
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
        morningFedByField.layer.cornerRadius = 8.0
        morningFedByField.layer.masksToBounds = true
        var lilac = UIColor(red:0.67, green:0.22, blue:0.96, alpha:1.0)
        morningFedByField.layer.borderColor = lilac.cgColor
        morningFedByField.layer.borderWidth = 1.0
        eveningFedByField.layer.cornerRadius = 8.0
        eveningFedByField.layer.masksToBounds = true
        eveningFedByField.layer.borderColor = lilac.cgColor
        eveningFedByField.layer.borderWidth = 1.0
        petNameField.layer.cornerRadius = 8.0
        petNameField.layer.masksToBounds = true
        petNameField.layer.borderColor = lilac.cgColor
        petNameField.layer.borderWidth = 1.0
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
        walkedTodaySegment.resignFirstResponder()
        leaveViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ManageCarers" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! ManageCarers
            destination.pet = self.pet
        }
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
