//
//  VehiclenoVC.swift
//  FuelSecuer
//
//  Created by VASP on 3/28/16.
//  Copyright © 2016 VASP. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let boldString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle,NSAttributedStringKey.font:UIFont(name: "Arial", size: 17)!])
        boldString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:text.count))
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let normal =  NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle,NSAttributedStringKey.font:UIFont(name: "Arial", size: 15.0)!])
        self.append(normal)
        return self
    }
}


class VehiclenoVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var Vehicleno: UITextField!
    @IBOutlet var Mview: UIView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var save: UIButton!
    
    var web = Webservices()
    var confs = FuelquantityVC()
    var odometervc = OdometerVC()
    var cf = Commanfunction()
    var sysdata:NSDictionary!
    var RData:NSDictionary!
    var IsGobuttontapped : Bool = false
    var odo = Vehicaldetails.sharedInstance.odometerreq
    var isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
    var isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
    var isother = Vehicaldetails.sharedInstance.IsOtherRequire
    var stoptimergotostart:Timer = Timer()
    var buttontype:String!
    var button = UIButton(type: UIButtonType.custom)
    let doneButton:UIButton = UIButton (frame: CGRect(x: 150, y: 150, width: 50, height: 44))
    let doneButton1:UIButton = UIButton (frame: CGRect(x: 150, y: 150, width: 50, height: 44))
    var countfailauth:Int = 0
    var counthourauth:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Vehicleno.font = UIFont(name: Vehicleno.font!.fontName, size: 40)
        Vehicleno.textAlignment = NSTextAlignment.center
        Vehicleno.textColor = UIColor.white
        Vehicleno.delegate = self

        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(VehiclenoVC.gotostart), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }
    
    @objc func gotostart(){
        
        self.web.sentlog(func_name: "vehicletimeout", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
    }
    
    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.Mview.endEditing(true)
        save.isHidden = false
        cancel.isHidden = false
    }

    @IBAction func Vno(_ sender: Any) {
        checkMaxLength(textField: Vehicleno,maxLength: 10)
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
    
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        
        
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                
                print("ssID Match")
                self.performSegue(withIdentifier: "Go", sender: self)
            }
            else{
                //self.mainPage()
                if #available(iOS 11.0, *) {
                    self.web.wifisettings(pagename: "Vehicle")
                } else {
                    // Fallback on earlier versions
                }
                self.mainPage()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
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
        stoptimergotostart.invalidate()
        viewWillAppear(true)
    }


    func mainPage()
    {
//        cf.delay(2){
            self.performSegue(withIdentifier: "Go", sender: self)
//        }
    }
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        let vehicle_no = Vehicleno.text
        countfailauth += 1
        let data = web.vehicleAuth(vehicle_no: vehicle_no!,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other)
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        //let error = Split[1]
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
                showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))

            }else{
                
                self.senddata(deptno: deptno,ppin:ppin,other:other)
            }
        }
        else
        {
            countfailauth = 0
            let data1:Data = reply.data(using: String.Encoding.utf8)!
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            
            print(sysdata)
            
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey:"ResponceText") as! NSString
            let ResponceData = sysdata.value(forKey:"ResponceData") as! NSDictionary
            let MinLimit = ResponceData.value(forKey:"MinLimit") as! NSNumber
            let PulseRatio = ResponceData.value(forKey:"PulseRatio") as! NSNumber
            let VehicleId = ResponceData.value(forKey:"VehicleId") as! NSNumber
            let FuelTypeId = ResponceData.value(forKey:"FuelTypeId") as! NSNumber
            let PersonId = ResponceData.value(forKey:"PersonId") as! NSNumber
            let PhoneNumber = ResponceData.value(forKey:"PhoneNumber") as! NSString
            let PulserStopTime = ResponceData.value(forKey:"PulserStopTime") as! NSString
            let ServerDate = ResponceData.value(forKey:"ServerDate") as! String
            let pumpoff_time = ResponceData.value(forKey: "PumpOffTime") as! String
            print(MinLimit,PersonId,PhoneNumber,FuelTypeId,VehicleId,PulseRatio)
            
            Vehicaldetails.sharedInstance.MinLimit = "\(MinLimit)"
            Vehicaldetails.sharedInstance.PulseRatio = "\(PulseRatio)"
            Vehicaldetails.sharedInstance.VehicleId = "\(VehicleId)"
            Vehicaldetails.sharedInstance.FuelTypeId = "\(FuelTypeId)"
            Vehicaldetails.sharedInstance.PersonId = "\(PersonId)"
            Vehicaldetails.sharedInstance.PhoneNumber = "\(PhoneNumber)"
            Vehicaldetails.sharedInstance.PulserStopTime = "\(pumpoff_time)" //Send pump off time to pulsar off time.
            Vehicaldetails.sharedInstance.date = "\(ServerDate)"
            
            if(ResponceMessage == "success") {
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){

                    if #available(iOS 11.0, *) {
                        self.mainPage()
                        self.web.wifisettings(pagename: "Vehicle")
                    } else {
                        // Fallback on earlier versions

                        let alertController = UIAlertController(title: NSLocalizedString("Title", comment:""), message: NSLocalizedString("Message", comment:"") + "\(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertControllerStyle.alert)
                        let backView = alertController.view.subviews.last?.subviews.last
                        backView?.layer.cornerRadius = 10.0
                        backView?.backgroundColor = UIColor.white

                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.left

                        let paragraphStyle1 = NSMutableParagraphStyle()
                        paragraphStyle1.alignment = NSTextAlignment.left

                        let attributedString = NSAttributedString(string:NSLocalizedString("Subtitle", comment:""), attributes: [
                            NSAttributedStringKey.paragraphStyle:paragraphStyle1,
                            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20), //your font here
                            NSAttributedStringKey.foregroundColor : UIColor.black
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
                        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default){
                            action in
                            self.performSegue(withIdentifier: "Go", sender: self)
                        }
                        alertController.addAction(action)

                        self.present(alertController, animated: true, completion: nil)
                    }
                   // self.mainPage()
                }
                
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                    self.performSegue(withIdentifier: "Go", sender: self)
                    self.web.sentlog(func_name: "Vehicle number entered \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")

                    self.web.sentlog(func_name: "Go button Tapped NO need to select Wifi data Manually", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                }
            }
            else {
                
                if(ResponceMessage == "fail")
                {
                    if(ResponceText == "Unauthorized vehicle")
                    {
                        
                    }
                    stoptimergotostart.invalidate()
                    viewWillAppear(true)
                    showAlert(message: "\(ResponceText)")
                }
            }
        }
    }
    
    
    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 11.0, *) {
            self.web.wifisettings(pagename: "Vehicle")
        } else {
            // Fallback on earlier versions
        }
        self.mainPage()
    }
    
    func getodometer(){
        if(odo == "False")
        {
            let odom = "0"
            _ = Int(odom)
            let vehicle_no = Vehicleno.text
            Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
            let data = web.checkhour_odometer(vehicle_no!)
            counthourauth += 1
            
            let Split = data.components(separatedBy: "#")
            let reply = Split[0]
            if (reply == "-1")
            {
                if(counthourauth>2)
                {
                    showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))
                }
                else
                {
                    getodometer()
                }
                showAlert(message: NSLocalizedString("Warningwait", comment:""))
                stoptimergotostart.invalidate()
                viewWillAppear(true)
            }
            else
            {
                counthourauth = 0
                let data1:Data = reply.data(using: String.Encoding.utf8)!
                do{
                    sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }

                print(sysdata)
                let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
                let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
                if(ResponceMessage == "success"){
                    self.web.sentlog(func_name: "Vehicle number entered \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")

                    let IsHoursRequire = sysdata.value(forKey: "IsHoursRequire") as! NSString
                    let IsOdoMeterRequire = sysdata.value(forKey: "IsOdoMeterRequire") as! NSString
                    let CheckOdometerReasonable = sysdata.value(forKey: "CheckOdometerReasonable") as! NSString
                    let OdometerReasonabilityConditions = sysdata.value(forKey: "OdometerReasonabilityConditions") as! NSString
                    let PreviousOdo = sysdata.value(forKey: "PreviousOdo") as! NSString
                    let OdoLimit = sysdata.value(forKey: "OdoLimit") as! NSString
                    
                    Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire as String
                    Vehicaldetails.sharedInstance.IsHoursrequirs = IsHoursRequire as String
                    Vehicaldetails.sharedInstance.CheckOdometerReasonable = CheckOdometerReasonable as String
                    Vehicaldetails.sharedInstance.OdometerReasonabilityConditions = OdometerReasonabilityConditions as String
                    Vehicaldetails.sharedInstance.PreviousOdo = Int(PreviousOdo as String)!
                    Vehicaldetails.sharedInstance.OdoLimit = Int(OdoLimit as String)!
                    let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
                    let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                    let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                    
                    if (IsOdoMeterRequire == "True"){
                        print(self.odo)
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "odometer", sender: self)
                    }
                    else
                    {
                        if (IsHoursRequire == "True"){
                            self.performSegue(withIdentifier: "hours", sender: self)
                        }
                        else
                        {
                            Vehicaldetails.sharedInstance.hours = ""
                            if(isdept == "True"){
                                stoptimergotostart.invalidate()
                                self.performSegue(withIdentifier: "dept", sender: self)
                            }
                            else
                            {
                                if(isPPin == "True"){
                                    stoptimergotostart.invalidate()
                                    self.performSegue(withIdentifier: "pin", sender: self)
                                }
                                else
                                {
                                    if(isother == "True"){
                                        stoptimergotostart.invalidate()
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
                                        self.senddata(deptno: deptno,ppin:ppin,other:other)
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    
                    if(ResponceMessage == "fail")
                    {
                        showAlert(message: "\(ResponceText)")
                        stoptimergotostart.invalidate()
                        viewWillAppear(true)
                    }
                }
            }
            Vehicaldetails.sharedInstance.Odometerno = odom
        }
        else if(odo == "True"){
            stoptimergotostart.invalidate()
            self.performSegue(withIdentifier: "odometer", sender: self)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        }
    }
    
    @IBAction func saveBtntapped(sender: AnyObject) {
        IsGobuttontapped = true
        
        stoptimergotostart.invalidate()
        
        if(Vehicleno.text == "")
        {
            showAlert(message: NSLocalizedString("Entervehicelno", comment:""))
            viewWillAppear(true)
        }
        else{
            getodometer()
            Vehicaldetails.sharedInstance.vehicleno = Vehicleno.text!
        }
    }
}
