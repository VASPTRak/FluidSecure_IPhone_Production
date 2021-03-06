//
//  PreauthVC.swift
//  FuelSecure
//
//  Created by VASP on 9/13/17.
//  Copyright © 2017 VASP. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation
import UIKit

@available(iOS 9.0, *)
class PreauthVC: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,UIPickerViewDelegate,StreamDelegate {
    var web = Webservices()
    var currentlocation :CLLocation!

    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!

    let defaults = UserDefaults.standard
    var timer:Timer = Timer()

    var reply:String!
    var IsDepartmentRequire:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var results = [NSManagedObject]()
    var Transaction_ID = [NSManagedObject]()
    var cf = Commanfunction()
    var unsync = Sync_Unsynctransactions()

    var sysdata:NSDictionary!
    var systemdata:NSDictionary!

    var pickerViewLocation: UIPickerView = UIPickerView()
    var ssid = [String]()
    var Pass = [String]()
    var location = [String]()

    var PulserStopTimelist = [String]()
    var PumpOffTimelist = [String]()
    var PumpOnTimelist = [String]()
    var Transaction_Id = [String]()
    var Available_preauthtransactions = [String]()
    var Ulocation = [String]()
    var siteID = [String]()
    var Uhosenumber = [String]()
    var IsOdoMeterRequire:String!
    var IsLoginRequire:String!

    var notransactionid :String!
    

    @IBOutlet var Companylogo: UIImageView!
    @IBOutlet var selecthose: UILabel!
    @IBOutlet var version_2: UILabel!
    @IBOutlet var itembarbutton: UIBarButtonItem!
    @IBOutlet var AvailablePreauthTransactions: UILabel!
    @IBOutlet var preauth: UIButton!
    @IBOutlet var version: UILabel!
    @IBOutlet var go: UIButton!
    @IBOutlet var datetime: UILabel!
    @IBOutlet var viewlable: UIView!
//    @IBOutlet var datepicker: UIDatePicker!
//    @IBOutlet var realyon: UIButton!
    @IBOutlet var warningLable: UILabel!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var infotext: UILabel!
    @IBOutlet var wifiNameTextField: UITextField!
//    @IBOutlet var help: UIButton!
    @IBAction func preAuthentication(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        version_2.text = "Version \(Version)"
        version.text = "Version \(Version)"
        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
            itembarbutton.title = "English"
            //defaults.set("es", forKey: "Language")

        }else  if(Vehicaldetails.sharedInstance.Language == ""){
            itembarbutton.title = "Spanish"
            //defaults.set("en", forKey: "Language")
        }
        wifiNameTextField.delegate = self


