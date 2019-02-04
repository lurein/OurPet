//
//  ViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 4/26/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import AlertOnboarding
import UserNotifications
import SCLAlertView





class ViewController: UIViewController{
    
    // MARK: Outlets and Declarations
    
    @IBOutlet weak var addButtonPressed: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var squigglyArrow: UIImageView!
    var authUI: FUIAuth!
    var pets: Pets!
    var globalIndexPath : IndexPath?
    var checkerBool = false // this avoids the repetitive image reloading bug
    
   
    
    // Setting up the onboarding alert
    var arrayOfImage = ["dog_avatar2", "Avatar_Dog-512", "friend_avatar"]
    var arrayOfTitle = ["WELCOME TO OURPET", "SET-UP YOUR PETS", "ADD CO-CARERS"]
    var arrayOfDescription = ["Welcome to OurPet, the simplest way for a group of people to effectively care for their pets. Invite your friends and family to get the group pet care started!",
                              "Press the '+' button on the OurPet home screen to set-up your pet, then use the simple one-tap logging to let the other carers know everytime you feed or walk your pet! ",
                              "Tap 'Manage Carers' on your Pet's details to add family, friends, and everyone else that helps take care of your pet and create your Carer Groups."]
    
 
    
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        pets = Pets()
        squigglyArrow.isHidden = true // This is now the 'add pets by pressing + image'
   
        // Sets the navigation bar gradient
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
        
        assignbackground()
        collectionView.alpha = 0
    
        // Card Cell Setup
        collectionView.collectionViewLayout = CardsCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        squigglyArrow.isHidden = true
        self.checkerBool = false
        let signedInBefore = UserDefaults.standard.integer(forKey: "signedInBefore")
        if signedInBefore == 0 && Auth.auth().currentUser?.uid != nil { //initial profile setup
            self.performSegue(withIdentifier: "MyProfile", sender: nil)
        }
        
