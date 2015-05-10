//
//  FindContactViewController.swift
//

class FindContactsViewController: UITableViewController {
    
    // enables colors for background gradient
    let colors = Colors()
    
    // initiates cell counter
    var cellCounter = 0
    
    // initialize refresh button
    @IBOutlet weak var RefreshingButton: UIButton!
    
    // initializes the alert 
    var controller:UIAlertController?
    
    var data:NSMutableArray = NSMutableArray()
    var selected : PFObject = PFObject(className: "people")
    var cur : PFObject = PFObject(className: "people")
    
    override init(style:UITableViewStyle){
        super.init(style: style)
    }
    
    @IBAction func RefreshButtonPressed(sender: AnyObject) {
        println("Refreshed Button Pressed")
        refresh()
    }
    
    required init(coder aDecoder: (NSCoder!)){
        super.init(coder:aDecoder)
    }
    
    // loads proximate users and updates own location variable
    func loadData(){
        self.cur = AddContactHelper.GetCurrentUserPFObject()
        var addedUsers : NSMutableArray = NSMutableArray()
        var queryAdded : PFQuery = PFQuery(className: "people")
        let addedIds : NSArray! = self.cur["approvedConnections"] as? NSArray
        if addedIds != nil {
            for id in addedIds {
                if let strId : String = id as? String{
                    addedUsers.addObject(queryAdded.getObjectWithId(strId))
                }
            }
        }
        
        // check if user has been added to other's lists since last refresh and if so add others to user's list
        for user in addedUsers{
            
            if AddContactHelper.CheckAInBList(self.cur, other: user as PFObject) && AddContactHelper.CheckAddedYet(user as PFObject, other : self.cur) {
                
                AddressBookController.addToContact(user as PFObject)
                // i NEW CONTACTS ADDED!!!!!!
                self.cur.addUniqueObject(user.objectId, forKey: "contactsAdded")
                self.cur.save()
                user.save()
                
                // create the cancel action
                var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
            }
        }

        
        let details : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let coords : [Double] = details.objectForKey("location") as [Double]
        let lat : Double = coords[0]
        let long : Double = coords[1]
 
        self.cur["location"] = PFGeoPoint(latitude: lat, longitude: long)
        self.cur.save()
        var addedHelp : NSArray? = self.cur["contactsAdded"] as? NSArray

        if addedHelp == nil{
            addedHelp = []
        }
        
        var added : [String] = addedHelp as [String]
        data.removeAllObjects()
        var query:PFQuery = PFQuery(className:"people")
        query.whereKey("location", nearGeoPoint: self.cur["location"] as PFGeoPoint, withinKilometers: 0.5)
        let objects : [AnyObject] = query.findObjects()
        if objects.count != 0 {
                for object in objects {
                    let otherId : String = object.objectId
                    if (object["findable"] === true && find(added, otherId) == nil) && self.cur.objectId != otherId{
                    self.data.addObject(object)
                    }
                }
        }
            self.tableView.reloadData()
        
    }

    
    func refresh()
    {
        self.cur = AddContactHelper.GetCurrentUserPFObject()
        println("Refreshed")
        
        var addedUsers : NSMutableArray = NSMutableArray()
        var queryAdded : PFQuery = PFQuery(className: "people")
        let addedIds : NSArray! = self.cur["approvedConnections"] as? NSArray
        if addedIds != nil {
            for id in addedIds {
                if let strId : String = id as? String{
                    addedUsers.addObject(queryAdded.getObjectWithId(strId))
                }
            }
            
        }
        
        // check if user has been added to other's lists since last refresh and if so add others to user's list
        var i : Int = 0;
        for user in addedUsers{
            
            if AddContactHelper.CheckAInBList(self.cur, other: user as PFObject) && AddContactHelper.CheckAddedYet(user as PFObject, other : self.cur){
                
                AddressBookController.addToContact(user as PFObject)
                // NEW CONTACTS ADDED
                self.cur.addUniqueObject(user.objectId, forKey: "contactsAdded")
                self.cur.save()
                user.save()

                
                // create the cancel action
                var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
            }
            
        }

        
        let details : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let coords : [Double] = details.objectForKey("location") as [Double]
        let lat : Double = coords[0]
        let long : Double = coords[1]
        self.cur["location"] = PFGeoPoint(latitude: lat, longitude: long)
        self.cur.save()
        var addedHelp : NSArray? = self.cur["contactsAdded"] as? NSArray
        
        if addedHelp == nil{
            addedHelp = []
        }
        
        var added : [String] = addedHelp! as [String]
        data.removeAllObjects()
        var query:PFQuery = PFQuery(className:"people")
        query.whereKey("location", nearGeoPoint: self.cur["location"] as PFGeoPoint, withinKilometers: 0.5)
        if let objects : [AnyObject] = query.findObjects(){
            for object in objects {
                let otherId : String = object.objectId
                if (object["findable"] === true && find(added, otherId) == nil) && self.cur.objectId != otherId{
                    self.data.addObject(object)
                }
            }
            
        }
        
        self.tableView.reloadData()
        
        
        
    }
    
