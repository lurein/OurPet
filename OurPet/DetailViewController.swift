//
//  DetailViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 4/27/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var petNameField: UITextField!
    @IBOutlet weak var walkedTodaySegment: UISegmentedControl!
    @IBOutlet weak var morningFedSegment: UISegmentedControl!
    @IBOutlet weak var morningFedByField: UITextField!
    @IBOutlet weak var eveningFedSegment: UISegmentedControl!
    @IBOutlet weak var eveningFedByField: UITextField!
    var pet: Pet!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var saveButtonPressed: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
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
        leaveViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ManageCarers" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! ManageCarers
            destination.pet = self.pet
        }
    }
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        uploadImagePic(img1: imageView.image!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImagePic(img1 :UIImage){
        var data = NSData()
        data = UIImageJPEGRepresentation(img1, 0.8)! as NSData
        // set upload path
        let filePath = "pets/\(pet.documentID)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                print("Uploaded image")
            }
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        pet.petName = petNameField.text!
        pet.walkedToday = String(walkedTodaySegment.selectedSegmentIndex)
        pet.morningFedStatus = String(morningFedSegment.selectedSegmentIndex)
        pet.morningFedBy = morningFedByField.text!
        pet.eveningFedStatus = String(eveningFedSegment.selectedSegmentIndex)
        pet.eveningFedBy = eveningFedByField.text!
        pet.saveData { success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Time delay to allow upload to process
                    UIViewController.removeSpinner(spinner: sv)
                    self.leaveViewController()
                }
               
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn’t saved.")
            }
        }
    }
    
}

// This extension is for the Activity Indicatior

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
