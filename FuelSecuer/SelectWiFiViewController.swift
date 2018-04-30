
//
//  SelectWiFiViewController.swift
//  FuelSecuer
//
//  Created by VASP on 19/05/16.
//  Copyright © 2016 VASP. All rights reserved.
//
import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation
//import CoreData
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
class SelectWiFiViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,CLLocationManagerDelegate{

//    var web = Webservices()
//    var SSid = ViewController()
//    var confs = FuelquantityVC()
//    var cf = Commanfunction()
//    var sysdata:NSDictionary!
//    var systemdata:NSDictionary!
//    var currentlocation :CLLocation!
//    var originCoordinate: CLLocationCoordinate2D!
//    var destinationCoordinate: CLLocationCoordinate2D!
//    let locationManager = CLLocationManager()
//    var sourcelat:Double!
//    var sourcelong:Double!
//    var locationName:NSString!
//    var currentSSID:String!
//    let defaults = NSUserDefaults.standardUserDefaults()
//    var pickerViewHose: UIPickerView = UIPickerView()
//    var pickerViewLocation: UIPickerView = UIPickerView()
//    var ssid = [String]()
//    var Pass = [String]()
//    var location = [String]()
//    var ReplaceableHosename = [String]()
//    var Ulocation = [String]()
//    var siteID = [String]()
//    var Uhosenumber = [String]()
//    var IsOdoMeterRequire:String!
//    var IsLoginRequire:String!
//    var reply :String!
//    var IsBusy :String!

//    @IBOutlet var mview: UIView!
//    @IBOutlet var scrollview: UIScrollView!
//    @IBOutlet var refreshButton: UIButton!
//    @IBOutlet var warningLable: UILabel!
//    @IBOutlet weak var wifiNameTextField: UITextField!


