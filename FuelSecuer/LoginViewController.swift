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
    var cf = Commanfunction()
    var unsync = Sync_Unsynctransactions()
    
    var sysdata:NSDictionary!
    var sysdataLog:NSDictionary!
    var jsonObject:NSDictionary!

    var sourcelat:Double!
    var sourcelong:Double!
    var currentlocation:CLLocation!
    let locationManager = CLLocationManager()

    var response:URLResponse?

    var IsOdoMeterRequire:String!
    var IsLoginRequire:String!
    var Email:String!
    var IsDepartmentRequire:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!

    let defaults = UserDefaults.standard

    var ssid = [String]()
    var Pass = [String]()
    var location = [String]()
    var Ulocation = [String]()
    var siteID = [String]()
    var Uhosenumber = [String]()

    var login = "True"
    var uuid:String = ""

    @IBOutlet var version: UILabel!
    @IBOutlet var version_2: UILabel!
    @IBOutlet var warning: UILabel!
    @IBOutlet var refresh: UIButton!
    @IBOutlet var mview: UIView!
    @IBOutlet var Loginbutton: UIButton!
    @IBOutlet var PWD: UITextField!
    @IBOutlet var Username: UITextField!
    @IBOutlet var preauth: UIButton!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet var Companylogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Activity.isHidden = true
        //Save UUID for the device into the keychain Service if it is not saved previously.
        let password = KeychainService.loadPassword()
        if(password == nil){
            let UUID = UIDevice.current.identifierForVendor!.uuidString
            KeychainService.savePassword(token: UUID as NSString)
        }
        else{
            let password = KeychainService.loadPassword()
            print(password!)//used this paasword (uuid)
            uuid = password! as String
        }

        version.text = "Version \(Version)"
        version_2.text = "Version \(Version)"

         //   Vehicaldetails.sharedInstance.URL = "http://sierravistatest.cloudapp.net/"//appLink as String testing
        Vehicaldetails.sharedInstance.URL = "https://www.fluidsecure.net/"//appLink as String testing"https://www.fluidsecure.net/"//"https://www.fluidsecure.net/" //Live
        Vehicaldetails.sharedInstance.deptno = ""
        Vehicaldetails.sharedInstance.Personalpinno = ""
        Vehicaldetails.sharedInstance.Other = ""
        Vehicaldetails.sharedInstance.Odometerno = ""
        Vehicaldetails.sharedInstance.hours = ""
        Vehicaldetails.sharedInstance.AppType = "AuthTransaction"
        Username.delegate = self
        PWD.delegate = self

        print(uuid)
        let uid = defaults.array(forKey: "SSID")

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        var reply:String!
        
        if(currentlocation == nil)
        {
            reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
        }
            
        else {
            sourcelat = currentlocation.coordinate.latitude
            sourcelong = currentlocation.coordinate.longitude
            //print (sourcelat,sourcelong)
            reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")

            if(reply != "-1"){
                cf.DeleteFileInApp(fileName: "getSites.txt")
                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
            }
            else if(reply == "-1"){
                if(cf.checkPath(fileName: "getSites.txt") == true) {
                    reply = cf.ReadFile(fileName: "getSites.txt")
                }
            }
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        if(reply == "-1")
        {
            preauth.isHidden = false
            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
            {
                self.navigationItem.title = NSLocalizedString("Error",comment:"")
                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                refresh.isHidden = false

//                cf.delay(0.2){
//
//                }
            }
                
            else if(Vehicaldetails.sharedInstance.reachblevia == "cellular") {

                self.navigationItem.title = NSLocalizedString("Error",comment:"")

                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                refresh.isHidden = false

            }
                
            else if( Vehicaldetails.sharedInstance.reachblevia == "notreachable"){
                self.navigationItem.title = NSLocalizedString("Error",comment:"")

                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                refresh.isHidden = false

                for i in 1...2
                {
                    print(i)
                    if(currentlocation == nil)
                    {
                        reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
                    }else{

                        reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
                    }

                    if(reply == "-1")
                    {
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
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
           // print(sysdata)
            if(sysdata == nil){
                self.navigationItem.title = NSLocalizedString("Error",comment:"")
                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                refresh.isHidden = false
                
//                cf.delay(0.2){
//
//                }
            }
            else{
                let Message = sysdata["ResponceMessage"] as! NSString
                let ResponseText = sysdata["ResponceText"] as! NSString
                if(Message == "success") {
                    preauth.isHidden = true
                    self.navigationItem.title = "Login"

                    let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
                    Email = objUserData.value(forKey: "Email") as! NSString as String
                    let IMEI_UDID = objUserData.value(forKey: "IMEI_UDID") as! NSString
                    let IsApproved = objUserData.value(forKey: "IsApproved") as! NSString
                    let PersonName = objUserData.value(forKey: "PersonName") as! NSString
                    let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
                    let CollectDiagnosticLogs = objUserData.value(forKey: "CollectDiagnosticLogs") as! NSString
                    IsOdoMeterRequire = objUserData.value(forKey:"IsOdoMeterRequire") as! NSString as String
                    IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                    IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                    IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                    IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
                    Vehicaldetails.sharedInstance.SupportPhonenumber = (objUserData.value(forKey: "SupportPhonenumber") as! NSString) as String
                    Vehicaldetails.sharedInstance.SupportEmail = (objUserData.value(forKey: "SupportEmail") as! NSString) as String
                    Vehicaldetails.sharedInstance.CompanyBarndName = (objUserData.value(forKey: "CompanyBrandName") as! NSString) as String
                    Vehicaldetails.sharedInstance.CompanyBrandLogoLink = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
                    let companybrandlogo = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String

                    if(defaults.string(forKey: "companylogolink") == nil)
                    {
                        defaults.set("", forKey: "companylogolink")
                    }
                    print(defaults.string(forKey: "companylogolink")!,Vehicaldetails.sharedInstance.CompanyBrandLogoLink)
                    if(defaults.string(forKey: "companylogolink") != Vehicaldetails.sharedInstance.CompanyBrandLogoLink || defaults.string(forKey: "companylogolink") == "")
                    {
                        defaults.set(companybrandlogo, forKey: "companylogolink")
                        cf.createDirectory()
                        let LogoImage:UIImage = web.downloadCompanylogoImage()
                        cf.saveImageDocumentDirectory(Image: LogoImage)

                        Companylogo.image = LogoImage
                    }
                    else if(defaults.string(forKey: "companylogolink") == Vehicaldetails.sharedInstance.CompanyBrandLogoLink)
                    {   //    Get Image from Document Directory :
                        let fileManager = FileManager.default

                        let imagePAth = (cf.getDirectoryPath() as NSString).appendingPathComponent("logoimage.jpg")

                        if fileManager.fileExists(atPath: imagePAth){

                            self.Companylogo.image = UIImage(contentsOfFile: imagePAth)

                        }else{
                            print("No Image")
                        }
                    }

                    defaults.set(PersonName, forKey: "firstName")
                    defaults.set(Email, forKey: "address")
                    defaults.set(PhoneNumber, forKey: "mobile")
                    defaults.set(uuid, forKey: "uuid")
                    defaults.set(1, forKey: "Register")

                    Vehicaldetails.sharedInstance.CollectDiagnosticLogs = CollectDiagnosticLogs as String
                    Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                    Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                    Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                    Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire

               //     print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
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
                        self.navigationItem.title = NSLocalizedString("Error",comment:"")
                        warning.text = NSLocalizedString("Regisration", comment:"")
                    }else
                    {
                        mview.isHidden = true
                        version.isHidden = false
                        warning.isHidden = false
                        refresh.isHidden = false
                        self.navigationItem.title = NSLocalizedString("Error",comment:"")
                        warning.text = ResponseText as String
                    }
                }
                defaults.set(uuid, forKey: "uuid")

                if(Message == "success") {
                    print(login)
                   // print(IsLoginRequire)
                    if (login == IsLoginRequire){
                        mview.isHidden = false
                        version.isHidden = true
                        warning.isHidden = true
                        refresh.isHidden = true
                        Username.text = Email
                    }
                    else
                    {
                        mview.isHidden = true
                        version.isHidden = false
                        warning.isHidden = false
                        refresh.isHidden = false
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        // Call a method on the CustomController property of the AppDelegate
                        appDel.start()
                    }
                }
            }
        }
        
        if(defaults.string(forKey: "Language") == "es"){
            Bundle.setLanguage("es")
            Vehicaldetails.sharedInstance.Language = "es-ES"
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
        }
        else if(defaults.string(forKey: "Language") == "en"){

            Bundle.setLanguage("en")
            Vehicaldetails.sharedInstance.Language = "en-US"
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginButtontapped(sender: AnyObject) {

        Activity.startAnimating()
        Activity.isHidden = false
        if(Username.text == "" || PWD.text == "")
        {
            Activity.stopAnimating()
            Activity.isHidden = true
            showAlert(message:  NSLocalizedString("EnterUserNamePWD",comment:""))
        }
        else
        {
            let replylog = web.Login(Username.text!, PWD:PWD.text!, uuid: uuid)

            if(replylog == "-1")
            {
                Activity.stopAnimating()
                Activity.isHidden = true
                if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
                {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    refresh.isHidden = false
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "cellular" ||  Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    refresh.isHidden = false
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable" ||  Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    mview.isHidden = true
                    version.isHidden = false
                    warning.isHidden = false
                    warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    refresh.isHidden = false            }
            }
            else {
                let data1:Data = (replylog.data(using: String.Encoding.utf8)! as NSData) as Data
                do {
                    sysdataLog = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
              //  print(sysdataLog)

                let Message = sysdataLog["ResponceMessage"] as! NSString
                let ResponseText = sysdataLog["ResponceText"] as! NSString?
                if(Message == "success") {
                    Activity.stopAnimating()
                    Activity.isHidden = true
                    defaults.set(1, forKey: "Login")
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    // Call a method on the CustomController property of the AppDelegate
                    appDel.start()
                }
                else if(Message == "fail"){
                    Activity.stopAnimating()
                    Activity.isHidden = true
                    showAlert(message: "\(ResponseText!)")
                }
            }
        }
    }

    @IBAction func preauth(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        Activity.stopAnimating()
        Activity.isHidden = true
        self.present(controller, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mview.endEditing(true)
        return false
    }

    @IBAction func refreshAction(sender: AnyObject) {

        viewDidLoad()
//        self.unsync.unsyncTransaction()
//        web.unsyncUpgradeTransactionStatus()
        

    }
}