        selecthose.text = NSLocalizedString("Select Hose to use", comment:"")
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State())
        doneButton.addTarget(self, action: #selector(tapAction), for: UIControl.Event.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        wifiNameTextField.returnKeyType = .done
        wifiNameTextField.inputAccessoryView = doneButton
        wifiNameTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        
        Vehicaldetails.sharedInstance.deptno = ""
        Vehicaldetails.sharedInstance.Personalpinno = ""
        Vehicaldetails.sharedInstance.Other = ""
       // Vehicaldetails.sharedInstance.Odometerno = ""
        Vehicaldetails.sharedInstance.hours = ""
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location

        let uuid:String //= UIDevice.current.identifierForVendor!.uuidString
        let password = KeychainService.loadPassword()
        if(password == nil){
            uuid = UIDevice.current.identifierForVendor!.uuidString
            KeychainService.savePassword(token: uuid as NSString)
        }
        else{
            let password = KeychainService.loadPassword()
            print(password!)// password = "Pa55worD"
            uuid = password! as String
        }
        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = "Enter Title" // PlaceHolderText
        
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        wifiNameTextField.attributedPlaceholder = myMutableStringTitle
        _ = defaults.array(forKey: "SSID")
        var reply:String!
        var error:String!
        //var data:String!

        if(currentlocation == nil)
        {
            let data =  web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
            let Split = data.components(separatedBy: "#")
            reply = Split[0]
            if(reply != "-1"){
                cf.DeleteFileInApp(fileName: "getSites.txt")
                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
                self.present(controller, animated: true, completion: nil)
            }
            else if(reply == "-1"){
                if(cf.checkPath(fileName: "getSites.txt") == true) {
                    reply = cf.ReadFile(fileName: "getSites.txt")
                }
            }
        }
        else {
            sourcelat = currentlocation.coordinate.latitude
            sourcelong = currentlocation.coordinate.longitude
            //print (sourcelat,sourcelong)
            Vehicaldetails.sharedInstance.Lat = sourcelat
            Vehicaldetails.sharedInstance.Long = sourcelong
            let data = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
            let Split = data.components(separatedBy: "#")
            reply = Split[0] 
            if(reply != "-1"){
                cf.DeleteFileInApp(fileName: "getSites.txt")
                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
                self.present(controller, animated: true, completion: nil)
            }
            else if(reply == "-1"){
                if(cf.checkPath(fileName: "getSites.txt") == true) {
                    reply = cf.ReadFile(fileName: "getSites.txt")
                }
            }
        }
        
        //Check User approved or not from server
        
        if(reply == "-1")
        {
            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
            {
                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
                scrollview.isHidden = true
                version.isHidden = false
                refreshButton.isHidden = false
                showAlertSetting(message: NSLocalizedString("warning_NoInternet_Connection", comment:""))//"Cannot connect to cloud server. Please connect to the network having the internet")
            }
                
            else if(Vehicaldetails.sharedInstance.reachblevia == "cellular") /*||  Vehicaldetails.sharedInstance.reachblevia == "notreachable"*/
            {
                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
               // showAlert(message: "\(error)")
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                warningLable.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")//"Cannot connect to cloud server.please check your internet connection."
                refreshButton.isHidden = false
            }
            else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
                if(error == nil){
                showAlert(message: NSLocalizedString("Preauthtrans",comment:""))//"Pre-Authorized transactions are not Available.")
                }
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                warningLable.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")//"Cannot connect to cloud server. Please check your internet connection."
                refreshButton.isHidden = false
                for i in 1...2
                {
                    print(i)
                    if(currentlocation == nil)
                    {

                    }else{
                        // data = web.checkApprove(uuid,lat:"\(sourcelat)",long:"\(sourcelong)")
                    }
                    //                     let Split = data.components(separatedBy: "#")
                    //                    reply = Split[0] 
                    //                    error = Split[1]
                    if(reply == "-1")
                    {//showAlert("Cannot connect to cloud server. Please check your internet connection. \n \(error)")
                    }
                    else
                    {
                        // viewDidLoad()
                        break;
                    }
                }
            }
        }
        else {
            
            let data1:Data = reply.data(using: String.Encoding.utf8)! as Data
            do {
                sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
           /// print(sysdata)
            
            let Message = sysdata["ResponceMessage"] as! NSString
            let ResponseText = sysdata["ResponceText"] as! NSString
            if(Message == "success") {
                self.navigationItem.title = "FluidSecure"
                let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
                let Email = objUserData.value(forKey: "Email") as! NSString
                let IMEI_UDID = objUserData.value(forKey: "IMEI_UDID") as! NSString
                let IsApproved = objUserData.value(forKey: "IsApproved") as! NSString
                let PersonName = objUserData.value(forKey: "PersonName") as! NSString
                let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
                IsOdoMeterRequire = objUserData.value(forKey: "IsOdoMeterRequire") as! NSString as String
                IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
                
                infotext.text = NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") + ": \(Email)"
                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
                
                defaults.set(PersonName, forKey: "firstName")
                defaults.set(Email, forKey: "address")
                defaults.set(PhoneNumber, forKey: "mobile")
                defaults.set(uuid, forKey: "uuid")
                defaults.set(1, forKey: "Register")
                
                print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
                _ = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
                    //    Get Image from Document Directory :
                    
                    
                    let fileManager = FileManager.default
                    
                    let imagePAth = (cf.getDirectoryPath() as NSString).appendingPathComponent("logoimage.jpg")
                    
                    if fileManager.fileExists(atPath: imagePAth){
                        
                        self.Companylogo.image = UIImage(contentsOfFile: imagePAth)
                        
                    }else{
                        
                        print("No Image")
                    }
            }
            else if(Message == "fail"){ }
            
            defaults.set(uuid, forKey: "uuid")
            
            if(Message == "success") {
                
                scrollview.isHidden = false
                version.isHidden = true
                warningLable.isHidden = true
                refreshButton.isHidden = true
                
                self.wifiNameTextField.placeholder = NSLocalizedString("Touch to select Site", comment:"")
                self.wifiNameTextField.textColor = UIColor.white
                self.wifiNameTextField.inputView = pickerViewLocation
                self.pickerViewLocation.delegate = self
                
                do {
                    _ = defaults.string(forKey: "firstName")
                    _ = defaults.string(forKey: "address")
                    _ = defaults.string(forKey: "mobile")
                    _ = defaults.string(forKey: "uuid")
                    
                    //IF USER IF Approved Get information from server like site,ssid,pwd,hose
                    
                    do{
                        systemdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    }catch let error as NSError {
                        print ("Error: \(error.domain)")
                        print ("Error: \(error)")
                    }
                //    print(systemdata)
                    ssid = []
                    Vehicaldetails.sharedInstance.Transaction_id = []
                    
                    let objUserDataT = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
                    let PreAuthJsonT = objUserDataT.value(forKey: "TransactionObj") as! NSArray
                    let PreAuthrowCountT = PreAuthJsonT.count
                    for i in 0  ..< PreAuthrowCountT
                    {
                        let PreAuthJsonRow = PreAuthJsonT[i] as! NSDictionary
                        let MessageTransactionObj = PreAuthJsonRow["ResponceMessage"] as! NSString

                        if(MessageTransactionObj == "success"){
                            let T_Id = PreAuthJsonRow["TransactionId"] as! NSString
                            Transaction_Id.append(T_Id as String)
                        }
                    }
                    
                    let objUserData = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
                    let PreAuthJson = objUserData.value(forKey: "SitesObj") as! NSArray
                    let PreAuthrowCount = PreAuthJson.count

                    for i in 0  ..< PreAuthrowCount
                    {
                        let PreAuthJsonRow = PreAuthJson[i] as! NSDictionary
                        let Message = PreAuthJsonRow["ResponceMessage"] as! NSString
                        let ResponseText = PreAuthJsonRow["ResponceText"] as! NSString
                        if(Message == "success") {
                            
                            let JsonRow = PreAuthJson[i] as! NSDictionary
                            
                            print(ssid)
                            defaults.set(ssid, forKey: "SSID")
                            defaults.set(siteID, forKey: "SiteID")
                            
                            Ulocation = location.removeDuplicates()
                            
                            if(Ulocation.count == 1)
                            {}
                            
                            let WifiSSId = JsonRow["WifiSSId"] as! NSString
//                            let PulserRatio = JsonRow["PulserRatio"] as! NSString
                            let DecimalPulserRatio = JsonRow["DecimalPulserRatio"] as! NSNumber
                            let FuelTypeId = JsonRow["FuelTypeId"] as! NSString
                            let Sitid = JsonRow["SiteId"] as! NSString
                            let pulsarstoptime = JsonRow["PulserStopTime"] as! NSString
                            let PumpOffTime = JsonRow["PumpOffTime"] as! NSString
                            let PumpOnTime = JsonRow["PumpOnTime"] as! NSString
                            
                            ssid.append(WifiSSId as String)
                            Ulocation = ssid.removeDuplicates()
                            location.append("\(DecimalPulserRatio)" as String)
                            Pass.append(FuelTypeId as String)
                            PulserStopTimelist.append(pulsarstoptime as String)
                            PumpOffTimelist.append(PumpOffTime as String)
                            PumpOnTimelist.append(PumpOnTime as String)

                            siteID.append(Sitid as String)
                            print(Uhosenumber)
                            
                        }
                        else if(Message == "fail")
                        {
                            self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
                            scrollview.isHidden = true
                            version.isHidden = false
                            warningLable.isHidden = false
                            refreshButton.isHidden = false
                            warningLable.text = "\(ResponseText)"//no hose found Please contact administrater"
                        }
                    }
                    
                    let tranid = objUserData.value(forKey: "TransactionObj") as! NSArray
                    let id = tranid.count

                    for i in 0  ..< id
                    {
                        let PreAuthJsonRow = tranid[i] as! NSDictionary
                        let Message = PreAuthJsonRow["ResponceMessage"] as! NSString
                        let ResponseText = PreAuthJsonRow["ResponceText"] as! NSString
                        if(Message == "success") {
                            let TransactionId = PreAuthJsonRow["TransactionId"] as! NSString
                            
                            let entityDescription = NSEntityDescription.entity(forEntityName: "TransactionID",in: managedObjectContext)
                            let ID = TransactionID(entity: entityDescription!, insertInto: managedObjectContext)
                            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TransactionID")
                            fetchRequest.returnsObjectsAsFaults = false
                            let resultPredicate2 = NSPredicate (format:"(transactionid == %@)",TransactionId)
                            let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate2])
                            fetchRequest.predicate = compound
                            do{
                                results = try context.fetch(fetchRequest) as! [NSManagedObject]
                                
                            } catch let error as NSError {
                                print ("Error: \(error.domain)")
                            }
                            Transaction_ID = []
                            Transaction_ID = results
                            print(results)
                            
                            if (results == [])
                            {
                                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
                                request.returnsObjectsAsFaults = false
                                ID.isactive = "false"
                                ID.transactionid = TransactionId as String
                                
                                do{
                                    try managedObjectContext.save()
                                }catch let error as NSError {
                                    print ("Error: \(error.domain)")
                                }
                                let Transactioniddeatils = Transaction_id(isactive: ID.isactive!,TransactionID: TransactionId as String)
                                Vehicaldetails.sharedInstance.Transaction_id.add(Transactioniddeatils)
                            }
                            else {
                                
                                let count = Transaction_ID.count
                                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
                                request.returnsObjectsAsFaults = false
                                
                                for i in 0  ..< count
                                {
                                    let certificate = self.Transaction_ID[i]
                                    let is_active = certificate.value(forKey: "isactive") as! String
                                    
                                    _ = certificate.value(forKey: "transactionid") as! String
                                    
                                    do{
                                        try managedObjectContext.save()
                                        
                                    }catch let error as NSError {
                                        print ("Error: \(error.domain)")
                                    }
                                    
                                    let Transactioniddeatils = Transaction_id(isactive: is_active,TransactionID: TransactionId as String)
                                    Vehicaldetails.sharedInstance.Transaction_id.add(Transactioniddeatils)
                                    
                                }
                            }
                        }
                            
                        else if(Message == "fail"){
                            
                            self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
                            scrollview.isHidden = true
                            version.isHidden = false
                            warningLable.isHidden = false
                            refreshButton.isHidden = false
                            warningLable.text = "\(ResponseText)"
                            shownotransId(message: "\(ResponseText)")
                        }
                    }
                    
                    if(Uhosenumber.count == 1)
                    {
                        let siteid = siteID[0]
                        let ssId = ssid[0]
                        
                        self.wifiNameTextField.text = ssid[0]
                        
                        Vehicaldetails.sharedInstance.siteID = siteid
                        Vehicaldetails.sharedInstance.SSId = ssId
                        defaults.set(siteid, forKey: "SiteID")
                    }
                }
            }
                
                //USER IS NOT REGISTER TO SYSTEM
            else if(ResponseText == "New Registration") {
                
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                defaults.set(0, forKey: "Register")
                // Call a method on the CustomController property of the AppDelegate
                self.web.sentlog(func_name: "Preauth", errorfromserverorlink: "", errorfromapp: "")
                appDel.start()
            }
                
            else if(Message == "fail") {
                
                defaults.set("false", forKey: "checkApproved")
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                refreshButton.isHidden = false
                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
                warningLable.text = NSLocalizedString("Regisration", comment:"")
                //"Your Registration request is not approved yet. It is marked Inactive in the Company Software. Please contact your company’s administrator."
            } else if(ResponseText == "New Registration") {
                performSegue(withIdentifier: "Register", sender: self)
            }
        }
        
        if(cf.getSSID() != "" ) {}
        else {
            //("SSID not found")
        }
        self.viewlable.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).cgColor
        let wifiSSid = Vehicaldetails.sharedInstance.SSId//getSSID()
        
        defaults.set(wifiSSid, forKey: "wifiSSID")
        // Do any additional setup after loading the view, typically from a nib.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM dd, yyyy"
        let strDate = dateFormatter.string(from: Date())
        datetime.text = strDate
        AvailablePreauthTransactions.text = NSLocalizedString("No_Pre-auth_transaction", comment:"") + "\(Available_preauthtransactions.count)"
    }
    
    @IBAction func spanish(_ sender: Any) {
        if(itembarbutton.title == "English"){
            Vehicaldetails.sharedInstance.Language = ""
            Bundle.setLanguage("en")
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.preauthstart()
        }else if(itembarbutton.title == "Spanish"){
            Bundle.setLanguage("es")
            Vehicaldetails.sharedInstance.Language = "es-ES"
            //itembarbutton.title = "Eng"
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.preauthstart()
        }
    }
    @IBAction func copypwd(sender: AnyObject) {
        print("Password is" + "12345678")// passwordTextField.text!)
        UIPasteboard.general.string = "12345678" //passwordTextField.text!
        print(UIPasteboard.general.string!)
    }
    
    
    @IBAction func Helptext(sender: AnyObject) {
        showAlert(message:NSLocalizedString("HelptextSelectedSite", comment:"") +  "12345678.")// "If you are using this hose for the first time you will need to enter the password when redirected to the WiFi screen. The password is 12345678.")
        
        print("Password is" + "12345678")// passwordTextField.text!)
        UIPasteboard.general.string = "12345678" //passwordTextField.text!
        print(UIPasteboard.general.string!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
        self.navigationItem.title = "FluidSecure"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        let index = Transaction_Id.count//Vehicaldetails.sharedInstance.Transaction_id.count
        if(index == 0){
            Available_preauthtransactions = []
        }else{
            timer.invalidate()
            Available_preauthtransactions = []
            print("ssID Match")
            for i in 0  ..< index
            {
                let obj: Transaction_id = Vehicaldetails.sharedInstance.Transaction_id[i] as! Transaction_id
                let transactionid = obj.TransactionID
                let status = obj.isactive
                if(status == "true"){
                    notransactionid = "True"
                }
                else if(status == "false"){
                    notransactionid = "False"
                    Available_preauthtransactions.append(transactionid)
                }
            }}
        AvailablePreauthTransactions.text = NSLocalizedString("No_Pre-auth_transaction", comment:"") + "\(Available_preauthtransactions.count)"//"Available Pre-Authorized transactions - \(Available_preauthtransactions.count)"
        if(cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {
            //showAlert("SSID not found wifi is not connected.")
        }

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if( cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {}
        _ = unsync.unsyncTransaction()

    }
    
    
//    func showAlert(message: String) {
//        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
//        // Background color.
//        let backView = alertController.view.subviews.last?.subviews.last
//        backView?.layer.cornerRadius = 10.0
//        backView?.backgroundColor = UIColor.white
//        // Change Message With Color and Font
//        let message  = message
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = NSTextAlignment.left
//        var messageMutableString = NSMutableAttributedString()
//        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [ NSAttributedStringKey.paragraphStyle: paragraphStyle,NSAttributedStringKey.font:UIFont(name: "Georgia", size: 24.0)!])
//        
//        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
//        alertController.setValue(messageMutableString, forKey: "attributedMessage")
//        // Action.
//        let action = UIAlertAction(title:NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goButtontapped(sender: AnyObject) {
        
        
        let index = Transaction_Id.count//Vehicaldetails.sharedInstance.Transaction_id.count
        if(index == 0){
            viewDidLoad()
        }else{
            timer.invalidate()
            if (wifiNameTextField.text == ""){
                showAlert(message: NSLocalizedString("NoHoseselect", comment:""))//"Please Select Hose to use.")
            }
            else{
                print("ssID Match")
                for i in 0  ..< index
                {
                    let obj: Transaction_id = Vehicaldetails.sharedInstance.Transaction_id[i] as! Transaction_id
                    let transactionid = obj.TransactionID
                    let status = obj.isactive
                    if(status == "true"){
                        notransactionid = "True"
                    }
                    else if(status == "false"){
                        notransactionid = "False"
                        Vehicaldetails.sharedInstance.TransactionId = Int(transactionid)!
                        
                        break;
                    }
                }
                if(notransactionid == "True"){

                    shownotransId(message: NSLocalizedString("Preauthnointernet", comment:""))//"Pre-authorized transactions not available for you. Please enabled your internet connection or Please contact your company’s administrator.")
                }
                else if(notransactionid == "False"){

                    self.performSegue(withIdentifier: "GO", sender: self)
                }
            }
        }
    }
    
    @objc func tapAction() {
        
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.endEditing(true)
    }
    
    @IBAction func refreshButtontappd(sender: AnyObject) {
        if(Vehicaldetails.sharedInstance.reachblevia == "wificonn" || Vehicaldetails.sharedInstance.reachblevia == "cellular")
        {
        let uuid:String// = UIDevice.current.identifierForVendor!.uuidString


            let password = KeychainService.loadPassword()
            if(password == nil){
                uuid = UIDevice.current.identifierForVendor!.uuidString
                KeychainService.savePassword(token: uuid as NSString)
            }
            else{
                let password = KeychainService.loadPassword()
                print(password!)// password = "Pa55worD"
                uuid = password! as String
            }
        let data = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
        let Split = data.components(separatedBy: "#")
        reply = Split[0]
        if(reply != "-1"){

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
            self.present(controller, animated: true, completion: nil)
            }

            }
            else{
        viewDidLoad()
        }

    }
    
    @IBAction func refreshButtontapped(sender: AnyObject) {
        if(cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {
            showAlert(message:  NSLocalizedString("NoSSIdFound", comment:""))//"SSID not found wifi is not connected.")
        }
    }
    
    
   @objc func numberOfComponentsInPickerView(pickerView: UIPickerView!)-> Int
    {
        if(pickerView == pickerViewLocation)
        {
            return 1
        }
        return 1
    }
    
    
    @objc func pickerView(_ pickerView: UIPickerView!,numberOfRowsInComponent component: Int)-> Int
    {
        if(pickerView == pickerViewLocation)
        {
            print(ssid.count)
            return ssid.count
        }
        return 0
    }
    
    
    @objc func pickerView(_ pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int)-> String?
    {
        if(pickerView == pickerViewLocation)
        {
            if(row == 0){
                self.wifiNameTextField.text = ssid[0]
                let siteid = siteID[0]
                let ssId = ssid[0]
                let Password = Pass[0]
                self.wifiNameTextField.text = ssid[0]

                Vehicaldetails.sharedInstance.siteID = siteid
                Vehicaldetails.sharedInstance.SSId = ssId
                Vehicaldetails.sharedInstance.password = Password
                return ssid[row]
            }
            else {
                return ssid[row]
            }
        }
        return ""
    }
    
    
    @objc func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int, inComponent component: Int)
    {
        var index: Int = 0
        if(pickerView == pickerViewLocation)
        {
            wifiNameTextField.text = ssid[row]
            print(location.count)
            for v in 0  ..< ssid.count
            {
                if(ssid[v] == ssid[row])
                {
                    index = v
                    break
                }
            }
            
            let siteid = siteID[index]
            let ssId = ssid[index]
            self.wifiNameTextField.text = ssid[index]
            Vehicaldetails.sharedInstance.siteID = siteid
            Vehicaldetails.sharedInstance.SSId = ssId
            Vehicaldetails.sharedInstance.PulseRatio = location[index]
            Vehicaldetails.sharedInstance.FuelTypeId = Pass[index]
            Vehicaldetails.sharedInstance.PulserStopTime = PulserStopTimelist[index]
            Vehicaldetails.sharedInstance.pumpoff_time = PumpOffTimelist[index]
        print(Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.PulseRatio,Vehicaldetails.sharedInstance.FuelTypeId,Vehicaldetails.sharedInstance.pumpoff_time)
            defaults.set(siteid, forKey: "SiteID")
            
            let Json = systemdata.value(forKey: "SSIDDataObj") as! NSArray
            let rowCount = Json.count
            
            for i in 0  ..< rowCount
            {
                let JsonRow = Json[i] as! NSDictionary
                let SiteName = JsonRow["SiteName"] as! NSString
                if(ssid[index] == SiteName as String){
                    let WifiSSId = JsonRow["WifiSSId"] as! NSString
                    let Password = JsonRow["InitialHoseName"] as! NSString
                    let hosename = JsonRow["HoseNumber"] as! NSString
                    let Sitid = JsonRow["SiteId"] as! NSString
                    ssid.append(WifiSSId as String)
                    location.append(SiteName as String)
                    Pass.append(Password as String)
                    Uhosenumber.append(hosename as String)
                    siteID.append(Sitid as String)
                    print(Uhosenumber)
                }
            }
            self.wifiNameTextField.text = ssid[index]
        }
        view.endEditing(true)
    }
    
    @IBAction func selecthose(sender: AnyObject) {
           self.performSegue(withIdentifier: "showhose", sender: self)
    }
    
    
    func wifisettings()
    {

    }
    
    func shownotransId(message:String){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
        //messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            self.web.sentlog(func_name: "Preauth shownotransId", errorfromserverorlink: "", errorfromapp: "")
            appDel.start()
            
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertSetting(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
       // messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            self.wifisettings()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func changewifi(sender: AnyObject) {

        viewWillAppear(true)
    }
}



