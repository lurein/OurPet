//
//  UserProfileViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 6/14/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore
import WXImageCompress
import OneSignal

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Outlets and Declarations
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var usernameUnavailableMessage: UILabel!
    var OPuser : OPUser!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var playerId : String?
    var pushToken : String?
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if OPuser == nil {
            OPuser = OPUser()
        }
        updateUserInterface()
        
        let signedInBefore = UserDefaults.standard.integer(forKey: "signedInBefore")
        if signedInBefore == 0 {
            cancelBarButton.isEnabled = false
            UserDefaults.standard.set(-1, forKey: "signedInBefore")
        }
        
        usernameUnavailableMessage.isHidden = true
        saveBarButton.isEnabled = false
        nameField.layer.cornerRadius = 8.0
        nameField.layer.masksToBounds = true
        var lilac = UIColor(red:0.67, green:0.22, blue:0.96, alpha:1.0)
        nameField.layer.borderColor = lilac.cgColor
        nameField.layer.borderWidth = 1.0
        usernameField.layer.cornerRadius = 8.0
        usernameField.layer.masksToBounds = true
        usernameField.layer.borderColor = lilac.cgColor
        usernameField.layer.borderWidth = 1.0
        
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
        assignbackground()
        
        let anyAvatarImage = imageView.image
        imageView.maskCircle(anyImage: anyAvatarImage!)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = lilac.cgColor
        
        // This creates the tap dismisser for the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // This generates the player_id for OneSignal
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        pushToken = status.subscriptionStatus.pushToken
        playerId = status.subscriptionStatus.userId
        }
    
    func updateUserInterface(){
        downloadUserImage()
        nameField.text = OPuser.fullName
        usernameField.text = OPuser.userName
    }
    
    //MARK: Textfield Actions
   
    @IBAction func nameEditingChanged(_ sender: UITextField) {
        if usernameUnavailableMessage.isHidden == true {
            saveBarButton.isEnabled = true
        }
    }
    
    @IBAction func usernameEditingDone(_ sender: UITextField) {
        let username = usernameField.text
        let db = Firestore.firestore()
        db.collection("opusers").whereField("userName", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.count == 0 {
                        print("username available")
                        self.saveBarButton.isEnabled = true
                        self.usernameUnavailableMessage.isHidden = true
                        
                    }
                    else{
                        print("username unavailable")
                        self.saveBarButton.isEnabled = false
                        self.usernameUnavailableMessage.isHidden = false
                    }
                }
        }
    }
    
    // MARK: Bar Buttons
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        usernameField.resignFirstResponder()
        nameField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let db = Firestore.firestore()
        let ref = db.collection("opusers").document((Auth.auth().currentUser?.uid)!)
        
        OneSignal.sendTag("userID", value: Auth.auth().currentUser?.uid)
        
        // Updates the player
        if pushToken != nil {
            ref.updateData([
                "notificationID": playerId
            ]) { err in
                if let err = err {
                    print("Error updating notificationID: \(err)")
                } else {
                    print("notificationID successfully updated")
                }
                
            }
        }
        // Updates userProfile details
        ref.updateData([
            "fullName": nameField.text,
            "userName": usernameField.text
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.dismiss(animated: true, completion: nil)
            }
       
        }
    }
    
    // MARK: Image Functions
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        if let compressedImage = imageView.image?.wxCompress() {
            print("image compressed")
            uploadImagePic(img1: compressedImage)
        } else{
            uploadImagePic(img1: imageView.image!)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func assignbackground(){
        let patternBackground = UIImage(named: "bgImage.pdf")
        
        var patternImageView : UIImageView!
        patternImageView = UIImageView(frame: view.bounds)
        patternImageView.contentMode =  UIViewContentMode.scaleAspectFill
        patternImageView.clipsToBounds = true
        patternImageView.image = patternBackground
        patternImageView.center = patternImageView.center
        view.addSubview(patternImageView)
        self.view.sendSubview(toBack: patternImageView)
    }
    
    func downloadUserImage(){
        let ispinner = UIViewController.imageSpinner(onView: self.imageView)
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child("opusers/\((Auth.auth().currentUser?.uid)!)")
        let imageView: UIImageView = self.imageView
        let placeholderImage = UIImage(named: "profile_image.png")
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
        let filePath = "opusers/\((Auth.auth().currentUser?.uid)!)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                print("Uploaded image")
            }
        }
        
    }
    
    
}
// MARK: Extensions

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}


