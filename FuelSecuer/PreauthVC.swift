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
import CommonCrypto


extension Data{

    func aesEncrypt( keyData: Data, ivData: Data, operation: Int) -> Data {
        let dataLength = self.count
        let cryptLength  = size_t(dataLength + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)

        let keyLength = size_t(kCCKeySizeAES128)
        let options = CCOptions(kCCOptionPKCS7Padding)


        var numBytesEncrypted :size_t = 0


        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            self.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, dataLength,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)

        } else {
            print("Error: \(cryptStatus)")
        }

        return cryptData;
    }

}



class PreauthVC: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,UIPickerViewDelegate,StreamDelegate {
    var web = Webservices()
    var currentlocation :CLLocation!

    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!
    var preauthalert = false
    let defaults = UserDefaults.standard
    var timer:Timer = Timer()
    var setFuelLimitePerDayOnce:Bool!
    var reply:String!
    var IsDepartmentRequire:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var results = [NSManagedObject]()
    var Transaction_ID = [NSManagedObject]()
    var cf = Commanfunction()
    var unsync = Sync_Unsynctransactions()

    var sysdata:NSDictionary!
    var systemdata:NSDictionary!
    var IsVehicleNumberRequire:String!
    var pickerViewLocation: UIPickerView = UIPickerView()
    var ssid = [String]()
    var Pass = [String]()
    var location = [String]()
    var PulserRatio = [String]()
    var PulserStopTimelist = [String]()
    var PumpOffTimelist = [String]()
    var PumpOnTimelist = [String]()
    var Transaction_Id = [String]()
    var Available_preauthtransactions = [String]()
    var Ulocation = [String]()
    var siteID = [String]()
    var Uhosenumber = [String]()
    var IsLink_Flagged = [String]()
    var LinkFlagged_Message = [String]()
    var IsTank_Empty = [String]()
    
    var IsOdoMeterRequire:String!
    var IsLoginRequire:String!
    var uuid:String!
    
    var OriginalNamesOfLink = [NSArray]()
    var Bluetooth_MacAddress = [String]()
    var Mac_Address = [String]()
    var Communication_Type = [String]()
    
