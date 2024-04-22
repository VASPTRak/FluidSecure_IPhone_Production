//  LoginViewController.swift
//  FuelSecure
//
//  Created by VASP on 1/4/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit
import CoreData
import CoreLocation



///Load the data for login page is on

class LoginViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {

    var web = Webservices()
    var cf = Commanfunction()
       
    var sysdata:NSDictionary!
    var sysdataLog:NSDictionary!
    var sourcelat:Double!
    var sourcelong:Double!
    var currentlocation:CLLocation!
    //let locationManager = CLLocationManager()
  
    var IsOdoMeterRequire:String!
    var IsLoginRequire:String = "False"
    var Email:String!
    var IsDepartmentRequire:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!

    let defaults = UserDefaults.standard
    
    var login = "True"
    var uuid:String = ""
    var groupAdminCompanyListCompanyID = [String]()
    var groupAdminCompanyList = [String]()
//var unsync = Sync_Unsynctransactions()
    
    
    @IBOutlet var version: UILabel!
    @IBOutlet weak var version_2: UILabel!
    @IBOutlet var warning: UILabel!
    @IBOutlet var refresh: UIButton!
    @IBOutlet var mview: UIView!
    @IBOutlet var Loginbutton: UIButton!
    @IBOutlet var PWD: UITextField!
    @IBOutlet var Username: UITextField!
    @IBOutlet weak var preauth: UIButton!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var Companylogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Activity.isHidden = true
        //Save UUID for the device into the keychain Service if it is not saved previously.
        Vehicaldetails.sharedInstance.HubLinkCommunication = ""
//        var uuid:String = ""
        if(brandname == "FluidSecure"){
            if(defaults.string(forKey: "\(brandname)") != nil) {
            uuid = defaults.string(forKey: "\(brandname)")!//UUID().uuidString
            KeychainService.savePassword(token: uuid as NSString)
        }
            
        }
        
        let preuuid = defaults.string(forKey: "uuid")
        if(preuuid == nil || preuuid == ""){
            let password = KeychainService.loadPassword()
                       
            if(password == nil || password == "")
            {
                uuid = UIDevice.current.identifierForVendor!.uuidString
                KeychainService.savePassword(token: uuid as NSString)
            }
            else
            {
                print(password!)//used this paasword (uuid)
                uuid = password! as String
            }
        }
        else
        {
            KeychainService.savePassword(token: preuuid! as NSString)
            let password = KeychainService.loadPassword()
            print(password!,preuuid!)//used this paasword (uuid)
            uuid = preuuid! as String
        }
//        var password = KeychainService.loadPassword()
//        if(password == nil || password == ""){
//            self.web.sentlog(func_name: "keychain service get \(password) ", errorfromserverorlink: "", errorfromapp: "")
//            let preuuid = defaults.string(forKey: "uuid")
//            self.web.sentlog(func_name: "on log in page uuid \(preuuid)", errorfromserverorlink: "", errorfromapp: "")
//            if(preuuid == nil || password == ""){
//                 uuid = UIDevice.current.identifierForVendor!.uuidString
//                KeychainService.savePassword(token: uuid as NSString)
//            }
//            else
//            {
//                KeychainService.savePassword(token: preuuid! as NSString)
//                password = KeychainService.loadPassword()! as NSString
//                print(password!)//used this paasword (uuid)
//                uuid = password! as String
//            }
//        }
//        else{
////            KeychainService.savePassword(token: "0B5C5D0B-70CE-4C75-8844-9E8938586489" as NSString)
//           // password = KeychainService.loadPassword()
//            print(password!)//used this paasword (uuid)
//            uuid = password! as String
//        }

        version.text = "Version \(Version)"
        version_2.text = "Version \(Version)"

//        Vehicaldetails.sharedInstance.URL = "http://fluidsecuretest.eastus.cloudapp.azure.com/"
//        "http://sierravistatest.cloudapp.net/"//appLink as String testing
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
        _ = defaults.array(forKey: "SSID")

//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        currentlocation = locationManager.location
        var reply:String!
        if(IsLoginRequire == "False")
        {
            mview.isHidden = true
            version.isHidden = false
            warning.isHidden = false
            self.warning.text = NSLocalizedString("Pleasewait", comment:"")
            refresh.isHidden = true
        }
        if(currentlocation == nil)
        {
            reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")   // send check approve command if lat long is zero.
            if(reply != "-1"){
                cf.DeleteFileInApp(fileName: "getSites.txt")
                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
            }
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
                   // reply = cf.ReadFile(fileName: "getSites.txt")
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.monospacedSystemFont(ofSize: 20, weight: .black)
            ]
            appearance.largeTitleTextAttributes = attrs
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    self.navigationController?.navigationBar.tintColor = UIColor.white
                    self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    
        

