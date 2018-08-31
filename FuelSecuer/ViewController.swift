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
    var Is_HoseNameReplaced = [String]()
    var IFIsDefective = [String]()
    var Uhosenumber = [String]()
    var TransactionId = [String]()
    var IsOdoMeterRequire:String!
    var IsLoginRequire:String!
    var IsBusy :String!
    var IsDefective:String!
    var IsGobuttontapped : Bool = false

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

    @IBAction func preAuthentication(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControlState())
        doneButton.addTarget(self, action: #selector(tapAction), for: UIControlEvents.touchUpInside);
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
        let uuid:String = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = "Enter Title" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 20.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Name.count))    // Color
        wifiNameTextField.attributedPlaceholder = myMutableStringTitle
        _ = defaults.array(forKey: "SSID")
        var reply:String!
         

        if(currentlocation == nil)
        {
            reply =  web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
        }
        else {
            sourcelat = currentlocation.coordinate.latitude
            sourcelong = currentlocation.coordinate.longitude
            print (sourcelat,sourcelong)
            Vehicaldetails.sharedInstance.Lat = sourcelat
            Vehicaldetails.sharedInstance.Long = sourcelong
            reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
            
        }

        //Check User approved or not from server
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
                        reply = web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
                    }else{
                        reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat)",long:"\(sourcelong)")
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
                let CollectDiagnosticLogs = objUserData.value(forKey: "CollectDiagnosticLogs") as! NSString
                IsOdoMeterRequire = objUserData.value(forKey: "IsOdoMeterRequire") as! NSString as String
                IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
                OtherLabel = objUserData.value(forKey:"OtherLabel") as!NSString as String
                timeout = objUserData.value(forKey:"TimeOut") as!NSString as String

                infotext.text =  NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") + ": \(Email)"
                Vehicaldetails.sharedInstance.CollectDiagnosticLogs = CollectDiagnosticLogs as String
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
                 Vehicaldetails.sharedInstance.AppType = "AuthTransaction"
                print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
            }
            else if(Message == "fail"){ }

            defaults.set(uuid, forKey: "uuid")
            if(Message == "success") {

                scrollview.isHidden = false
                version.isHidden = true
                warningLable.isHidden = true
                refreshButton.isHidden = true
                preauth.isHidden = true

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
                    IFIsDefective = []
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
                                let IsDefective = JsonRow["IsDefective"] as!NSString

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
                        defaults.set(siteid, forKey: "SiteID")
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

                defaults.set("false", forKey: "checkApproved")
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                refreshButton.isHidden = false
                self.navigationItem.title = NSLocalizedString("Error",comment:"")
                warningLable.text = NSLocalizedString("Regisration", comment:"")
            } else if(ResponseText == "New Registration") {
                performSegue(withIdentifier: "Register", sender: self)
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

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [ NSAttributedStringKey.paragraphStyle: paragraphStyle,NSAttributedStringKey.font:UIFont(name: "Georgia", size: 24.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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

    @IBAction func goButtontapped(sender: AnyObject) {
        if(self.wifiNameTextField.text == ""){
            showAlert(message: NSLocalizedString("NoHoseselect", comment:""))
        }
        else{
            print(Vehicaldetails.sharedInstance.IsBusy)
            IsGobuttontapped = true
            timer.invalidate()
            self.viewDidLoad()
            for id in 0  ..< self.ssid.count {
                if(self.wifiNameTextField.text == self.ssid[id])
                {
                    Vehicaldetails.sharedInstance.IsBusy = self.IFISBusy[id]
                    Vehicaldetails.sharedInstance.IsDefective = self.IFIsDefective[id]
                    print(Vehicaldetails.sharedInstance.IsBusy)
                }
            }
            print(Vehicaldetails.sharedInstance.IsDefective )
            if(Vehicaldetails.sharedInstance.IsDefective == "True"){
                showAlert(message: NSLocalizedString("Hoseorder", comment:""))
            }
            else {
                if(Vehicaldetails.sharedInstance.IsBusy == "Y"){
                    let alert = UIAlertController(title: "Warning", message: NSLocalizedString("", comment:""), preferredStyle: UIAlertControllerStyle.alert )
                    let backView = alert.view.subviews.last?.subviews.last
                    backView?.layer.cornerRadius = 10.0
                    backView?.backgroundColor = UIColor.white
                    var messageMutableString = NSMutableAttributedString()
                    messageMutableString = NSMutableAttributedString(string: NSLocalizedString("warninghoseinused", comment:"")as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 20.0)!])
                    messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:"Hose In Use \n Please try after sometime".count))
                    alert.setValue(messageMutableString, forKey: "attributedMessage")

                    let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertActionStyle.default) { action in

                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else if(Vehicaldetails.sharedInstance.IsBusy == "N")
                {
                    if (wifiNameTextField.text == ""){
                        showAlert(message: NSLocalizedString("NoHoseselect", comment:""))
                    }
                    else{
                        let reply = self.web.sendSiteID()
                        if(reply == "-1"){
                            showAlert(message: NSLocalizedString("NoInternet", comment:""))
                            
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
                                showAlert(message: NSLocalizedString("warninghoseinused", comment:""))

                            }else if(ResponceText == "Busy"){
                                print("ssID Match")
                                Vehicaldetails.sharedInstance.TransactionId = 0;
                                self.performSegue(withIdentifier: "GO", sender: self)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func refreshButtontappd(sender: AnyObject)
    {
        viewDidLoad()
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
        }
        view.endEditing(true)
    }
}



