//  HourViewController.swift
//  FuelSecure
//
//  Created by VASP on 6/30/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit

class HourViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var oview: UIView!
    @IBOutlet var Hour: UITextField!
    @IBOutlet var Activity: UIActivityIndicatorView!
    @IBOutlet var Go: UIButton!
    @IBOutlet var Hourlabel: UILabel!

    var web = Webservices()
    var sysdata:NSDictionary!
    var cf = Commanfunction()
//    var stoptimergotostart:Timer = Timer()
    var Hourstoptimergotostart:Timer = Timer()
    var IsSavebuttontapped : Bool = false
    var countfailauth:Int = 0
    var countdata = 0
    var appisonhourscreen = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Hour.delegate = self
        Hour.font = UIFont(name: Hour.font!.fontName, size: 40)
        Hour.text = Vehicaldetails.sharedInstance.hours

        if(Vehicaldetails.sharedInstance.Language == "es-ES")
         {
             Hourlabel.text = "Ingrese  \(Vehicaldetails.sharedInstance.ScreenNameForHours)"
         }
         else{
        Hourlabel.text = "Enter \(Vehicaldetails.sharedInstance.ScreenNameForHours)"
         }

        var myMutableStringTitle = NSMutableAttributedString()
        var Name  = "Enter \(Vehicaldetails.sharedInstance.ScreenNameForHours)" // PlaceHolderText
        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            Name = "Ingrese  \(Vehicaldetails.sharedInstance.ScreenNameForHours)"
        }
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        Hour.attributedPlaceholder = myMutableStringTitle

        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State())
        doneButton.addTarget(self, action: #selector(tapAction), for: UIControl.Event.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        Hour.returnKeyType = .done
        Hour.inputAccessoryView = doneButton
        Hour.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        Activity.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        Hour.becomeFirstResponder()
        
        
        Hourstoptimergotostart.invalidate()
        Hourstoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(HourViewController.gotostart), userInfo: nil, repeats: false)
        Go.isEnabled = true
        Activity.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        Hourstoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
        appisonhourscreen = false
        Hourstoptimergotostart.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        Hourstoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
        appisonhourscreen = false
        Hourstoptimergotostart.invalidate()
    }

    @objc func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }

    @objc func gotostart(){
        if(appisonhourscreen == true){
        self.web.sentlog(func_name: "Hour_screen_timeout, back to home screen", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
        }
        else
        {
            Hourstoptimergotostart.invalidate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func hour(_ sender: Any) {
        checkMaxLength(textField: Hour, maxLength:7)
    }

    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }

    @IBAction func reset(sender: AnyObject) {
        Hourstoptimergotostart.invalidate()
        viewWillAppear(true)
        Hour.text = ""
    }

    //AUTHENTICATION FUNCTION CALL

    func mainPage()
    {
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
        {

            self.performSegue(withIdentifier: "GoUDP", sender: self)

        }
        else{
        self.performSegue(withIdentifier: "Go", sender: self)
        }
    }

    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
        countfailauth += 1
        let Split = data.components(separatedBy: "#@*%*@#")
        let reply = Split[0] 
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
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
            if(sysdata == nil){
                
            }
            else{
           // print(sysdata) Check the response and if it is true than pase it other wise display message
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString

            if(ResponceMessage == "success")
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                    if #available(iOS 12.0, *) {
                        self.web.wifisettings(pagename: "Hour")
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
                                self.Hourstoptimergotostart.invalidate()
//
                                self.performSegue(withIdentifier: "GoUDP", sender: self)
//
                            }
                            else{
                                self.Hourstoptimergotostart.invalidate()
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
                    }}
            }
            else {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                if(ResponceMessage == "fail")
                {
                    if(ValidationFailFor == "Vehicle") {
                        Hourstoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "Vehicle", sender: self)

                    }else if(ValidationFailFor == "Dept")
                    {
                        Hourstoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "dept", sender: self)
                    }else if(ValidationFailFor == "Odo")
                    {
                        Hourstoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "odometer", sender: self)
                    }
                    else if(ValidationFailFor == "Pin")
                    {
                        Hourstoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "pin", sender: self)
                    }
                    showAlert(message: "\(ResponceText)")
                }
            }
        }
        }
    }

    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 12.0, *) {
            self.web.wifisettings(pagename: "Hour")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }
    func send_data()
    {
        
        let IsExtraOther = Vehicaldetails.sharedInstance.IsExtraOther
        let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
        let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
        let isother = Vehicaldetails.sharedInstance.IsOtherRequire
       
        
        //    parameter name: ErrorCode
        //  Value : 1 (This for attempting odometer more than 3)
        Vehicaldetails.sharedInstance.Errorcode = "1"
        
        if (IsExtraOther == "True"){
            self.performSegue(withIdentifier: "otherVehicle", sender: self)
            self.Activity.stopAnimating()
            self.Activity.isHidden = true
        }else
        if(isdept == "True"){
            self.countdata = 0
            self.performSegue(withIdentifier: "dept", sender: self)
        }
        else{
            if(isPPin == "True"){
                self.countdata = 0
                self.performSegue(withIdentifier: "pin", sender: self)
            }
            else{
                if(isother == "True"){
                    self.countdata = 0
                    self.performSegue(withIdentifier: "other", sender: self)
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

    @IBAction func saveButtontapped(sender: AnyObject) {
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
            
            delay(1){
                self.IsSavebuttontapped = true
                self.Hourstoptimergotostart.invalidate()
                self.tapAction()
                if(self.Hour.text == "")
                {
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    if(Vehicaldetails.sharedInstance.Language == "es-ES")
                    {
                        self.showAlert(message:NSLocalizedString("EneterHour", comment:""))
                    }
                    else{
                        self.showAlert(message: "Please Enter \(Vehicaldetails.sharedInstance.ScreenNameForHours)")
                    }
                    
                    self.Hourstoptimergotostart.invalidate()
                    self.viewWillAppear(true)
                }
                else
                {
                    if(Int(self.Hour.text!) == nil)
                    {
                        self.Activity.stopAnimating()
                        self.Activity.isHidden = true
                        self.showAlert(message: NSLocalizedString("EnterHour_Eng", comment:""))
                        
                    }
                    else{
                        let LastTransQuantity = Vehicaldetails.sharedInstance.LastTransactionFuelQuantity
                        let hour:Int! = Int(self.Hour.text!)
                        Vehicaldetails.sharedInstance.hours = "\(hour!)"
                        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                        {
                            self.web.sentlog(func_name: "Hour Entered : \(hour!) ", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: "")
                        }
                        else{
                            self.web.sentlog(func_name: "Hour Entered : \(hour!) ", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")
                        }
                        let IsExtraOther = Vehicaldetails.sharedInstance.IsExtraOther
                        //                   // let hours = Vehicaldetails.sharedInstance.IsHoursrequirs
                        let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
                        let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                        let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                        let CheckOdometerReasonable = Vehicaldetails.sharedInstance.CheckOdometerReasonable
                        let OdometerReasonabilityConditions = Vehicaldetails.sharedInstance.OdometerReasonabilityConditions
                        let Hourlimit:Int = Vehicaldetails.sharedInstance.HoursLimit
                        let Previoushours:Int = Vehicaldetails.sharedInstance.PreviousHours
                        
                        if(CheckOdometerReasonable == "True"){
                            
                            if(OdometerReasonabilityConditions == "1"){
                                
                                if(Hourlimit >= hour && hour >= Previoushours)
                                {
                                    
                                    if (IsExtraOther == "True"){
                                        self.performSegue(withIdentifier: "otherVehicle", sender: self)
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                    }else
                                    if(isdept == "True"){
                                        self.countdata = 0
                                        self.Hourstoptimergotostart.invalidate()
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                        self.performSegue(withIdentifier: "dept", sender: self)
                                    }
                                    else{
                                        if(isPPin == "True"){
                                            self.countdata = 0
                                            self.Hourstoptimergotostart.invalidate()
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            self.performSegue(withIdentifier: "pin", sender: self)
                                        }
                                        else{
                                            if(isother == "True"){
                                                self.Activity.stopAnimating()
                                                self.Activity.isHidden = true
                                                self.countdata = 0
                                                self.Hourstoptimergotostart.invalidate()
                                                self.performSegue(withIdentifier: "other", sender: self)
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
                                else{
                                    self.countdata += 1
                                    
                                    if(self.countdata >  3){
                                        if(((LastTransQuantity)as NSString).doubleValue < 10)
                                        {
                                            if(hour < Previoushours){
                                                self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                                self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
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
                                            if(hour <= Previoushours){
                                                self.showAlert(message: NSLocalizedString("warningOdoHour", comment:""))
//                                                self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                                self.Activity.stopAnimating()
                                                self.Activity.isHidden = true
                                                self.viewWillAppear(true)
                                            }
                                            else
                                            {
                                                self.send_data()
                                            }
                                            //                                    if(((LastTransQuantity)as NSString).doubleValue <= 10 || hour <= Previoushours)
                                            //                                    {
                                            //                                        self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                                            //                                        self.Activity.stopAnimating()
                                            //                                        self.Activity.isHidden = true
                                            //                                        self.viewWillAppear(true)
                                            //                                    }
                                            //                                    else
                                            //                                    {
                                            //                                    if (IsExtraOther == "True"){
                                            //                                        self.performSegue(withIdentifier: "otherVehicle", sender: self)
                                            //                                        self.Activity.stopAnimating()
                                            //                                        self.Activity.isHidden = true
                                            //                                    }else
                                            //                                    if(isdept == "True"){
                                            //                                        self.countdata = 0
                                            //                                        self.performSegue(withIdentifier: "dept", sender: self)
                                            //                                    }
                                            //                                    else{
                                            //                                        if(isPPin == "True"){
                                            //                                            self.countdata = 0
                                            //                                            self.performSegue(withIdentifier: "pin", sender: self)
                                            //                                        }
                                            //                                        else{
                                            //                                            if(isother == "True"){
                                            //                                                self.countdata = 0
                                            //                                                self.performSegue(withIdentifier: "other", sender: self)
                                            //                                            }
                                            //                                            else{
                                            //                                                let deptno = ""
                                            //                                                let ppin = ""
                                            //                                                let other = ""
                                            //                                                Vehicaldetails.sharedInstance.deptno = ""
                                            //                                                Vehicaldetails.sharedInstance.Personalpinno = ""
                                            //                                                Vehicaldetails.sharedInstance.Other = ""
                                            //                                                self.senddata(deptno: deptno,ppin:ppin,other:other)
                                            //                                            }
                                            //                                        }
                                            //                                    }
                                        }
                                    }
                                    else{
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                        self.showAlert(message: NSLocalizedString("Hour_Reasonability", comment:""))
                                        self.viewWillAppear(true)
                                        print(self.countdata)
                                    }
                                }
                                
                            } else if(OdometerReasonabilityConditions == "2"){
                                
                                if(Hourlimit >= hour && hour >= Previoushours)
                                {
                                    
                                    Vehicaldetails.sharedInstance.hours = ""
                                    if (IsExtraOther == "True"){
                                        self.performSegue(withIdentifier: "otherVehicle", sender: self)
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                    }else
                                    if(isdept == "True"){
                                        self.countdata = 0
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                        self.performSegue(withIdentifier: "dept", sender: self)
                                    }
                                    else{
                                        if(isPPin == "True"){
                                            self.countdata = 0
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                            self.performSegue(withIdentifier: "pin", sender: self)
                                        }
                                        else{
                                            if(isother == "True"){
                                                self.countdata = 0
                                                self.Activity.stopAnimating()
                                                self.Activity.isHidden = true
                                                self.performSegue(withIdentifier: "other", sender: self)
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
                                else{
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                    self.showAlert(message: NSLocalizedString("Hour_Reasonability", comment:""))
                                    self.viewWillAppear(true)
                                }
                            }
                        }
                        else if (CheckOdometerReasonable == "False"){
                            
                            if(hour > 0)
                            {
                                self.send_data()
                            }
                            else{
                                self.showAlert(message:"Please check and try again. If the issue persists, please contact your Manager.")
                            }
                            //#1750
                            //                        if(((LastTransQuantity)as NSString).doubleValue < 10)
                            //                        {
                            //                            if(hour < Previoushours){
                            //                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
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
                            //                            if(hour <= Previoushours){
                            //                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                            //                            self.Activity.stopAnimating()
                            //                            self.Activity.isHidden = true
                            //                            self.viewWillAppear(true)
                            //                            }
                            //                            else
                            //                            {
                            //                                self.send_data()
                            //                            }
                            
                            //                        if(((LastTransQuantity)as NSString).doubleValue <= 10 && hour < Previoushours)
                            //                        {
                            //                            self.showAlert(message: "You have entered a reading that was previously entered. Please check and try again. If the issue persists, please contact your Manager.")
                            //                            self.Activity.stopAnimating()
                            //                            self.Activity.isHidden = true
                            //                            self.viewWillAppear(true)
                            //                        }
                            //                        else
                            //                        {
                            //
                            //                        if (IsExtraOther == "True"){
                            //                            self.performSegue(withIdentifier: "otherVehicle", sender: self)
                            //                        }else
                            //                        if(isdept == "True"){
                            //                            self.performSegue(withIdentifier: "dept", sender: self)
                            //                        }
                            //                        else//{
                            //                            if(isPPin == "True"){
                            //                                self.performSegue(withIdentifier: "pin", sender: self)
                            //                            }
                            //                            else//{
                            //                                if(isother == "True"){
                            //                                    self.performSegue(withIdentifier: "other", sender: self)
                            //                                }
                            //                                else{
                            //                                    let deptno = ""
                            //                                    let ppin = ""
                            //                                    let other = ""
                            //                                    Vehicaldetails.sharedInstance.deptno = ""
                            //                                    Vehicaldetails.sharedInstance.Personalpinno = ""
                            //                                    Vehicaldetails.sharedInstance.Other = ""
                            //                                    self.senddata(deptno: deptno,ppin:ppin,other:other)
                            //                        }
                            //                        }
                        }
                        
                        else{
                            self.Activity.stopAnimating()
                            self.Activity.isHidden = true
                            self.showAlert(message: NSLocalizedString("Hour_Reasonability", comment:""))
                            self.viewWillAppear(true)
                        }
                    }
                }
            }
        }
    }
}