    var notransactionid :String!
    var preauthusyncdatatimer:Timer = Timer()
    var ResponceMessageUpload:String = ""
    var sysdata1:NSDictionary!

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
    @IBOutlet var suportinfotext: UILabel!
    @IBAction func preAuthentication(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
//    override func viewDidLoad() {

    //        super.viewDidLoad()
    //        version_2.text = "Version \(Version)"
    //        version.text = "Version \(Version)"
    //        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
    //            itembarbutton.title = "English"
    //            //defaults.set("es", forKey: "Language")
    //
    //        }else  if(Vehicaldetails.sharedInstance.Language == ""){
    //            itembarbutton.title = "Spanish"
    //            //defaults.set("en", forKey: "Language")
    //        }
    //        wifiNameTextField.delegate = self
    //        if(preauthalert == false){
    //        Alert(message: "You currently have no cellular service and will be performing an Offline Transaction. After finishing, please leave app open until you regain service.")
    //        }
    //
    //        selecthose.text = NSLocalizedString("Select Hose to use", comment:"")
    //        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
    //        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State())
    //        doneButton.addTarget(self, action: #selector(tapAction), for: UIControl.Event.touchUpInside);
    //        doneButton.backgroundColor = UIColor .black
    //        wifiNameTextField.returnKeyType = .done
    //        wifiNameTextField.inputAccessoryView = doneButton
    //        wifiNameTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    //
    //        Vehicaldetails.sharedInstance.deptno = ""
//        Vehicaldetails.sharedInstance.Personalpinno = ""
//        Vehicaldetails.sharedInstance.Other = ""
//       // Vehicaldetails.sharedInstance.Odometerno = ""
//        Vehicaldetails.sharedInstance.hours = ""
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        currentlocation = locationManager.location
//
//        //let uuid:String
//        var uuid:String = ""
//        if(brandname == "FluidSecure"){
//        if(defaults.string(forKey: "\(brandname)") != nil) {
//            uuid = defaults.string(forKey: "\(brandname)")!//UUID().uuidString
//            KeychainService.savePassword(token: uuid as NSString)
//        }
//
//        }//= UIDevice.current.identifierForVendor!.uuidString
//        let password = KeychainService.loadPassword()
//        if(password == nil){
//            uuid = UIDevice.current.identifierForVendor!.uuidString
//            KeychainService.savePassword(token: uuid as NSString)
//        }
//        else{
//            let password = KeychainService.loadPassword()
//            print(password!)// password = "Pa55worD"
//            uuid = password! as String
//        }
//        var myMutableStringTitle = NSMutableAttributedString()
//        let Name  = "Enter Title" // PlaceHolderText
//
//        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
//        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
//        wifiNameTextField.attributedPlaceholder = myMutableStringTitle
//        _ = defaults.array(forKey: "SSID")
//        var reply:String!
//        var error:String!
//        //var data:String!
//
//        if(currentlocation == nil)
//        {
//            let data =  web.checkApprove(uuid: uuid,lat:"\(0)",long:"\(0)")
//            let Split = data.components(separatedBy: "#")
//            reply = Split[0]
//            if(reply != "-1"){
//                cf.DeleteFileInApp(fileName: "getSites.txt")
//                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
//                self.present(controller, animated: true, completion: nil)
//            }
//            else if(reply == "-1"){
//                if(cf.checkPath(fileName: "getSites.txt") == true) {
//                    reply = cf.ReadFile(fileName: "getSites.txt")
//                }
//            }
//        }
//        else {
//            sourcelat = currentlocation.coordinate.latitude
//            sourcelong = currentlocation.coordinate.longitude
//            //print (sourcelat,sourcelong)
//            Vehicaldetails.sharedInstance.Lat = sourcelat
//            Vehicaldetails.sharedInstance.Long = sourcelong
//            let data = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
//            let Split = data.components(separatedBy: "#")
//            reply = Split[0]
//            if(reply != "-1"){
//                cf.DeleteFileInApp(fileName: "getSites.txt")
//                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
//                self.present(controller, animated: true, completion: nil)
//            }
//            else if(reply == "-1"){
//                if(cf.checkPath(fileName: "getSites.txt") == true) {
//                    reply = cf.ReadFile(fileName: "getSites.txt")
//                }
//            }
//        }
//
//        //Check User approved or not from server
//
//        if(reply == "-1")
//        {
//            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
//            {
//                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//                scrollview.isHidden = true
//                version.isHidden = false
//                refreshButton.isHidden = false
//                showAlertSetting(message: NSLocalizedString("warning_NoInternet_Connection", comment:""))//"Cannot connect to cloud server. Please connect to the network having the internet")
//            }
//
//            else if(Vehicaldetails.sharedInstance.reachblevia == "cellular") /*||  Vehicaldetails.sharedInstance.reachblevia == "notreachable"*/
//            {
//                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//               // showAlert(message: "\(error)")
//                scrollview.isHidden = true
//                version.isHidden = false
//                warningLable.isHidden = false
//                warningLable.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")//"Cannot connect to cloud server.please check your internet connection."
//                refreshButton.isHidden = false
//            }
//            else if(Vehicaldetails.sharedInstance.reachblevia == "notreachable") {
//                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//                if(error == nil){
//                    showAlert(message: NSLocalizedString("Preauthtrans",comment:"") )//"Pre-Authorized transactions are not Available.")
//                }
//                scrollview.isHidden = true
//                version.isHidden = false
//                warningLable.isHidden = false
//                warningLable.text = NSLocalizedString("warning_NoInternet_Connection", comment:"")//"Cannot connect to cloud server. Please check your internet connection."
//                refreshButton.isHidden = false
//                for i in 1...2
//                {
//                    print(i)
//                    if(currentlocation == nil)
//                    {
//
//                    }else{
//                        // data = web.checkApprove(uuid,lat:"\(sourcelat)",long:"\(sourcelong)")
//                    }
//                    //                     let Split = data.components(separatedBy: "#")
//                    //                    reply = Split[0]
//                    //                    error = Split[1]
//                    if(reply == "-1")
//                    {//showAlert("Cannot connect to cloud server. Please check your internet connection. \n \(error)")
//                    }
//                    else
//                    {
//                        // viewDidLoad()
//                        break;
//                    }
//                }
//            }
//        }
//        else {
//
//            let data1:Data = reply.data(using: String.Encoding.utf8)! as Data
//            do {
//                sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//            }catch let error as NSError {
//                print ("Error: \(error.domain)")
//            }
//           /// print(sysdata)
//
//            let Message = sysdata["ResponceMessage"] as! NSString
//            let ResponseText = sysdata["ResponceText"] as! NSString
//            if(Message == "success") {
//                self.navigationItem.title = "FluidSecure"
//                let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
//                let Email = objUserData.value(forKey: "Email") as! NSString
//                let IMEI_UDID = objUserData.value(forKey: "IMEI_UDID") as! NSString
//                let IsApproved = objUserData.value(forKey: "IsApproved") as! NSString
//                let PersonName = objUserData.value(forKey: "PersonName") as! NSString
//                let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
//                IsOdoMeterRequire = objUserData.value(forKey: "IsOdoMeterRequire") as! NSString as String
//                IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
//                IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
//                IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
//                IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
//
//                infotext.text = NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") + ": \(Email)"
//                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
//                Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
//                Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
//                Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
//
//                defaults.set(PersonName, forKey: "firstName")
//                defaults.set(Email, forKey: "address")
//                defaults.set(PhoneNumber, forKey: "mobile")
//                defaults.set(uuid, forKey: "uuid")
//                defaults.set(1, forKey: "Register")
//
//                print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
//                _ = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
//                    //    Get Image from Document Directory :
//
//
//                    let fileManager = FileManager.default
//
//                    let imagePAth = (cf.getDirectoryPath() as NSString).appendingPathComponent("logoimage.jpg")
//
//                    if fileManager.fileExists(atPath: imagePAth){
//
//                        let url = Bundle.main.url(forAuxiliaryExecutable: imagePAth)// (forResource: "image", withExtension: "png")!
//                       let imageData = try! Data(contentsOf: url!)
//                                                  // let _ = UIImage(data: imageData)
//                         self.Companylogo.image = UIImage(data: imageData)//UIImage(contentsOfFile: imagePAth)
//                        //self.Companylogo.image = UIImage(contentsOfFile: imagePAth)
//
//                    }else{
//
//                        print("No Image")
//                    }
//            }
//            else if(Message == "fail"){ }
//
//            defaults.set(uuid, forKey: "uuid")
//
//            if(Message == "success") {
//
//                scrollview.isHidden = false
//                version.isHidden = true
//                warningLable.isHidden = true
//                refreshButton.isHidden = true
//
//                self.wifiNameTextField.placeholder = NSLocalizedString("Touch to select Site", comment:"")
//                self.wifiNameTextField.textColor = UIColor.white
//                self.wifiNameTextField.inputView = pickerViewLocation
//                self.pickerViewLocation.delegate = self
//
//                do {
//                    _ = defaults.string(forKey: "firstName")
//                    _ = defaults.string(forKey: "address")
//                    _ = defaults.string(forKey: "mobile")
//                    _ = defaults.string(forKey: "uuid")
//
//                    //IF USER IF Approved Get information from server like site,ssid,pwd,hose
//
//                    do{
//                        systemdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                    }catch let error as NSError {
//                        print ("Error: \(error.domain)")
//                        print ("Error: \(error)")
//                    }
//                    print(systemdata)
//                    ssid = []
//                    Communication_Type = []
//                    Vehicaldetails.sharedInstance.Transaction_id = []
//
//                    let objUserDataT = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
//                    let PreAuthJsonT = objUserDataT.value(forKey: "TransactionObj") as! NSArray
//                    let PreAuthrowCountT = PreAuthJsonT.count
//                    for i in 0  ..< PreAuthrowCountT
//                    {
//                        let PreAuthJsonRow = PreAuthJsonT[i] as! NSDictionary
//                        let MessageTransactionObj = PreAuthJsonRow["ResponceMessage"] as! NSString
//
//                        if(MessageTransactionObj == "success"){
//                            let T_Id = PreAuthJsonRow["TransactionId"] as! NSString
//                            Transaction_Id.append(T_Id as String)
//                        }
//                    }
//
//                    let objUserData = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
//                    //get Fuel limit per day from server
//                    let FuelLimitPerDay = objUserData.value(forKey: "FuelLimitPerDay") as! NSString
//                    let FuelLimitPerTxn = objUserData.value(forKey:"FuelLimitPerTxn") as! NSString
//                    _ = objUserData.value(forKey: "PreAuthDataDwnldFreq") as! NSString
//                    _ = objUserData.value(forKey:"PreAuthDataDownloadDay") as! NSString
//                    _ = objUserData.value(forKey: "PreAuthDataDownloadTimeInHrs") as! NSString
//                    _ = objUserData.value(forKey:"PreAuthDataDownloadTimeInMin") as! NSString
//                    _ = objUserData.value(forKey: "PreAuthVehicleDataFilePath") as! NSString
//                    _ = objUserData.value(forKey:"PreAuthVehicleDataFilesCount") as! NSString
//
//                       // defaults.set(FuelLimitPerTxn, forKey: "GetFuelLimitPerTxn")
//
//                    let getfirsttimeFuelLimitPerDay = self.defaults.string(forKey:"GetFuelLimitPerDay")
//                     //  let getfirsttimeFuelLimitPerTxn =
//                    Vehicaldetails.sharedInstance.FuelLimitPerTnx = FuelLimitPerTxn as String
//
//                    let dateFormatter = DateFormatter()
//                           dateFormatter.dateFormat = "yyyy-MM-dd"
//                           let strDate = dateFormatter.string(from: Date())
//
//
//                    let todaydate = defaults.string(forKey:"date")
//                    if(todaydate == strDate){
//                    print(Int(getfirsttimeFuelLimitPerDay! as String) == Int(FuelLimitPerDay as String))
//
//                        if(Int(getfirsttimeFuelLimitPerDay! as String) == Int(FuelLimitPerDay as String)){}
//                        else
//                        {
//                            if(Int(FuelLimitPerDay as String) == 0)
//                            {
//                                defaults.set(FuelLimitPerDay, forKey: "FuelLimitPerDay")
//                                defaults.set(FuelLimitPerDay, forKey: "GetFuelLimitPerDay")
//                            }else{
//
//                            defaults.set(strDate,forKey:"date")
//                             let FuelLimit_PerDay = self.defaults.string(forKey:"FuelLimitPerDay")
//                            let FLPD:String = FuelLimit_PerDay!
//                            let updateFuelLimitPerDay = Int(getfirsttimeFuelLimitPerDay!)! - Int(FLPD)!
//                            let updateFLPD = Int(FuelLimitPerDay as String)! - updateFuelLimitPerDay
//
//                            defaults.set(updateFLPD, forKey: "FuelLimitPerDay")
//                            defaults.set(FuelLimitPerDay, forKey: "GetFuelLimitPerDay")
//                            setFuelLimitePerDayOnce = false
//                            }
//                        }
//
//
//                    }else
//                    {
//                        defaults.set(strDate,forKey:"date")
//                        defaults.set(FuelLimitPerDay, forKey: "FuelLimitPerDay")
//                        defaults.set(FuelLimitPerDay, forKey: "GetFuelLimitPerDay")
//                        setFuelLimitePerDayOnce = false
//                    }
//
//                    let PreAuthJson = objUserData.value(forKey: "SitesObj") as! NSArray
//                    let PreAuthrowCount = PreAuthJson.count
//
//
//                    for i in 0  ..< PreAuthrowCount
//                    {
//                        let PreAuthJsonRow = PreAuthJson[i] as! NSDictionary
//                        let Message = PreAuthJsonRow["ResponceMessage"] as! NSString
//                        let ResponseText = PreAuthJsonRow["ResponceText"] as! NSString
//                        if(Message == "success") {
//
//                            let JsonRow = PreAuthJson[i] as! NSDictionary
//
//                            print(ssid)
//                            defaults.set(ssid, forKey: "SSID")
//                            defaults.set(siteID, forKey: "SiteID")
//
//                            Ulocation = location.removeDuplicates()
//
//                            if(Ulocation.count == 1)
//                            {}
//
//                            let WifiSSId = JsonRow["WifiSSId"] as! NSString
////                            let PulserRatio = JsonRow["PulserRatio"] as! NSString
//                            let DecimalPulserRatio = JsonRow["DecimalPulserRatio"] as! NSNumber
//                            let FuelTypeId = JsonRow["FuelTypeId"] as! NSString
//                            let Sitid = JsonRow["SiteId"] as! NSString
//                            let pulsarstoptime = JsonRow["PulserStopTime"] as! NSString
//                            let PumpOffTime = JsonRow["PumpOffTime"] as! NSString
//                            let PumpOnTime = JsonRow["PumpOnTime"] as! NSString
//
//                            let MacAddress = JsonRow["MacAddress"] as! NSString as String
//                            let BluetoothMacAddress = JsonRow["BluetoothMacAddress"] as! NSString as String
//                            let HubLinkCommunication = JsonRow["HubLinkCommunication"] as! NSString
//                            Communication_Type.append(HubLinkCommunication as String)
//                            Bluetooth_MacAddress.append(BluetoothMacAddress as String)
//                            Mac_Address.append(MacAddress as String)
//                            ssid.append(WifiSSId as String)
//                            Ulocation = ssid.removeDuplicates()
//
//                            PulserRatio.append("\(DecimalPulserRatio)" as String)
//                            Pass.append(FuelTypeId as String)
//                            PulserStopTimelist.append(pulsarstoptime as String)
//                            PumpOffTimelist.append(PumpOffTime as String)
//                            PumpOnTimelist.append(PumpOnTime as String)
//
//                            siteID.append(Sitid as String)
//                            print(Uhosenumber)
//
//                        }
//                        else if(Message == "fail")
//                        {
//                            self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//                            scrollview.isHidden = true
//                            version.isHidden = false
//                            warningLable.isHidden = false
//                            refreshButton.isHidden = false
//                            warningLable.text = "\(ResponseText)"//no hose found Please contact administrater"
//                        }
//                    }
//
//                    let managedObjectContext = appDelegate.managedObjectContext
//                    let tranid = objUserData.value(forKey: "TransactionObj") as! NSArray
//                    let id = tranid.count
//
//                    for i in 0  ..< id
//                    {
//                        let PreAuthJsonRow = tranid[i] as! NSDictionary
//                        let Message = PreAuthJsonRow["ResponceMessage"] as! NSString
//                        let ResponseText = PreAuthJsonRow["ResponceText"] as! NSString
//                        if(Message == "success") {
//                            let TransactionId = PreAuthJsonRow["TransactionId"] as! NSString
//
//                            let entityDescription = NSEntityDescription.entity(forEntityName: "TransactionID",in: managedObjectContext)
//                            let ID = TransactionID(entity: entityDescription!, insertInto: managedObjectContext)
//                            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TransactionID")
//                            fetchRequest.returnsObjectsAsFaults = false
//                            let resultPredicate2 = NSPredicate (format:"(transactionid == %@)",TransactionId)
//                            let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate2])
//                            fetchRequest.predicate = compound
//                            do{
//                                results = try context.fetch(fetchRequest) as! [NSManagedObject]
//
//                            } catch let error as NSError {
//                                print ("Error: \(error.domain)")
//                            }
//                            Transaction_ID = []
//                            Transaction_ID = results
//                            print(results)
//
//                            if (results == [])
//                            {
//                                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
//                                request.returnsObjectsAsFaults = false
//                                ID.isactive = "false"
//                                ID.transactionid = TransactionId as String
//
//                                do{
//                                    try managedObjectContext.save()
//                                }catch let error as NSError {
//                                    print ("Error: \(error.domain)")
//                                }
//                                let Transactioniddeatils = Transaction_id(isactive: ID.isactive!,TransactionID: TransactionId as String)
//                                Vehicaldetails.sharedInstance.Transaction_id.add(Transactioniddeatils)
//                            }
//                            else {
//
//                                let count = Transaction_ID.count
//                                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
//                                request.returnsObjectsAsFaults = false
//
//                                for i in 0  ..< count
//                                {
//                                    let certificate = self.Transaction_ID[i]
//                                    let is_active = certificate.value(forKey: "isactive") as! String
//
//                                    _ = certificate.value(forKey: "transactionid") as! String
//
//                                    do{
//                                        try managedObjectContext.save()
//
//                                    }catch let error as NSError {
//                                        print ("Error: \(error.domain)")
//                                    }
//
//                                    let Transactioniddeatils = Transaction_id(isactive: is_active,TransactionID: TransactionId as String)
//                                    Vehicaldetails.sharedInstance.Transaction_id.add(Transactioniddeatils)
//
//                                }
//                            }
//                        }
//
//                        else if(Message == "fail"){
//
//                            self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//                            scrollview.isHidden = true
//                            version.isHidden = false
//                            warningLable.isHidden = false
//                            refreshButton.isHidden = false
//                            warningLable.text = "\(ResponseText)"
//                            shownotransId(message: "\(ResponseText)")
//                        }
//                    }
//
//
//
//                     Uhosenumber = []
//                    location = []
//                    let Json = systemdata.value(forKey: "SSIDDataObj") as! NSArray
//                             let rowCount = Json.count
//                             let index: Int = 0
//                             for i in 0  ..< rowCount
//                             {
//                                 let JsonRow = Json[i] as! NSDictionary
//
//                                let SiteName = JsonRow["SiteName"] as! NSString
//                                location.append(SiteName as String)
//
//                                print(ssid)
////                                defaults.set(ssid, forKey: "SSID")
////                                defaults.set(siteID, forKey: "SiteID")
//                                Ulocation = location.removeDuplicates()
//
//                                if(Ulocation[index] == SiteName as String){
//
//
//                                    _ = JsonRow["WifiSSId"] as! NSString
//
//                                     let hosename = JsonRow["HoseNumber"] as! NSString
//                                     let Sitid = JsonRow["SiteId"] as! NSString
//                                     //ssid.append(WifiSSId as String)
//                                     location.append(SiteName as String)
//
//                                     Uhosenumber.append(hosename as String)
//                                     siteID.append(Sitid as String)
//                                     print(Uhosenumber)
//                                }
//                             }
//
//
//
//
//                    if(Uhosenumber.count == 1)
//                    {
//                        let index: Int = 0
//                        let siteid = siteID[index]
//                            let ssId = ssid[index]
//                            self.wifiNameTextField.text = ssid[index]
//                            Vehicaldetails.sharedInstance.siteID = siteid
//                            Vehicaldetails.sharedInstance.SSId = ssId
//                            Vehicaldetails.sharedInstance.PulseRatio = PulserRatio[index]
//                            Vehicaldetails.sharedInstance.FuelTypeId = Pass[index]
//                            Vehicaldetails.sharedInstance.PulserStopTime = PulserStopTimelist[index]
//                            Vehicaldetails.sharedInstance.pumpoff_time = PumpOffTimelist[index]
//                            print(Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.PulseRatio,Vehicaldetails.sharedInstance.FuelTypeId,Vehicaldetails.sharedInstance.pumpoff_time)
//
////                        let siteid = siteID[0]
////                        let ssId = ssid[0]
////
//
//
//                    }
//                }
//            }
//
//                //USER IS NOT REGISTER TO SYSTEM
//            else if(ResponseText == "New Registration") {
//
//                let appDel = UIApplication.shared.delegate! as! AppDelegate
//                defaults.set(0, forKey: "Register")
//                // Call a method on the CustomController property of the AppDelegate
//                self.web.sentlog(func_name: "Preauth", errorfromserverorlink: "", errorfromapp: "")
//               appDel.preauthstart()
//            }
//
//            else if(Message == "fail") {
//
//                defaults.set("false", forKey: "checkApproved")
//                scrollview.isHidden = true
//                version.isHidden = false
//                warningLable.isHidden = false
//                refreshButton.isHidden = false
//                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//                warningLable.text = NSLocalizedString("Regisration", comment:"") //+ defaults.string(forKey: "address")! + NSLocalizedString("registration1", comment:"")
//                //"Your Registration request is not approved yet. It is marked Inactive in the Company Software. Please contact your company’s administrator."
//            } else if(ResponseText == "New Registration") {
//                performSegue(withIdentifier: "Register", sender: self)
//            }
//        }
//
//        if(cf.getSSID() != "" ) {}
//        else {
//            //("SSID not found")
//        }
//        self.viewlable.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0).cgColor
//        let wifiSSid = Vehicaldetails.sharedInstance.SSId//getSSID()
//
//        defaults.set(wifiSSid, forKey: "wifiSSID")
//        // Do any additional setup after loading the view, typically from a nib.
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm MMM dd, yyyy"
//        let strDate = dateFormatter.string(from: Date())
//        datetime.text = strDate
//       // AvailablePreauthTransactions.text = NSLocalizedString("No_Pre-auth_transaction", comment:"") + "\(Available_preauthtransactions.count)"
//
//
//
//    }
    
    override func viewDidLoad()
    {
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
        
        if(preauthalert == false){
            //Alert(message: "You currently have no cellular service and will be performing an Offline Transaction. After finishing, please leave app open until you regain service.")
        }
        
        
        selecthose.text = NSLocalizedString("Select Hose To Use", comment:"")
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
        Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
        //= UIDevice.current.identifierForVendor!.uuidString
        
        var password = KeychainService.loadPassword()
        if(password == nil || password == ""){
            self.web.sentlog(func_name: "keychain service get \(password) ", errorfromserverorlink: "", errorfromapp: "")
            let preuuid = defaults.string(forKey: "uuid")
            if(preuuid == nil){
                let uuid:String = UIDevice.current.identifierForVendor!.uuidString
                KeychainService.savePassword(token: uuid as NSString)
            }
            else
            {
                KeychainService.savePassword(token: preuuid! as NSString)
                password = KeychainService.loadPassword()
                print(password!)//used this paasword (uuid)
                uuid = password! as String
            }
        }
        else{
            //            KeychainService.savePassword(token: "0B5C5D0B-70CE-4C75-8844-9E8938586489" as NSString)
            password = KeychainService.loadPassword()
            print(password!)//used this paasword (uuid)
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
                    showAlert(message: NSLocalizedString("Preauthtrans",comment:""), title: "")//"Pre-Authorized transactions are not Available.")
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
            if(sysdata == nil){
                
            }
           else{
            
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
                IsVehicleNumberRequire = objUserData.value(forKey: "IsVehicleNumberRequire") as! NSString as String
                IsOdoMeterRequire = objUserData.value(forKey: "IsOdoMeterRequire") as! NSString as String
                IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
                Vehicaldetails.sharedInstance.SupportPhonenumber = (objUserData.value(forKey: "SupportPhonenumber") as! NSString) as String
                Vehicaldetails.sharedInstance.SupportEmail = (objUserData.value(forKey: "SupportEmail") as! NSString) as String
                let ScreenNameForHours = objUserData.value(forKey: "ScreenNameForHours") as! String
                let ScreenNameForOdometer = objUserData.value(forKey: "ScreenNameForOdometer") as! String
                let ScreenNameForPersonnel = objUserData.value(forKey: "ScreenNameForPersonnel") as! String
                let ScreenNameForVehicle = objUserData.value(forKey: "ScreenNameForVehicle") as! String
                let ScreenNameForDepartment = objUserData.value(forKey: "ScreenNameForDepartment") as! String
                let OtherLabel = objUserData.value(forKey: "OtherLabel") as! String
                
                Vehicaldetails.sharedInstance.IsVehicleNumberRequire = IsVehicleNumberRequire
                Vehicaldetails.sharedInstance.ScreenNameForVehicle = ScreenNameForVehicle
                Vehicaldetails.sharedInstance.ScreenNameForPersonnel = ScreenNameForPersonnel
                Vehicaldetails.sharedInstance.ScreenNameForHours = ScreenNameForHours
                Vehicaldetails.sharedInstance.ScreenNameForOdometer = ScreenNameForOdometer
                Vehicaldetails.sharedInstance.ScreenNameForDepartment = ScreenNameForDepartment
                Vehicaldetails.sharedInstance.Otherlable = OtherLabel
                
                
                let IsNonValidateVehicle = objUserData.value(forKey:"IsNonValidateVehicle") as!NSString as String
                let IsNonValidateODOM = objUserData.value(forKey: "IsNonValidateODOM") as! NSString as String
                defaults.set(IsNonValidateVehicle, forKey: "IsNonValidateVehicle")
                defaults.set(IsOdoMeterRequire, forKey: "IsOdoMeterRequire")
                defaults.set(IsNonValidateODOM, forKey: "IsNonValidateODOM")
                
                infotext.text = NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") + ": \(Email)"
                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
                print("\(Vehicaldetails.sharedInstance.SupportEmail) or " + "\(Vehicaldetails.sharedInstance.SupportPhonenumber)")
                suportinfotext.text = "\(Vehicaldetails.sharedInstance.SupportEmail) or " + "\(Vehicaldetails.sharedInstance.SupportPhonenumber)"
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
                    
                    let url = Bundle.main.url(forAuxiliaryExecutable: imagePAth)// (forResource: "image", withExtension: "png")!
                    let imageData = try! Data(contentsOf: url!)
                    // let _ = UIImage(data: imageData)
                    self.Companylogo.image = UIImage(data: imageData)//UIImage(contentsOfFile: imagePAth)
                    //self.Companylogo.image = UIImage(contentsOfFile: imagePAth)
                    
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
                        systemdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    }catch let error as NSError {
                        print ("Error: \(error.domain)")
                        print ("Error: \(error)")
                    }
                    //    print(systemdata)
                    ssid = []
                    Vehicaldetails.sharedInstance.Transaction_id = []
                    OriginalNamesOfLink = []
                    Uhosenumber = []
                    location = []
                    ssid = []
                    Communication_Type = []
                    location = []
                    siteID = []
                    Bluetooth_MacAddress = []
                    Mac_Address = []
                    PulserRatio = []
                    
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
                    //get Fuel limit per day from server
                    let FuelLimitPerDay = objUserData.value(forKey: "FuelLimitPerDay") as! NSString
                    let FuelLimitPerTxn = objUserData.value(forKey:"FuelLimitPerTxn") as! NSString
                    //                    let PreAuthDataDwnldFreq = objUserData.value(forKey: "PreAuthDataDwnldFreq") as! NSString
                    //                    let PreAuthDataDownloadDay = objUserData.value(forKey:"PreAuthDataDownloadDay") as! NSString
                    //                    let PreAuthDataDownloadTimeInHrs = objUserData.value(forKey: "PreAuthDataDownloadTimeInHrs") as! NSString
                    //                    let PreAuthDataDownloadTimeInMin = objUserData.value(forKey:"PreAuthDataDownloadTimeInMin") as! NSString
                    //                   let PreAuthVehicleDataFilePath = objUserData.value(forKey: "PreAuthVehicleDataFilePath") as! NSString
                    //                   let PreAuthVehicleDataFilesCount = objUserData.value(forKey:"PreAuthVehicleDataFilesCount") as! NSString
                    let DoNotAllowOfflinePreauthorizedTransactions = objUserData.value(forKey: "DoNotAllowOfflinePreauthorizedTransactions") as! NSString
                    
                    Vehicaldetails.sharedInstance.DoNotAllowOfflinePreauthorizedTransactions = DoNotAllowOfflinePreauthorizedTransactions as String
                    // defaults.set(FuelLimitPerTxn, forKey: "GetFuelLimitPerTxn")
                    
                    let getfirsttimeFuelLimitPerDay = self.defaults.string(forKey:"GetFuelLimitPerDay")
                    //  let getfirsttimeFuelLimitPerTxn =
                    Vehicaldetails.sharedInstance.FuelLimitPerTnx = FuelLimitPerTxn as String
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let strDate = dateFormatter.string(from: Date())
                    
                    
                    let todaydate = defaults.string(forKey:"date")
                    if(todaydate == strDate){
                        print(Int(getfirsttimeFuelLimitPerDay! as String) == Int(FuelLimitPerDay as String))
                        
                        if(Int(getfirsttimeFuelLimitPerDay! as String) == Int(FuelLimitPerDay as String)){}
                        else
                        {
                            if(Int(FuelLimitPerDay as String) == 0)
                            {
                                defaults.set(FuelLimitPerDay, forKey: "FuelLimitPerDay")
                                defaults.set(FuelLimitPerDay, forKey: "GetFuelLimitPerDay")
                            }else{
                                
                                defaults.set(strDate,forKey:"date")
                                let FuelLimit_PerDay = self.defaults.string(forKey:"FuelLimitPerDay")
                                let FLPD:String = FuelLimit_PerDay!
                                let updateFuelLimitPerDay = Int(getfirsttimeFuelLimitPerDay!)! - Int(FLPD)!
                                let updateFLPD = Int(FuelLimitPerDay as String)! - updateFuelLimitPerDay
                                
                                defaults.set(updateFLPD, forKey: "FuelLimitPerDay")
                                defaults.set(FuelLimitPerDay, forKey: "GetFuelLimitPerDay")
                                setFuelLimitePerDayOnce = false
                            }
                        }
                        
                        
                    }else
                    {
                        defaults.set(strDate,forKey:"date")
                        defaults.set(FuelLimitPerDay, forKey: "FuelLimitPerDay")
                        defaults.set(FuelLimitPerDay, forKey: "GetFuelLimitPerDay")
                        setFuelLimitePerDayOnce = false
                    }
                    
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
                            let Pulser_Ratio = JsonRow["PulserRatio"] as! NSString
                            //let DecimalPulserRatio = JsonRow["DecimalPulserRatio"] as! NSNumber
                            let FuelTypeId = JsonRow["FuelTypeId"] as! NSString
                            let Sitid = JsonRow["SiteId"] as! NSString
                            let pulsarstoptime = JsonRow["PulserStopTime"] as! NSString
                            let PumpOffTime = JsonRow["PumpOffTime"] as! NSString
                            let PumpOnTime = JsonRow["PumpOnTime"] as! NSString
                            let Original_NamesOfLink = JsonRow["OriginalNamesOfLink"] as! NSArray
                            
                            
                            
                            let MacAddress = JsonRow["MacAddress"] as! NSString as String
                            let BluetoothMacAddress = JsonRow["BluetoothMacAddress"] as! NSString as String
                            let HubLinkCommunication = JsonRow["HubLinkCommunication"] as! NSString
                            
                            
                            ssid.append(WifiSSId as String)
                            Ulocation = ssid.removeDuplicates()
                            OriginalNamesOfLink.append(Original_NamesOfLink as NSArray )
                            PulserRatio.append(Pulser_Ratio as String)
                            Pass.append(FuelTypeId as String)
                            PulserStopTimelist.append(pulsarstoptime as String)
                            PumpOffTimelist.append(PumpOffTime as String)
                            PumpOnTimelist.append(PumpOnTime as String)
                            Communication_Type.append(HubLinkCommunication as String)
                            Bluetooth_MacAddress.append(BluetoothMacAddress as String)
                            Mac_Address.append(MacAddress as String)
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
                    
                    
                    
                    //                     Uhosenumber = []
                    //                    location = []
                    ////                    ssid = []
                    //                    Communication_Type = []
                    //                    location = []
                    ////                    siteID = []
                    //                    Bluetooth_MacAddress = []
                    //                    Mac_Address = []
                    
                    
                    
                    let Json = systemdata.value(forKey: "SSIDDataObj") as! NSArray
                    let rowCount = Json.count
                    let index: Int = 0
                    for i in 0  ..< rowCount
                    {
                        let JsonRow = Json[i] as! NSDictionary
                        
                        let SiteName = JsonRow["SiteName"] as! NSString
                        location.append(SiteName as String)
                        
                        print(ssid)
                        //                                defaults.set(ssid, forKey: "SSID")
                        //                                defaults.set(siteID, forKey: "SiteID")
                        Ulocation = location.removeDuplicates()
                        
                        if(Ulocation[index] == SiteName as String){
                            
                            
                            let WifiSSId = JsonRow["WifiSSId"] as! NSString
                            
                            let hosename = JsonRow["HoseNumber"] as! NSString
                            let Sitid = JsonRow["SiteId"] as! NSString
                            let MacAddress = JsonRow["MacAddress"] as! NSString as String
                            let BluetoothMacAddress = JsonRow["BluetoothMacAddress"] as! NSString as String
                            let HubLinkCommunication = JsonRow["HubLinkCommunication"] as! NSString
                            let IsLinkFlagged = JsonRow["IsLinkFlagged"] as! NSString  as String
                            let LinkFlaggedMessage =  JsonRow["LinkFlaggedMessage"] as! NSString as String
                            let IsTankEmpty = JsonRow["IsTankEmpty"] as! NSString as String
                            
                            //                                     ssid.append(WifiSSId as String)
                            location.append(SiteName as String)
                            
                            Uhosenumber.append(hosename as String)
                            //                                     siteID.append(Sitid as String)
                            //                                    Communication_Type.append(HubLinkCommunication as String)
                            IsTank_Empty.append(IsTankEmpty as String)
                            IsLink_Flagged.append(IsLinkFlagged as String)
                            LinkFlagged_Message.append(LinkFlaggedMessage as String)
                            //                                 Bluetooth_MacAddress.append(BluetoothMacAddress as String)
                            //                                 Mac_Address.append(MacAddress as String)
                            print(Uhosenumber)
                        }
                    }
                    
                    
                    
                    
                    if(Uhosenumber.count == 1)
                    {
                        let index: Int = 0
                        let siteid = siteID[index]
                        let ssId = ssid[index]
                        self.wifiNameTextField.text = ssid[index]
                        Vehicaldetails.sharedInstance.siteID = siteid
                        Vehicaldetails.sharedInstance.SSId = ssId
                        Vehicaldetails.sharedInstance.PulseRatio = PulserRatio[index]
                        Vehicaldetails.sharedInstance.FuelTypeId = Pass[index]
                        Vehicaldetails.sharedInstance.PulserStopTime = PulserStopTimelist[index]
                        Vehicaldetails.sharedInstance.pumpoff_time = PumpOffTimelist[index]
                        Vehicaldetails.sharedInstance.pumpon_time = PumpOnTimelist[index]
                        Vehicaldetails.sharedInstance.OriginalNamesOfLink = OriginalNamesOfLink[index] as! NSMutableArray
                        print(Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.PulseRatio,Vehicaldetails.sharedInstance.FuelTypeId,Vehicaldetails.sharedInstance.pumpoff_time,Vehicaldetails.sharedInstance.OriginalNamesOfLink)
                        
                        //                        let siteid = siteID[0]
                        //                        let ssId = ssid[0]
                        //
                        
                        
                    }
                }
            }
            
            //USER IS NOT REGISTER TO SYSTEM
            else if(ResponseText == "New Registration") {
                
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                defaults.set(0, forKey: "Register")
                // Call a method on the CustomController property of the AppDelegate
                self.web.sentlog(func_name: "Preauth", errorfromserverorlink: "", errorfromapp: "")
                appDel.preauthstart()
            }
            
            else if(Message == "fail") {
                
                defaults.set("false", forKey: "checkApproved")
                scrollview.isHidden = true
                version.isHidden = false
                warningLable.isHidden = false
                refreshButton.isHidden = false
                self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
                warningLable.text = NSLocalizedString("Regisration", comment:"") + defaults.string(forKey: "address")! + NSLocalizedString("registration1", comment:"")
                //"Your Registration request is not approved yet. It is marked Inactive in the Company Software. Please contact your company’s administrator."
            } else if(ResponseText == "New Registration") {
                performSegue(withIdentifier: "Register", sender: self)
            }
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
        
        if(Vehicaldetails.sharedInstance.DoNotAllowOfflinePreauthorizedTransactions == "True")
        {
            showAlert(message:"We have detected that your device is not in cellular range sufficient to perform this transaction. We do have the ability to allow you to use this device, in an offline mode, however, your Manager has removed that option in your profile. Please contact your Manager.")//NSLocalizedString("HelptextSelectedSite", comment:"")
        }
        
        
    }
    
    
    
    
//    func aesDecrypt(key: String) throws -> String {
//
//        var result = ""
//
//        do {
//
//            let encrypted = self
//            let key: [UInt8] = Array(key.utf8) as [UInt8]
//
//           // let aes = try! AES(key: key, blockMode: .ECB, padding: .pkcs5) // AES128 .ECB pkcs7
//            let decrypted = try aes.decrypt(Array(base64: encrypted))
//
//            result = String(data: Data(decrypted), encoding: .utf8) ?? ""
//
//            print("AES Decryption Result: \(result)")
//
//        } catch {
//
//            print("Error: \(error)")
//        }
//
//        return result
//    }
    
    
    func Alert(message: String)
    {
        preauthalert = true
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
            
         
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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
        showAlert(message:NSLocalizedString("HelptextSelectedSite", comment:"") +  "12345678." )// "If you are using this hose for the first time you will need to enter the password when redirected to the WiFi screen. The password is 12345678.")
        
        print("Password is" + "12345678")// passwordTextField.text!)
        UIPasteboard.general.string = "12345678" //passwordTextField.text!
        print(UIPasteboard.general.string!)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        preauthusyncdatatimer.invalidate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        print("Available Pre-Authorized transactions -: \(Available_preauthtransactions.count)")//"Available Pre-Authorized transactions - \(Available_preauthtransactions.count)")
        //AvailablePreauthTransactions.text = NSLocalizedString("No_Pre-auth_transaction", comment:"") + "\(Available_preauthtransactions.count)"//"Available Pre-Authorized transactions - \(Available_preauthtransactions.count)"
//        if(Available_preauthtransactions.count <= 32)
//        {
//            showAlert(message:"We have detected that your device has been offline. You have \(Available_preauthtransactions.count) offline transactions remaining. In order to resupply your offline transaction count, you will need to take your device where it has cellular service so the offline transactions can be sent to the Cloud, and you will be able to perform additional offline transactions. If you have any questions, please call into Support.")//NSLocalizedString("HelptextSelectedSite", comment:"") )
//        }
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
        unsync.unsyncTransaction()
       
        
        preauthusyncdatatimer.invalidate()
        preauthusyncdatatimer = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(PreauthVC.preauthunsyncTransaction), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        preauthusyncdatatimer.invalidate()
        preauthusyncdatatimer.invalidate()
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goButtontapped(sender: AnyObject) {
        
        
        if(Available_preauthtransactions.count <= 5)
        {
            let alertController = UIAlertController(title: "", message: "We have detected that your device has been offline. You have \(Available_preauthtransactions.count) offline transactions remaining. In order to resupply your offline transaction count, you will need to take your device where it has cellular service so the offline transactions can be sent to the Cloud, and you will be able to perform additional offline transactions. If you have any questions, please call into Support.", preferredStyle: UIAlertController.Style.alert)
            // Background color.
            let backView = alertController.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.white
            
            let message  = "We have detected that your device has been offline. You have \(Available_preauthtransactions.count) offline transactions remaining. In order to resupply your offline transaction count, you will need to take your device where it has cellular service so the offline transactions can be sent to the Cloud, and you will be able to perform additional offline transactions. If you have any questions, please call into Support."
            var messageMutableString = NSMutableAttributedString()
            messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
           // messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
            alertController.setValue(messageMutableString, forKey: "attributedMessage")
            
            // Action.
            let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default) { action in //self.//
                self.gobuttontap()
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
//            showAlert(message:"We have detected that your device has been offline. You have \(Available_preauthtransactions.count) offline transactions remaining. In order to resupply your offline transaction count, you will need to take your device where it has cellular service so the offline transactions can be sent to the Cloud, and you will be able to perform additional offline transactions. If you have any questions, please call into Support.")//NSLocalizedString("HelptextSelectedSite", comment:"") )
        }
        else{
            self.defaults.setValue("0", forKey: "previouspulsedata")
            gobuttontap()
        }
        
    }
    
    func gobuttontap()
    {
        preauthunsyncTransaction()
   
        let index = Transaction_Id.count//Vehicaldetails.sharedInstance.Transaction_id.count
        if(index == 0){
//            shownotransId(message: NSLocalizedString("Preauthnointernet", comment:""))
            preauthalert = false
           // viewDidLoad()
        }else{
            timer.invalidate()
            if (wifiNameTextField.text == ""){
                showAlert(message: NSLocalizedString("NoHoseselect", comment:"") )//"Please Select Hose to use.")
            }
            else{
                //#1761
                if(Vehicaldetails.sharedInstance.PulseRatio == "")
                 {
                    Alert(message:"You do not have enough cellular coverage to perform this transaction. Please return to where you have coverage and reopen the APP for at least two minutes. During this time, an offline database will be loaded onto your device where you can return to perform your transaction(s). The transaction(s) will be loaded into the Cloud once you return again to where you have cellular coverage. If you have any questions, please contact Support.")
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

//                    shownotransId(message: NSLocalizedString("Preauthnointernet", comment:""))//"Pre-authorized transactions not available for you. Please enabled your internet connection or Please contact your company’s administrator.")
                }
                else if(notransactionid == "False"){
                    if(self.IsVehicleNumberRequire == "True"){
                        self.performSegue(withIdentifier: "veh", sender: self)
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
                                    //self.senddata(deptno: self.IsDepartmentRequire,ppin:self.IsPersonnelPINRequire,other:self.IsOtherRequire)
                                    Vehicaldetails.sharedInstance.MinLimit = "0"
                                    self.performSegue(withIdentifier: "Go", sender: self)
                                }
                            }
                        }
                    }
//                    self.performSegue(withIdentifier: "GO", sender: self)
                }
            }
            }
        }
    }
    
    @objc func tapAction() {
        
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.endEditing(true)
    }
    
