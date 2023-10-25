//  OdometerVC.swift
//  FuelSecuer
//
//  Created by VASP on 3/29/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit


class OdometerVC: UIViewController,UITextFieldDelegate //
{
    @IBOutlet var oview: UIView!
    @IBOutlet var Odometer: UITextField!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet var Go: UIButton!
    @IBOutlet var OdometerLabel: UILabel!

    var web = Webservices()
    
    var sysdata:NSDictionary!
    var cf = Commanfunction()
    var countdata = 0
    
    var IsGobuttontapped : Bool = false
    var odostoptimergotostart:Timer = Timer()
    var countfailauth:Int = 0
    var appison_odometer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Activity.isHidden = true
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

        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            OdometerLabel.text = "Ingrese la lectura del odómetro  \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)"
        }
        else{
       OdometerLabel.text = "Enter \(Vehicaldetails.sharedInstance.ScreenNameForOdometer) Reading"
        }


        var myMutableStringTitle = NSMutableAttributedString()
        var Name  = "Enter \(Vehicaldetails.sharedInstance.ScreenNameForOdometer) Reading" // PlaceHolderText
        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            Name = "Ingrese la lectura del odómetro  \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)"
        }
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        Odometer.attributedPlaceholder = myMutableStringTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Odometer.becomeFirstResponder()
        odostoptimergotostart.invalidate()
        odostoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(OdometerVC.gotostart), userInfo: nil, repeats: false)
        Go.isEnabled = true
        Activity.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        odostoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
        appison_odometer = false
        odostoptimergotostart.invalidate()
    }
    
    @objc func gotostart(){
        
        if(appison_odometer == true){
        self.web.sentlog(func_name: "Odometer", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
        }
        else
        {
            odostoptimergotostart.invalidate()
        }
       
    }
    
    @objc func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func odometer(_ sender: Any)
    {
        checkMaxLength(textField: Odometer, maxLength:8)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    @IBAction func reset(sender: AnyObject) {
        Odometer.text = ""
        viewWillAppear(true)
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
        let action =  UIAlertAction(title: NSLocalizedString("REGISTER", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            
            self.cf.delay(1){
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                // Call a method on the CustomController property of the AppDelegate
                defaults.set(0, forKey: "Register")
                appDel.start()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        
        if #available(iOS 12.0, *) {
            self.web.wifisettings(pagename: "Odometer")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }
    
    //AUTHENTICATION FUNCTION CALL
    
    func mainPage()
    {
        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
        {
            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
            {
                self.performSegue(withIdentifier: "GoUDP", sender: self)
            }
            else{
            self.performSegue(withIdentifier: "Go", sender: self)
            }
        }
        else
        {

            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
            {
                self.performSegue(withIdentifier: "GoUDP", sender: self)
            }
            else if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
            {
                self.performSegue(withIdentifier: "Go", sender: self)
            }
            else
            {
                            self.web.sentlog(func_name: "user need to select Wifi data Manually", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose : \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.performSegue(withIdentifier: "Go", sender: self)
            }
        }
    }
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer:Int! = Int(odom)!
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        countfailauth += 1
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
        let Split = data.components(separatedBy: "#@*%*@#")
        let reply = Split[0]
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
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
          //  print(sysdata)
            if(sysdata == nil){
                
            }
            else{
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString
            
            if(ResponceMessage == "success")
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                   
                    if #available(iOS 12.0, *) {
                        if (Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP") {
                        self.web.wifisettings(pagename: "Odometer")
                    }
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
                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                            {
                                self.performSegue(withIdentifier: "GoUDP", sender: self)
                            }
                            else{
                            self.performSegue(withIdentifier: "Go", sender: self)
                            }
                        }
                        alertController.addAction(action)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    self.mainPage()
                    
                }
                
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                    {
                        self.performSegue(withIdentifier: "GoUDP", sender: self)
                    }
                    else{
                    self.performSegue(withIdentifier: "Go", sender: self)
                    }
                }
            }
            else {
                
                if(ResponceMessage == "fail")
                {
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    if(ValidationFailFor == "Vehicle") {
                        odostoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "Vehicle", sender: self)
                        
                    }else if(ValidationFailFor == "Dept")
                    {
                        odostoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "dept", sender: self)
                    }else if(ValidationFailFor == "Odo")
                    {
                        odostoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "odometer", sender: self)
                    }
                    else if(ValidationFailFor == "Pin")
                    {
                        odostoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "pin", sender: self)
                    }
                }
                delay(1){
                    if(ResponceText.contains("Mobile is not registered in the system, Please contact administrator."))
                    {
                        self.Alert(message: "Your device had been deactivated by your Manager. Please press register if you would like to have it reactivated")
                    }
                    else{
                        self.showAlert(message: "\(ResponceText)")
                    }
                    self.Alert(message: "\(ResponceText)")
                }//showAlert(message: "\(ResponceText)")
            }
        }
    }
    }
    
    func switchValueDidChange(sender:UISwitch!){
        
        print("Switch Value : \(sender.isOn))")
    }
    //#1750 test the app
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
        if (hours == "True"){
            self.performSegue(withIdentifier: "hour", sender: self)
            self.Activity.stopAnimating()
            self.Activity.isHidden = true
        }
        else
            if (IsExtraOther == "True"){
                self.performSegue(withIdentifier: "otherVehicle", sender: self)
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
        }else{
            Vehicaldetails.sharedInstance.hours = ""
            if(isdept == "True"){
                self.countdata = 0
                self.performSegue(withIdentifier: "dept", sender: self)
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
            }
            else{
                if(isPPin == "True"){
                    self.countdata = 0
                    self.performSegue(withIdentifier: "pin", sender: self)
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                }
                else{
                    if(isother == "True"){
                        self.countdata = 0
                        self.performSegue(withIdentifier: "other", sender: self)
                        self.Activity.stopAnimating()
                        self.Activity.isHidden = true
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
        
        if(self.cf.getSSID() != "" && Vehicaldetails.sharedInstance.SSId != self.cf.getSSID() && Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP") {
            print("SSID: \(self.cf.getSSID())")
            self.showAlert(message:NSLocalizedString("SwitchoffyourWiFi", comment:""))
//            self.showAlert(message:"Please switch off your wifi before proceeding. \n To switch off the wifi you can use the shortcut.  If you have an iPhone with Touch ID, swipe up from the bottom of the screen. If you have an iPhone with Face ID, swipe down from the upper right. Then tap on the wifi icon to switch it off.")
            //            self.Activity.stopAnimating()
            //            self.Activity.isHidden = true
            // self.go.isEnabled = true
        }
        else{
            Activity.startAnimating()
            Activity.isHidden = false
            Go.isEnabled = false
            let LastTransQuantity = Vehicaldetails.sharedInstance.LastTransactionFuelQuantity
            print(LastTransQuantity)
            delay(1){
                //self.tapAction()
                self.odostoptimergotostart.invalidate()
                self.IsGobuttontapped = true
                if(self.Odometer.text == "")
                {
                    if(Vehicaldetails.sharedInstance.Language == "es-ES")
                    {
                        self.showAlert(message:NSLocalizedString("EneterOdometer", comment:""))
                    }
                    else{
                        self.showAlert(message: "Please Enter \(Vehicaldetails.sharedInstance.ScreenNameForOdometer) Reading")
                    }
                    //
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    self.viewWillAppear(true)
                }
                else
                {
                    if(Int(self.Odometer.text!) == nil){
                        self.showAlert(message: NSLocalizedString("EnterHour_Eng", comment:""))
                        self.Activity.stopAnimating()
                        self.Activity.isHidden = true
                    }
                    else{
                        let odometer:Int! = Int(self.Odometer.text!)
                        Vehicaldetails.sharedInstance.Odometerno = "\(odometer!)"
                        self.Odometer.text = Vehicaldetails.sharedInstance.Odometerno
                        _ = Vehicaldetails.sharedInstance.IsHoursrequirs
                        _ = Vehicaldetails.sharedInstance.IsExtraOther
                        _ = Vehicaldetails.sharedInstance.IsDepartmentRequire
                        _ = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                        _ = Vehicaldetails.sharedInstance.IsOtherRequire
                        let CheckOdometerReasonable = Vehicaldetails.sharedInstance.CheckOdometerReasonable
                        let OdometerReasonabilityConditions = Vehicaldetails.sharedInstance.OdometerReasonabilityConditions
                        let PreviousOdo:Int = Vehicaldetails.sharedInstance.PreviousOdo
                        let OdoLimit:Int = Vehicaldetails.sharedInstance.OdoLimit
                        
                        if(CheckOdometerReasonable == "True"){
                            
                            if(OdometerReasonabilityConditions == "1"){
                                
                                if(OdoLimit >= odometer && odometer >= PreviousOdo)
                                {
                                    Vehicaldetails.sharedInstance.Errorcode = "0"
                                    if(((LastTransQuantity)as NSString).doubleValue < 10)
                                    {
                                        if(odometer < PreviousOdo){
                                            self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            self.viewWillAppear(true)
                                        }
                                        else
                                        {
                                            self.send_data()
                                            
                                        }
                                    }
                                    else{
                                        if(odometer <= PreviousOdo){
                                            self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            self.viewWillAppear(true)
                                        }
                                        else
                                        {
                                            self.send_data()
                                        }
                                    }
                                }
                                else{
                                    self.countdata += 1
                                    
                                    if(self.countdata > 3){
                                        if(odometer > 0)
                                        {
                                            self.send_data()
                                        }
                                        else{
                                            self.showAlert(message:"Please check and try again. If the issue persists, please contact your Manager.")
                                        }
                                        //#1750
                                        //                                    if(((LastTransQuantity)as NSString).doubleValue < 10)
                                        //                                    {
                                        //                                        if(odometer < PreviousOdo){
                                        //                                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager." )
                                        //                                        self.Activity.stopAnimating()
                                        //                                        self.Activity.isHidden = true
                                        //                                        self.viewWillAppear(true)
                                        //                                        }
                                        //                                        else
                                        //                                        {
                                        //                                            self.send_data()
                                        //
                                        //                                        }
                                        //                                    }
                                        //                                    else{
                                        //                                        if(odometer <= PreviousOdo){
                                        //                                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager." )
                                        //                                        self.Activity.stopAnimating()
                                        //                                        self.Activity.isHidden = true
                                        //                                        self.viewWillAppear(true)
                                        //                                        }
                                        //                                        else
                                        //                                        {
                                        //                                            self.send_data()
                                        //                                        }
                                        //                                    //    parameter name: ErrorCode
                                        //                                    //  Value : 1 (This for attempting odometer more than 3)
                                        //                                    Vehicaldetails.sharedInstance.Errorcode = "1"
                                        ////
                                        //                                    }
                                    }
                                    else{
                                        
                                        if(odometer < PreviousOdo){
                                            self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            self.viewWillAppear(true)
                                        }
                                        else{
                                            
                                            Vehicaldetails.sharedInstance.Errorcode = "0"
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            if(Vehicaldetails.sharedInstance.Language == "es-ES")
                                            {
                                                self.showAlert(message: "El \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)" + NSLocalizedString("Odometer_Reasonability", comment:"") )
                                            }
                                            else{
                                                self.showAlert(message: "The \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)" + NSLocalizedString("Odometer_Reasonability", comment:"") )
                                            }
                                            self.viewWillAppear(true)
                                            print(self.countdata)
                                        }
                                    }
                                }
                                
                            } else if(OdometerReasonabilityConditions == "2"){
                                Vehicaldetails.sharedInstance.Errorcode = "0"
                                if(OdoLimit >= odometer && odometer >= PreviousOdo)
                                {
                                    
                                    if(((LastTransQuantity)as NSString).doubleValue < 10)
                                    {
                                        if(odometer < PreviousOdo){
                                            self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            self.viewWillAppear(true)
                                        }
                                        else
                                        {
                                            self.send_data()
                                            
                                        }
                                    }
                                    else{
                                        if(odometer <= PreviousOdo){
                                            self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            self.viewWillAppear(true)
                                        }
                                        else
                                        {
                                            self.send_data()
                                        }
                                    }
                                }
                                else{
                                    Vehicaldetails.sharedInstance.Errorcode = "0"
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                    
                                    if(odometer < PreviousOdo){
                                        self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                        self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                        self.viewWillAppear(true)
                                    }
                                    else{
                                        
                                        if(Vehicaldetails.sharedInstance.Language == "es-ES")
                                        {
                                            self.showAlert(message: "El \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)" + NSLocalizedString("Odometer_Reasonability", comment:"") )
                                        }
                                        else{
                                            self.showAlert(message: "The \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)" + NSLocalizedString("Odometer_Reasonability", comment:"") )
                                        }
                                        self.viewWillAppear(true)
                                        
                                    }
                                }
                            }
                        }
                        else if (CheckOdometerReasonable == "False"){
                            //#1750
                            //                        if(((LastTransQuantity)as NSString).doubleValue < 10)
                            //                        {
                            //                            if(odometer < PreviousOdo){
                            //                                self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager." )
                            //                            self.Activity.stopAnimating()
                            //                            self.Activity.isHidden = true
                            //                            self.viewWillAppear(true)
                            //                            }
                            //                            else
                            //                            {
                            //                                self.send_data()
                            //
                            //                            }
                            //                        }
                            //                        else{
                            //                            if(odometer <= PreviousOdo){
                            //                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager." )
                            //                            self.Activity.stopAnimating()
                            //                            self.Activity.isHidden = true
                            //                            self.viewWillAppear(true)
                            //                            }
                            //                            else
                            //                            {
                            //                                self.send_data()
                            //                            }
                            if(odometer > 0)
                            {
                                self.send_data()
                            }
                            else{
                                self.showAlert(message:"Please check and try again. If the issue persists, please contact your Manager.")
                            }
                            
                        }
                        else{
                            self.Activity.stopAnimating()
                            self.Activity.isHidden = true
                            
                            if(odometer < PreviousOdo){
                                self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                self.Activity.stopAnimating()
                                self.Activity.isHidden = true
                                self.viewWillAppear(true)
                            }
                            else{
                                if(Vehicaldetails.sharedInstance.Language == "es-ES")
                                {
                                    self.showAlert(message: "El \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)" + NSLocalizedString("Odometer_Reasonability", comment:""))
                                }
                                else{
                                    self.showAlert(message: "The \(Vehicaldetails.sharedInstance.ScreenNameForOdometer)" + NSLocalizedString("Odometer_Reasonability", comment:""))
                                }
                                self.viewWillAppear(true)
                            }
                        }
                    }
                }
            }
        }
    }
}