    // function that is called when a cell in the tableview is selected
   
    //consolidate two viewDidLoad()s
    override func viewDidLoad() {

        // places gradient on the background
        view.backgroundColor = UIColor.clearColor()
        var backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
        
        super.viewDidLoad()
        
        self.loadData()
        cur = AddContactHelper.GetCurrentUserPFObject()
        cur["findable"] = true
        cur.save()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("You selected cell #\(indexPath.row)!")
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }

        
        // code for referencing object contained in respective cell clicked
        selected = self.data.objectAtIndex(indexPath.row) as PFObject
        
        
        // ensure that object desired is corresponding correctly with the cell selected
        var selectedFirstName = selected.objectForKey("first_name") as String
        var selectedLastName = selected.objectForKey("last_name") as String
        var selectedBio = selected.objectForKey("description") as String
        println(selectedFirstName + " " + selectedLastName)
        
        
        // titles the page
        self.title = "People Near You"
       
        //All the code for prompting users they selected a cell with an alert
        // sets up alert controller
        controller = UIAlertController(title: "Confirmation",
            message: "Are you sure you want to exchange contact information with " + selectedFirstName + " " + selectedLastName + "?\n\n" + "Contact's Description: " + selectedBio, preferredStyle: .Alert)
        
        // create the cancel action
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // create the yes action
        var yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("Yes Pressed")
            //UITableViewCell.appearance().backgroundColor? = UIColor.blueColor()
            
            // add other's id to user's approvedConnections array
            self.cur.addUniqueObject(self.selected.objectId, forKey: "approvedConnections")
            
            self.cur.save()
            
            // check if other has already added user. if yes, then add them to contact list
            var addedAlready : Bool = AddContactHelper.CheckAInBList(self.cur, other: self.selected) && AddContactHelper.CheckAddedYet(self.selected as PFObject, other : self.cur as PFObject) as Bool
            if addedAlready {
                AddressBookController.addToContact(self.selected)
                // ONE NEW CONTACT ADDED

                self.cur.addUniqueObject(self.selected.objectId, forKey: "contactsAdded")
                self.cur.save()
                self.selected.addUniqueObject(self.cur.objectId, forKey: "contactsAdded")
                self.selected.save()
                
                
                
            }
            
        }
        controller!.addAction(cancelAction)
        controller!.addAction(yesAction)
        self.presentViewController(controller!, animated: true, completion: nil)
    }



    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // initializes cell
        var cell:UITableViewCell = UITableViewCell()

        // sets up the PFObject name data to be pulled for putting into the text of the cell
        let user:PFObject = self.data.objectAtIndex(indexPath.row) as PFObject
        let fname = user.objectForKey("first_name") as String
        let lname = user.objectForKey("last_name") as String
        
        // sets name into the cell
        cell.textLabel.text = fname + " " + lname
        
        // centers the text in the cell
        cell.textLabel.textAlignment = NSTextAlignment.Center
        cellCounter++
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