        if Auth.auth().currentUser?.uid != nil {
        pets.loadData {
            let sv = UIViewController.displaySpinner(onView: self.view) // Creates the loading spinner
            self.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 1 to desired number of seconds
                if(self.checkerBool == false) {self.collectionView.reloadData()}
                if self.pets.loadedBinary == 1 {
                UIViewController.removeSpinner(spinner: sv)
                    self.collectionView.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        if self.pets.petArray.count == 0 {
                            if signedInBefore == -1 {
                                self.squigglyArrow.isHidden = false
                                UserDefaults.standard.set(1, forKey: "signedInBefore")
                            }
                            
                        } else {
                            self.dailyResetting()
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
               if(self.checkerBool == false) {self.collectionView.reloadData()}
                if self.pets.loadedBinary == 1 {
                    UIViewController.removeSpinner(spinner: sv)
                    self.collectionView.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        if self.pets.petArray.count == 0 {
                            if signedInBefore == -1 {
                                self.squigglyArrow.isHidden = false
                                UserDefaults.standard.set(1, forKey: "signedInBefore")
                            }
                        }else {
                            self.dailyResetting()
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // change 3 to desired number of seconds
                if(self.checkerBool == false) {self.collectionView.reloadData()}
                if self.pets.loadedBinary == 1 {
                    UIViewController.removeSpinner(spinner: sv)
                    self.collectionView.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        if self.pets.petArray.count == 0 {
                            if signedInBefore == -1 {
                                self.squigglyArrow.isHidden = false
                                UserDefaults.standard.set(1, forKey: "signedInBefore")
                            }
                        } else {
                            self.dailyResetting()
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // change 4 to desired number of seconds
                if(self.checkerBool == false) {self.collectionView.reloadData()}
                if self.pets.loadedBinary == 1 {
                    UIViewController.removeSpinner(spinner: sv)
                    self.collectionView.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        if self.pets.petArray.count == 0 {
                            if signedInBefore == -1 {
                                self.squigglyArrow.isHidden = false
                                UserDefaults.standard.set(1, forKey: "signedInBefore")
                            }
                        } else {
                            self.dailyResetting()
                        }
                    }
                    
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 5 to desired number of seconds
                if(self.checkerBool == false) {self.collectionView.reloadData()}
                if self.pets.loadedBinary == 1 {
                    UIViewController.removeSpinner(spinner: sv)
                    self.collectionView.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        if self.pets.petArray.count == 0 {
                            if signedInBefore == -1 {
                                self.squigglyArrow.isHidden = false
                                UserDefaults.standard.set(1, forKey: "signedInBefore")
                            }
                        } else {
                            self.dailyResetting()
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) { // change 6 to desired number of seconds
                if(self.checkerBool == false) {self.collectionView.reloadData()}
                UIViewController.removeSpinner(spinner: sv)
                self.collectionView.alpha = 1
                if self.pets.loadedBinary == 0{
                    // Creates the Check Internet Connection Alert
                    self.collectionView.alpha = 0
                    let internetAlert = UIAlertController(title: "Poor Network Connection", message: "The internet connection was too slow, try open and close 'My Profile' or restarting the app", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    internetAlert.addAction(action)
                    self.present(internetAlert, animated: true, completion: nil)
                    
                }
            }
        }

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
        
    }
    
    @IBAction func myFamilyButtonPressed(_ sender: UITapGestureRecognizer) {
        if(pets.OPuser.family == ""){
           self.performSegue(withIdentifier: "MyFamily", sender: nil) // Move this down
        }
        
    }
    
    
    
    // MARK: Segue Preperations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Passes pet information to PetDetails Scene
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            self.collectionView.allowsMultipleSelection = false
            let selectedIndex = self.collectionView.indexPathsForSelectedItems?.first
            if pets.petArray.count != 0 {
                destination.pet = pets.petArray[selectedIndex!.row]
                
                
            }
        }
        // Passes user information to UserProfile scene
        if segue.identifier == "MyProfile" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! UserProfileViewController
            destination.OPuser = pets.OPuser
        }
        
        // Passes user information to MyFamily scene
        if segue.identifier == "MyFamily" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! MyFamily
            destination.OPuser = pets.OPuser
        }
    }
    
    // MARK: Auth Code
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            collectionView.isHidden = false
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            collectionView.isHidden = true
            signIn()
        } catch {
            collectionView.isHidden = true
            print("*** ERROR: Couldn't sign out")
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    

    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        // Create a frame for an ImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // place bottom of UIImageView at center of screen
        // Use values above to build a CGRect for the ImageView’s frame
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width:
            self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo_2" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo_2")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
    
    // MARK: Card Cell Functions
    
    // The various background colour options for cards
    var colors: [UIColor]  = [
        UIColor(red: 194, green: 234, blue: 189), // green
        UIColor(red: 255, green: 184, blue: 184), // young salmon
        UIColor(red: 249, green: 220, blue: 92), // yellow
        UIColor(red: 205, green: 132, blue: 241), // bright lilac
        UIColor(red: 243, green: 166, blue: 131), // creamy peach
        UIColor(red: 52, green: 231, blue: 228), // fresh turquoise
        UIColor(red: 255, green: 184, blue: 209), // pink
        UIColor(red: 75, green: 207, blue: 250), // megaman blue
        UIColor(red: 11, green: 232, blue: 129), // minty green
        UIColor(red: 255, green: 192, blue: 72), // nãrenji orange
        UIColor(red: 197, green: 108, blue: 240) // light purple
    ]

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
    
// MARK: Date Functions
    func resetData(petRef: String, dateString: String){
        // This updates the datestring in the pets Firebase doc
        let db = Firestore.firestore()
        let dateRef = db.collection("pets").document(petRef)
        dateRef.updateData(["lastReset": dateString, "morningFedStatus": "0", "morningFedBy": "", "eveningFedStatus": "0", "eveningFedBy": "", "walkedToday": "0"]) { err in
            if let err = err {
                print("Error in Daily Resettingx: \(err)")
            } else {
                print("Daily Resetting Successful")
                self.checkerBool = false
                self.pets.petArray = Array(NSOrderedSet(array: self.pets.petArray)) as! [Pet]
                self.pets.loadData {
                    self.collectionView.reloadData()

                }
                //self.performSegue(withIdentifier: "resetVC", sender: nil)
            }
        }
    }
    
    func compareDates(dateToCompare: String, petRef: String){
        // This block gets and formats the current date into a dateString
        let unformattedCurrentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        let dateString = dateformatter.string(from: unformattedCurrentDate)
        let currentDate = dateformatter.date(from: dateString)
       
        let lastDate = dateformatter.date(from: dateToCompare)
        
        
        if currentDate! > lastDate! {
            // update the firebase date with this one, and reset data
            resetData(petRef: petRef, dateString: dateString)
        }
    }
    
    func dailyResetting(){
        for pet in self.pets.petArray {
            let petID = pet.documentID
            // Now we need to call on the lastReset date here
            let lastReset = pet.lastReset
            print(lastReset)
            compareDates(dateToCompare: lastReset, petRef: petID)
        }
    }
    
    // MARK: Reminder Functions

}

// MARK: Extensions

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication:
            sourceApplication) ?? false {
            return true
        }
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            let db = Firestore.firestore()
            let userDocRef = db.collection("opusers").document((authUI.auth?.currentUser?.uid)!)
            userDocRef.getDocument { (document, error) in
                if let document = document {
                    if document.exists{
                    } else {
                        db.collection("opusers").document((authUI.auth?.currentUser?.uid)!).setData(["fullName" : "", "userName" : "", "userPets" : [""] ])
                    }
                }
            }
            collectionView.isHidden = false
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
            // Alert Onboarding Code
            var alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
            //Modify size of alertview (Purcentage of screen height and width)
            alertView.percentageRatioHeight = 0.6
            alertView.percentageRatioWidth = 0.7
            alertView.titleGotItButton = "GOT IT!"
            alertView.show()
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    // This determines how many cards there are (by the number of pets)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.petArray.count
    }

