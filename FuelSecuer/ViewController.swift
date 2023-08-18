//  ViewController.swift
//  FuelSecuer
//  Created by VASP on 3/28/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation
import CoreBluetooth
import Network
import UIKit
import MapKit
import UserNotifications

//remove duplicates SSID from an Array
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


class ViewController: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,UIPickerViewDelegate,StreamDelegate {
    var web = Webservices()
    var cf = Commanfunction()
    
    var unsync = Sync_Unsynctransactions()
    
    var currentlocation :CLLocation!
    var locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!
    
    let defaults = UserDefaults.standard
    var IsDepartmentRequire:String!
    var IsUseBarcode:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!
    var OtherLabel:String!
    var timeout:String!
    var IsOdoMeterRequire:String!
    var IsVehicleNumberRequire:String!
    var IsLoginRequire:String!
    var IsBusy :String!
    
    var sysdata:NSDictionary!
    var systemdata:NSDictionary!
    
    var pickerViewLocation: UIPickerView = UIPickerView()
    
    var ssid = [String]()
    var preSSID = [String]()
    var OriginalNamesOfLink = [NSArray]()
    var Pass = [String]()
    var location = [String]()
    var ReplaceableHosename = [String]()
    var Ulocation = [String]()
    var siteID = [String]()
    var HoseId = [String]()
    var Is_upgrade = [String]()
    var pulsartimeadjust = [String]()
    var IFISBusy = [String]()
    var Is_HoseNameReplaced = [String]()
    var IFIsDefective = [String]()
    var Uhosenumber = [String]()
    var TransactionId = [String]()
    var TLDCall = [String]()
    var IsTank_Empty = [String]()
    var Is_ResetSwitchTimeBounce = [String]()
    var IsLink_Flagged = [String]()
    var LinkFlagged_Message = [String]()
    var Bluetooth_MacAddress = [String]()
    var Mac_Address = [String]()
    var Communication_Type = [String]()
//    var groupAdminCompanyListCompanyID = [String]()
//    var groupAdminCompanyList = [String]()
    
    var IsGobuttontapped : Bool = false
    var IsrefreshButtontapped : Bool = false
    var now:Date!
    var sentcalltogetdatavehicle = false
    
    var ResponceMessageUpload:String = ""
    var sysdata1:NSDictionary!
    var reply :String!
    
    //BLE
    let kBLEService_UUID = "4c425346-0000-1000-8000-00805f9b34fb"
    let kBLE_Characteristic_uuid_Tx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    let kBLE_Characteristic_uuid_Rx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    
    var ISLocationpermissiongetfromuser = true
    
    var txCharacteristic : CBCharacteristic?
    var rxCharacteristic : CBCharacteristic?
    var blePeripheral : CBPeripheral?
    var characteristicASCIIValue = ""
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    var BLErescount = 0
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var peripheral: CBPeripheral!
    var RSSIs = [NSNumber]()
    var data = NSMutableData()
    var peripherals: [CBPeripheral] = []
    var countfailBLEConn:Int = 0
    //var ifSubscribed = false
    var isdisconnected = false
    var connectedperipheral = ""
    var appdisconnects_automatically = false
    var Last10transaction = ""
    
    @IBOutlet var supportinfo: UILabel!
    @IBOutlet var Activity: UIActivityIndicatorView!
    @IBOutlet var version_2: UILabel!
    @IBOutlet var selectHose: UILabel!
    @IBOutlet var itembarbutton: UIBarButtonItem!
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
    @IBOutlet weak var helpbutton: UIButton!
    @IBOutlet weak var Companynamelabel: UILabel!
    @IBOutlet var wifiNameTextField: UITextField!
    @IBOutlet  var Companylogo: UIImageView!
    
    @IBAction func preAuthentication(sender: AnyObject) {
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
                self.web.sentlog(func_name: "Tapped preAuthTransaction Button", errorfromserverorlink: "", errorfromapp: "")
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkLocationpermission()
    {
        locationManager = CLLocationManager()

        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 14.0, *) {
                switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    ISLocationpermissiongetfromuser = false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    ISLocationpermissiongetfromuser = true
                @unknown default:
                    break
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    //MARK: ViewDidLoad Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Activity.isHidden = true
        Vehicaldetails.sharedInstance.HubLinkCommunication = ""
        version.text = "Version \(Version)"
        version_2.text = "Version \(Version)"
        
        if defaults.value(forKey: "dateof_DownloadVehiclesForphone") != nil {
            //Key exists
//            print(defaults.value(forKey: "dateof_DownloadVehiclesForphone"))
        }
        else
        {
            defaults.set("", forKey: "dateof_DownloadVehiclesForphone")
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        
        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
            itembarbutton.title = "English"
        }else  if(Vehicaldetails.sharedInstance.Language == ""){
            itembarbutton.title = "Spanish"
        }
        
        TransactionId = []
        wifiNameTextField.delegate = self
        self.web.sentlog(func_name: "<ViewdidLoad> select hose page", errorfromserverorlink: "", errorfromapp: "")
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
        Vehicaldetails.sharedInstance.Odometerno = ""
        Vehicaldetails.sharedInstance.hours = ""
        
        getdatauser()
        //check the downloadvehiclesforphone & DownloadPreAuthDepartmentData in mobile device.
        if(defaults.string(forKey: "dateof_DownloadVehiclesForphonefilename") == nil)   {
            _ = web.GetVehiclesForPhone()
            
            sentcalltogetdatavehicle = true
        }
        else{
            if(cf.checkPath(fileName: defaults.string(forKey: "dateof_DownloadVehiclesForphonefilename")!) == true)
            {
                print(defaults.string(forKey: "dateof_DownloadVehiclesForphonefilename")!)
            }
            else{
                //                _ = web.GetVehiclesForPhone()
                _ = web.GetDepartmentsForPhone()
                sentcalltogetdatavehicle = true
            }
        }
        if(defaults.string(forKey: "dateof_DownloadPreAuthDepartmentData") == nil)
        {
            _ = web.GetDepartmentsForPhone()
            sentcalltogetdatavehicle = true
        }
        else
        if(cf.checkPath(fileName: defaults.string(forKey: "dateof_DownloadPreAuthDepartmentData")!) == true)
        {
            print(defaults.string(forKey: "dateof_DownloadPreAuthDepartmentData")!)
        }

        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else {
                print("Please enable \"Notifications\" from App Settings.")
                self?.showPermissionAlert(message:"Notifications are disabled. Please enable it using the app settings option below.") //"Please allow FluidSecure to access Notifications in the app Settings."
                return
            }
            
        }
        checkLocationpermission()
        }
//    }
    
