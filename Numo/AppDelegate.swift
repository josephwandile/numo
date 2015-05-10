//
//  AddressBookController.swift
//

import UIKit
import CoreLocation
import AddressBook
import AddressBookUI

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // connect and validate parse
        Parse.setApplicationId("q50YpNQ3xnR3pDVF6qPPXpiVe8GDJRjHwqGdmTO9", clientKey: "ib1ggXnb9QgsI9dmYvQ4jn9V3DJLWez1bp0HM3DG")
        
        initLocationManager();
        
        
        let abController = AddressBookController()
        switch ABAddressBookGetAuthorizationStatus() {
        case .Authorized:
            println("Already authorized")
            abController.createAddressBook()
            /* Now address book can be used */
            // AB = abController.addressBook
        case .Denied:
            println("You are denied access to address book")
            
        case .NotDetermined:
            abController.createAddressBook()
            if let theBook: ABAddressBookRef = abController.addressBook {
                ABAddressBookRequestAccessWithCompletion(theBook,
                    {(granted: Bool, error: CFError!) in
                        
                        if granted{
                            println("Access is granted")
                        } else {
                            println("Access is not granted")
                        }
                        
                })
            }
            
        case .Restricted:
            println("Access is restricted")
            
        default:
            println("Unhandled")
        }
        
        return true
    }
    
    // Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Location Manager Delegate stuff
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if let e = error {
            if (seenError == false) {
                seenError = true
                print(e)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            
            NSUserDefaults.standardUserDefaults().setObject([coord.latitude, coord.longitude], forKey: "location")
            
            /* post notification holding location object
            NSNotificationCenter.defaultCenter().postNotificationName("location", object : locationObj)
            */
            
            println(coord.latitude)
            println(coord.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            /*
            LOCATION NOTIFICATION POSTING
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)*/
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }
}
