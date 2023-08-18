//
//  PreauthVehicleVC.swift
//  FuelSecure
//
//  Created by VASP on 9/13/17.
//  Copyright © 2017 VASP. All rights reserved.
//

import UIKit


class PreauthVehiclenoVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var Vehicleno: UITextField!
    @IBOutlet var Mview: UIView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var VehicleLabel: UILabel!
    @IBOutlet var save: UIButton!
    
    
    var cf = Commanfunction()
    var web = Webservices()
    
    var vehicledata:NSDictionary!
    var vehiclenumber = [String]()
    var CheckOdometerReasonable = [String]()
    var RequireHours = [String]()
    var OdometerReasonabilityConditions = [String]()
    var VehicleId = [String]()
    var FuelQuantityOfVehiclePerMonth = [String]()
    var FuelLimitPerTxn = [String]()
    var FuelLimitPerDay = [String]()
    var ExtraOtherLabel = [String]()
    var IsExtraOther = [String]()
    var Active = [String]()
    var FuelLimitPerMonth = [String]()
    var CheckFuelLimitPerMonth = [String]()
    var CurrentOdometer = [String]()
    var RequireOdometerEntry = [String]()
    var OdoLimit = [String]()
    var HoursLimit = [String]()
    var CurrentHours = [String]()
    var preauthtransdata:NSDictionary!
    var Totalfuelquantity:Float = 0.0
    
    var is_vehicle_no:Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Vehicleno.font = UIFont(name: Vehicleno.font!.fontName, size: 40)
        Vehicleno.textAlignment = NSTextAlignment.center
        Vehicleno.textColor = UIColor.white
        Vehicleno.delegate = self
        save.isEnabled = false
        
        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            VehicleLabel.text = "Ingrese Numero de " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)"
        }
        else{
        VehicleLabel.text = "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number"
        }
        
        var myMutableStringTitle = NSMutableAttributedString()
        
        let Name  = "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        Vehicleno.attributedPlaceholder = myMutableStringTitle
        
        DispatchQueue.main.async(execute: {
            self.web.beginBackgroundUpdateTask()
            
            self.vehicle_data()
            // End the background task.
            
            self.web.endBackgroundUpdateTask()
        })
        
    }
  
    
    func vehicle_data()
    {
        if(defaults.string(forKey: "dateof_DownloadVehiclesForphonefilename") == nil) {
        }
        else{
            if(cf.checkPath(fileName: defaults.string(forKey: "dateof_DownloadVehiclesForphonefilename")!) == true) {
                var getdata = cf.ReadFile(fileName: defaults.string(forKey: "dateof_DownloadVehiclesForphonefilename")!) //Vehicaldetails.sharedInstance.PreAuthVehicleDataFilename)
                
                // print(getdata)
                getdata.remove(at: getdata.startIndex)
                
                print(getdata)
                let json = testAES(encryped_data: getdata)
                //print(json)
                let data1:Data = json.data(using: String.Encoding.utf8.rawValue)! as Data
                do {
                    vehicledata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                /// print(sysdata)
                vehiclenumber = []
                CheckOdometerReasonable = []
                CurrentOdometer = []
                RequireOdometerEntry = []
                OdoLimit = []
                FuelQuantityOfVehiclePerMonth = []
                FuelLimitPerTxn = []
                FuelLimitPerDay = []
                FuelLimitPerMonth = []
                ExtraOtherLabel = []
                CheckFuelLimitPerMonth = []
                RequireHours = []
                HoursLimit = []
                IsExtraOther = []
                Active = []
                CurrentHours = []
                
                
                let Message = vehicledata["ResponceMessage"] as! NSString
                //let ResponseText = vehicledata["ResponceText"] as! NSString
                if(Message == "success") {
                    
                    let objUserData = vehicledata.value(forKey: "VehicleDataObj") as! NSArray
                    let rowCount = objUserData.count
                    let index: Int = 0
                    for i in 0  ..< rowCount
                    {
                        let JsonRow = objUserData[i] as! NSDictionary
                        let Vehicle_Number = JsonRow.value(forKey: "VehicleNumber") as! NSString
                        let Vehicle_Id = JsonRow.value(forKey: "VehicleId") as! NSNumber
                        let Current_Odometer = JsonRow.value(forKey: "CurrentOdometer") as! NSNumber
                        let RequireOdometer_Entry = JsonRow.value(forKey: "RequireOdometerEntry") as! NSString
                        let IsRequireHours = JsonRow.value(forKey: "RequireHours") as! NSString
                        let Current_Hours = JsonRow.value(forKey: "CurrentHours") as! NSNumber
                        let Odo_Limit = JsonRow.value(forKey: "OdoLimit") as! NSString
                        let _Active = JsonRow.value(forKey: "Active") as! NSString
                        let Check_OdometerReasonable = JsonRow.value(forKey: "CheckOdometerReasonable") as! NSString
                        let Odometer_ReasonabilityConditions = JsonRow.value(forKey: "OdometerReasonabilityConditions") as! NSString
                        let Is_ExtraOther = JsonRow.value(forKey: "IsExtraOther") as! NSString
                        let Hours_Limit = JsonRow.value(forKey: "HoursLimit") as! NSString
                        let Extra_OtherLabel = JsonRow.value(forKey: "ExtraOtherLabel") as! NSString
                        let FuelLimitPer_Month = JsonRow.value(forKey: "FuelLimitPerMonth") as! NSNumber
                        let FuelLimitPer_Day = JsonRow.value(forKey: "FuelLimitPerDay") as! NSNumber
                        let FuelLimitPer_Txn = JsonRow.value(forKey: "FuelLimitPerTxn") as! NSNumber
                        let FuelQuantityOf_VehiclePerMonth = JsonRow.value(forKey: "FuelQuantityOfVehiclePerMonth") as! NSNumber
                        let Check_FuelLimitPerMonth = JsonRow.value(forKey: "CheckFuelLimitPerMonth") as! Bool
                        
                        CheckFuelLimitPerMonth.append("\(Check_FuelLimitPerMonth)" as String)
                        FuelLimitPerMonth.append("\(FuelLimitPer_Month)" as String)
                        FuelLimitPerDay.append("\(FuelLimitPer_Day)" as String)
                        FuelLimitPerTxn.append("\(FuelLimitPer_Txn)" as String)
                        FuelQuantityOfVehiclePerMonth.append("\(FuelQuantityOf_VehiclePerMonth)" as String)
                        
                        CurrentHours.append("\(Current_Hours)" as String)
                        Active.append(_Active as String)
                        IsExtraOther.append(Is_ExtraOther as String)
                        ExtraOtherLabel.append(Extra_OtherLabel as String)
                        RequireHours.append(IsRequireHours as String)
                        OdometerReasonabilityConditions.append(Odometer_ReasonabilityConditions as String)
                        CheckOdometerReasonable.append(Check_OdometerReasonable as String)
                        vehiclenumber.append(Vehicle_Number as String)
                        VehicleId.append("\(Vehicle_Id)" as String)
                        CurrentOdometer.append("\(Current_Odometer)")
                        RequireOdometerEntry.append(RequireOdometer_Entry as String)
                        OdoLimit.append(Odo_Limit as String)
                        HoursLimit.append(Hours_Limit as String)
                    }
                }
            }
        }
    }
    
    func testAES(encryped_data:String) -> NSString {
        
        let message     = encryped_data
        let key         = "(fs@!<(t!8*N+^e9"
        let ivString     = "(fs@!<(t!8*N+^e9"   // 16 bytes for AES128
        
        let messageData = message.data(using:String.Encoding.utf8)!
        let keyData     = key.data(using: .utf8)!
        let ivData      = ivString.data(using: .utf8)!
        
        
        
        let encryptedData = messageData.aesEncrypt( keyData:keyData, ivData:ivData, operation:kCCEncrypt)
        let decryptedData = Data(base64Encoded: message)!.aesEncrypt( keyData:keyData, ivData:ivData, operation:kCCDecrypt)
        let decrypted     = String(bytes:decryptedData, encoding:String.Encoding.utf8)!
        print(decrypted)
        return decrypted as NSString
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        Vehicleno.becomeFirstResponder()
    }
    
    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.Mview.endEditing(true)
        save.isHidden = false
        cancel.isHidden = false
    }
    
    
    @IBAction func Vno(_ sender: Any) {
        
        checkMaxLength(textField: Vehicleno,maxLength: 20)
        if(Vehicleno.text != "0"){
            save.isEnabled = true
        }
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func showAlert(message: String) {
    //        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
    //        // Background color.
    //        let backView = alertController.view.subviews.last?.subviews.last
    //        backView?.layer.cornerRadius = 10.0
    //        backView?.backgroundColor = UIColor.white
    //        let message  = message
    //        var messageMutableString = NSMutableAttributedString()
    //        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
    //        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
    //        alertController.setValue(messageMutableString, forKey: "attributedMessage")
    //
    //        // Action.
    //        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
    //        alertController.addAction(action)
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    
    //    func showAlertSetting(message: String)
    //    {
    //        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
    //        // Background color.
    //        let backView = alertController.view.subviews.last?.subviews.last
    //        backView?.layer.cornerRadius = 10.0
    //        backView?.backgroundColor = UIColor.white
    //
    //        let message  = message
    //        var messageMutableString = NSMutableAttributedString()
    //        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
    //        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
    //        alertController.setValue(messageMutableString, forKey: "attributedMessage")
    //
    //        // Action.
    //        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in //self.//
    //            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
    //            {
    //                print("ssID Match")
    //                self.performSegue(withIdentifier: "Go", sender: self)
    //            }
    //            else{
    //                if #available(iOS 11.0, *) {
    //                    self.web.wifisettings(pagename: "PreauthVehicle")
    //                } else {
    //                    // Fallback on earlier versions
    //                }//self.wifisettings()
    //            }
    //        }
    //        alertController.addAction(action)
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    //
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.Mview.endEditing(true)
        return true
    }
    
    @IBAction func done(sender: AnyObject) {
        
    }
    
    @IBAction func letterBtntapped(sender: AnyObject) {
        self.Mview.endEditing(true)
        self.Vehicleno.keyboardType = UIKeyboardType.default
        self.Vehicleno.becomeFirstResponder()
    }
    
    @IBAction func numberbtntapped(sender: AnyObject) {
        self.Mview.endEditing(true)
        self.Vehicleno.keyboardType = UIKeyboardType.numberPad
        self.Vehicleno.becomeFirstResponder()
    }
    
    @IBAction func Letters(sender: AnyObject) {
        self.Mview.endEditing(true)
        self.Vehicleno.keyboardType = UIKeyboardType.default
        self.Vehicleno.becomeFirstResponder()
    }
    
    @IBAction func reset(sender: AnyObject) {
        
        Vehicleno.text = ""
    }
    
    
    func mainPage()
    {
        cf.delay(2){
            self.performSegue(withIdentifier: "Go", sender: self)
        }
    }
    
    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 12.0, *) {
            self.web.wifisettings(pagename: "PreauthVehicle")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }
    
    func createSwitch() -> UISwitch{
        
        let switchControl = UISwitch(frame:CGRect(x: 10, y: 130, width: 0, height: 0));
        if(Vehicaldetails.sharedInstance.reachblevia == "wificonn"){
            switchControl.isOn = false
            switchControl.setOn(true, animated: false);
            switchControl.isEnabled = false
            return switchControl
        }
        
        else if(Vehicaldetails.sharedInstance.reachblevia != "wificonn"){
            switchControl.isOn = true
            switchControl.setOn(true, animated: false);
            switchControl.isEnabled = false
            return switchControl
        }
        return switchControl
    }
    
    
    func getodometer(){
        let hours = Vehicaldetails.sharedInstance.IsHoursrequirs
        let IsExtraOther = Vehicaldetails.sharedInstance.IsExtraOther
        let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
        let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
        let isother = Vehicaldetails.sharedInstance.IsOtherRequire
        let odo = Vehicaldetails.sharedInstance.odometerreq
//        if(odo == "False")
//        {
//            let odom = "0"
//            _ = Int(odom)
//            let vehicle_no = Vehicleno.text
//            Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
//             = Barcodescanvalue
//            print(Vehicaldetails.sharedInstance.Barcodescanvalue)
//            let data = web.checkhour_odometer(vehicle_no!,Vehicaldetails.sharedInstance.Barcodescanvalue)
//            counthourauth += 1
//
//            let Split = data.components(separatedBy: "#")
//            let reply = Split[0]
//            if (reply == "-1")
//            {
//                if(counthourauth>2)
//                {
//                    showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))
//                }
//                else
//                {
////                    if(IsScanBarcode == true){
////                   delay(1){
////                        self.getodometer()
////                        }
////                    }
////                    else if(IsScanBarcode == false)
////                    {
////                        getodometer()
////                    }
//                }
//                showAlert(message: NSLocalizedString("Warningwait", comment:""))
////                stoptimergotostart.invalidate()
//                viewWillAppear(true)
//            }
//            else
//            {
//                counthourauth = 0
//                let data1:Data = data.data(using: String.Encoding.utf8)!
//                do{
//                    sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                }catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                }
                
               // print(sysdata)
//                if(sysdata == nil){
//
//                }
//                else{
//                let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
//                let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
//                if(ResponceMessage == "success"){
//
//                    appisonVehicle = false
//                    let ExtraOtherLabel = sysdata.value(forKey: "ExtraOtherLabel") as! NSString
//                    let IsExtraOther = sysdata.value(forKey: "IsExtraOther") as! NSString
//                    let IsHoursRequire = sysdata.value(forKey: "IsHoursRequire") as! NSString
//                    let IsOdoMeterRequire = sysdata.value(forKey: "IsOdoMeterRequire") as! NSString
//                    let CheckOdometerReasonable = sysdata.value(forKey: "CheckOdometerReasonable") as! NSString
//                    let OdometerReasonabilityConditions = sysdata.value(forKey: "OdometerReasonabilityConditions") as! NSString
//                    let PreviousOdo = sysdata.value(forKey: "PreviousOdo") as! NSString
//                    let OdoLimit = sysdata.value(forKey: "OdoLimit") as! NSString
//                    let PreviousHours = sysdata.value(forKey: "PreviousHours") as! NSString
//                    let HoursLimit = sysdata.value(forKey: "HoursLimit")  as! NSString
//                    let VehicleNumber = sysdata.value(forKey: "VehicleNumber") as! NSString
//                    let LastTransactionFuelQuantity = sysdata.value(forKey: "LastTransactionFuelQuantity") as! NSString
//
//
//                    Vehicaldetails.sharedInstance.IsExtraOther = IsExtraOther as String
//                    Vehicaldetails.sharedInstance.ExtraOtherLabel = ExtraOtherLabel as String
//                    Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire as String
//                    Vehicaldetails.sharedInstance.IsHoursrequirs = IsHoursRequire as String
//                    Vehicaldetails.sharedInstance.CheckOdometerReasonable = CheckOdometerReasonable as String
//                    Vehicaldetails.sharedInstance.OdometerReasonabilityConditions = OdometerReasonabilityConditions as String
//                    Vehicaldetails.sharedInstance.PreviousOdo = Int(PreviousOdo as String)!
//                    Vehicaldetails.sharedInstance.OdoLimit = Int(OdoLimit as String)!
//                    Vehicaldetails.sharedInstance.HoursLimit = Int(HoursLimit as String)!
//                    Vehicaldetails.sharedInstance.PreviousHours = Int(PreviousHours as String)!
//                    Vehicaldetails.sharedInstance.vehicleno = VehicleNumber as String
//                    Vehicaldetails.sharedInstance.LastTransactionFuelQuantity = LastTransactionFuelQuantity as String
//
////                    Activity.stopAnimating()
////                    Activity.isHidden = true
//                    let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
//                    let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
//                    let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                    
                    if (odo == "Y"){

//                        print(self.odo)
//                        stoptimergotostart.invalidate()
//                        delay(2){
//                            self.stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "odometer", sender: self)
//                        }
                    }
                    else
                    {
                        if (hours == "Y"){
//                            stoptimergotostart.invalidate()
                            self.performSegue(withIdentifier: "hours", sender: self)
                        }
                        else if(IsExtraOther == "True")
                        {
//                            stoptimergotostart.invalidate()
                            self.performSegue(withIdentifier: "otherVehicle", sender: self)
                        }
                        else
                        {
                            Vehicaldetails.sharedInstance.hours = ""
                            if(isdept == "True"){
//                                stoptimergotostart.invalidate()
                                self.performSegue(withIdentifier: "dept", sender: self)
                            }
                            else
                            {
                                if(isPPin == "True"){
//                                    stoptimergotostart.invalidate()
                                    self.performSegue(withIdentifier: "pin", sender: self)
                                }
                                else
                                {
                                    if(isother == "True"){
//                                        stoptimergotostart.invalidate()
                                        self.performSegue(withIdentifier: "other", sender: self)
                                    }
                                    else{
                                        let deptno = ""
                                        let ppin = ""
                                        let other = ""
                                        Vehicaldetails.sharedInstance.deptno = ""
                                        Vehicaldetails.sharedInstance.Personalpinno = ""
                                        Vehicaldetails.sharedInstance.Other = ""
                                        Vehicaldetails.sharedInstance.Odometerno = "0"
                                        Vehicaldetails.sharedInstance.vehicleno = Vehicleno.text!
//                                        Vehicaldetails.sharedInstance.MinLimit = "0"
                                        self.performSegue(withIdentifier: "Go", sender: self)
//                                        stoptimergotostart.invalidate()
//                                        self.senddata(deptno: deptno,ppin:ppin,other:other)
                                    }
                                }
//                            }
//                        }
                    }
               }
//                else {
//
//                    if(ResponceMessage == "fail")
//                    {
//                         delay(1){
//                            self.showAlert(message: "\(ResponceText)")
////                            self.stoptimergotostart.invalidate()
//                         self.viewWillAppear(true)
////                         self.Activity.stopAnimating()
////                         self.Activity.isHidden = true
//                        }
//
//                    }
//                }
            }
//            }
//            Vehicaldetails.sharedInstance.Odometerno = odom
//        }
//        else if(odo == "True"){
////            stoptimergotostart.invalidate()
//            self.performSegue(withIdentifier: "odometer", sender: self)
//            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//            //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
//        }
    }
    
    func getpreauthtransactiondatatocallvehLimits()
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
                        
                        let data1:Data = JData.data(using: String.Encoding.utf8)!
                        do {
                            preauthtransdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        }catch let error as NSError {
                            
                            print ("Error: \(error.domain)")
                        }
                        print(preauthtransdata!)
                        if(preauthtransdata == nil){
                        }
                        else{
                            
                            let FuelQuantity = preauthtransdata["FuelQuantity"] as! NSNumber
                            let VehicleNumber = preauthtransdata["VehicleNumber"] as! NSString
                            let TransactionId = preauthtransdata["TransactionId"] as! NSNumber
                            print(FuelQuantity,VehicleNumber,TransactionId,Vehicaldetails.sharedInstance.vehicleno)
                            if(Vehicaldetails.sharedInstance.vehicleno == VehicleNumber as String)
                            {
                                
                                Totalfuelquantity =  Totalfuelquantity + Float(FuelQuantity)
                                print( Totalfuelquantity)
                                
                            }
                        }
                               
                    }
                }
            }
        }
        

    
    @IBAction func saveBtntapped(sender: AnyObject) {
        Totalfuelquantity = 0.0
        if(Vehicleno.text == "")
        {
            showAlert(message: NSLocalizedString("Entervehicelno", comment:""))
        }
        else{
            
            let vehicle_no = Vehicleno.text
            
            if(vehiclenumber.count == 0)
            {
                showAlert(message:"You do not have enough cellular coverage to perform this transaction. Please return to where you have coverage and reopen the APP for at least two minutes. During this time, an offline database will be loaded onto your device where you can return to perform your transaction(s). The transaction(s) will be loaded into the Cloud once you return again to where you have cellular coverage. If you have any questions, please contact Support.")
            }
            
            
            if("True" == defaults.string(forKey: "IsNonValidateVehicle"))
            {
                    getodometer()
//                if("True" == defaults.string(forKey: "IsNonValidateODOM"))
//                {
//                    Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
//                    self.performSegue(withIdentifier: "odometer", sender: self)
//                }
//                else
//                {
//                    Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
//                    Vehicaldetails.sharedInstance.MinLimit = "0"
//                    self.performSegue(withIdentifier: "Go", sender: self)
//                }
            }
            
            else{
                Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
                getpreauthtransactiondatatocallvehLimits()
                
                for id in 0  ..< self.vehiclenumber.count {
                    if(vehicle_no == vehiclenumber[id]){
                        Vehicaldetails.sharedInstance.PreviousOdo = Int(CurrentOdometer[id])!
                        Vehicaldetails.sharedInstance.OdoLimit = Int(OdoLimit[id])!
                        Vehicaldetails.sharedInstance.VehicleId = VehicleId[id]
                        Vehicaldetails.sharedInstance.CheckOdometerReasonable = CheckOdometerReasonable[id] as String
                        Vehicaldetails.sharedInstance.OdometerReasonabilityConditions = OdometerReasonabilityConditions[id] as String
                        Vehicaldetails.sharedInstance.HoursLimit = Int(HoursLimit[id] as String)!
                        let CheckFuel_LimitPerMonth = CheckFuelLimitPerMonth[id]
                        let FuelLimit_PerMonth = FuelLimitPerMonth[id]
                        let FuelLimit_PerDay = FuelLimitPerDay[id]
                        let FuelLimitPerTXN = FuelLimitPerTxn[id]
                        let FuelQuantityOfVehiclePerMonth = FuelQuantityOfVehiclePerMonth[id]
//                        var transactionlimit = [FuelLimit_PerDay,]
                        Vehicaldetails.sharedInstance.IsExtraOther = IsExtraOther[id] as String
                        Vehicaldetails.sharedInstance.ExtraOtherLabel = ExtraOtherLabel[id] as String
//                        Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire[id] as String
                        Vehicaldetails.sharedInstance.IsHoursrequirs = RequireHours[id] as String
//                        Vehicaldetails.sharedInstance.OdometerReasonabilityConditions = OdometerReasonabilityConditions[id] as String
//                        Vehicaldetails.sharedInstance.PreviousOdo = Int(PreviousOdo[id] as String)!
                        Vehicaldetails.sharedInstance.OdoLimit = Int(OdoLimit[id] as String)!
                        Vehicaldetails.sharedInstance.HoursLimit = Int(HoursLimit[id] as String)!
//                        Vehicaldetails.sharedInstance.PreviousHours = Int(PreviousHours[id] as String)!
                        Vehicaldetails.sharedInstance.vehicleno = vehiclenumber[id] as String
//                        Vehicaldetails.sharedInstance.LastTransactionFuelQuantity = LastTransactionFuelQuantity as String
                        if(CheckFuel_LimitPerMonth == "true")
                        {
                            if(Float(FuelQuantityOfVehiclePerMonth)! >= Float(FuelLimit_PerMonth)! && Float(FuelLimit_PerMonth)! != 0)
                            {
                                self.showAlert(message: NSLocalizedString("Fuelmonthlylimit", comment:""))
                            }
                            else{
                            if(FuelLimit_PerMonth == "0")
                            {
                                if(Vehicaldetails.sharedInstance.MinLimit > "0")
                                {
                                    
                                }
                                else
                                {
                                    Vehicaldetails.sharedInstance.MinLimit = "0"
                                }
                            }
                            else{
                                
                                print(Totalfuelquantity)
                                Totalfuelquantity = Totalfuelquantity + Float(FuelQuantityOfVehiclePerMonth)!
                                let limit = (FuelLimit_PerMonth as NSString).floatValue - Totalfuelquantity
                                
                                if(limit < 0.0)
                                {
                                    self.showAlert(message: NSLocalizedString("Fuelmonthlylimit", comment:""))
                                }
                                else{
                                    Vehicaldetails.sharedInstance.MinLimit = "\(limit)"
                                    Vehicaldetails.sharedInstance.FuelLimitPerMonth = "FuelLimitPerMonth"
                                }
                                
//                                Vehicaldetails.sharedInstance.MinLimit = "\(limit)"
                            }
                            
                                if(FuelLimit_PerDay == "0")
                                {
                                    if(Vehicaldetails.sharedInstance.MinLimit > "0")
                                    {
                                        
                                    }
                                    else
                                    {
                                        Vehicaldetails.sharedInstance.MinLimit = "0"
                                    }
                                }
                                else{

                                    print(Totalfuelquantity)
                                    let limit = (FuelLimit_PerDay as NSString).floatValue - Totalfuelquantity
                                    if(limit < 0.0)
                                    {
                                        self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:""))
                                    }
                                    else{
                                        Vehicaldetails.sharedInstance.MinLimit = "\(limit)"
                                        Vehicaldetails.sharedInstance.FuelLimitPerDay = "FuelLimitPerDay"
                                    }
                                }
                                
                                if(FuelLimitPerTXN == "0")
                                {
                                    if(Vehicaldetails.sharedInstance.MinLimit > "0")
                                    {
                                        
                                    }
                                    else
                                    {
                                        Vehicaldetails.sharedInstance.MinLimit = "0"
                                    }
                                }
                                else{

                                    print(Totalfuelquantity)
                                    let limit = (FuelLimitPerTXN as NSString).floatValue //- Totalfuelquantity
                                    if(limit < 0.0)
                                    {
                                        self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:""))
                                    }
                                    else{
                                        Vehicaldetails.sharedInstance.MinLimit = "\(limit)"
                                        Vehicaldetails.sharedInstance.FuelLimitPerTnx = "FuelLimitPerTnx"
                                    }
                                }
                        }
                        }
                        else
                        {
                            
                            if(FuelLimit_PerDay == "0")
                            {
                                if(Vehicaldetails.sharedInstance.MinLimit > "0")
                                {
                                    
                                }
                                else
                                {
                                    Vehicaldetails.sharedInstance.MinLimit = "0"
                                }
                            }
                            else{
                                
                                print(Totalfuelquantity)
                                let limit = (FuelLimit_PerDay as NSString).floatValue - Totalfuelquantity
                                if(limit < 0.0)
                                {
                                    self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:""))
                                }
                                else{
                                    Vehicaldetails.sharedInstance.MinLimit = "\(limit)"
                                }
                            }
                            
                            if(FuelLimitPerTXN == "0")
                            {
                                if(Vehicaldetails.sharedInstance.MinLimit > "0")
                                {
                                    
                                }
                                else
                                {
                                    Vehicaldetails.sharedInstance.MinLimit = "0"
                                }
                            }
                            else{
                                
                                print(Totalfuelquantity)
                                let limit = (FuelLimitPerTXN as NSString).floatValue - Totalfuelquantity
                                if(limit < 0.0)
                                {
                                    self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:""))
                                }
                                else{
                                    Vehicaldetails.sharedInstance.MinLimit = "\(limit)"
                                }
                            }
                            
                            
                        }
                        is_vehicle_no = true
                        if(RequireOdometerEntry[id] == "Y"){
                            self.performSegue(withIdentifier: "odometer", sender: self)
                            self.web.sentlog(func_name: "Fuel limit \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                        }
                        else
                        {
                            if((Vehicaldetails.sharedInstance.MinLimit as NSString).doubleValue < 0)
                            {
                                self.showAlert(message: NSLocalizedString("Fuelmonthlylimit", comment:""))
                            }
                            else{
                                getodometer()
                                self.web.sentlog(func_name: "Fuel limit \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                            }
//                            Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
//                            Vehicaldetails.sharedInstance.MinLimit = "0"
//                            self.performSegue(withIdentifier: "Go", sender: self)
                        }
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                        self.web.sentlog(func_name: "Preauthorized Transaction Customer type vehicle number: \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link : \(self.cf.getSSID())")
                        break;
                    }
                    else
                    {
                        is_vehicle_no = false
                        
                    }
                    
                    Vehicaldetails.sharedInstance.vehicleno = Vehicleno.text!
                }
                
                
                if(is_vehicle_no == false)
                {
                    showAlert(message: "Invalid vehicle number. Try again or Contract adminstrator.")
                    
                }
            }
        }
    }
}
