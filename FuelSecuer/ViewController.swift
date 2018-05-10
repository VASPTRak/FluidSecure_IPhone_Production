//  ViewController.swift
//  FuelSecuer
//  Created by VASP on 3/28/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation
import UIKit
import MapKit

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

@available(iOS 9.0, *)
class ViewController: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,UIPickerViewDelegate,StreamDelegate {
    var web = Webservices()
    var currentlocation :CLLocation!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!
    var locationName:NSString!
    var currentSSID:String!
    var cmd:NEHotspotHelperCommand!
    let defaults = UserDefaults.standard
    var timer:Timer = Timer()
    var readData:String!
    var reply:String!
    var IsDepartmentRequire:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!
    var OtherLabel:String!
    var timeout:String!
    var cf = Commanfunction()
    var ad = FuelquantityVC()
    var pa = PreauthFuelquantity()
    var sysdata:NSDictionary!
    var systemdata:NSDictionary!
    var pickerViewHose: UIPickerView = UIPickerView()
    var pickerViewLocation: UIPickerView = UIPickerView()
    var ssid = [String]()
    var Pass = [String]()
    var location = [String]()
    var ReplaceableHosename = [String]()
    var Ulocation = [String]()
    var siteID = [String]()
    var HoseId = [String]()
    var Is_upgrade = [String]()
    var pulsartimeadjust = [String]()
    var IFISBusy = [String]()
    var Uhosenumber = [String]()
    var TransactionId = [String]()
    var IsOdoMeterRequire:String!
    var IsLoginRequire:String!
    var IsBusy :String!
    var IsGobuttontapped : Bool = false

    @IBOutlet var preauth: UIButton!
    @IBOutlet var oview: UIView!
    @IBOutlet var version: UILabel!
    @IBOutlet var go: UIButton!
    @IBOutlet var datetime: UILabel!
    @IBOutlet var viewlable: UIView!
    @IBOutlet var warningLable: UILabel!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var infotext: UILabel!
    @IBOutlet var wifiNameTextField: UITextField!

    @IBAction func preAuthentication(sender: AnyObject) {

        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.present(controller, animated: true, completion: nil)


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TransactionId = []
        wifiNameTextField.delegate = self
        //wifiNameTextField.font = UIFont(name: wifiNameTextField.font!.fontName, size: 40)
       // wifiNameTextField.text = Vehicaldetails.sharedInstance.hours
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle("Return", for: UIControlState())
        doneButton.addTarget(self, action: #selector(tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        wifiNameTextField.returnKeyType = .done
        wifiNameTextField.inputAccessoryView = doneButton
        wifiNameTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters

//            if #available(iOS 11.0, *) {
//                let configuration = NEHotspotConfiguration.init(ssid: "SalesUnleaded", passphrase: "123456789", isWEP: false)
//
//        configuration.joinOnce = true
//
//
//            NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
//                if error != nil {
//                    //an error accured
//                    print(error!.localizedDescription)
//                }
//                else {
//                    //success
//                }
//            }
//        
//            } else {
//                // Fallback on earlier versions
//        }


        Vehicaldetails.sharedInstance.deptno = ""
        Vehicaldetails.sharedInstance.Personalpinno = ""
        Vehicaldetails.sharedInstance.Other = ""
        Vehicaldetails.sharedInstance.Odometerno = ""
        Vehicaldetails.sharedInstance.hours = ""
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        let uuid:String = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = "Enter Title" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 20.0)!]) // Font
        myMutableStringTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:NSRange(location:0,length:Name.count))    // Color
        wifiNameTextField.attributedPlaceholder = myMutableStringTitle
        _ = defaults.array(forKey: "SSID") //stringForKey("SSID")
        var reply:String!