    func showPermissionAlert(message:String) {
        let alert = UIAlertController(title: "WARNING", message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    private func gotoAppSettings() {

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)//UIApplication.shared.openURL(settingsUrl)
        }
    }

    
    func GotoSettingpage(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!])
        
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func gotopreauth()
    {
        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        self.web.sentlog(func_name: "Tapped preAuthTransaction Button", errorfromserverorlink: "", errorfromapp: "")
    }
    
    
    func getdatauser()
    {
        var uuid:String = ""
//        if(brandname == "FluidSecure"){
//
//            if(defaults.string(forKey: "\(brandname)") != nil) {
//                uuid = defaults.string(forKey: "\(brandname)")!//UUID().uuidString
//                KeychainService.savePassword(token: uuid as NSString)
//            }
//        }
//        print(defaults.string(forKey: "Register"))
//        var password = KeychainService.loadPassword()
//        if(password == nil || password == "")
//        {
//            self.web.sentlog(func_name: "keychain service get \(password) ", errorfromserverorlink: "", errorfromapp: "")
            let preuuid = defaults.string(forKey: "uuid")
            if(preuuid == nil){
               var password = KeychainService.loadPassword()
                           
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
                var password = KeychainService.loadPassword()
                print(password!)//used this paasword (uuid)
                uuid = preuuid! as String
            }

            var myMutableStringTitle = NSMutableAttributedString()
            let Name = "Select Hose to Use"// PlaceHolderText
            myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 25.0)!]) // Font
            myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
            wifiNameTextField.attributedPlaceholder = myMutableStringTitle
            _ = defaults.array(forKey: "SSID")
            var reply:String!
            
            //Server call to Check User approved or not.
            if(currentlocation == nil)
            {
                if( self.IsGobuttontapped == true || self.IsrefreshButtontapped == true){
                    reply =  web.checkApprove(uuid: uuid as String,lat:"\(0)",long:"\(0)")
                }
                else{
                    
                }
               
            }
            else
            {
                sourcelat = currentlocation.coordinate.latitude
                sourcelong = currentlocation.coordinate.longitude
                print (sourcelat!,sourcelong!)
                Vehicaldetails.sharedInstance.Lat = sourcelat!
                Vehicaldetails.sharedInstance.Long = sourcelong!
                if( self.IsGobuttontapped == true || self.IsrefreshButtontapped == true){
                    reply = web.checkApprove(uuid: uuid as String,lat:"\(sourcelat!)",long:"\(sourcelong!)")
                    if(reply != "-1"){
                        cf.DeleteFileInApp(fileName: "getSites.txt")
                        cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
                    }
                }
                else
                {
                    if(cf.checkPath(fileName: "getSites.txt") == true) {
                        reply = cf.ReadFile(fileName: "getSites.txt")
                    }
                }
                
            }
            
            
            if(reply == "-1")
            {
                self.warningLable.text =  "Please wait while your data connection is established.."
                delay(2)
                {
                    for i in 1...3
                    {
                        print(i)

                        if(self.currentlocation == nil)
                        {
                            reply = self.web.checkApprove(uuid: uuid as String,lat:"\(0)",long:"\(0)")
                        }else{

                            reply = self.web.checkApprove(uuid: uuid as String,lat:"\(self.sourcelat!)",long:"\(self.sourcelong!)")
                        }

                        if(reply == "-1")
                        {
                            if(i == 3){
                                self.gotopreauth()
                            }
                        }
                        else
                        {
                            self.getdatauser()
                            break;
                        }
                    }
                }
            }
            else {
                if(cf.checkPath(fileName: "getSites.txt") == true) {
                    reply = cf.ReadFile(fileName: "getSites.txt")
                }
                let data1:Data = reply.data(using: String.Encoding.utf8)!
                do {
                    sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    
                    print ("Error: \(error.domain)")
                }

                if(sysdata == nil){
                }
                else{
                    let Message = sysdata["ResponceMessage"] as! NSString
                    let ResponseText = sysdata["ResponceText"] as! NSString
                    if(Message == "success") {
                        
                        let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
                        let CompanyName = objUserData.value(forKey: "CompanyName") as! NSString
                        let Email = objUserData.value(forKey: "Email") as! NSString
                        let IMEI_UDID = objUserData.value(forKey: "IMEI_UDID") as! NSString
                        let IsApproved = objUserData.value(forKey: "IsApproved") as! NSString
                        let PersonName = objUserData.value(forKey: "PersonName") as! NSString
                        let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
                        let CollectDiagnosticLogs = objUserData.value(forKey: "CollectDiagnosticLogs") as! NSString
                        IsVehicleNumberRequire = objUserData.value(forKey: "IsVehicleNumberRequire") as! NSString as String
                        let ScreenNameForHours = objUserData.value(forKey: "ScreenNameForHours") as! String
                        let ScreenNameForOdometer = objUserData.value(forKey: "ScreenNameForOdometer") as! String
                        let ScreenNameForPersonnel = objUserData.value(forKey: "ScreenNameForPersonnel") as! String
                        let ScreenNameForVehicle = objUserData.value(forKey: "ScreenNameForVehicle") as! String
                        let ScreenNameForDepartment = objUserData.value(forKey: "ScreenNameForDepartment") as! String
                        let TopicNameForFCMFor_IPhone = objUserData.value(forKey: "TopicNameForFCMForIPhone") as! String
                        defaults.set(TopicNameForFCMFor_IPhone, forKey: "TopicNameForFCMForIPhone")
                        
                        Vehicaldetails.sharedInstance.ScreenNameForVehicle = ScreenNameForVehicle
                        Vehicaldetails.sharedInstance.ScreenNameForPersonnel = ScreenNameForPersonnel
                        Vehicaldetails.sharedInstance.ScreenNameForHours = ScreenNameForHours
                        Vehicaldetails.sharedInstance.ScreenNameForOdometer = ScreenNameForOdometer
                        Vehicaldetails.sharedInstance.ScreenNameForDepartment = ScreenNameForDepartment
                        
                        IsOdoMeterRequire = objUserData.value(forKey: "IsOdoMeterRequire") as! NSString as String
                        IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                        IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                        IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                        IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
                        OtherLabel = objUserData.value(forKey:"OtherLabel") as!NSString as String
                        timeout = objUserData.value(forKey:"TimeOut") as!NSString as String
                        IsUseBarcode = objUserData.value(forKey: "UseBarcode") as! NSString as String
                        Vehicaldetails.sharedInstance.CompanyBarndName = (objUserData.value(forKey: "CompanyBrandName") as! NSString) as String
                        
                        Vehicaldetails.sharedInstance.CompanyBrandLogoLink = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
                        
                        let IsNonValidateVehicle = objUserData.value(forKey:"IsNonValidateVehicle") as!NSString as String
                        let IsNonValidateODOM = objUserData.value(forKey: "IsNonValidateODOM") as! NSString as String
                        defaults.set(IsNonValidateVehicle, forKey: "IsNonValidateVehicle")
                        defaults.set(IsOdoMeterRequire, forKey: "IsOdoMeterRequire")
                        defaults.set(IsNonValidateODOM, forKey: "IsNonValidateODOM")
                        
                        Vehicaldetails.sharedInstance.IsVehicleNumberRequire = IsVehicleNumberRequire
                        self.navigationItem.title = Vehicaldetails.sharedInstance.CompanyBarndName
                        
                        
                        if(IsVehicleNumberRequire == "False")
                        {
                            Vehicaldetails.sharedInstance.vehicleno = ""
                            Vehicaldetails.sharedInstance.Odometerno = "0"
                        }
                        else if(IsVehicleNumberRequire == "True"){
                            
                        }
                        
                        infotext.text =  NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") +  ": \(Email) \n"
                        
                        Companynamelabel.text = NSLocalizedString("Company Name", comment:"") + ": \(CompanyName)"
                        Companynamelabel.lineBreakMode = .byWordWrapping
                        infotext.lineBreakMode = .byWordWrapping
                        
                        
                        Vehicaldetails.sharedInstance.CollectDiagnosticLogs = CollectDiagnosticLogs as String
                        Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                        Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                        Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                        Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
                        Vehicaldetails.sharedInstance.Otherlable = OtherLabel
                        Vehicaldetails.sharedInstance.TimeOut = timeout
                        Vehicaldetails.sharedInstance.IsUseBarcode = IsUseBarcode
                        
                        defaults.set(PersonName, forKey: "firstName")
                        defaults.set(Email, forKey: "address")
                        defaults.set(PhoneNumber, forKey: "mobile")
                        defaults.set(uuid, forKey: "uuid")
                        defaults.set(1, forKey: "Register")
                        Vehicaldetails.sharedInstance.AppType = "AuthTransaction"
                        print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
                        web.sentlog(func_name: "Name : \(PersonName)", errorfromserverorlink: "Company : \(CompanyName)", errorfromapp: "Email : \(Email)")
                        
                        Vehicaldetails.sharedInstance.SupportPhonenumber = (objUserData.value(forKey: "SupportPhonenumber") as! NSString) as String
                        Vehicaldetails.sharedInstance.SupportEmail = (objUserData.value(forKey: "SupportEmail") as! NSString) as String
                        
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
                            weak var LogoImage:UIImage? = web.downloadCompanylogoImage()
                            cf.saveImageDocumentDirectory(Image: LogoImage!)
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
                    }
                    
                    else if(Message == "fail")
                    {
                        
                    }
                    
                    defaults.set(uuid, forKey: "uuid")
                    if(Message == "success") {
                        
                        scrollview.isHidden = false
                        version.isHidden = true
                        warningLable.isHidden = true
                        refreshButton.isHidden = true
                        preauth.isHidden = true
                        
                        supportinfo.text = "\(Vehicaldetails.sharedInstance.SupportEmail) or " + "\(Vehicaldetails.sharedInstance.SupportPhonenumber)"
                        self.wifiNameTextField.placeholder = NSLocalizedString("Select Hose to Use", comment:"")
                        
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
                                systemdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            }catch let error as NSError {
                                print ("Error: \(error.domain)")
                                print ("Error: \(error)")
                            }
                            // print(systemdata)
                            ssid = []
                            preSSID = []
                            OriginalNamesOfLink = []
                            Pass = []
                            location = []
                            ReplaceableHosename = []
                            siteID = []
                            HoseId = []
                            Is_upgrade = []
                            pulsartimeadjust = []
                            IFISBusy = []
                            Is_HoseNameReplaced = []
                            IFIsDefective = []
                            Uhosenumber = []
                            TLDCall = []
                            IsTank_Empty = []
                            Is_ResetSwitchTimeBounce = []
                            IsLink_Flagged = []
                            LinkFlagged_Message = []
                            Bluetooth_MacAddress = []
                            Mac_Address = []
                            Communication_Type = []
                            
                            
                            defaults.removeObject(forKey: "SSID")
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
                                    
                                    if(Ulocation[index] == SiteName as String){
                                        let WifiSSId = JsonRow["WifiSSId"] as! NSString
                                        let PrevWifiSSId = JsonRow["PrevWifiSSId"] as! NSString
                                        let Password = JsonRow["Password"] as! NSString
                                        let hosename = JsonRow["HoseNumber"] as! NSString
                                        //                                               let PrevWifiSSId = JsonRow["PrevWifiSSId"] as! NSString
                                        let Sitid = JsonRow["SiteId"] as! NSString
                                        let HoseID = JsonRow["HoseId"] as! NSString
                                        let IsUpgrade = JsonRow["IsUpgrade"] as! NSString
                                        let IsHoseNameReplaced = JsonRow["IsHoseNameReplaced"] as! NSString
                                        IsBusy = JsonRow["IsBusy"] as! NSString as String
                                        
                                        let IsTankEmpty = JsonRow["IsTankEmpty"] as! NSString as String
                                        //                                        let MacAddress = JsonRow["MacAddress"] as! NSString
                                        let PulserTimingAdjust = JsonRow["PulserTimingAdjust"] as! NSString
                                        let IsDefective = JsonRow["IsDefective"] as!NSString
                                        let IsTLDCall = JsonRow["IsTLDCall"] as! NSString
                                        let IsLinkFlagged = JsonRow["IsLinkFlagged"] as! NSString  as String
                                        let LinkFlaggedMessage =  JsonRow["LinkFlaggedMessage"] as! NSString as String
                                        let MacAddress = JsonRow["MacAddress"] as! NSString as String
                                        let BluetoothMacAddress = JsonRow["BluetoothMacAddress"] as! NSString as String
                                        let HubLinkCommunication = JsonRow["HubLinkCommunication"] as! NSString
                                        Communication_Type.append(HubLinkCommunication as String)
                                        let IsResetSwitchTimeBounce = JsonRow["IsResetSwitchTimeBounce"] as! NSNumber
                                        let Original_NamesOfLink = JsonRow["OriginalNamesOfLink"] as! NSArray
                                        
                                        ssid.append(WifiSSId as String)
                                        preSSID.append(PrevWifiSSId as String)
                                        OriginalNamesOfLink.append(Original_NamesOfLink as NSArray )
                                        IFISBusy.append(IsBusy as String)
                                        location.append(SiteName as String)
                                        Pass.append(Password as String)
                                        Uhosenumber.append(hosename as String)
                                        siteID.append(Sitid as String)
                                        HoseId.append(HoseID as String)
                                        Is_upgrade.append(IsUpgrade as String)
                                        IFIsDefective.append(IsDefective as String)
                                        pulsartimeadjust.append(PulserTimingAdjust as String)
                                        Is_HoseNameReplaced.append(IsHoseNameReplaced as String)
                                        TLDCall.append(IsTLDCall as String)
                                        IsTank_Empty.append(IsTankEmpty as String)
                                        IsLink_Flagged.append(IsLinkFlagged as String)
                                        LinkFlagged_Message.append(LinkFlaggedMessage as String)
                                        Bluetooth_MacAddress.append(BluetoothMacAddress as String)
                                        Mac_Address.append(MacAddress as String)
                                        Is_ResetSwitchTimeBounce.append("\(IsResetSwitchTimeBounce)")
                                        print(Uhosenumber)
                                    }
                                    
                                    
                                    let objUserData = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
                                    
                                    //get Fuel limit per day from server
                                    let FuelLimitPerDay = objUserData.value(forKey: "FuelLimitPerDay") as! NSString
                                    let FuelLimitPerTxn = objUserData.value(forKey:"FuelLimitPerTxn") as! NSString
                                    let PreAuthDataDwnldFreq = objUserData.value(forKey: "PreAuthDataDwnldFreq") as! NSString
                                    let PreAuthDataDownloadDay = objUserData.value(forKey:"PreAuthDataDownloadDay") as! NSString
                                    let PreAuthDataDownloadTimeInHrs = objUserData.value(forKey: "PreAuthDataDownloadTimeInHrs") as! NSString
                                    let PreAuthDataDownloadTimeInMin = objUserData.value(forKey:"PreAuthDataDownloadTimeInMin") as! NSString
                                    let PreAuthVehicleDataFilePath = objUserData.value(forKey: "PreAuthVehicleDataFilePath") as! NSString as String
                                    let PreAuthDepartmentDataFilePath = objUserData.value(forKey: "PreAuthDepartmentDataFilePath") as! NSString as String
                                    let PreAuthVehicleDataFilesCount = objUserData.value(forKey:"PreAuthVehicleDataFilesCount") as! NSString
                                    print()
                                    let DoNotAllowOfflinePreauthorizedTransactions = objUserData.value(forKey: "DoNotAllowOfflinePreauthorizedTransactions") as! NSString
                                    
                                    Vehicaldetails.sharedInstance.DoNotAllowOfflinePreauthorizedTransactions = DoNotAllowOfflinePreauthorizedTransactions as String
                                    // Vehicaldetails.sharedInstance.PreAuthDataDwnldFreq = PreAuthDataDwnldFreq as String
                                    // Vehicaldetails.sharedInstance.PreAuthDataDownloadDay = PreAuthDataDownloadDay as String
                                    Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath = PreAuthVehicleDataFilePath.trimmingCharacters(in: .whitespacesAndNewlines)
                                    Vehicaldetails.sharedInstance.PreAuthDepartmentDataFilePath = PreAuthDepartmentDataFilePath.trimmingCharacters(in: .whitespacesAndNewlines)
                                    // Vehicaldetails.sharedInstance.PreAuthDataDownloadTimeInMin = PreAuthDataDownloadTimeInMin as String
                                    // Vehicaldetails.sharedInstance.PreAuthDataDownloadTimeInHrs = PreAuthDataDownloadTimeInHrs as String
                                    Vehicaldetails.sharedInstance.PreAuthVehicleDataFilesCount = PreAuthVehicleDataFilesCount as String
                                    
                                    var datadownloadday = ""
                                    switch PreAuthDataDownloadDay {
                                    case "1":
                                        print("Sunday")
                                        datadownloadday = "Sunday"
                                    case "2":
                                        print("Monday")
                                        datadownloadday = "Monday"
                                    case "3":
                                        print("Tuesday")
                                        datadownloadday = "Tuesday"
                                    case "4":
                                        print("Wednesday")
                                        datadownloadday = "Wednesday"
                                    case "5":
                                        print("Thursday")
                                        datadownloadday = "Thursday"
                                    case "6":
                                        print("Friday")
                                        datadownloadday = "Friday"
                                    case "7":
                                        print("Saturday")
                                        datadownloadday = "Saturday"
                                    default:
                                        print("Invalid day")
                                        datadownloadday = "Invalid day"
                                    }
                                    
                                    
                                    let PreAuthJson = objUserData.value(forKey: "TransactionObj") as! NSArray
                                    let PreAuthrowCount = PreAuthJson.count
                                    if(PreAuthrowCount > 0 )
                                    {
                                        
                                        if(sentcalltogetdatavehicle == true){}
                                        else{
                                            if(Vehicaldetails.sharedInstance.DoNotAllowOfflinePreauthorizedTransactions == "False"){
                                                if(PreAuthDataDwnldFreq == "Weekly")//
                                                {
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "EEEE"
                                                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                                                    let todayname: String = dateFormatter.string(from: NSDate() as Date)
                                                    
                                                    let date_Formatter = DateFormatter()
                                                    date_Formatter.dateFormat = "EEEE,dd/MM/yyyy"
                                                    date_Formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                                                    let todaydate: String = date_Formatter.string(from: NSDate() as Date)
                                                    
                                                    print(defaults.string(forKey: "dateof_DownloadVehiclesForphone")!)
                                                    if(todaydate == defaults.string(forKey: "dateof_DownloadVehiclesForphone")!)
                                                    {
                                                        print(defaults.string(forKey: "dateof_DownloadVehiclesForphone"))
                                                    }
                                                    else{
                                                        if((defaults.string(forKey: "dateof_DownloadVehiclesForphone")?.contains(todayname)) != nil)
                                                        {
                                                            
                                                            _ = web.GetVehiclesForPhone()
                                                            _ = web.GetDepartmentsForPhone()
                                                            sentcalltogetdatavehicle = true
                                                        }
                                                    }
                                                }
                                                else if(PreAuthDataDwnldFreq == "Daily")
                                                {
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "dd/mm/yyy"
                                                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                                                    let todayname: String = dateFormatter.string(from: NSDate() as Date)
                                                    if((defaults.string(forKey: "dateof_DownloadVehiclesForphone")?.contains(todayname)) != nil)
                                                    {}
                                                    else{
                                                        
                                                        
                                                        _ = web.GetVehiclesForPhone()
                                                        _ = web.GetDepartmentsForPhone()
                                                        sentcalltogetdatavehicle = true
                                                    }
                                                }
                                                
                                                //                                            print(data)
                                            }
                                        }
                                    }
                                    
                                    for i in 0  ..< PreAuthrowCount
                                    {
                                        let PreAuthJsonRow = PreAuthJson[i] as! NSDictionary
                                        let MessageTransactionObj = PreAuthJsonRow["ResponceMessage"] as! NSString
                                        
                                        if(MessageTransactionObj == "success"){
                                            let T_Id = PreAuthJsonRow["TransactionId"] as! NSString
                                            TransactionId.append(T_Id as String)
                                        }
                                    }
                                }
                                else if(Message == "fail")
                                {
                                    self.navigationItem.title = NSLocalizedString("FluidSecure",comment:"")//"Error"
                                    scrollview.isHidden = false
                                    viewlable.isHidden = true
                                    go.isHidden = true
                                    Companylogo.isHidden = true
                                    datetime.isHidden = true
                                    version_2.isHidden = true
                                    // helpbutton.isHidden = true
                                    version.isHidden = false
                                    supportinfo.isHidden = true
                                    warningLable.isHidden = false
                                    //refreshButton.isHidden = false
                                    warningLable.text = "\(ResponseText)"//no hose found Please contact administrater"
                                }
                            }
                            
                            if(Uhosenumber.count == 1)
                            {
                                let siteid = siteID[0]
                                
                                let ssId = ssid[0]
                                let pressid = preSSID[0]
                                let Original_NamesOfLink = OriginalNamesOfLink[0]
                                let hoseid = HoseId[0]
                                let Password = Pass[0]
                                self.wifiNameTextField.text = ssid[0]
                                let isupgrade = Is_upgrade[0]
                                let pulsartime_adjust = pulsartimeadjust[0]
                                Vehicaldetails.sharedInstance.siteID = siteid;               Vehicaldetails.sharedInstance.prevSSID = pressid
                                Vehicaldetails.sharedInstance.OriginalNamesOfLink = Original_NamesOfLink as! NSMutableArray
                                Vehicaldetails.sharedInstance.SSId = ssId
                                Vehicaldetails.sharedInstance.HoseID = hoseid
                                Vehicaldetails.sharedInstance.password = Password
                                Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
                                Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
                                Vehicaldetails.sharedInstance.IsBusy = IsBusy
                                Vehicaldetails.sharedInstance.IsDefective = IFIsDefective[0]
                                Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[0]
                                Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[0]
                                Vehicaldetails.sharedInstance.IsLinkFlagged = IsLink_Flagged[0]
                                Vehicaldetails.sharedInstance.LinkFlaggedMessage = LinkFlagged_Message[0]
                                Vehicaldetails.sharedInstance.MacAddress = Mac_Address[0]
                                Vehicaldetails.sharedInstance.BTMacAddress = Bluetooth_MacAddress[0]
                                Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce = Is_ResetSwitchTimeBounce[0]
                                print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced,Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce,Vehicaldetails.sharedInstance.OriginalNamesOfLink)
                                
                                
                                delay(0.2){
                                    if( self.IsGobuttontapped == true){
                                        
                                    }
                                    else{
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    //USER IS NOT REGISTER TO SYSTEM
//                    else if(ResponseText == "New Registration") {
//                        let appDel = UIApplication.shared.delegate! as! AppDelegate
//                        defaults.set(0, forKey: "Register")
//                        self.web.sentlog(func_name: "New Registration", errorfromserverorlink: "", errorfromapp: "")
//                        // Call a method on the CustomController property of the AppDelegate
//                        appDel.start()
//                    }
                    
                    else if(Message == "fail") {
                        
                        if(ResponseText == "New Registration")
                        {
                            let appDel = UIApplication.shared.delegate! as! AppDelegate
                            // Call a method on the CustomController property of the AppDelegate
                            defaults.set(0, forKey: "Register")
                            appDel.start()
                        }
                        else
                        if(ResponseText == "notapproved")
                        {
                            defaults.set("false", forKey: "checkApproved")
                            scrollview.isHidden = true
                            version.isHidden = false
                            warningLable.isHidden = false
                            //refreshButton.isHidden = false
                            preauth.isHidden = true
                            self.navigationItem.title = "Thank you for registering"
                            warningLable.text = NSLocalizedString("Regisration", comment:"")
                            //+ " " +  defaults.string(forKey: "address")! + " " +  NSLocalizedString("registration1", comment:"")
                        }else
                        {
                            scrollview.isHidden = true
                            version.isHidden = false
                            warningLable.isHidden = false
                            //refreshButton.isHidden = false
                            self.navigationItem.title = NSLocalizedString("Error",comment:"")
                            warningLable.text = ResponseText as String
                        }
                        
                        //                        defaults.set("false", forKey: "checkApproved")
                        //                        scrollview.isHidden = true
                        //                        version.isHidden = false
                        //                        warningLable.isHidden = false
                        //                        refreshButton.isHidden = false
                        //                        self.navigationItem.title = NSLocalizedString("Error",comment:"")
                        //                        warningLable.text = NSLocalizedString("Regisration", comment:"")
                        //                    } else if(ResponseText == "New Registration") {
                        //                        performSegue(withIdentifier: "Register", sender: self)
                    }
                }
            }
            
            //                   if(getSSID() != "" ) {}
            //                   else {}
            self.viewlable.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).cgColor
            let wifiSSid = Vehicaldetails.sharedInstance.SSId
            defaults.set(wifiSSid, forKey: "wifiSSID")
            // Do any additional setup after loading the view, typically from a nib.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm MMM dd, yyyy"
            let strDate = dateFormatter.string(from: NSDate() as Date)
            datetime.text = strDate
            //                   selectHose.text = NSLocalizedString("selectHose", comment:"")
        
        
        //            if(Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath == nil || Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath == "")
        //            {
        //                Vehicaldetails.sharedInstance.PreAuthVehicleDataFilename = "vehicledata_1.txt"
        //            }
        //            else{
        //                let newString = Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath.replacingOccurrences(of: " " , with: "%20", options: .literal, range: nil)
        //                print(newString)
        //                print(Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath)
        //
        //                let url = URL(string: newString)!
        //                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //                let filename = url.lastPathComponent
        //                Vehicaldetails.sharedInstance.PreAuthVehicleDataFilename = filename
        //            }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        go.isEnabled = true
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
        
        
        
        if(self.cf.getSSID() != "" ) {
            print("SSID: \(self.cf.getSSID())")
        } else {}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if( self.cf.getSSID() != "" ) {
            print("SSID: \(self.cf.getSSID())")
            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT"){}
            else{}
         
        } else {}
        unsync.unsyncTransaction()   ///check
        unsync.unsyncP_typestatus()
        self.unsync.Send10trans()
       _ = self.preauthunsyncTransaction()
        
        if(Vehicaldetails.sharedInstance.Warningunsync_transaction == "True"){
            
            warningLable.text =  "Cannot connect to cloud server." + "\n" + "Please make sure your internet connection is ON as app needs to send your completed transaction to the server."
        }
        else if(Vehicaldetails.sharedInstance.Warningunsync_transaction == "Flase")
        {
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let strDate = dateFormatter.string(from: NSDate() as Date)
        print(strDate)
        if(defaults.string(forKey:"Date") == nil){
            cf.showUpdateWithForce()
            defaults.set(strDate,forKey: "Date")
            now = Date()
        }else{
            print(defaults.string(forKey:"Date")!)
            let savedate = defaults.string(forKey:"Date")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            //print(now)
            
            let currentdate = (dateFormatter.date(from: savedate!))//NSDate()
            let x = 2
            let calendar = Calendar.current// NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let dateComponent = NSDateComponents()
            
            dateComponent.day = x
            if(currentdate == nil){}
            else{
                now = (calendar.date(byAdding: dateComponent as DateComponents, to: currentdate!))! as Date// (byAdding: dateComponent as DateComponents, to: currentdate! , options:[])! as NSDate) as Date
            }
        }
        
        delay(1){
            let soon = Date()
//            print(self.now!,soon)
            if(self.now! < soon){
                self.cf.showUpdateWithForce()
                self.defaults.set("\(soon)",forKey: "Date")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func helpButtontapped(_ sender: Any) {
        
        if(wifiNameTextField.text == ""){
            showAlert(message:NSLocalizedString("HelptextSelectedSite", comment:""))
        }
        else{
            showAlert(message: NSLocalizedString("Helptext", comment:"") +  "\(Vehicaldetails.sharedInstance.password).")
            
            print("Password is" + "\(Vehicaldetails.sharedInstance.password)")
            UIPasteboard.general.string = "\(Vehicaldetails.sharedInstance.password)"
            print(UIPasteboard.general.string!)
        }
    }
    
    @objc func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }
    
    @IBAction func spanish(_ sender: Any) {
        if(itembarbutton.title == "English"){
            Vehicaldetails.sharedInstance.Language = ""
            Bundle.setLanguage("en")
            defaults.set("en", forKey: "Language")
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
        }else if(itembarbutton.title == "Spanish"){
            Bundle.setLanguage("es")
            defaults.set("es", forKey: "Language")
            Vehicaldetails.sharedInstance.Language = "es-ES"
            
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GO")
        {
            if let vc = segue.destination as? VehiclenoVC {
                vc.IsUseBarcode = IsUseBarcode
            }
        }
        
        if(segue.identifier == "other")
        {
            if let vc = segue.destination as? OtherViewController {
                vc.otherlbl = OtherLabel
            }
        }
    }
    
    //MARK:Go Button tapped
    @IBAction func goButtontapped(sender: AnyObject) {
        checkLocationpermission()
        unsync.unsyncTransaction()
        unsync.unsyncP_typestatus()
        self.unsync.Send10trans()
        _ = preauthunsyncTransaction()
        
        self.Activity.startAnimating()
        self.Activity.isHidden = false
        self.go.isEnabled = false
        Vehicaldetails.sharedInstance.Barcodescanvalue = ""
        Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
        delay(0.1){
            if(self.ISLocationpermissiongetfromuser == true){
                self.go.isEnabled = false
                if(self.wifiNameTextField.text == ""){
                    self.showAlert(message: NSLocalizedString("NoHoseselect", comment:""))
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    self.go.isEnabled = true
                }
                else{
                    self.web.sentlog(func_name: "Selected hose \(Vehicaldetails.sharedInstance.SSId)", errorfromserverorlink: "", errorfromapp: "")
                    //#1594
                    if(Vehicaldetails.sharedInstance.IsLinkFlagged == "True")
                    {
                        self.showAlert(message: "\(Vehicaldetails.sharedInstance.LinkFlaggedMessage)")
                    }
                    else{
                        print("SSID: \(self.cf.getSSID())", self.wifiNameTextField.text!)
                        if(self.cf.getSSID() != "" && self.wifiNameTextField.text != self.cf.getSSID() && Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP") {
                            print("SSID: \(self.cf.getSSID())")
                            self.showAlert(message:NSLocalizedString("SwitchoffyourWiFi", comment:""))
                            
                            self.Activity.stopAnimating()
                            self.Activity.isHidden = true
                            self.go.isEnabled = true
                        }
                        else{
                            if(self.wifiNameTextField.text != "") {
                                print(Vehicaldetails.sharedInstance.IsBusy)
                                self.IsGobuttontapped = true
                                
                                self.getdatauser()
                                for id in 0  ..< self.ssid.count {
                                    if(self.wifiNameTextField.text == self.ssid[id])
                                    {
                                        Vehicaldetails.sharedInstance.IsBusy = self.IFISBusy[id]
                                        Vehicaldetails.sharedInstance.IsDefective = self.IFIsDefective[id]
                                        Vehicaldetails.sharedInstance.Istankempty = self.IsTank_Empty[id]
                                        print(Vehicaldetails.sharedInstance.IsBusy)
                                        let siteid = self.siteID[id]
                                        let ssId = self.ssid[id]
                                        let hoseid = self.HoseId[id]
                                        let Password = self.Pass[id]
                                        self.wifiNameTextField.text = self.ssid[id]
                                        let isupgrade = self.Is_upgrade[id]
                                        let pulsartime_adjust = self.pulsartimeadjust[id]
                                        Vehicaldetails.sharedInstance.siteID = siteid
                                        
                                        Vehicaldetails.sharedInstance.SSId = ssId.trimmingCharacters(in: .whitespacesAndNewlines)
                                        print(Vehicaldetails.sharedInstance.SSId)
                                        Vehicaldetails.sharedInstance.HoseID = hoseid
                                        Vehicaldetails.sharedInstance.password = Password
                                        Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
                                        Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
                                        //                        Vehicaldetails.sharedInstance.IsBusy = IsBusy
                                        Vehicaldetails.sharedInstance.IsDefective = self.IFIsDefective[id]
                                        Vehicaldetails.sharedInstance.prevSSID = self.preSSID[id]
                                        Vehicaldetails.sharedInstance.OriginalNamesOfLink = self.OriginalNamesOfLink[id] as! NSMutableArray
                                        Vehicaldetails.sharedInstance.IsHoseNameReplaced = self.Is_HoseNameReplaced[id]
                                        Vehicaldetails.sharedInstance.ReplaceableHoseName = self.ReplaceableHosename[id]
                                        print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                                        Vehicaldetails.sharedInstance.HubLinkCommunication = self.Communication_Type[id]
                                        Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce = self.Is_ResetSwitchTimeBounce[id]
                                    }
                                }
                                print(Vehicaldetails.sharedInstance.IsDefective )
                                if(Vehicaldetails.sharedInstance.IsDefective == "True"){
                                    self.showAlert(message: NSLocalizedString("Hoseorder", comment:""))
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                }
                                else {
                                    if(Vehicaldetails.sharedInstance.IsBusy == "Y"){
                                        let alert = UIAlertController(title: "", message: NSLocalizedString("", comment:""), preferredStyle: UIAlertController.Style.alert )
                                        let backView = alert.view.subviews.last?.subviews.last
                                        backView?.layer.cornerRadius = 10.0
                                        backView?.backgroundColor = UIColor.white
                                        var messageMutableString = NSMutableAttributedString()
                                        messageMutableString = NSMutableAttributedString(string: NSLocalizedString("warninghoseinused", comment:"")as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!])
                                        self.web.sentlog(func_name: "Go button tapped Hose In Use\(Vehicaldetails.sharedInstance.IsBusy)", errorfromserverorlink: "", errorfromapp: "")
                                        
                                        alert.setValue(messageMutableString, forKey: "attributedMessage")
                                        
                                        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default) { action in
                                            self.go.isEnabled = true
                                        }
                                        alert.addAction(okAction)
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    else if(Vehicaldetails.sharedInstance.IsBusy == "N")
                                    {
                                        if(Vehicaldetails.sharedInstance.Istankempty == "True")
                                        {
                                            
                                            self.showAlert(message: NSLocalizedString("tankempty", comment:""))
                                            //                                        self.showAlert(message: "The system is low on fuel and must be refilled before fueling can start.\n Please contact your Manager.")
                                            self.go.isEnabled = true
                                        }
                                        else{
                                            if (self.wifiNameTextField.text == ""){
                                                self.showAlert(message: NSLocalizedString("NoHoseselect", comment:""))
                                                self.Activity.stopAnimating()
                                                self.Activity.isHidden = true
                                                self.go.isEnabled = true
                                            }
                                            else{
                                                let reply = self.web.sendSiteID()
                                                if(reply == "-1"){
                                                    self.showAlert(message: NSLocalizedString("NoInternet", comment:""))
                                                    self.Activity.stopAnimating()
                                                    self.Activity.isHidden = true
                                                    self.go.isEnabled = true
                                                    
                                                }else{
                                                    let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
                                                    do{
                                                        self.sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                                    }catch let error as NSError {
                                                        print ("Error: \(error.domain)")
                                                    }
                                                    
                                                    if(self.sysdata == nil){
                                                        
                                                    }
                                                    else{
                                                        let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                                        
                                                        print(ResponceText)
                                                        if(ResponceText == "Y"){
                                                            self.showAlert(message: NSLocalizedString("warninghoseinused", comment:""))
                                                            self.Activity.stopAnimating()
                                                            self.Activity.isHidden = true
                                                        }
                                                        else if(ResponceText == "Busy"){
                                                            print("ssID Match")
                                                            self.Activity.stopAnimating()
                                                            self.Activity.isHidden = true
                                                            Vehicaldetails.sharedInstance.TransactionId = 0;
                                                            
                                                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT"){
                                                                let fVC = FuelquantityVC()
                                                            fVC.connectToBLE()
                                                                
                                                            }
                                                            
                                                            if(self.IsVehicleNumberRequire == "True"){
                                                                self.performSegue(withIdentifier: "GO", sender: self)
                                                            }
                                                            else{
                                                                if(self.IsDepartmentRequire == "True"){
                                                                    self.performSegue(withIdentifier: "dept", sender: self)
                                                                }
                                                                else{
                                                                    if(self.IsPersonnelPINRequire == "True"){
                                                                        self.performSegue(withIdentifier: "pin", sender: self)
                                                                    }
                                                                    else{
                                                                        if(self.IsOtherRequire == "True"){
                                                                            self.performSegue(withIdentifier: "other", sender: self)
                                                                        }
                                                                        else{
                                                                            self.senddata(deptno: self.IsDepartmentRequire,ppin:self.IsPersonnelPINRequire,other:self.IsOtherRequire)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                self.showPermissionAlert(message: "Location is disabled. Please enable it using the app settings option below.")
            }
        }
    }
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer:Int! = Int(odom)!
        let vehicle_no = ""//Vehicaldetails.sharedInstance.vehicleno
        
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
        let Split = data.components(separatedBy: "#@*%*@#")
        let reply = Split[0]
        if (reply == "-1")
        {
            
        }
        else
        {
            let data1:Data = reply.data(using: String.Encoding.utf8)!
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            //print(sysdata)
            if(sysdata == nil){
                
            }
            else{
                let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
                let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
                let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString
                
                if(ResponceMessage == "success")
                {
                    if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                        if #available(iOS 12.0, *) {
                            self.web.wifisettings(pagename: "Odometer")
                        }
                        else {
                            // Fallback on earlier versions
                            let alertController = UIAlertController(title: NSLocalizedString("Title", comment:""), message: NSLocalizedString("Message", comment:"") + "\(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertController.Style.alert)
                            let backView = alertController.view.subviews.last?.subviews.last
                            backView?.layer.cornerRadius = 10.0
                            backView?.backgroundColor = UIColor.white
                            
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = NSTextAlignment.left
                            
                            let paragraphStyle1 = NSMutableParagraphStyle()
                            paragraphStyle1.alignment = NSTextAlignment.left
                            
                            let attributedString = NSAttributedString(string:NSLocalizedString("Subtitle", comment:""), attributes: [
                                NSAttributedString.Key.paragraphStyle:paragraphStyle1,
                                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), //your font here
                                NSAttributedString.Key.foregroundColor : UIColor.black
                            ])
                            
                            let formattedString = NSMutableAttributedString()
                            formattedString
                                .normal(NSLocalizedString("Step1", comment:""))
                                .bold("\(Vehicaldetails.sharedInstance.SSId)")
                                .normal(NSLocalizedString("Step2", comment:""))
                                .bold("\(Vehicaldetails.sharedInstance.SSId)")
                                .normal(NSLocalizedString("Step3", comment:""))
                            
                            alertController.setValue(formattedString, forKey: "attributedMessage")
                            alertController.setValue(attributedString, forKey: "attributedTitle")
                            let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default){
                                action in
                                self.performSegue(withIdentifier: "fueling", sender: self)
                            }
                            alertController.addAction(action)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                        
                        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                        {
                            self.performSegue(withIdentifier: "GoUDP", sender: self)
                        }
                        else{
                            self.performSegue(withIdentifier: "fueling", sender: self)
                        }
                    }
                    else{
                        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                        {
                            self.performSegue(withIdentifier: "GoUDP", sender: self)
                        }
                        else{
                            self.performSegue(withIdentifier: "fueling", sender: self)
                        }
                    }
                }
                else {
                    
                    if(ResponceMessage == "fail")
                    {
                        if(ValidationFailFor == "Vehicle")
                        {
                            self.performSegue(withIdentifier: "Vehicle", sender: self)
                            
                        }else if(ValidationFailFor == "Dept")
                        {
                            self.performSegue(withIdentifier: "dept", sender: self)
                            
                        }else if(ValidationFailFor == "Odo")
                        {
                            self.performSegue(withIdentifier: "odometer", sender: self)
                        }
                        else if(ValidationFailFor == "Pin")
                        {
                            self.performSegue(withIdentifier: "pin", sender: self)
                        }
                    }
                    showAlert(message: "\(ResponceText)")
                }
            }
        }
    }
    
    @IBAction func refreshButtontappd(sender: AnyObject)
    {
        IsrefreshButtontapped = true
        viewDidLoad()
        unsync.unsyncTransaction()
        unsync.unsyncP_typestatus()
       
        
    }
    
    //MARK: PickerView delegate methods to Show the hose list get received from server.
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
            self.wifiNameTextField.text = ssid[0]
            let siteid = siteID[0]
            let ssId = ssid[0]
            let hoseid = HoseId[0]
            let Password = Pass[0]
            self.wifiNameTextField.text = ssid[0]
            IsBusy = IFISBusy[0]
            Vehicaldetails.sharedInstance.Istankempty = IsTank_Empty[0]
            let pulsartime_adjust = pulsartimeadjust[0]
            let isupgrade = Is_upgrade[0]
            let IsDefective = IFIsDefective[0]
            let IsTLDCall = TLDCall[0]
            Vehicaldetails.sharedInstance.IsTLDdata = IsTLDCall
            Vehicaldetails.sharedInstance.siteID = siteid
            Vehicaldetails.sharedInstance.SSId = ssId
            Vehicaldetails.sharedInstance.prevSSID = preSSID[0]
            Vehicaldetails.sharedInstance.OriginalNamesOfLink = OriginalNamesOfLink[0] as! NSMutableArray
            Vehicaldetails.sharedInstance.HoseID = hoseid
            Vehicaldetails.sharedInstance.password = Password
            Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
            Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
            Vehicaldetails.sharedInstance.IsBusy = IsBusy
            Vehicaldetails.sharedInstance.IsDefective = IsDefective
            Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[0]
            Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[0]
            Vehicaldetails.sharedInstance.HubLinkCommunication = Communication_Type[0]
            Vehicaldetails.sharedInstance.IsLinkFlagged = IsLink_Flagged[0]
            Vehicaldetails.sharedInstance.LinkFlaggedMessage = LinkFlagged_Message[0]
            Vehicaldetails.sharedInstance.MacAddress = Mac_Address[0]
            Vehicaldetails.sharedInstance.BTMacAddress = Bluetooth_MacAddress[0]
            return ssid[row]
        }
        return ""
    }
    
    @objc func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int, inComponent component: Int)
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
            let pressid = preSSID[index]
            Vehicaldetails.sharedInstance.OriginalNamesOfLink = OriginalNamesOfLink[index] as! NSMutableArray
            let ssId = ssid[index]
            let hoseid = HoseId[index]
            let Password = Pass[index]
            self.wifiNameTextField.text = ssid[index]
            IsBusy = IFISBusy[index]
            Vehicaldetails.sharedInstance.Istankempty = IsTank_Empty[index]
            let pulsartime_adjust = pulsartimeadjust[index]
            let isupgrade = Is_upgrade[index]
            let IsTLDCall = TLDCall[index]
            print(IsTLDCall)
            Vehicaldetails.sharedInstance.IsTLDdata = IsTLDCall
            Vehicaldetails.sharedInstance.siteID = siteid
            Vehicaldetails.sharedInstance.SSId = ssId
            Vehicaldetails.sharedInstance.prevSSID = pressid
            Vehicaldetails.sharedInstance.HoseID = hoseid
            Vehicaldetails.sharedInstance.password = Password
            Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
            Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
            Vehicaldetails.sharedInstance.IsBusy = IsBusy
            Vehicaldetails.sharedInstance.IsDefective = IFIsDefective[index]
            Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[index]
            Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[index]
            Vehicaldetails.sharedInstance.HubLinkCommunication = Communication_Type[index]
            Vehicaldetails.sharedInstance.IsLinkFlagged = IsLink_Flagged[index]
            Vehicaldetails.sharedInstance.LinkFlaggedMessage = LinkFlagged_Message[index]
            Vehicaldetails.sharedInstance.MacAddress = Mac_Address[index]
            Vehicaldetails.sharedInstance.BTMacAddress = Bluetooth_MacAddress[index]
            print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced,Vehicaldetails.sharedInstance.prevSSID,Vehicaldetails.sharedInstance.OriginalNamesOfLink,Vehicaldetails.sharedInstance.BTMacAddress )
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
            IsGobuttontapped = false
            go.isEnabled = true
        }
        view.endEditing(true)
    }
    
    func preauthunsyncTransaction() -> String
    {
        if (Vehicaldetails.sharedInstance.reachblevia == "cellular")
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/preauth/")
            let fromPath: String = (readdata!.path)
            do{
                
                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                    {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                }
                }
                               
                reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                for x in 0  ..< reportsArray.count
                {
                    let filename: String = "\(reportsArray[x])"
                    let Split = filename.components(separatedBy: "#")
                    _ = Split[1]
                    
                    let JData: String = cf.preauthReadReportFile(fileName: filename)
                    if(JData != "")
                    {
                        Upload(jsonstring: JData,filename: filename,siteName:"SavePreAuthTransactions")
                        return "true"
                    }
                }
            }
        }
        
        else if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/preauth/")
            let fromPath: String = (readdata!.path)
            do{
                
                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                    {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                }
                }
                
                reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                for x in 0  ..< reportsArray.count
                {
                    let filename: String = "\(reportsArray[x])"
                    let Split = filename.components(separatedBy: "#")
                    
                    _ = Split[1]
                    
                    let JData: String = cf.preauthReadReportFile(fileName: filename)
                    if(JData != "")
                    {
                        Upload(jsonstring: JData,filename: filename,siteName:"SavePreAuthTransactions")
                    }
                }
            }
        }
        return "False"
    }
    
    func Upload(jsonstring: String,filename:String,siteName:String)
    {
        let FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + siteName + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = cf.convertStringToBase64(string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        print(jsonstring)
        request.httpBody = jsonstring.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                
                let ResponceText = self.sysdata1.value(forKey: "ResponceText") as! NSString
                
                self.ResponceMessageUpload = (self.sysdata1.value(forKey: "ResponceMessage") as! NSString) as String
                
                if(self.ResponceMessageUpload == "fail"){
                    if(ResponceText == "TransactionId not found."){
                        self.cf.preauthDeleteReportTextFile(fileName: filename, writeText: "")
                    }
                    self.cf.preauthDeleteReportTextFile(fileName: filename, writeText: "")
                }
                if(self.ResponceMessageUpload == "success"){
                    self.cf.preauthDeleteReportTextFile(fileName: filename, writeText: "")
                }
                
            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}

