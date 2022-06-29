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
    @IBOutlet var save: UIButton!
    

    var cf = Commanfunction()
    var web = Webservices()

    var vehicledata:NSDictionary!
    var vehiclenumber = [String]()
    var CurrentOdometer = [String]()
    var RequireOdometerEntry = [String]()
    var OdoLimit = [String]()
    
    
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

        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = "Enter Vehicle Number" // PlaceHolderText
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
        if(cf.checkPath(fileName: "vehicledata_1.txt") == true) {
            var getdata = cf.ReadFile(fileName: "vehicledata_1.txt")
            
           // print(getdata)
            getdata.remove(at: getdata.startIndex)
            
            print(getdata)
            var json = testAES(encryped_data: getdata)
            //print(json)
            let data1:Data = json.data(using: String.Encoding.utf8.rawValue)! as Data
             do {
                 vehicledata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
             }catch let error as NSError {
                 print ("Error: \(error.domain)")
             }
            /// print(sysdata)
             vehiclenumber = []
             CurrentOdometer = []
             RequireOdometerEntry = []
             OdoLimit = []
            
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
                       let Current_Odometer = JsonRow.value(forKey: "CurrentOdometer") as! NSNumber
//                       let RequireOdometer_Entry = JsonRow.value(forKey: "RequireOdometerEntry") as! NSString
                       let Odo_Limit = JsonRow.value(forKey: "OdoLimit") as! NSString
                    
                    
                       vehiclenumber.append(Vehicle_Number as String)
                       CurrentOdometer.append("\(Current_Odometer)")
//                       RequireOdometerEntry.append(RequireOdometer_Entry as String)
                       OdoLimit.append(Odo_Limit as String)
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
    
    @IBAction func saveBtntapped(sender: AnyObject) {
        
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
            
            Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
            for id in 0  ..< self.vehiclenumber.count {
                if(vehicle_no == vehiclenumber[id]){
                    Vehicaldetails.sharedInstance.PreviousOdo = Int(CurrentOdometer[id])!
                    Vehicaldetails.sharedInstance.OdoLimit = Int(OdoLimit[id])!
                    is_vehicle_no = true
            self.performSegue(withIdentifier: "odometer", sender: self)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            self.web.sentlog(func_name: "Preauthorized Transaction Vehicle number entered \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link : \(self.cf.getSSID())")
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