//        var error:String!
//        var data:String!

        if(currentlocation == nil)
        {
           reply =  web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
//              let Split = data.components(separatedBy: "#")
//            reply = Split[0]
//            error = Split[1]
        }
        else {
            sourcelat = currentlocation.coordinate.latitude
            sourcelong = currentlocation.coordinate.longitude
            print (sourcelat,sourcelong)
            Vehicaldetails.sharedInstance.Lat = sourcelat
            Vehicaldetails.sharedInstance.Long = sourcelong
           // let preauthdata =  web.Preauthrization(uuid,lat:"\(sourcelat)",long:"\(sourcelong)")

            reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")

//            let Split = data.components(separatedBy: "#")
//            reply = Split[0]
//            error = Split[1]
        }

        //Check User approved or not from server
        if(reply == "-1")
        {
            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
            {
                self.navigationItem.title = "Error"
//                self.navigationController?.navigationBar.barTintColor = UIColor.blue
//                self.navigationController?.navigationBar.tintColor = UIColor.blue
//                self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blue]

                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                refreshButton.isHidden = false
               // preauth.isHidden = false//preauth.hidden = true//
                warningLable.text = "Cannot connect to cloud server.please check your internet connection."
                cf.delay(0.5){
                   // self.viewDidLoad()
                }
            }
            else if(Vehicaldetails.sharedInstance.reachblevia == "cellular") /*||  Vehicaldetails.sharedInstance.reachblevia == "notreachable"*/
            {
                self.navigationItem.title = "Error"
               // showAlert(message: "\(error)")
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                //preauth.isHidden = false// preauth.hidden = true//preauth.hidden = false
                warningLable.text = "Cannot connect to cloud server.please check your internet connection."
                refreshButton.isHidden = false
                // viewDidLoad()
            }
            else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                self.navigationItem.title = "Error"
                //showAlert(message: "\(error!)")
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
               // preauth.isHidden = false//preauth.hidden = true//preauth.hidden = false
                warningLable.text = "Cannot connect to cloud server.please check your internet connection."
                refreshButton.isHidden = false
                for i in 1...2
                {
                    print(i)
                    if(currentlocation == nil)
                    {
                        reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
                    }else{
                        reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat)",long:"\(sourcelong)")
                    }
//                    let Split:NSArray = data.components(separatedBy: "#") as NSArray
//                    reply = Split[0] as! String
//                    error = Split[1]as! String
                    if(reply == "-1")
                    {//showAlert("Cannot connect to cloud server. Please check your internet connection. \n \(error)")
                    }
                    else
                    {
                        viewDidLoad()
                        break;
                    }
                 }
            }
        }
        else {
            let data1:Data = reply.data(using: String.Encoding.utf8)!
            do {
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(sysdata)
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
                OtherLabel = objUserData.value(forKey:"OtherLabel") as!NSString as String
                timeout = objUserData.value(forKey:"TimeOut") as!NSString as String

                infotext.text = "Name: \(PersonName)\nMobile: \(PhoneNumber)\nEmail: \(Email)"
                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
                Vehicaldetails.sharedInstance.Otherlable = OtherLabel
                Vehicaldetails.sharedInstance.TimeOut = timeout


                defaults.set(PersonName, forKey: "firstName")
                defaults.set(Email, forKey: "address")
                defaults.set(PhoneNumber, forKey: "mobile")
                defaults.set(uuid, forKey: "uuid")
                defaults.set(1, forKey: "Register")

                print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)


                
            }
            else if(Message == "fail"){ }

            defaults.set(uuid, forKey: "uuid")
            if(Message == "success") {
                let objUserData = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
                let PreAuthJson = objUserData.value(forKey: "TransactionObj") as! NSArray
                let PreAuthrowCount = PreAuthJson.count
                for i in 0  ..< PreAuthrowCount
                {
                    let PreAuthJsonRow = PreAuthJson[i] as! NSDictionary
                    let MessageTransactionObj = PreAuthJsonRow["ResponceMessage"] as! NSString
//                    let ResponseText = PreAuthJsonRow["ResponceText"] as! NSString
                    if(MessageTransactionObj == "success"){
                let T_Id = PreAuthJsonRow["TransactionId"] as! NSString
                TransactionId.append(T_Id as String)
                    }
                }
                scrollview.isHidden = false
                version.isHidden = true
                warningLable.isHidden = true
                refreshButton.isHidden = true
                preauth.isHidden = true

                self.wifiNameTextField.placeholder = "Touch to select Site"
                self.wifiNameTextField.textColor = UIColor.white
                self.wifiNameTextField.inputView = pickerViewLocation
                self.pickerViewLocation.delegate = self

                do {
//                    locationManager.delegate = self
//                    locationManager.requestWhenInUseAuthorization()
//                    locationManager.desiredAccuracy=kCLLocationAccuracyBest
//                    locationManager.startUpdatingLocation()
//                    currentlocation = locationManager.location
//                                if(currentlocation == nil)
//                                {
//                                    scrollview.isHidden = true
//                                    version.isHidden = false
//                                    warningLable.isHidden = false
//                                    warningLable.text = "Unable to retrieve your location. Please check your GPS and try again."
//                                    refreshButton.isHidden = false
//                                   // viewDidLoad()
//                                }
//                                else {
//                                    sourcelat = currentlocation.coordinate.latitude
//                                    sourcelong = currentlocation.coordinate.longitude
//                                    print (sourcelat,sourcelong)
                                    _ = defaults.string(forKey: "firstName")
                                    _ = defaults.string(forKey: "address")
                                    _ = defaults.string(forKey: "mobile")
                                    _ = defaults.string(forKey: "uuid")

                    //IF USER IF Approved Get information from server like site,ssid,pwd,hose
                    do{
                        systemdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    }catch let error as NSError {
                        print ("Error: \(error.domain)")
                        print ("Error: \(error)")
                    }
                    print(systemdata)
                    ssid = []
                IFISBusy = []
                HoseId = []
                Pass = []
                Is_upgrade = []

                    let Json = systemdata.value(forKey: "SSIDDataObj") as! NSArray
                    let rowCount = Json.count
                    let index: Int = 0
                    for i in 0  ..< rowCount
                    {
                        let JsonRow = Json[i] as! NSDictionary
                        let Message = JsonRow["ResponceMessage"] as! NSString
                        let ResponseText = JsonRow["ResponceText"] as! NSString
                        if(Message == "success") {

                            let JsonRow = Json[i] as! NSDictionary
                            let SiteName = JsonRow["SiteName"] as! NSString
                            location.append(SiteName as String)
                            let ReplaceableHoseName = JsonRow["ReplaceableHoseName"] as! NSString
                            ReplaceableHosename.append(ReplaceableHoseName as String)

                            print(ssid)
                            defaults.set(ssid, forKey: "SSID")
                            defaults.set(siteID, forKey: "SiteID")
                            Ulocation = location.removeDuplicates()

                            if(Ulocation.count == 1)
                            {
                            }
                            if(Ulocation[index] == SiteName as String){
                                let WifiSSId = JsonRow["WifiSSId"] as! NSString
                                let Password = JsonRow["Password"] as! NSString
                                let hosename = JsonRow["HoseNumber"] as! NSString
                                let Sitid = JsonRow["SiteId"] as! NSString
                                let HoseID = JsonRow["HoseId"] as! NSString
                                let IsUpgrade = JsonRow["IsUpgrade"] as! NSString
                                let IsHoseNameReplaced = JsonRow["IsHoseNameReplaced"] as! NSString
                                IsBusy = JsonRow["IsBusy"] as! NSString as String
                                let MacAddress = JsonRow["MacAddress"] as! NSString
                                let PulserTimingAdjust = JsonRow["PulserTimingAdjust"] as! NSString

                                Vehicaldetails.sharedInstance.MacAddress = MacAddress as String
                                Vehicaldetails.sharedInstance.IsHoseNameReplaced = IsHoseNameReplaced as String
                                Vehicaldetails.sharedInstance.HoseID = HoseID as String
                                Vehicaldetails.sharedInstance.IsUpgrade = IsUpgrade as String
                                Vehicaldetails.sharedInstance.PulserTimingAdjust = PulserTimingAdjust as String

                                ssid.append(WifiSSId as String)
                                IFISBusy.append(IsBusy as String)
                                location.append(SiteName as String)
                                Pass.append(Password as String)
                                Uhosenumber.append(hosename as String)
                                siteID.append(Sitid as String)
                                HoseId.append(HoseID as String)
                                Is_upgrade.append(IsUpgrade as String)
                                pulsartimeadjust.append(PulserTimingAdjust as String)
                                print(Uhosenumber)
                            }
                        }
                        else if(Message == "fail")
                        {
                            self.navigationItem.title = "Error"
                            scrollview.isHidden = true
                            version.isHidden = false
                            warningLable.isHidden = false
                            refreshButton.isHidden = false
                            warningLable.text = "\(ResponseText)"//no hose found Please contact administrater"
                        }
                    }

                    if(Uhosenumber.count == 1)
                    {
                        let siteid = siteID[0]
                        let ssId = ssid[0]
                        let hoseid = HoseId[0]
                        let Password = Pass[0]
                        self.wifiNameTextField.text = ssid[0]
                        let isupgrade = Is_upgrade[0]
                        let pulsartime_adjust = pulsartimeadjust[0]
                        Vehicaldetails.sharedInstance.siteID = siteid
                        Vehicaldetails.sharedInstance.SSId = ssId
                        Vehicaldetails.sharedInstance.HoseID = hoseid
                        Vehicaldetails.sharedInstance.password = Password
                        Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
                        Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
                        defaults.set(siteid, forKey: "SiteID")
                    }
                }
           // }
        }
                
            //USER IS NOT REGISTER TO SYSTEM
            else if(ResponseText == "New Registration") {
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                defaults.set(0, forKey: "Register")
                self.web.sentlog(func_name: "Other_screen_timeout")
                // Call a method on the CustomController property of the AppDelegate
                appDel.start()
            }
                
            else if(Message == "fail") {

                defaults.set("false", forKey: "checkApproved")
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                refreshButton.isHidden = false
                self.navigationItem.title = "Error"
                warningLable.text = "Your Registration request is not approved yet. It is marked Inactive in the Company Software. Please contact your company’s administrator."
            } else if(ResponseText == "New Registration") {
                performSegue(withIdentifier: "Register", sender: self)
            }
        }

        if(cf.getSSID() != "" ) {}
        else {}
        self.viewlable.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).cgColor
        let wifiSSid = Vehicaldetails.sharedInstance.SSId//getSSID()
        defaults.set(wifiSSid, forKey: "wifiSSID")
                // Do any additional setup after loading the view, typically from a nib.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM dd, yyyy"
        let strDate = dateFormatter.string(from: NSDate() as Date)
        datetime.text = strDate
        
   }

    func openMapForPlace() {

        let latitude: CLLocationDegrees = currentlocation.coordinate.latitude
        let longitude: CLLocationDegrees = currentlocation.coordinate.longitude

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "MyLocation"
        mapItem.openInMaps(launchOptions: options)
    }

    override func viewWillAppear(_ animated: Bool) {
       
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        if(cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {}
 }

    override func viewDidAppear(_ animated: Bool) {
        if( cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {}
        _ = ad.unsyncTransaction()
        _ = pa.preauthunsyncTransaction()
        //self.locationname.text! = cf.getSSID()
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        // Change Message With Color and Font
        let message  = message
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [ NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Georgia", size: 24.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   // @available(iOS 11.0, *)
    @IBAction func helpButtontapped(_ sender: Any) {

//        let hotspotConfig = NEHotspotConfiguration(ssid: "SalesUnleaded", passphrase: "123456789", isWEP: false)
//
//        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {[unowned self] (error) in
//
//            if let error = error {
//                self.showError(error: error)
//            }
//            else {
//                self.showSuccess()
//            }
//        }
        if(wifiNameTextField.text == ""){
            showAlert(message: "Please select Site & then Proceed.")
        }
        else{
        showAlert(message: "If you are using this hose for the first time you will need to enter the password when redirected to the WiFi screen. The password is \(Vehicaldetails.sharedInstance.password).")

        print("Password is" + "\(Vehicaldetails.sharedInstance.password)")// passwordTextField.text!)
        UIPasteboard.general.string = "\(Vehicaldetails.sharedInstance.password)" //passwordTextField.text!
        print(UIPasteboard.general.string!)
    }
    }
//    private func showError(error: Error) {
//        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Darn", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func showSuccess() {
//        let alert = UIAlertController(title: "", message: "Connected", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Cool", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }

    func tapAction() {

        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }


    @IBAction func goButtontapped(sender: AnyObject) {
            IsGobuttontapped = true
            timer.invalidate()
            if(IsBusy == "Y"){
                        let alert = UIAlertController(title: "Warning", message: NSLocalizedString("", comment:""), preferredStyle: UIAlertControllerStyle.alert )
                        let backView = alert.view.subviews.last?.subviews.last
                        backView?.layer.cornerRadius = 10.0
                        backView?.backgroundColor = UIColor.white
                        var messageMutableString = NSMutableAttributedString()
                        messageMutableString = NSMutableAttributedString(string: "\n Hose In Use \n Please try after sometime" as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 20.0)!])
                        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:"Hose In Use \n Please try after sometime".count))
                        alert.setValue(messageMutableString, forKey: "attributedMessage")

                        let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertActionStyle.default) { action in
                            self.viewDidLoad()
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                      }
                    else if(IsBusy == "N")
                    {
                        if (wifiNameTextField.text == ""){
                                showAlert(message: "Please Select Hose to use.")
                               }
                               else{
                                    let reply = self.web.sendSiteID()
                            if(reply == "-1"){
                               showAlert(message: "Please check your internet connection and try again later.")
                            }else{
                            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
                            do{
                                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            }catch let error as NSError {
                                print ("Error: \(error.domain)")
                            }
                            print(sysdata)
                             let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
                          
                            print(ResponceText)
                            if(ResponceText == "Y"){
                                showAlert(message: "\n Hose In Use \n Please try after sometime")

                            }else if(ResponceText == "Busy"){
                                     print("ssID Match")
                                     self.performSegue(withIdentifier: "GO", sender: self)
                                   }
                            }
                    }
              }
        }

    @IBAction func refreshButtontappd(sender: AnyObject) {
        //web.recordcheck()
        viewDidLoad()
    }

   func numberOfComponentsInPickerView(pickerView: UIPickerView!)-> Int
    {
        if(pickerView == pickerViewLocation)
        {
            return 1
        }
        return 1
    }

    func pickerView(_ pickerView: UIPickerView!,numberOfRowsInComponent component: Int)-> Int
    {
        if(pickerView == pickerViewLocation)
        {
            print(ssid.count)
            return ssid.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int)-> String?
    {
        if(pickerView == pickerViewLocation)
        {
            self.wifiNameTextField.text = ssid[0]
            let siteid = siteID[0]
            let ssId = ssid[0]
            let hoseid = HoseId[0]
            let Password = Pass[0]
            self.wifiNameTextField.text = ssid[0]
            IsBusy = IFISBusy[0]
            let pulsartime_adjust = pulsartimeadjust[0]
            let isupgrade = Is_upgrade[0]
            Vehicaldetails.sharedInstance.siteID = siteid
            Vehicaldetails.sharedInstance.SSId = ssId
            Vehicaldetails.sharedInstance.HoseID = hoseid
            Vehicaldetails.sharedInstance.password = Password
            Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
            Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust

            return ssid[row]
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int, inComponent component: Int)
    {
        var index: Int = 0
        if(pickerView == pickerViewLocation)
        {
            wifiNameTextField.text = ssid[row]
            for v in 0  ..< location.count
            {
                if(ssid[v] == ssid[row])
                {
                    index = v
                    break
                }
            }
            let siteid = siteID[index]
            let ssId = ssid[index]
            let hoseid = HoseId[index]
            let Password = Pass[index]
            self.wifiNameTextField.text = ssid[index]
            IsBusy = IFISBusy[index]
            let pulsartime_adjust = pulsartimeadjust[index]
            let isupgrade = Is_upgrade[index]
            Vehicaldetails.sharedInstance.siteID = siteid
            Vehicaldetails.sharedInstance.SSId = ssId
            Vehicaldetails.sharedInstance.HoseID = hoseid
            Vehicaldetails.sharedInstance.password = Password
            Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
            Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
        print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID)
            defaults.set(siteid, forKey: "SiteID")

            let Json = systemdata.value(forKey: "SSIDDataObj") as! NSArray
            let rowCount = Json.count

            for i in 0  ..< rowCount
            {
                let JsonRow = Json[i] as! NSDictionary
                let SiteName = JsonRow["SiteName"] as! NSString
                if(ssid[index] == SiteName as String){
                    let WifiSSId = JsonRow["WifiSSId"] as! NSString
                    let Password = JsonRow["Password"] as! NSString
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
}



