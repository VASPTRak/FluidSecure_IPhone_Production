//  LoginViewController.swift
//  FuelSecure
//
//  Created by VASP on 1/4/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit
import CoreData
import CoreLocation
import MapKit

class LoginViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {

    var web = Webservices()
    var SSid = ViewController()
    var confs = FuelquantityVC()
    var cf = Commanfunction()
    var sysdata:NSDictionary!
    var systemdata:NSDictionary!
    var sourcelat:Double!
    var sourcelong:Double!
    var locationName:NSString!
    var currentSSID:String!
    var jsonObject:NSDictionary!
    var response:URLResponse?
    var IsOdoMeterRequire:String!
    var IsLoginRequire:String!
    var Email:String!
    var currentlocation:CLLocation!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    var IsDepartmentRequire:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!
    let defaults = UserDefaults.standard
    var pickerViewHose: UIPickerView = UIPickerView()
    var pickerViewLocation: UIPickerView = UIPickerView()
    var ssid = [String]()
    var Pass = [String]()
    var location = [String]()
    var Ulocation = [String]()
    var siteID = [String]()
    var Uhosenumber = [String]()
    var login = "True"
    let uuid:String = UIDevice.current.identifierForVendor!.uuidString

    @IBOutlet var version: UILabel!
    @IBOutlet var warning: UILabel!
    @IBOutlet var refresh: UIButton!
    @IBOutlet var mview: UIView!
    @IBOutlet var Loginbutton: UIButton!
    @IBOutlet var PWD: UITextField!
    @IBOutlet var Username: UITextField!
    @IBOutlet var preauth: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        Vehicaldetails.sharedInstance.deptno = ""
        Vehicaldetails.sharedInstance.Personalpinno = ""
        Vehicaldetails.sharedInstance.Other = ""
        Vehicaldetails.sharedInstance.Odometerno = ""
        Vehicaldetails.sharedInstance.hours = ""
        Username.delegate = self
        PWD.delegate = self

