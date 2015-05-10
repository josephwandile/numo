//
//  AddContactHelper.swift
//


import Foundation

class AddContactHelper{
    
    class func GetCurrentUserPFObject()->PFObject {
        var user : PFObject = PFObject(className: "people")
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        // get user PFObject by querying on unique phone number then primary key
        let number = defaults.objectForKey("phone") as String
            var query:PFQuery = PFQuery(className: "people")
            query.whereKey("number", equalTo: number)
        let objects : [AnyObject]! = query.findObjects() as [AnyObject]!
                for object in objects {
                    let objectId = object.objectId
                    var query2 = PFQuery(className:"people")
                    user = query.getObjectWithId(objectId!)
                    
                }
        return user
    }
    
    // check if user is in other's array
    class func CheckAInBList(user : PFObject, other : PFObject)->Bool{
        let arr: NSArray! = other["approvedConnections"] as? NSArray
            if arr != nil{
            for id in arr {
                if let strId : String = id as? String{
                    if strId.compare(user.objectId ) == NSComparisonResult.OrderedSame{
                        return true
                    }
                }
            }
        }
        return false
    }

     // check if other has been added to user's contact list
    class func CheckAddedYet(user : PFObject, other : PFObject)->Bool{
        let arr: NSArray! = other["contactsAdded"] as? NSArray
            if arr != nil{
            for id in arr {
                if let strId : String = id as? String{
                    if strId.compare(user.objectId ) == NSComparisonResult.OrderedSame{
                        return false
                    }
                }
            }
        }
        return true
    }
}