    // This determines the content of each card
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellReuseIdentifier", for: indexPath) as! CollectionViewCell
        if pets.petArray.count == 1{
            cell.activateShadowBinary = 1   // This enables the card shadow if there is just 1 card
        } else {
            cell.activateShadowBinary = 0
        }
        // This function downloads the pet image and masks it
        func downloadPetImage(){
            let ispinner = UIViewController.imageSpinner(onView: cell.petImage)
            let storageRef = Storage.storage().reference()
            let reference = storageRef.child("pets/\(pets.petArray[indexPath.row].documentID)")
            let imageView: UIImageView = cell.petImage
            let placeholderImage = UIImage(named: "dog_avatar2.jpg")!
            
            reference.downloadURL { url, error in
                if let error = error {
                    // Handle any errors
                    print("No Image Available")
                    UIViewController.removeSpinner(spinner: ispinner)
                } else {
                    // Get the download URL
                    imageView.sd_setImage(with: url, placeholderImage: placeholderImage)
                    UIViewController.removeSpinner(spinner: ispinner)
                    let imageToBeMasked = cell.petImage.image
                    imageView.maskCircle(anyImage: imageToBeMasked!)
                    imageView.layer.borderWidth = 2.0
                    imageView.layer.borderColor = UIColor.white.cgColor
                }
            }
        }
        if pets.petArray.count != 0 {
            if pets.petArray[indexPath.row].hasImage == 1{
                downloadPetImage()
                
            }
            self.checkerBool = true // indicates cards no longer need to be reloaded
            let pet = pets.petArray[indexPath.row]
            cell.layer.cornerRadius = 7.0
            cell.backgroundColor = colors[indexPath.row % colors.count] // picks a random color
            cell.petNameLabel.text = pet.petName
            if(Int(pet.walkedToday) == 1){cell.walkedTodayLabel.text = "Walked today"}
            else{cell.walkedTodayLabel.text = "Not walked today"}
            if(Int(pet.morningFedStatus) == 0){cell.morningFedLabel.text = "Not fed"}
            else{cell.morningFedLabel.text = "Fed"}
            if(Int(pet.eveningFedStatus) == 0){cell.eveningFedLabel.text = "Not fed"}
            else{cell.eveningFedLabel.text = "Fed"}
        }
        return cell
    }
}