        print(uuid)
        let uid = defaults.array(forKey: "SSID") //stringForKey("SSID")

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        var reply:String!
        //        var error:String!
        //        var data:String!
        if(currentlocation == nil)
        {
            reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
            //            let Split = data.components(separatedBy: "#")
            //            reply = Split[0]
            //            error = Split[1]
        }
        else {
            sourcelat = currentlocation.coordinate.latitude
            sourcelong = currentlocation.coordinate.longitude
            print (sourcelat,sourcelong)
            reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
            //             let Split = data.components(separatedBy: "#")
            //            reply = Split[0]
            if(reply != "-1"){
                cf.DeleteFileInApp(fileName: "getSites.txt")
                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
            }
            else if(reply == "-1"){
                if(cf.checkPath(fileName: "getSites.txt") == true) {
                    reply = cf.ReadFile(fileName: "getSites.txt")
                }
            }
            // error = Split[1]
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        if(reply == "-1")
        {
            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
            {
                self.navigationItem.title = "Error"
                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = "Cannot connect to cloud server. Please check your internet connection."
                refresh.isHidden = false

                cf.delay(0.2){
                    self.viewDidLoad()
                }
            }
            else if(Vehicaldetails.sharedInstance.reachblevia == "cellular") {

                self.navigationItem.title = "Error"
                // showAlert("Cannot connect to cloud server. Please check your internet connection. \n \(error)")
                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = "Cannot connect to cloud server. Please check your internet connection."
                refresh.isHidden = false
                //viewDidLoad()
            }
            else if( Vehicaldetails.sharedInstance.reachblevia == "notreachable"){
                self.navigationItem.title = "Error"
                //showAlert("Cannot connect to cloud server. Please check your internet connection. \n \(error)")
                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = "Cannot connect to cloud server. Please check your internet connection."
                refresh.isHidden = false
                for i in 1...2
                {
                    //
                    print(i)
                    if(currentlocation == nil)
                    {
                        reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
                    }else{

                        reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
                    }
                    //                      let Split = data.components(separatedBy: "#")
                    //                    reply = Split[0]
                    //                    error = Split[1]
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
                let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
                self.navigationItem.title = "Login"
                Email = objUserData.value(forKey: "Email") as! NSString as String
                let IMEI_UDID = objUserData.value(forKey: "IMEI_UDID") as! NSString
                let IsApproved = objUserData.value(forKey: "IsApproved") as! NSString
                let PersonName = objUserData.value(forKey: "PersonName") as! NSString
                let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
                IsOdoMeterRequire = objUserData.value(forKey:"IsOdoMeterRequire") as! NSString as String
                IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String

                defaults.set(PersonName, forKey: "firstName")
                defaults.set(Email, forKey: "address")
                defaults.set(PhoneNumber, forKey: "mobile")
                defaults.set(uuid, forKey: "uuid")
                defaults.set(1, forKey: "Register")

                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire

                print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
                let Json = sysdata.value(forKey: "SSIDDataObj") as! NSArray
                let rowCount = Json.count
                let index: Int = 0
                for i in 0  ..< rowCount
                {
                    let JsonRow = Json[i] as! NSDictionary
                    let Message = JsonRow["ResponceMessage"] as! NSString

                    if(Message == "success") {
                        let JsonRow = Json[i] as! NSDictionary
                        let SiteName = JsonRow["SiteName"] as! NSString
                        location.append(SiteName as String)
                        print(ssid)
                        defaults.set(siteID, forKey: "SiteID")
                        Ulocation = location.removeDuplicates()
                        print(location.removeDuplicates())

                        if(Ulocation[index] == SiteName as String){
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
                    }else if(Message == "fail") {

                        let ResponseText = JsonRow["ResponceText"] as! NSString
                        showMap(message: ResponseText as String)
                        defaults.set("ssid", forKey: "SSID")
                    }
                }
            }
            else if(Message == "fail"){
                if(ResponseText == "New Registration")
                {
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    // Call a method on the CustomController property of the AppDelegate
                    defaults.set(0, forKey: "Register")
                    appDel.start()
                }
                else if(ResponseText == "notapproved")
                {
                    defaults.set("false", forKey: "checkApproved")
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    refresh.isHidden = false
                    self.navigationItem.title = "Error"
                    warning.text = "Your Registration request is not approved yet.  It is marked Inactive in the Company Software.  Please contact your company’s administrator."
                }else
                {
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    refresh.isHidden = false
                    self.navigationItem.title = "Error"
                    warning.text = ResponseText as String
                }
            }
            defaults.set(uuid, forKey: "uuid")
            
            if(Message == "success") {
                print(login)
                print(IsLoginRequire)
                if (login == IsLoginRequire){
                    mview.isHidden = false
                    version.isHidden = true
                    warning.isHidden = true
                    refresh.isHidden = true
                    Username.text = Email
                }
                else{
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    // Call a method on the CustomController property of the AppDelegate
                    appDel.start()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAlert(message: String)
    {
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

    func openMapForPlace() {

        let latitude: CLLocationDegrees = currentlocation.coordinate.latitude
        let longitude: CLLocationDegrees = currentlocation.coordinate.longitude
        let regionDistance:CLLocationDistance = 500
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

    @IBAction func LoginButtontapped(sender: AnyObject) {

        if(Username.text == "" || PWD.text == "")
        {
            showAlert(message: "Please enter Username And Password")
        }
        else
        {
            let reply = web.Login(Username.text!, PWD:PWD.text!, uuid: uuid)
            //            let Split = data.components(separatedBy: "#")
            //            let reply = Split[0]

            if(reply == "-1")
            {
                if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
                {
                    self.navigationItem.title = "Error"
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    warning.text = "Cannot connect to cloud server.Please check your internet connection."
                    refresh.isHidden = false
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "cellular" ||  Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                    self.navigationItem.title = "Error"
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    warning.text = "Cannot connect to cloud server.Please check your internet connection."
                    refresh.isHidden = false
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable" ||  Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                    self.navigationItem.title = "Error"
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    warning.text = "Cannot connect to cloud server.Please check your internet connection."
                    refresh.isHidden = false            }
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
                let ResponseText = sysdata["ResponceText"] as! NSString?
                if(Message == "success") {
                    defaults.set(1, forKey: "Login")
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    // Call a method on the CustomController property of the AppDelegate
                    appDel.start()
                }
                else if(Message == "fail"){ showAlert(message: "\(ResponseText!)")
                }
            }
        }
    }

    @IBAction func preauth(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }

    func wifisettings()
    {
        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared// .shared
        app.openURL(url! as URL)
    }

    func showMap(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            self.openMapForPlace()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlertSetting(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default){ action in //self.//
            self.wifisettings()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mview.endEditing(true)
        return false
    }

    @IBAction func refreshAction(sender: AnyObject) {

        viewDidLoad()
        
    }
}
