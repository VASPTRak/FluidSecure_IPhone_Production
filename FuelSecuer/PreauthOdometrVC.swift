//
//  PreauthOdometrVC.swift
//  FuelSecure
//
//  Created by VASP on 9/13/17.
//  Copyright © 2017 VASP. All rights reserved.
//

import UIKit


class PreauthOdometerVC: UIViewController,UITextFieldDelegate //
{
    @IBOutlet var oview: UIView!
    @IBOutlet var Odometer: UITextField!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet var Go: UIButton!
    @IBOutlet var OdometerLabel: UILabel!
    
    var cf = Commanfunction()
    var countdata = 0
    var web = Webservices()
    var countfailauth:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Odometer.delegate = self
        Odometer.font = UIFont(name: Odometer.font!.fontName, size: 40)
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State.normal)
        doneButton.addTarget(self, action: #selector(OdometerVC.tapAction), for: UIControl.Event.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        Odometer.returnKeyType = .done
        Odometer.inputAccessoryView = doneButton
        Odometer.autocapitalizationType = UITextAutocapitalizationType.allCharacters

        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = "Enter Odometer Reading" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        Odometer.attributedPlaceholder = myMutableStringTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Odometer.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if (textField.tag == 1) {
        //            UIView.beginAnimations(nil, context: nil)
        //            UIView.setAnimationDelegate(self)
        //            UIView.setAnimationDuration(0.5)
        //            UIView.setAnimationBeginsFromCurrentState(true)
        //            self.view.frame = CGRectMake(0,-140, self.view.frame.size.width, self.view.frame.size.height)
        //            UIView.commitAnimations()
        //        }
    }
    
    func shownumbers(){
        
    }
    
   @objc func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
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
//        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    @IBAction func odometer(_ sender: Any) {
        
        checkMaxLength(textField: Odometer, maxLength:6)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    @IBAction func reset(sender: AnyObject) {
        
        Odometer.text = ""
    }
    
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
    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 12.0, *) {
            self.web.wifisettings(pagename: "PreauthVehicle")
        } else {
            // Fallback on earlier versions
        };if #available(iOS 12.0, *) {
            self.web.wifisettings(pagename: "PreauthVehicle")
        } else {
            // Fallback on earlier versions
        }//wifisettings()
        mainPage()
    }
    
    //AUTHENTICATION FUNCTION CALL

    func mainPage()
    {
        if(Vehicaldetails.sharedInstance.SSId == cf.getSSID())
        {
            self.performSegue(withIdentifier: "Go", sender: self)
        }
        else{
             self.web.sentlog(func_name: "In Preauthorized Transaction Go button Tapped user need to select Wifi data Manually", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            self.performSegue(withIdentifier: "Go", sender: self)
        }
    }
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer:Int! = Int(odom)!
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        countfailauth += 1
//        Vehicaldetails.sharedInstance.MinLimit = "0"
//        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
//        let Split = data.components(separatedBy: "#@*%*@#")
//        let reply = Split[0]
//        if (reply == "-1")
//        {
//            if(countfailauth>2)
//            {
//                showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))
//            }else{
//                self.senddata(deptno: deptno,ppin:ppin,other:other)
//            }
//        }
//        else
//        {
//            countfailauth = 0
//            let data1:Data = reply.data(using: String.Encoding.utf8)!
//            do{
//                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//            }catch let error as NSError {
//                print ("Error: \(error.domain)")
//            }
//          //  print(sysdata)
//            if(sysdata == nil){
//
//            }
//            else{
//            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
//            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
//            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString
//
//            if(ResponceMessage == "success")
//            {
//                self.Activity.stopAnimating()
//                self.Activity.isHidden = true
//
//                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
//
//                    if #available(iOS 12.0, *) {
//                        if (Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP") {
//                        self.web.wifisettings(pagename: "Odometer")
//                    }
//                    }
//                    else {
//                        // Fallback on earlier versions
//
//                        let alertController = UIAlertController(title: NSLocalizedString("Title", comment:""), message: NSLocalizedString("Message", comment:"") + "\(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertController.Style.alert)
//                        let backView = alertController.view.subviews.last?.subviews.last
//                        backView?.layer.cornerRadius = 10.0
//                        backView?.backgroundColor = UIColor.white
//
//                        let paragraphStyle = NSMutableParagraphStyle()
//                        paragraphStyle.alignment = NSTextAlignment.left
//
//                        let paragraphStyle1 = NSMutableParagraphStyle()
//                        paragraphStyle1.alignment = NSTextAlignment.left
//
//                        let attributedString = NSAttributedString(string:NSLocalizedString("Subtitle", comment:""), attributes: [
//                            NSAttributedString.Key.paragraphStyle:paragraphStyle1,
//                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), //your font here
//                            NSAttributedString.Key.foregroundColor : UIColor.black
//                            ])
//
//                        let formattedString = NSMutableAttributedString()
//                        formattedString
//                            .normal(NSLocalizedString("Step1", comment:""))
//                            .bold("\(Vehicaldetails.sharedInstance.SSId)")
//                            .normal(NSLocalizedString("Step2", comment:""))
//                            .bold("\(Vehicaldetails.sharedInstance.SSId)")
//                            .normal(NSLocalizedString("Step3", comment:""))
//
//                        alertController.setValue(formattedString, forKey: "attributedMessage")
//                        alertController.setValue(attributedString, forKey: "attributedTitle")
//                        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default){
//                            action in
//                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
//                            {
//                                self.performSegue(withIdentifier: "GoUDP", sender: self)
//                            }
//                            else{
//                            self.performSegue(withIdentifier: "Go", sender: self)
//                            }
//                        }
//                        alertController.addAction(action)
//
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                    self.mainPage()
//
//                }
//
//                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
//                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
//                    {
//                        self.performSegue(withIdentifier: "GoUDP", sender: self)
//                    }
//                    else{
                    self.performSegue(withIdentifier: "Go", sender: self)
//                    }
//                }
//            }
//            else {
//
//                if(ResponceMessage == "fail")
//                {
//                    self.Activity.stopAnimating()
//                    self.Activity.isHidden = true
//                    if(ValidationFailFor == "Vehicle") {
//                        odostoptimergotostart.invalidate()
//                        self.performSegue(withIdentifier: "Vehicle", sender: self)
//
//                    }else if(ValidationFailFor == "Dept")
//                    {
//                        odostoptimergotostart.invalidate()
//                        self.performSegue(withIdentifier: "dept", sender: self)
//                    }else if(ValidationFailFor == "Odo")
//                    {
//                        odostoptimergotostart.invalidate()
//                        self.performSegue(withIdentifier: "odometer", sender: self)
//                    }
//                    else if(ValidationFailFor == "Pin")
//                    {
//                        odostoptimergotostart.invalidate()
//                        self.performSegue(withIdentifier: "pin", sender: self)
//                    }
//                }
//                showAlert(message: "\(ResponceText)")
//            }
//        }
//    }
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
    
    func switchValueDidChange(sender:UISwitch!){
        
        print("Switch Value : \(sender.isOn))")
    }
    
    func send_data()
    {
        self.web.sentlog(func_name: "Last fueling Quantity of vehicle for reasonability checking : \(Vehicaldetails.sharedInstance.LastTransactionFuelQuantity)", errorfromserverorlink: "", errorfromapp: "")
        let hours = Vehicaldetails.sharedInstance.IsHoursrequirs
        let IsExtraOther = Vehicaldetails.sharedInstance.IsExtraOther
        let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
        let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
        let isother = Vehicaldetails.sharedInstance.IsOtherRequire
       
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
        {
            self.web.sentlog(func_name: "Odometer Entered : \(Vehicaldetails.sharedInstance.Odometerno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: "")
        }
        else{
        self.web.sentlog(func_name: "Odometer Entered : \(Vehicaldetails.sharedInstance.Odometerno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link : \(self.cf.getSSID())")
        }
        //    parameter name: ErrorCode
        //  Value : 1 (This for attempting odometer more than 3)
        Vehicaldetails.sharedInstance.Errorcode = "1"
        if (hours == "Y"){
            self.performSegue(withIdentifier: "hour", sender: self)
//            self.Activity.stopAnimating()
//            self.Activity.isHidden = true
        }
        else
            if (IsExtraOther == "True"){
                self.performSegue(withIdentifier: "otherVehicle", sender: self)
//                self.Activity.stopAnimating()
//                self.Activity.isHidden = true
        }else{
            Vehicaldetails.sharedInstance.hours = ""
            if(isdept == "True"){
                self.countdata = 0
                self.performSegue(withIdentifier: "dept", sender: self)
//                self.Activity.stopAnimating()
//                self.Activity.isHidden = true
            }
            else{
                if(isPPin == "True"){
                    self.countdata = 0
                    self.performSegue(withIdentifier: "pin", sender: self)
//                    self.Activity.stopAnimating()
//                    self.Activity.isHidden = true
                }
                else{
                    if(isother == "True"){
                        self.countdata = 0
                        self.performSegue(withIdentifier: "other", sender: self)
//                        self.Activity.stopAnimating()
//                        self.Activity.isHidden = true
                    }
                    else{
                        let deptno = ""
                        let ppin = ""
                        let other = ""
                        Vehicaldetails.sharedInstance.deptno = ""
                        Vehicaldetails.sharedInstance.Personalpinno = ""
                        Vehicaldetails.sharedInstance.Other = ""
                        self.senddata(deptno: deptno,ppin:ppin,other:other)
                    }
                }
            }
        }
    }
    
    @IBAction func saveButtontapped(sender: UIButton) {
        
//        tapAction()
//        Vehicaldetails.sharedInstance.MinLimit = "0"
       
        if(Odometer.text == "")
        {
            showAlert(message: NSLocalizedString("EneterOdometer", comment:""))//showAlert(message: "Please Enter Odometer Number.")
        }
        else
        {
//            let odometer:Int! = Int(self.Odometer.text!)
//            let PreviousOdo = Vehicaldetails.sharedInstance.PreviousOdo
//            let OdoLimit = Vehicaldetails.sharedInstance.OdoLimit
//            if(OdoLimit >= odometer && odometer >= PreviousOdo)
//            {
//                Vehicaldetails.sharedInstance.Errorcode = "0"
//                if(((LastTransQuantity)as NSString).doubleValue < 10)
//                {
//                    if(odometer < PreviousOdo){
//                    self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
//                    self.Activity.stopAnimating()
//                    self.Activity.isHidden = true
//                    self.viewWillAppear(true)
//                    }
//                    else
//                    {
//                        let odometer:Int! = Int(Odometer.text!)
//                             Vehicaldetails.sharedInstance.Odometerno = "\(odometer!)"
//                        Odometer.text = Vehicaldetails.sharedInstance.Odometerno
//                        self.senddata()
//
//                    }
//                }
//                else{
//                  if(odometer <= PreviousOdo){
//                    self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
////                    self.Activity.stopAnimating()
////                    self.Activity.isHidden = true
//                    self.viewWillAppear(true)
//                    }
//                    else
//                    {
                        let odometer:Int! = Int(Odometer.text!)
                             Vehicaldetails.sharedInstance.Odometerno = "\(odometer!)"
                        Odometer.text = Vehicaldetails.sharedInstance.Odometerno
                        self.send_data()
//                    }
//                }
//           }
            
        }
    }
}
