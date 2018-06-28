//
//  ViewController.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 4/26/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import AlertOnboarding
import GoogleMobileAds


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonPressed: UIBarButtonItem!
    
    var authUI: FUIAuth!
    var pets: Pets!
    var bannerView: GADBannerView!
   
    // Setting up the onboarding alert
    var arrayOfImage = ["dog_avatar2", "Avatar_Dog-512", "friend_avatar"]
    var arrayOfTitle = ["WELCOME TO OURPET", "SET-UP YOUR PETS", "ADD CO-CARERS"]
    var arrayOfDescription = ["Welcome to OurPet, the simplest way for a group of people to effectively care for their pets. Invite your friends and family to get the group pet care started!",
                              "Press the '+' button on the OurPet home screen to set-up your pet, then use the simple one-tap logging to let the other carers know everytime you feed or walk your pet! ",
                              "Tap 'Manage Carers' on your Pet's details to add family, friends, and everyone else that helps take care of your pet and create your Carer Groups."]
    
 
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        pets = Pets()
        
        // Banner Ad Setup
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // Real UnitID: ca-app-pub-5053341811681547/6605210108
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
   
        
        var bgimage = UIImage(named: "moon_purple.jpg") as! UIImage
        self.navigationController!.navigationBar.setBackgroundImage(bgimage,
                                                                    for: .default)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if Auth.auth().currentUser?.uid != nil {
        pets.loadData {
            let sv = UIViewController.displaySpinner(onView: self.view)
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 5 to desired number of seconds
                self.tableView.reloadData()
                if self.pets.loadedBinary != 0 {
                UIViewController.removeSpinner(spinner: sv)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 5 to desired number of seconds
                self.tableView.reloadData()
                if self.pets.loadedBinary != 0 {
                    UIViewController.removeSpinner(spinner: sv)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // change 5 to desired number of seconds
                self.tableView.reloadData()
                if self.pets.loadedBinary != 0 {
                    UIViewController.removeSpinner(spinner: sv)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // change 5 to desired number of seconds
                self.tableView.reloadData()
                if self.pets.loadedBinary != 0 {
                    UIViewController.removeSpinner(spinner: sv)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 5 to desired number of seconds
                self.tableView.reloadData()
                UIViewController.removeSpinner(spinner: sv)
            }
        }

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
        
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndex = tableView.indexPathForSelectedRow!
            if pets.petArray.count != 0 {
                destination.pet = pets.petArray[selectedIndex.row]
            }
        }
        if segue.identifier == "MyProfile" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! UserProfileViewController
            destination.OPuser = pets.OPuser
        }
    }
    
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            tableView.isHidden = false
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            tableView.isHidden = true
            signIn()
        } catch {
            tableView.isHidden = true
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
}

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
            tableView.isHidden = false
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // change zero below to appropriate datasource.count
        print(pets.petArray.count)
        return pets.petArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        if pets.petArray.count != 0 {
            let pet = pets.petArray[indexPath.row]
            cell.textLabel?.text = "\(pet.petName)"
            if(Int(pet.walkedToday) == 0){cell.detailTextLabel?.text = "Not Walked Today"}
            else{cell.detailTextLabel?.text = "Walked Today"}
        }
        return cell
    }
}