        if(reply == "-1")
        {
            // self.warningLable.text =  "Please wait while your data connection is established.."
            delay(0.1)
             {
                 
             for i in 1...3
             {
                 print(i)
                
                     if(self.currentlocation == nil)
                     {
                         reply = self.web.checkApprove(uuid: self.uuid as String,lat:"\(0)",long:"\(0)")
                     }else{

                         reply = self.web.checkApprove(uuid: self.uuid as String,lat:"\(self.sourcelat!)",long:"\(self.sourcelong!)")
                     }
                 
                 if(reply == "-1")
                 {
                     if(i == 3){
                     self.gotopreauth()
                     }
                 }
                 else
                 {
                     self.viewDidLoad()
                   //  self.getdatauser()
                     break;
                 }
             }
             }
             


        }
//        {
//            preauth.isHidden = false
//            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
//            {
//                self.navigationItem.title = NSLocalizedString("Error",comment:"")
//                mview.isHidden = true
//                version.isHidden = false
//                warning.isHidden = false
//                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
//                refresh.isHidden = false
//            }
//
//            else if(Vehicaldetails.sharedInstance.reachblevia == "cellular") {
//
//                self.navigationItem.title = NSLocalizedString("Error",comment:"")
//
//                mview.isHidden = true
//                version.isHidden = false
//                warning.isHidden = false
//                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
//                refresh.isHidden = false
//
//            }
//
//            else if( Vehicaldetails.sharedInstance.reachblevia == "notreachable"){
//                self.navigationItem.title = NSLocalizedString("Error",comment:"")
//
//                mview.isHidden = true
//                version.isHidden = false
//                warning.isHidden = false
//                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
//                refresh.isHidden = false
//
//                // trying to get connection 2-3 attempts to send check approve command
//
//                for i in 1...2
//                {
//                    print(i)
//                    if(currentlocation == nil)
//                    {
//                        reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
//                    }else{
//
//                        reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
//                    }
//
//                    if(reply == "-1")
//                    {
//                    }
//                    else
//                    {
//                        viewDidLoad()
//                        break;
//                    }
//                }
//            }
//        }
        else {

            let data1:Data = reply.data(using: String.Encoding.utf8)!
            do {
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
           
            if(sysdata == nil){
                self.navigationItem.title = NSLocalizedString("Error",comment:"")
                mview.isHidden = true
                version.isHidden = false
                warning.isHidden = false
                warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                refresh.isHidden = false
            }
            else{
                let Message = sysdata["ResponceMessage"] as! NSString
                
                let ResponseText = sysdata["ResponceText"] as! NSString
                if(Message == "success") {
                
                        mview.isHidden = false
                        version.isHidden = true
                        warning.isHidden = true
                        refresh.isHidden = true
                        Username.text = Email
                    
                    preauth.isHidden = true
                    self.navigationItem.title = "Login"

                    let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
                    Email = objUserData.value(forKey: "Email") as! NSString as String
                    _ = objUserData.value(forKey: "IMEI_UDID") as! NSString
                    _ = objUserData.value(forKey: "IsApproved") as! NSString
                    let PersonName = objUserData.value(forKey: "PersonName") as! NSString
                    let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
                    let CollectDiagnosticLogs = objUserData.value(forKey: "CollectDiagnosticLogs") as! NSString
                    IsOdoMeterRequire = objUserData.value(forKey:"IsOdoMeterRequire") as! NSString as String
                    IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                    IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                    IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                    IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
                    
//                    let IsNonValidateVehicle = objUserData.value(forKey:"IsNonValidateVehicle") as!NSString as String
//                    let IsNonValidateODOM = objUserData.value(forKey: "IsNonValidateODOM") as! NSString as String
//                    defaults.set(IsNonValidateVehicle, forKey: "IsNonValidateVehicle")
//                    defaults.set(IsOdoMeterRequire, forKey: "IsOdoMeterRequire")
//                    defaults.set(IsNonValidateODOM, forKey: "IsNonValidateODOM")
                    
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

                            let url = Bundle.main.url(forAuxiliaryExecutable: imagePAth)// (forResource: "image", withExtension: "png")!
                            let imageData = try! Data(contentsOf: url!)
                           // let _ = UIImage(data: imageData)
                            self.Companylogo.image = UIImage(data: imageData)//UIImage(contentsOfFile: imagePAth)

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
                    
                    let CompanyJson = objUserData.value(forKey: "groupAdminCompanyListObj") as! NSArray
                    let row_Count = CompanyJson.count
                    //let index: Int = 0
                    if(CompanyJson.count > 1)
                    {
                        defaults.set("Company2", forKey: "Companyname")
                    }
                    else
                    {
                        defaults.set("Company1", forKey: "Companyname")
                    }
                    for i in 0  ..< row_Count
                    {
                        let JsonRow = CompanyJson[i] as! NSDictionary
                        let CompanyId = JsonRow["CompanyId"] as! NSString
                        let CompanyName = JsonRow["CompanyName"] as! NSString
                        print(CompanyId,CompanyName)
                        groupAdminCompanyList.append(CompanyName as String)
                        groupAdminCompanyListCompanyID.append(CompanyId as String)
                    }

               //     print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
                    let Json = sysdata.value(forKey: "SSIDDataObj") as! NSArray
                    let rowCount = Json.count
                  //  let index: Int = 0
                    for i in 0  ..< rowCount
                    {
                        let JsonRow = Json[i] as! NSDictionary
                        let Message = JsonRow["ResponceMessage"] as! NSString

                        if(Message == "success")
                        {
                           // let JsonRow = Json[i] as! NSDictionary
                           // let SiteName = JsonRow["SiteName"] as! NSString
                           // location.append(SiteName as String)
                          //  print(ssid)
                          //  defaults.set(siteID, forKey: "SiteID")
                           // Ulocation = location.removeDuplicates()
                         //   print(location.removeDuplicates())

                         //   if(Ulocation[index] == SiteName as String){
//                                let WifiSSId = JsonRow["WifiSSId"] as! NSString
//                                let Password = JsonRow["Password"] as! NSString
//                                let hosename = JsonRow["HoseNumber"] as! NSString
//                                let Sitid = JsonRow["SiteId"] as! NSString

                              //  ssid.append(WifiSSId as String)
                               // location.append(SiteName as String)
                              //  Pass.append(Password as String)
//                                Uhosenumber.append(hosename as String)
//                                siteID.append(Sitid as String)
//                                print(Uhosenumber)
                         //   }
                        }else if(Message == "fail") {
//                            let ResponseText = JsonRow["ResponceText"] as! NSString

                            defaults.set("ssid", forKey: "SSID")
                        }
                    }
                        
                        
                }
                else if(Message == "fail"){
                    if(ResponseText == "New Registration")
                    {
                        self.web.sentlog(func_name: "New Registration from  server UUID \(uuid).,Brand \(brandname)", errorfromserverorlink: "", errorfromapp: "")
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
                        preauth.isHidden = true
                        self.navigationItem.title = "Thank you for registering"
                        warning.text = NSLocalizedString("Regisration", comment:"") + " " +  defaults.string(forKey: "address")! + " " +  NSLocalizedString("registration1", comment:"")
                        defaults.set(1, forKey: "Register")
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
                    print(IsLoginRequire)
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
    
    override func viewDidAppear(_ animated: Bool) {
//        if (login == IsLoginRequire){
//            mview.isHidden = false
//            version.isHidden = true
//            warning.isHidden = true
//            refresh.isHidden = true
//            Username.text = Email
//        }
////        else if (IsLoginRequire == "False"){
////        {
////        mview.isHidden = true
////        version.isHidden = false
////        warning.isHidden = false
////        self.warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
////        refresh.isHidden = true
////        }}
        }
    
    func gotopreauth()
    {
        //self.cf.delay(1){
            let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
            Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
            let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
            self.web.sentlog(func_name: "Starts preAuthTransaction", errorfromserverorlink: "", errorfromapp: "")
        //}
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginButtontapped(sender: AnyObject) {

        Activity.startAnimating()
        Activity.isHidden = false
        cf.delay(1){
            if(self.Username.text == "" || self.PWD.text == "")
        {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                self.showAlert(message:  NSLocalizedString("EnterUserNamePWD",comment:""))
        }
        else
        {
            let replylog = self.web.Login(self.Username.text!, PWD:self.PWD.text!, uuid: self.uuid)

            if(replylog == "-1")
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
                {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    self.mview.isHidden = true
                    self.version.isHidden = false
                    self.warning.isHidden = false
                    self.warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    self.refresh.isHidden = false
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "cellular" ||  Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    self.mview.isHidden = true
                    self.version.isHidden = false
                    self.warning.isHidden = false
                    self.warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    self.refresh.isHidden = false
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable" ||  Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    self.mview.isHidden = true
                    self.version.isHidden = false
                    self.warning.isHidden = false
                    self.warning.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    self.refresh.isHidden = false            }
            }
            else {
                let data1:Data = (replylog.data(using: String.Encoding.utf8)! as NSData) as Data
                do {
                     self.sysdataLog = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
              //  print(sysdataLog)

                let Message =  self.sysdataLog["ResponceMessage"] as! NSString
                let ResponseText =  self.sysdataLog["ResponceText"] as! NSString?
                if(Message == "success") {
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    self.defaults.set(1, forKey: "Login")
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    // Call a method on the CustomController property of the AppDelegate
                    appDel.start()
                }
                else if(Message == "fail"){
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    self.showAlert(message: "\(ResponseText!)")
                }
            }
        }
        }
    }

    @IBAction func preauth(_ sender: AnyObject) {
        Alert(message: "You currently have no cellular service and will be performing an Offline Transaction. After finishing, please leave app open until you regain service.")

    }

    func Alert(message: String)
    {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
        
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            
            self.cf.delay(1){
                let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
                Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
                let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
                self.web.sentlog(func_name: "Starts preAuthTransaction", errorfromserverorlink: "", errorfromapp: "")
            }
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
//        self.unsync.unsyncTransaction()
//        web.unsyncUpgradeTransactionStatus()
        

    }
}
