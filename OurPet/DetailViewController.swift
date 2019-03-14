//
//  DetailViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 4/27/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import WXImageCompress
import OneSignal
import CropViewController


class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Outlets and Declarations
    @IBOutlet weak var petNameField: UITextField!
    @IBOutlet weak var walkedTodaySegment: UISegmentedControl!
    @IBOutlet weak var morningFedSegment: UISegmentedControl!
    @IBOutlet weak var morningFedByField: UITextField!
    @IBOutlet weak var eveningFedSegment: UISegmentedControl!
    @IBOutlet weak var eveningFedByField: UITextField!
    var pet: Pet!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var saveButtonPressed: UIBarButtonItem!
    
    @IBOutlet weak var manageCarersButton: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var morningLabel: UILabel!
    
    @IBOutlet weak var eveningLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var morningCardView: CardView!
    
    @IBOutlet weak var eveningCardView: CardView!
    
    @IBOutlet weak var morningImageView: UIImageView!
    
    @IBOutlet weak var eveningImageView: UIImageView!
    
    var walkedValueChangedBinary : Int = 0
    var morningFedValueChangedBinary : Int = 0
    var eveningFedValueChangedBinary : Int = 0
    var imageAdded = false
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pet == nil {
            pet = Pet()
        }
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            manageCarersButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            updateUserInterface()
        }
        
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
        
        //morningCardView.backgroundColor = UIColor(patternImage: UIImage(named: "nightCartoon.jpg")!)
        assignbackground()
        
        let anyAvatarImage = imageView.image
        imageView.maskCircle(anyImage: anyAvatarImage!)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = lilac.cgColor
        
        // This creates the tap dismisser for the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func updateUserInterface() {
        downloadPetImage()
        petNameField.text = pet.petName
        walkedTodaySegment.selectedSegmentIndex = Int(pet.walkedToday)!
        morningFedSegment.selectedSegmentIndex = Int(pet.morningFedStatus)!
        morningFedByField.text = pet.morningFedBy
        eveningFedSegment.selectedSegmentIndex = Int(pet.eveningFedStatus)!
        eveningFedByField.text = pet.eveningFedBy
    }
    
    // MARK: Segue Control
    
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
    
    // MARK: Image Functions
    
    func assignbackground(){
        let morningBackground = UIImage(named: "field_sunny_vector.png")
        let eveningBackground = UIImage(named: "windmill_nightscape.png")
        let patternBackground = UIImage(named: "bgImage.pdf")
        
        morningImageView.contentMode =  UIViewContentMode.scaleAspectFill
        morningImageView.layer.cornerRadius = 20.0
        morningImageView.clipsToBounds = true
        morningImageView.image = morningBackground
        morningImageView.center = morningImageView.center
        morningCardView.addSubview(morningImageView)
        self.morningCardView.sendSubview(toBack: morningImageView)
       
        
        eveningImageView.contentMode =  UIViewContentMode.scaleAspectFill
        eveningImageView.layer.cornerRadius = 20.0
        eveningImageView.clipsToBounds = true
        eveningImageView.image = eveningBackground
        eveningImageView.center = eveningImageView.center
        eveningCardView.addSubview(eveningImageView)
        self.eveningCardView.sendSubview(toBack: eveningImageView)
        
        var patternImageView : UIImageView!
        patternImageView = UIImageView(frame: view.bounds)
        patternImageView.contentMode =  UIViewContentMode.scaleAspectFill
        patternImageView.clipsToBounds = true
        patternImageView.image = patternBackground
        patternImageView.center = patternImageView.center
        view.addSubview(patternImageView)
        self.view.sendSubview(toBack: patternImageView)
    }
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
            print("tapped")
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        self.imageAdded = true
        presentCropViewController()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func downloadPetImage(){
        let ispinner = UIViewController.imageSpinner(onView: self.imageView)
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child("pets/\(pet.documentID)")
        let imageView: UIImageView = self.imageView
        let placeholderImage = UIImage(named: "pet_image.jpg")
        reference.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print("error getting download URL")
                UIViewController.removeSpinner(spinner: ispinner)
            } else {
                // Get the download URL
                imageView.sd_setImage(with: url, placeholderImage: placeholderImage)
                UIViewController.removeSpinner(spinner: ispinner)
            }
        }
        
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
                print("Uploaded image")
                // Updates hasImage
                let db = Firestore.firestore()
                let petRef = db.collection("pets").document(self.pet.documentID)
                petRef.updateData([
                    "hasImage": 1
                ]) { err in
                    if let err = err {
                        print("Error updating hasImage: \(err)")
                    } else {
                        print("hasImage successfully updated")
                        self.pet.hasImage = 1
                    }
                }
            }
        }
    }
    func deleteImage(){
        let filePath = "pets/\(pet.documentID)"
        let storageRef = Storage.storage().reference()
        
        if pet.hasImage == 1 {
            storageRef.child(filePath).delete(completion: nil)
        }
        // Note that this delete function accompanies the deletion of a pet
        // therefore we do not bother the updating of the pet's hasImage binary
    }
    
    // MARK: Bar Buttons
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        pet.petName = petNameField.text!
        pet.walkedToday = String(walkedTodaySegment.selectedSegmentIndex)
        pet.morningFedStatus = String(morningFedSegment.selectedSegmentIndex)
        pet.morningFedBy = morningFedByField.text!
        pet.eveningFedStatus = String(eveningFedSegment.selectedSegmentIndex)
        pet.eveningFedBy = eveningFedByField.text!
        
        
        // This large block ensures the pet is added across the whole family
        

        
        pet.saveData { success in
            if success {
                
                if self.imageAdded {
                    if let compressedImage = self.imageView.image?.wxCompress() {
                        print("image compressed")
                        self.uploadImagePic(img1: compressedImage)
                    } else{
                        self.uploadImagePic(img1: self.imageView.image!)
                    }
                }
                // This large block below handles push notifications
                for eachCarer in self.pet.carers {
                    if eachCarer != Auth.auth().currentUser?.uid && self.pet.carers.count >= 1 {
                        let db = Firestore.firestore()
                        let carerRef = db.collection("opusers").document(eachCarer)
                        carerRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                var notificationID = document.get("notificationID")
                                if self.walkedValueChangedBinary == 1 && self.walkedTodaySegment.selectedSegmentIndex == 1 {
                                    OneSignal.postNotification([
                                        "include_player_ids": [notificationID],
                                        "headings": ["en": "\(self.pet.petName) has been walked"],
                                        "contents": ["en": "Tap to see details"],
                                        ])
                                }
                                if (self.morningFedValueChangedBinary == 1 && self.morningFedSegment.selectedSegmentIndex == 1) || (self.eveningFedValueChangedBinary == 1 && self.eveningFedSegment.selectedSegmentIndex == 1) {
                                    OneSignal.postNotification([
                                        "include_player_ids": [notificationID],
                                        "headings": ["en": "\(self.pet.petName) has been fed"],
                                        "contents": ["en": "Tap to see details"],
                                        ])
                                }
                                
                            }
                
                        }
                    }
                }
                    
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Time delay to allow upload to process
                    UIViewController.removeSpinner(spinner: sv)
                    self.leaveViewController()
                }
               
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn’t saved.")
            }
        }
    }
    
    // MARK: Additional Functions
    
    @IBAction func manageCarersButtonPressed(_ sender: UIControl) {
        self.performSegue(withIdentifier: "ManageCarers", sender: nil)
    }
    
    
    @IBAction func walkedTodayValueChanged(_ sender: UISegmentedControl) {
        walkedValueChangedBinary = 1
    }
    
    @IBAction func morningFedValueChanged(_ sender: UISegmentedControl) {
        morningFedValueChangedBinary = 1
    }
    
    @IBAction func eveningFedValueChanged(_ sender: UISegmentedControl) {
        eveningFedValueChangedBinary = 1
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let deleteAlert = UIAlertController(title: "Delete Pet", message: "Are you sure you want to delete \(pet.petName)? This action cannot be undone. ", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive , handler: { (action: UIAlertAction!) in
            self.deletePet()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: { (action: UIAlertAction!) in
            // Any functions go here
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    
    func deletePet() {
        deleteImage() // removes the pets image from storage, if it has one
        let db = Firestore.firestore()
        db.collection("pets").document(pet.documentID).delete() { err in
            if let err = err {
                print("Error deleting pet: \(err)")
            } else {
                print("Pet deleted from pets collection")  // Delete the pet from the pets collection
            }
        }
        for eachUser in pet.carers {  // For every user in petCarers, delete the pet from userPets
            let docRef = db.collection("opusers").document(eachUser)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    var eachUserPets = document.get("userPets") as! [String]
                    eachUserPets = eachUserPets.filter{$0 != self.pet.documentID}
                    docRef.updateData(["userPets" : eachUserPets])
                }
            }
            print("Pet deleted from \(eachUser)'s userPets")
        }
        leaveViewController()
    }
}

// MARK: Extensions

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

extension UIViewController {
    class func imageSpinner(onView : UIImageView) -> UIView {
        let spinnerView = UIImageView.init(frame: onView.bounds)
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
    

}

extension DetailViewController: CropViewControllerDelegate {
    func presentCropViewController() {
        let image: UIImage = self.imageView.image! //Load an image
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.cancelButtonTitle = ""
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: true)
        self.imageView.image = image
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
}

