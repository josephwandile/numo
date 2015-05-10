//
//  PromptViewController.swift
//

import Foundation
import UIKit
import CoreLocation

class PromptViewController: UIViewController  {
    
    // enables colors for background gradient
    let colors = Colors()
    
    // initializes the alert
    var controller:UIAlertController?
    
    override func viewDidAppear(animated: Bool) {
        
        // places gradient on the background
        view.backgroundColor = UIColor.clearColor()
        var backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    required init(coder aDecoder: (NSCoder!)) {
        super.init(coder:aDecoder)
    }

    // initializes all label objects for this view
    @IBOutlet weak var PromptLabel: UILabel!
    
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var BioLabel: UILabel!
    
    // initializes all textfield objects for this view
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var BioTextField: UITextField!
    
    // initializes button used to create account once textfields are filled out
    @IBOutlet weak var CreateButton: UIButton!
    
    var locationObj : CLLocation = CLLocation()
    
    // initializes variables necessary for info
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var email: String = ""
    var bio: String = ""
    
    // ensure that phone number meets minimum length requirement
    func numberOfDigits(string: String) -> Int {
        var counter = 0
        for ch in string {
            switch "\(ch)" {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                counter++
            default:
                break
            }
        }
        return counter
    }
    
    // ensure valid email address by checking for only one "@" character
    func emailValidation(string: String) -> Int {
        var counter = 0
        for ch in string {
            switch "\(ch)" {
            case "@":
                counter++
            default:
                break
            }
        }
        return counter
    }
    
    // ensure valid number by checking for only one "+" character
    func phoneValidation(string: String) -> Int {
        var counter = 0
        for ch in string {
            switch "\(ch)" {
            case "+":
                counter++
            default:
                break
            }
        }
        return counter
    }
    
    
    // function called when button is pressed
    @IBAction func CreateAccount(sender: AnyObject) {
        
        // Ensures that none of the fields are empty and reacts with warning prompt if they are not all filled out

        if FirstNameTextField.text.isEmpty
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter your first name.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)

        }
        else if LastNameTextField.text.isEmpty
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter your last name.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)
        }
        else if PhoneTextField.text.isEmpty
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter your phone number.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)
        }
        else if numberOfDigits(PhoneTextField.text) < 10 || phoneValidation(PhoneTextField.text) > 1
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter a ten digit phone number.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)
        }
        else if EmailTextField.text.isEmpty
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter your email.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)
        }
        else if emailValidation(EmailTextField.text) != 1
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter a valid email.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)
        }
        else if BioTextField.text.isEmpty
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter your bio.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)
        }
        else if countElements(BioTextField.text) >= 140
        {
            // sets up alert controller
            controller = UIAlertController(title: "Sorry",
                message: "Please enter a bio less than 140 characterts.",
                preferredStyle: .Alert)
            
            // create the cancel action
            var okConfirm = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Ok Pressed.")
            }
            
            controller!.addAction(okConfirm)
            
            self.presentViewController(controller!, animated: true, completion: nil)
        }

        else
        {
            
            firstName = FirstNameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            lastName = LastNameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            phone = PhoneTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            email = EmailTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            bio = BioTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
            
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            // if user information exists already, query by phone number and update fields
            if let number = defaults.objectForKey("phone") as? String {
                var query:PFQuery = PFQuery(className: "people")
                query.whereKey("number", equalTo: number)
                query.findObjectsInBackgroundWithBlock({
                    (objects:[AnyObject]!, error:NSError!)->Void in
                    
                    if error == nil {
                        for object in objects {
                            let objectId = object.objectId
                            var query2 = PFQuery(className:"people")
                            query.getObjectInBackgroundWithId(objectId) {
                                (obj: PFObject!, error: NSError!) -> Void in
                                if error != nil {
                                    NSLog("%@", error)
                                } else {
                                    obj["first_name"] = self.firstName
                                    obj["last_name"] = self.lastName
                                    obj["number"] = self.phone
                                    obj["email_address"] = self.email
                                    obj["description"] = self.bio
                                    obj.save()
                                }
                            }
                        }
                    }
                })
            }
            else {
                //add user to parse back end if does not exist
                let curUser:PFObject = PFObject(className: "people")
                curUser["first_name"] = firstName
                curUser["last_name"] = lastName
                curUser["number"] = phone
                curUser["email_address"] = email
                curUser["description"] = bio
                curUser["findable"] = false
                curUser.saveInBackgroundWithBlock({
                    (result:Bool!, error:NSError!) -> Void in
                    if error == nil {
                        println("User created!")
                    }
                })
            }
            // save user defaults with same data
            defaults.setObject(firstName, forKey: "firstName")
            defaults.setObject(lastName, forKey: "lastName")
            defaults.setObject(phone, forKey: "phone")
            defaults.setObject(email, forKey: "email")
            defaults.setObject(bio, forKey: "bio")
            
            defaults.synchronize()
            
            // Load the homepage once again
            let launchView = self.storyboard?.instantiateViewControllerWithIdentifier("launchView") as LaunchViewController
            self.navigationController?.pushViewController(launchView, animated: true)
            NSLog("Prompting for info")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let FirstNameIsNotNill = defaults.objectForKey("firstName") as? String {
            NSLog("Found: %@", FirstNameIsNotNill as NSString)
            self.FirstNameTextField.text = defaults.objectForKey("firstName") as String
        }
        
        if let LastNameIsNotNill = defaults.objectForKey("lastName") as? String {
            self.LastNameTextField.text = defaults.objectForKey("lastName") as String
        }
        
        if let EmailIsNotNill = defaults.objectForKey("email") as? String {
            self.EmailTextField.text = defaults.objectForKey("email") as String
        }
        
        if let PhoneIsNotNill = defaults.objectForKey("phone") as? String {
            self.PhoneTextField.text = defaults.objectForKey("phone") as String
        }
        if let BioTextField = defaults.objectForKey("bio") as? String {
            self.BioTextField.text = defaults.objectForKey("bio") as String
        }
    }
}