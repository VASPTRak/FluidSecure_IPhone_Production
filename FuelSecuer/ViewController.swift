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
    var cf = Commanfunction()
    var pa = PreauthFuelquantity()
    var unsync = Sync_Unsynctransactions()

    var currentlocation :CLLocation!
    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!

    let defaults = UserDefaults.standard
    var timer:Timer = Timer()
    
    var reply:String!
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
    var IsDefective:String!

    var sysdata:NSDictionary!
    var systemdata:NSDictionary!
    
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
    var Is_HoseNameReplaced = [String]()
    var IFIsDefective = [String]()
    var Uhosenumber = [String]()
    var TransactionId = [String]()
    var TLDCall = [String]()

    var IsGobuttontapped : Bool = false
    var now:Date!

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
    @IBOutlet var wifiNameTextField: UITextField!
    @IBOutlet var Companylogo: UIImageView!
    
    @IBAction func preAuthentication(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    //MARK: ViewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Activity.isHidden = true
        
        version.text = "Version \(Version)"
        version_2.text = "Version \(Version)"

        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
            itembarbutton.title = "English"
        }else  if(Vehicaldetails.sharedInstance.Language == ""){
            itembarbutton.title = "Spanish"
        }

        TransactionId = []
        wifiNameTextField.delegate = self
        self.web.sentlog(func_name: "ViewdidLoad select hose page", errorfromserverorlink: "", errorfromapp: "")
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
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location

        let password = KeychainService.loadPassword()
        if(password == nil)
        {
            let uuid:String = UIDevice.current.identifierForVendor!.uuidString
            KeychainService.savePassword(token: uuid as NSString)
        }
        else
        {
            let uuid = password
            var myMutableStringTitle = NSMutableAttributedString()
            let Name  = "Touch to select Site"// PlaceHolderText
            myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 25.0)!]) // Font
            myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
            wifiNameTextField.attributedPlaceholder = myMutableStringTitle
            _ = defaults.array(forKey: "SSID")
            var reply:String!

            //Server call to Check User approved or not.
            if(currentlocation == nil)
            {
                reply =  web.checkApprove(uuid: uuid! as String,lat:"\(0)",long:"\(0)")
            }
            else {
                sourcelat = currentlocation.coordinate.latitude
                sourcelong = currentlocation.coordinate.longitude
                print (sourcelat!,sourcelong!)
                Vehicaldetails.sharedInstance.Lat = sourcelat!
                Vehicaldetails.sharedInstance.Long = sourcelong!
                reply = web.checkApprove(uuid: uuid! as String,lat:"\(sourcelat!)",long:"\(sourcelong!)")
            }
            

            if(reply == "-1")
            {
                if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
                {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    scrollview.isHidden = true
                    version.isHidden = false
                    warningLable.isHidden = false
                    refreshButton.isHidden = false
                    preauth.isHidden = false
                    warningLable.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    cf.delay(0.5){
                    }
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "cellular")
                {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    scrollview.isHidden = true
                    version.isHidden = false
                    warningLable.isHidden = false
                    preauth.isHidden = false
                    warningLable.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    refreshButton.isHidden = false
                }
                else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
                    self.navigationItem.title = NSLocalizedString("Error",comment:"")
                    scrollview.isHidden = true
                    version.isHidden = false
                    warningLable.isHidden = false
                    preauth.isHidden = false
                    warningLable.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")
                    refreshButton.isHidden = false
                    for i in 1...2
                    {
                        print(i)
                        if(currentlocation == nil)
                        {
                            reply = web.checkApprove(uuid: uuid! as String,lat:"\(0)",long:"\(0)")
                        }else{
                            reply = web.checkApprove(uuid: uuid! as String,lat:"\(sourcelat!)",long:"\(sourcelong!)")
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
                cf.DeleteFileInApp(fileName: "getSites.txt")
                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
                let data1:Data = reply.data(using: String.Encoding.utf8)!
                do {
                    sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    
                    print ("Error: \(error.domain)")
                }
               // print(sysdata)
                if(sysdata == nil){
                }
                else{
                    let Message = sysdata["ResponceMessage"] as! NSString
                    let ResponseText = sysdata["ResponceText"] as! NSString
                    if(Message == "success") {
                        self.navigationItem.title = Vehicaldetails.sharedInstance.CompanyBarndName
                        let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
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

                        Vehicaldetails.sharedInstance.ScreenNameForVehicle = ScreenNameForVehicle
                        Vehicaldetails.sharedInstance.ScreenNameForPersonnel = ScreenNameForPersonnel
                        Vehicaldetails.sharedInstance.ScreenNameForHours = ScreenNameForHours
                        Vehicaldetails.sharedInstance.ScreenNameForOdometer = ScreenNameForOdometer

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
                        Vehicaldetails.sharedInstance.IsVehicleNumberRequire = IsVehicleNumberRequire

                        if(IsVehicleNumberRequire == "False")
                        {
                            Vehicaldetails.sharedInstance.vehicleno = ""
                            Vehicaldetails.sharedInstance.Odometerno = "0"
                        }
                        else if(IsVehicleNumberRequire == "True"){

                        }

                        infotext.text =  NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") + ": \(Email)"

                        Vehicaldetails.sharedInstance.CollectDiagnosticLogs = CollectDiagnosticLogs as String
                        Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                        Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                        Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                        Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
                        Vehicaldetails.sharedInstance.Otherlable = OtherLabel
                        Vehicaldetails.sharedInstance.TimeOut = timeout
                        //                        Vehicaldetails.sharedInstance.IsUseBarcode = IsUseBarcode

                        defaults.set(PersonName, forKey: "firstName")
                        defaults.set(Email, forKey: "address")
                        defaults.set(PhoneNumber, forKey: "mobile")
                        defaults.set(uuid, forKey: "uuid")
                        defaults.set(1, forKey: "Register")
                        Vehicaldetails.sharedInstance.AppType = "AuthTransaction"
                        print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)

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
                    }

                    else if(Message == "fail"){ }

                    defaults.set(uuid, forKey: "uuid")
                    if(Message == "success") {

                        scrollview.isHidden = false
                        version.isHidden = true
                        warningLable.isHidden = true
                        refreshButton.isHidden = true
                        preauth.isHidden = true

                        supportinfo.text = "Support:\(Vehicaldetails.sharedInstance.SupportEmail) or " + "\(Vehicaldetails.sharedInstance.SupportPhonenumber)"
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
                                systemdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            }catch let error as NSError {
                                print ("Error: \(error.domain)")
                                print ("Error: \(error)")
                            }
                           // print(systemdata)
                            ssid = []
                            IFISBusy = []
                            HoseId = []
                            Pass = []
                            Is_upgrade = []
                            IFIsDefective = []
                            Uhosenumber = []
                            Is_HoseNameReplaced = []
                            ReplaceableHosename = []
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
                                        let Password = JsonRow["Password"] as! NSString
                                        let hosename = JsonRow["HoseNumber"] as! NSString
                                        let Sitid = JsonRow["SiteId"] as! NSString
                                        let HoseID = JsonRow["HoseId"] as! NSString
                                        let IsUpgrade = JsonRow["IsUpgrade"] as! NSString
                                        let IsHoseNameReplaced = JsonRow["IsHoseNameReplaced"] as! NSString
                                        IsBusy = JsonRow["IsBusy"] as! NSString as String
                                        //                                        let MacAddress = JsonRow["MacAddress"] as! NSString
                                        let PulserTimingAdjust = JsonRow["PulserTimingAdjust"] as! NSString
                                        let IsDefective = JsonRow["IsDefective"] as!NSString
                                        let IsTLDCall = JsonRow["IsTLDCall"] as! NSString

                                        ssid.append(WifiSSId as String)
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
                                        print(Uhosenumber)
                                    }


                                    let objUserData = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
                                    let PreAuthJson = objUserData.value(forKey: "TransactionObj") as! NSArray
                                    let PreAuthrowCount = PreAuthJson.count
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
                                    self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
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
                                Vehicaldetails.sharedInstance.IsBusy = IsBusy
                                Vehicaldetails.sharedInstance.IsDefective = IFIsDefective[0]
                                Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[0]
                                Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[0]
                                print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced)

                                defaults.set(siteid, forKey: "SiteID")
                                cf.delay(0.2){
                                    if( self.IsGobuttontapped == true){

                                    }
                                    else{

                                    }
                                }
                            }
                        }
                    }

                        //USER IS NOT REGISTER TO SYSTEM
                    else if(ResponseText == "New Registration") {
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        defaults.set(0, forKey: "Register")
                        self.web.sentlog(func_name: "Other_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
                        // Call a method on the CustomController property of the AppDelegate
                        appDel.start()
                    }

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
                                refreshButton.isHidden = false
                                self.navigationItem.title = NSLocalizedString("Error",comment:"")
                                warningLable.text = NSLocalizedString("Regisration", comment:"")
                            }else
                            {
                                scrollview.isHidden = true
                                version.isHidden = false
                                warningLable.isHidden = false
                                refreshButton.isHidden = false
                                self.navigationItem.title = NSLocalizedString("Error",comment:"")
                                warningLable.text = ResponseText as String
                        }                        
                    }
                }
            }
            
            if(cf.getSSID() != "" ) {}
            else {}
            self.viewlable.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).cgColor
            let wifiSSid = Vehicaldetails.sharedInstance.SSId
            defaults.set(wifiSSid, forKey: "wifiSSID")
            // Do any additional setup after loading the view, typically from a nib.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm MMM dd, yyyy"
            let strDate = dateFormatter.string(from: NSDate() as Date)
            datetime.text = strDate
            selectHose.text = NSLocalizedString("selectHose", comment:"")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        go.isEnabled = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if(cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if( cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {}
        _ = unsync.unsyncTransaction()
        _ = self.unsync.Send10trans()
        _ = pa.preauthunsyncTransaction()
        
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
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let dateComponent = NSDateComponents()
            
            dateComponent.day = x
            now = (calendar!.date(byAdding: dateComponent as DateComponents, to: currentdate! , options:[])! as NSDate) as Date
            //print(now)
        }

        cf.delay(1){
            let soon = Date()
            print(self.now!,soon)
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
    
    // @available(iOS 11.0, *)
    @IBAction func helpButtontapped(_ sender: Any) {
        
        if(wifiNameTextField.text == ""){
            showAlert(message:NSLocalizedString("Helptext", comment:""))
        }
        else{
            showAlert(message: NSLocalizedString("HelptextSelectedSite", comment:"") +  "\(Vehicaldetails.sharedInstance.password).")
            
            print("Password is" + "\(Vehicaldetails.sharedInstance.password)")
            UIPasteboard.general.string = "\(Vehicaldetails.sharedInstance.password)"
            print(UIPasteboard.general.string!)
        }
    }
    
    
    @objc func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }
    
    @IBAction func change_language(_ sender: Any) {
        //        if(itembarbutton.title == "English"){
        //        Bundle.setLanguage("en")
        //        let appDel = UIApplication.shared.delegate! as! AppDelegate
        //        appDel.start()
        //
        //        }
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
        
        _ = unsync.unsyncTransaction()
               _ = self.unsync.Send10trans()
               _ = pa.preauthunsyncTransaction()
        
        self.Activity.startAnimating()
        self.Activity.isHidden = false
        Vehicaldetails.sharedInstance.Barcodescanvalue = ""
        Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
        cf.delay(0.1){            
            
            self.go.isEnabled = false
            if(self.wifiNameTextField.text == ""){
                self.showAlert(message: NSLocalizedString("NoHoseselect", comment:""))
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                self.go.isEnabled = true
            }
            else{
                print(Vehicaldetails.sharedInstance.IsBusy)
                self.IsGobuttontapped = true
                self.timer.invalidate()
                self.viewDidLoad()
                for id in 0  ..< self.ssid.count {
                    if(self.wifiNameTextField.text == self.ssid[id])
                    {
                        Vehicaldetails.sharedInstance.IsBusy = self.IFISBusy[id]
                        Vehicaldetails.sharedInstance.IsDefective = self.IFIsDefective[id]
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
                        Vehicaldetails.sharedInstance.IsHoseNameReplaced = self.Is_HoseNameReplaced[id]
                        Vehicaldetails.sharedInstance.ReplaceableHoseName = self.ReplaceableHosename[id]
                        print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced)
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
                        let alert = UIAlertController(title: "Warning", message: NSLocalizedString("", comment:""), preferredStyle: UIAlertController.Style.alert )
                        let backView = alert.view.subviews.last?.subviews.last
                        backView?.layer.cornerRadius = 10.0
                        backView?.backgroundColor = UIColor.white
                        var messageMutableString = NSMutableAttributedString()
                        messageMutableString = NSMutableAttributedString(string: NSLocalizedString("warninghoseinused", comment:"")as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!])
                        //messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:"Hose In Use \n Please try after sometime".count))
                        alert.setValue(messageMutableString, forKey: "attributedMessage")
                        
                        let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertAction.Style.default) { action in
                            self.go.isEnabled = true
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if(Vehicaldetails.sharedInstance.IsBusy == "N")
                    {
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
                                //print(self.sysdata)
                                let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                
                                print(ResponceText)
                                if(ResponceText == "Y"){
                                    self.showAlert(message: NSLocalizedString("warninghoseinused", comment:""))
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                    
                                }else if(ResponceText == "Busy"){
                                    print("ssID Match")
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                    Vehicaldetails.sharedInstance.TransactionId = 0;
                                    
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
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer:Int! = Int(odom)!
        let vehicle_no = ""//Vehicaldetails.sharedInstance.vehicleno
        
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
        let Split = data.components(separatedBy: "#")
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
            
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString
            
            if(ResponceMessage == "success")
            {
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                    if #available(iOS 11.0, *) {
                        self.web.wifisettings(pagename: "Odometer")
                    } else {
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
                    self.performSegue(withIdentifier: "fueling", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "fueling", sender: self)
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
    
    @IBAction func refreshButtontappd(sender: AnyObject)
    {
        viewDidLoad()
        unsync.unsyncTransaction()
        
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
            let pulsartime_adjust = pulsartimeadjust[0]
            let isupgrade = Is_upgrade[0]
            let IsDefective = IFIsDefective[0]
            let IsTLDCall = TLDCall[0]
            Vehicaldetails.sharedInstance.IsTLDdata = IsTLDCall
            Vehicaldetails.sharedInstance.siteID = siteid
            Vehicaldetails.sharedInstance.SSId = ssId
            Vehicaldetails.sharedInstance.HoseID = hoseid
            Vehicaldetails.sharedInstance.password = Password
            Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
            Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
            Vehicaldetails.sharedInstance.IsBusy = IsBusy
            Vehicaldetails.sharedInstance.IsDefective = IsDefective
            Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[0]
            Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[0]
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
            let ssId = ssid[index]
            let hoseid = HoseId[index]
            let Password = Pass[index]
            self.wifiNameTextField.text = ssid[index]
            IsBusy = IFISBusy[index]
            let pulsartime_adjust = pulsartimeadjust[index]
            let isupgrade = Is_upgrade[index]
            let IsTLDCall = TLDCall[index]
            print(IsTLDCall)
            Vehicaldetails.sharedInstance.IsTLDdata = IsTLDCall
            Vehicaldetails.sharedInstance.siteID = siteid
            Vehicaldetails.sharedInstance.SSId = ssId
            Vehicaldetails.sharedInstance.HoseID = hoseid
            Vehicaldetails.sharedInstance.password = Password
            Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
            Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
            Vehicaldetails.sharedInstance.IsBusy = IsBusy
            Vehicaldetails.sharedInstance.IsDefective = IFIsDefective[index]
            Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[index]
            Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[index]
            print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced)
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
        }
        view.endEditing(true)
    }
}