//    @IBAction func refreshButtontappd(sender: AnyObject)
//    {
//        if(Vehicaldetails.sharedInstance.reachblevia == "wificonn" || Vehicaldetails.sharedInstance.reachblevia == "cellular")
//        {
//        let uuid:String// = UIDevice.current.identifierForVendor!.uuidString
//
//
//            let password = KeychainService.loadPassword()
//            if(password == nil){
//                uuid = UIDevice.current.identifierForVendor!.uuidString
//                KeychainService.savePassword(token: uuid as NSString)
//            }
//            else{
//                let password = KeychainService.loadPassword()
//                print(password!)// password = "Pa55worD"
//                uuid = password! as String
//            }
//        let data = web.checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")
//        let Split = data.components(separatedBy: "#")
//        reply = Split[0]
//        if(reply != "-1"){
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
//            self.present(controller, animated: true, completion: nil)
//            }
//
//            }
//            else{
//        viewDidLoad()
//        }
//
//    }
    
    @IBAction func refreshButtontapped(sender: AnyObject) {
        if(cf.getSSID() != "" ) {
            print("SSID: \(cf.getSSID())")
        } else {
            showAlert(message:  NSLocalizedString("NoSSIdFound", comment:"") )//"SSID not found wifi is not connected.")
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
                //print(PulserRatio[0])
                Vehicaldetails.sharedInstance.siteID = siteid
                Vehicaldetails.sharedInstance.SSId = ssId
                Vehicaldetails.sharedInstance.password = Password
                Vehicaldetails.sharedInstance.PulseRatio = PulserRatio[0]
             
                Vehicaldetails.sharedInstance.OriginalNamesOfLink = OriginalNamesOfLink[0] as! NSMutableArray
                Vehicaldetails.sharedInstance.HubLinkCommunication = Communication_Type[0]
                
                Vehicaldetails.sharedInstance.FuelTypeId = Pass[0]
                Vehicaldetails.sharedInstance.PulserStopTime = PulserStopTimelist[0]
                Vehicaldetails.sharedInstance.pumpoff_time = PumpOffTimelist[0]
                Vehicaldetails.sharedInstance.pumpon_time = PumpOnTimelist[0]
               
                Vehicaldetails.sharedInstance.IsLinkFlagged = IsLink_Flagged[0]
                Vehicaldetails.sharedInstance.LinkFlaggedMessage = LinkFlagged_Message[0]
                Vehicaldetails.sharedInstance.FS_MacAddress = Mac_Address[0]
                Vehicaldetails.sharedInstance.BTMacAddress = Bluetooth_MacAddress[0]
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
            Vehicaldetails.sharedInstance.PulseRatio = PulserRatio[index]
            Vehicaldetails.sharedInstance.OriginalNamesOfLink = OriginalNamesOfLink[index] as! NSMutableArray
            Vehicaldetails.sharedInstance.FuelTypeId = Pass[index]
            Vehicaldetails.sharedInstance.PulserStopTime = PulserStopTimelist[index]
            Vehicaldetails.sharedInstance.pumpoff_time = PumpOffTimelist[index]
            Vehicaldetails.sharedInstance.pumpon_time = PumpOnTimelist[index]
            Vehicaldetails.sharedInstance.HubLinkCommunication = Communication_Type[index]
            Vehicaldetails.sharedInstance.IsLinkFlagged = IsLink_Flagged[index]
            Vehicaldetails.sharedInstance.LinkFlaggedMessage = LinkFlagged_Message[index]
            Vehicaldetails.sharedInstance.FS_MacAddress = Mac_Address[index]
            Vehicaldetails.sharedInstance.BTMacAddress = Bluetooth_MacAddress[index]
            print(Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.PulseRatio,Vehicaldetails.sharedInstance.FuelTypeId,Vehicaldetails.sharedInstance.pumpoff_time,Vehicaldetails.sharedInstance.HubLinkCommunication,Vehicaldetails.sharedInstance.OriginalNamesOfLink)
            defaults.set(siteid, forKey: "SiteID")
            Vehicaldetails.sharedInstance.CollectDiagnosticLogs = "True"
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
            appDel.preauthstart()
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
    
    @objc func preauthunsyncTransaction()// -> String
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
//                        return "true"
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
//        return "False"
    }
    
    func showAlert(message: String,title:String)
    {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        // Change Message With Color and Font
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
        //messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func Upload(jsonstring: String,filename:String,siteName:String)
    {
        let FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
//        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
               // print(self.reply)
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
             //   print(self.sysdata1)

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