    override func viewDidLoad() {
        showAlert(message: "Finished Fueling – please close app")
    }
    override func viewDidAppear(_ animated: Bool)  {
        showAlert(message: "Finished Fueling – please close app")
    }

//        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        currentlocation = locationManager.location
//        let uuid:String = UIDevice.currentDevice().identifierForVendor!.UUIDString
//        print(uuid)
//
//        _ = defaults.arrayForKey("SSID") //stringForKey("SSID")
//        var reply:String!
//        var error:String!
//        var data:String!
//        if(currentlocation == nil)
//        {
//           let data =  web.checkApprove(uuid,lat:"\(0)",long:"\(0)")
//            let Split:NSArray = data.componentsSeparatedByString("#")
//            reply = Split[0] as! String
//            error = Split[1]as! String
//        }
//        else {
//            sourcelat = currentlocation.coordinate.latitude
//            sourcelong = currentlocation.coordinate.longitude
//            print (sourcelat,sourcelong)
//            let data = web.checkApprove(uuid,lat:"\(sourcelat)",long:"\(sourcelong)")
//            let Split:NSArray = data.componentsSeparatedByString("#")
//            reply = Split[0] as! String
//            error = Split[1]as! String
//        }
//
//        //Check User approved or not from server
//
//        if(reply == "-1")
//        {
//            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
//            {
//                self.navigationItem.title = "Error"
//
//                scrollview.hidden = true
//                warningLable.hidden = false
//                warningLable.text = "Cannot connect to cloud server.Please check your internet connection."
//                refreshButton.hidden = false
//                web.sleep()
//                cf.delay(5){
//                for i in 1...5
//                {
//                    //
//                    print(i)
//                    if(self.currentlocation == nil)
//                    {
//                        data = self.web.checkApprove(uuid,lat:"\(0)",long:"\(0)")
//                    }else{
//                     data = self.web.checkApprove(uuid,lat:"\(self.sourcelat)",long:"\(self.sourcelong)")
//                    }
//                    let Split:NSArray = data.componentsSeparatedByString("#")
//                    reply = Split[0] as! String
//                    error = Split[1]as! String
//                    if(reply == "-1")
//                    {
//                        self.showAlert("Cannot connect to cloud server. Please check your internet connection. \n \(error)")
//                    }
//                    else if(reply != "-1")
//                    {
//                        self.viewDidLoad()
//                        break;
//                    }
//                    //self.showAlert("\(i)" + "\(error)")
//
//                }
//                }
//                //showAlert("sleep wifi for 30sec")
//            }
//
//            else if(Vehicaldetails.sharedInstance.reachblevia == "cellular") /*||  Vehicaldetails.sharedInstance.reachblevia == "notreachable"*/
//            {
//
//            self.navigationItem.title = "Error"
//            showAlert("\(error)")
//            scrollview.hidden = true
//            warningLable.hidden = false
//            warningLable.text = "Cannot connect to cloud server.please check your internet connection."
//            refreshButton.hidden = false
////                let Count = 4
////                for i in 0  ..< Count
////                {
////
//                    viewDidLoad()
////                    showAlert("\(i)" + "\(error)")
////                }
//
//            }
//            else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
//                self.navigationItem.title = "Error"
//                showAlert("\(error)")
//                scrollview.hidden = true
//                warningLable.hidden = false
//                warningLable.text = "Cannot connect to cloud server.please check your internet connection."
//                refreshButton.hidden = false
//                for i in 1...2
//                {
//                    //
//                    print(i)
//                    if(currentlocation == nil)
//                    {
//                        data = web.checkApprove(uuid,lat:"\(0)",long:"\(0)")
//                    }else{
//                     data = web.checkApprove(uuid,lat:"\(sourcelat)",long:"\(sourcelong)")
//                    }
//                    let Split:NSArray = data.componentsSeparatedByString("#")
//                    reply = Split[0] as! String
//                    error = Split[1]as! String
//                    if(reply == "-1")
//                    {showAlert("Cannot connect to cloud server. Please check your internet connection. \n \(error)")}
//                    else
//                    {
//                        viewDidLoad()
//                        break;
//                    }
//                    //showAlert("\(i)" + "\(error)")
//
//                }
//
//
//
//            }
//        }
//        else {
//        let data1:NSData = reply.dataUsingEncoding(NSUTF8StringEncoding)!
//        do {
//            sysdata = try NSJSONSerialization.JSONObjectWithData(data1, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//        }catch let error as NSError {
//            print ("Error: \(error.domain)")
//        }
//        print(sysdata)
//
//            let Message = sysdata["ResponceMessage"] as! NSString
//            let ResponseText = sysdata["ResponceText"] as! NSString
//            if(Message == "success") {
//            let objUserData = sysdata.valueForKey("objUserData") as! NSDictionary
//           // self.navigationItem.title = "Select Hose"
//            let Email = objUserData.valueForKey("Email") as! NSString
//            let IMEI_UDID = objUserData.valueForKey("IMEI_UDID") as! NSString
//            let IsApproved = objUserData.valueForKey("IsApproved") as! NSString
//            let PersonName = objUserData.valueForKey("PersonName") as! NSString
//            let PhoneNumber = objUserData.valueForKey("PhoneNumber") as! NSString
//                IsOdoMeterRequire = objUserData.valueForKey("IsOdoMeterRequire") as! NSString as String
//                IsLoginRequire = objUserData.valueForKey("IsLoginRequire") as! NSString as String
//
//
//                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
//                defaults.setObject(PersonName, forKey: "firstName")
//                defaults.setObject(Email, forKey: "address")
//                defaults.setObject(PhoneNumber, forKey: "mobile")
//                defaults.setObject(uuid, forKey: "uuid")
//                defaults.setObject(1, forKey: "Register")
//
//            print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
//
//            }
//            else if(Message == "fail"){ }
//
//        defaults.setObject(uuid, forKey: "uuid")
//
//        if(Message == "success") {
//
//            scrollview.hidden = false
//            warningLable.hidden = true
//            refreshButton.hidden = true
//
//            self.wifiNameTextField.placeholder = "Touch to select Site"
//            self.wifiNameTextField.inputView = pickerViewLocation
//            self.pickerViewLocation.delegate = self
//
//        do {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        currentlocation = locationManager.location
////            if(currentlocation == nil)
////            {
//////                scrollview.hidden = true
//////                warningLable.hidden = false
//////                warningLable.text = "Please allow GPS."
//////                refreshButton.hidden = false
////            }
////            else {
////                sourcelat = currentlocation.coordinate.latitude
////                sourcelong = currentlocation.coordinate.longitude
////                print (sourcelat,sourcelong)
//
//            _ = defaults.stringForKey("firstName")
//            _ = defaults.stringForKey("address")
//            _ = defaults.stringForKey("mobile")
//            _ = defaults.stringForKey("uuid")
//
//            //IF USER IF Approved Get information from server like site,ssid,pwd,hose
//
//            do{
//                systemdata = try NSJSONSerialization.JSONObjectWithData(data1, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//            }catch let error as NSError {
//                print ("Error: \(error.domain)")
//                print ("Error: \(error)")
//            }
//            print(systemdata)
//            ssid = []
//
//
//                    let Json = systemdata.valueForKey("SSIDDataObj") as! NSArray
//                    let rowCount = Json.count
//                    let index: Int = 0
//                    for i in 0  ..< rowCount
//                    {
//
//                        let JsonRow = Json[i] as! NSDictionary
//                        let Message = JsonRow["ResponceMessage"] as! NSString
//                        let ResponseText = JsonRow["ResponceText"] as! NSString
//                        if(Message == "success") {
//
//                        let JsonRow = Json[i] as! NSDictionary
//                        let SiteName = JsonRow["SiteName"] as! NSString
//                            location.append(SiteName as String)
//                            let ReplaceableHoseName = JsonRow["ReplaceableHoseName"] as! NSString
//                            ReplaceableHosename.append(ReplaceableHoseName as String)
//
//                            print(ssid)
//                            defaults.setObject(ssid, forKey: "SSID")
//                        defaults.setObject(siteID, forKey: "SiteID")
//
//                        Ulocation = location.removeDuplicates()
//
//                        if(Ulocation.count == 1)
//                        {
//                            //locationTextField.text =  Ulocation[0]
//                           // selectHoseTextField.enabled = true
//                        }
//                       // let SiteName = JsonRow["SiteName"] as! NSString
//                        if(Ulocation[index] == SiteName as String){
//                            let WifiSSId = JsonRow["WifiSSId"] as! NSString
//                            let Password = JsonRow["ReplaceableHoseName"] as! NSString
//                            let hosename = JsonRow["HoseNumber"] as! NSString
//                            let Sitid = JsonRow["SiteId"] as! NSString
//                            let HoseID = JsonRow["HoseId"] as! NSString
//                            let IsHoseNameReplaced = JsonRow["IsHoseNameReplaced"] as! NSString
//                            IsBusy = JsonRow["IsBusy"] as! NSString as String
//
//
//                            Vehicaldetails.sharedInstance.IsHoseNameReplaced = IsHoseNameReplaced as String
//                            Vehicaldetails.sharedInstance.HoseID = HoseID as String
//
//                                ssid.append(WifiSSId as String)
//
//                            location.append(SiteName as String)
//                            Pass.append(Password as String)
//                            Uhosenumber.append(hosename as String)
//                            siteID.append(Sitid as String)
//                            print(Uhosenumber)
//                        }
//                    }
//                        else if(Message == "fail")
//                        {
//                            self.navigationItem.title = "Error"
//                            scrollview.hidden = true
//                            warningLable.hidden = false
//                            refreshButton.hidden = false
//                            warningLable.text = "\(ResponseText)"//no hose found Please contact administrater"
//                        }
//
//                }
//
//                if(Uhosenumber.count == 1)
//                {
//
//
//                    let siteid = siteID[0]
//                    let ssId = ssid[0]
//
//                    self.wifiNameTextField.text = ssid[0]
//
//                    Vehicaldetails.sharedInstance.siteID = siteid
//                    Vehicaldetails.sharedInstance.SSId = ssId
//                    defaults.setObject(siteid, forKey: "SiteID")
//
//
//                }
//
//
//
//            }
//
//       }
//
//        //USER IS NOT REGISTER TO SYSTEM
//        else if(ResponseText == "New Registration") {
//
//            let appDel = UIApplication.sharedApplication().delegate! as! AppDelegate
//            defaults.setObject(0, forKey: "Register")
//            // Call a method on the CustomController property of the AppDelegate
//           
//            appDel.start()
//        }
//
//        else if(Message == "fail") {
//
//            defaults.setObject("false", forKey: "checkApproved")
//            scrollview.hidden = true
//            warningLable.hidden = false
//            refreshButton.hidden = false
//            self.navigationItem.title = "Error"
//            warningLable.text = "Your Registration request is not approved yet. It is marked Inactive in the Company Software. Please contact your company’s administrator."//"Thank you for registering. Your request has been sent for the approval. You will be able to proceed with the aplication after your request has been approved by the administrator. Your registration request is still not approved. Please contact administrator."
//        } else if(ResponseText == "New Registration") {
//             performSegueWithIdentifier("Register", sender: self)
//        }
//
//        }
//        // Do any additional setup after loading the view.
//    }
//
//    
//
//    func sortData()
//    {
//        for name in 0 ..< Ulocation.count {
//
//        let Json = systemdata.valueForKey("SSIDDataObj") as! NSArray
//        let rowCount = Json.count
//        for i in 0  ..< rowCount
//        {
//            let JsonRow = Json[i] as! NSDictionary
//            let SiteName = JsonRow["SiteName"] as! NSString
//            if(Ulocation[name] == SiteName as String)
//            {
//                let WifiSSId = JsonRow["WifiSSId"] as! NSString
//                let Password = JsonRow["Password"] as! NSString
//                let hosename = JsonRow["HoseNumber"] as! NSString
//                //let Sitid = JsonRow["SiteId"] as! NSString
//                ssid.append(WifiSSId as String)
//                Pass.append(Password as String)
//                Uhosenumber.append(hosename as String)
//             }
//          }
//       }
//    }
//
//
//    func sleep() {
//        let Url:String = "http://192.168.4.1/config?command=diswifi"
//        let request: NSMutableURLRequest = NSMutableURLRequest(URL:NSURL(string:Url)!)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPMethod = "POST"
//        let bodyData = "{\"wifi_request\":{\"time\":15}}"
//        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
//        //request.HTTPBodyStream = NSInputStream(data: bodyData.dataUsingEncoding(NSUTF8StringEncoding)!)
//
//
//        let session = NSURLSession.sharedSession()
//        //let semaphore = dispatch_semaphore_create(0)
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: NSUTF8StringEncoding))
//                 self.reply = NSString(data: data, encoding:NSASCIIStringEncoding)as! String
//                print(self.reply)
//                if(self.reply != "")
//                {
//                    self.viewDidLoad()
//                }
//                print(response)
//                if let httpResponse = response as? NSHTTPURLResponse {
//                    print("Status code: (\(httpResponse.statusCode))")
//                    if(httpResponse.statusCode != 200)
//                    {
//
//                        self.sleep()
//
//                    }
//                    else if(httpResponse.statusCode == 200 || self.reply != "")
//                    {
//                        //self.viewDidLoad()
//                    }
//                }
//
//
//                "\(self.reply)"
//                if(self.reply != "")
//                {
//                    //self.viewDidLoad()
//                }
//
//            } else {
//                print(error)
//                self.reply = "-1"
//            }
//           // dispatch_semaphore_signal(semaphore)
//        }
//
//        task.resume()
//        //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
//        
//    }
//
//    @IBAction func Helptext(sender: AnyObject) {
//
//      ///  showAlert("If you are using this hose for the first time, you may need to enter the password of the Selected Wifi. \nPlease click on Copy password to save it on the clipboard. \nPlease paste it when app asks for the password while connecting to FS wifi.")
//
//    }
//
//
    func showAlert(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        alertController
        // Change Message With Color and Font

        let message  = message
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [ NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Georgia", size: 24.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.characters.count))

            alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//  
//    
//    @IBAction func refreshAction(sender: AnyObject) {
//        viewDidLoad()
//
//    }
//
//    func numberOfComponentsInPickerView(pickerView: UIPickerView!)-> Int
//    {
//        if(pickerView == pickerViewLocation)
//        {
//            return 1
//        }
//        return 1
//    }
//    
//    func pickerView(pickerView: UIPickerView!,numberOfRowsInComponent component: Int)-> Int
//    {
//        if(pickerView == pickerViewLocation)
//        {
//            print(ssid.count)
//            return ssid.count
//
//        }
//        return 0
//    }
//    
//    func pickerView(pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int)-> String?
//    {
//        if(pickerView == pickerViewLocation)
//        {
//            return ssid[row]
//        }
//        return ""
//    }
//    
//    func pickerView(pickerView: UIPickerView,didSelectRow row: Int, inComponent component: Int)
//    {
//         var index: Int = 0
//
//        if(pickerView == pickerViewLocation)
//        {
//            wifiNameTextField.text = ssid[row]
//            for v in 0  ..< location.count
//            {
//                if(ssid[v] == ssid[row])
//                {
//                    index = v
//                    break
//                }
//            }
//            let siteid = siteID[index]
//                        let ssId = ssid[index]
//                        self.wifiNameTextField.text = ssid[index]
//
//                        Vehicaldetails.sharedInstance.siteID = siteid
//                        Vehicaldetails.sharedInstance.SSId = ssId
//                        defaults.setObject(siteid, forKey: "SiteID")
//
//            let Json = systemdata.valueForKey("SSIDDataObj") as! NSArray
//            let rowCount = Json.count
//
//            for i in 0  ..< rowCount
//            {
//                let JsonRow = Json[i] as! NSDictionary
//                let SiteName = JsonRow["SiteName"] as! NSString
//                if(ssid[index] == SiteName as String){
//                    let WifiSSId = JsonRow["WifiSSId"] as! NSString
//                    let Password = JsonRow["InitialHoseName"] as! NSString
//                    let hosename = JsonRow["HoseNumber"] as! NSString
//                    let Sitid = JsonRow["SiteId"] as! NSString
//
//                    
//                    ssid.append(WifiSSId as String)
//                    location.append(SiteName as String)
//                    Pass.append(Password as String)
//                    Uhosenumber.append(hosename as String)
//                    siteID.append(Sitid as String)
//                    print(Uhosenumber)
//                }
//            }
//
//            self.wifiNameTextField.text = ssid[index]
//
//        }
//    }
//    
//
//    @IBAction func actionGotoWifiSettings(sender: AnyObject) {
//
//        if(wifiNameTextField.text == "" )
//        {
//           showAlert("please select Site Name to proceed")
//            wifiNameTextField.becomeFirstResponder()
//        }
//        else if(IsBusy == "Y"){
//            let alert = UIAlertController(title: "Warning", message: NSLocalizedString("Hose In Use \n Please try after sometime", comment:""), preferredStyle: UIAlertControllerStyle.Alert )
//            let backView = alert.view.subviews.last?.subviews.last
//            backView?.layer.cornerRadius = 10.0
//            backView?.backgroundColor = UIColor.whiteColor()
//            var messageMutableString = NSMutableAttributedString()
//            messageMutableString = NSMutableAttributedString(string: "Hose In Use \n Please try after sometime" as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
//            messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSRange(location:0,length:"Hose In Use \n Please try after sometime".characters.count))
//            alert.setValue(messageMutableString, forKey: "attributedMessage")
//
//
//            let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertActionStyle.Default) { action in //self.//performSegueWithIdentifier("logout", sender: self)//(submity) -> Void in
//
//                // Call a method on the CustomController property of the AppDelegate
//                                    self.viewDidLoad()
//
//            }
//
//            alert.addAction(okAction)
//           // alert.addAction(cancelAction)
//            
//            self.presentViewController(alert, animated: true, completion: nil)
//            //showAlert("Hose In Use \n Please try after sometime")
//        }
//        else if(IsBusy == "N")
//        {
//
//            self.performSegueWithIdentifier("connect", sender: self)
//            Vehicaldetails.sharedInstance.siteName = wifiNameTextField.text!
//        }
//    }
//    
//    func openWiFiPrefernces() {
//        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
//        let app = UIApplication.sharedApplication()// .shared
//        app.openURL(url!)
//       
//    }
}
