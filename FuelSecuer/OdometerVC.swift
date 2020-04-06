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
    var stoptimergotostart:Timer = Timer()
    var countfailauth:Int = 0
    
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
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(OdometerVC.gotostart), userInfo: nil, repeats: false)
        Go.isEnabled = true
        Activity.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }
    
    @objc func gotostart(){
        self.web.sentlog(func_name: "Odometer", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
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
    
    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        
        if #available(iOS 11.0, *) {
            self.web.wifisettings(pagename: "Odometer")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }
    
    //AUTHENTICATION FUNCTION CALL
    
    func mainPage()
    {
        if(Vehicaldetails.sharedInstance.SSId == cf.getSSID())
        {
            self.performSegue(withIdentifier: "Go", sender: self)
        }
        else
        {
            self.web.sentlog(func_name: "Go button Tapped user need to select Wifi data Manually", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
            self.performSegue(withIdentifier: "Go", sender: self)
        }
    }
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer:Int! = Int(odom)!
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        countfailauth += 1
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
        let Split = data.components(separatedBy: "#")
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
            
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString
            
            if(ResponceMessage == "success")
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
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
                            self.performSegue(withIdentifier: "Go", sender: self)
                        }
                        alertController.addAction(action)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    self.mainPage()
                    
                }
                
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                    self.performSegue(withIdentifier: "Go", sender: self)
                }
            }
            else {
                
                if(ResponceMessage == "fail")
                {
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    if(ValidationFailFor == "Vehicle") {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "Vehicle", sender: self)
                        
                    }else if(ValidationFailFor == "Dept")
                    {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "dept", sender: self)
                    }else if(ValidationFailFor == "Odo")
                    {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "odometer", sender: self)
                    }
                    else if(ValidationFailFor == "Pin")
                    {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "pin", sender: self)
                    }
                }
                showAlert(message: "\(ResponceText)")
            }
        }
    }
    
    func switchValueDidChange(sender:UISwitch!){
        
        print("Switch Value : \(sender.isOn))")
    }
    
    @IBAction func saveButtontapped(sender: UIButton) {
        Activity.startAnimating()
        Activity.isHidden = false
        Go.isEnabled = false
        cf.delay(1){
            self.tapAction()
            self.stoptimergotostart.invalidate()
            self.IsGobuttontapped = true
            if(self.Odometer.text == "")
            {
                if(Vehicaldetails.sharedInstance.Language == "es-ES")
                               {
                                    self.showAlert(message:NSLocalizedString("EneterOdometer", comment:""))
                               }
                               else{
                              self.showAlert(message: "Enter \(Vehicaldetails.sharedInstance.ScreenNameForOdometer) Reading")
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
                    let hours = Vehicaldetails.sharedInstance.IsHoursrequirs
                    let IsExtraOther = Vehicaldetails.sharedInstance.IsExtraOther
                    let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
                    let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                    let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                    let CheckOdometerReasonable = Vehicaldetails.sharedInstance.CheckOdometerReasonable
                    let OdometerReasonabilityConditions = Vehicaldetails.sharedInstance.OdometerReasonabilityConditions
                    let PreviousOdo:Int = Vehicaldetails.sharedInstance.PreviousOdo
                    let OdoLimit:Int = Vehicaldetails.sharedInstance.OdoLimit
                    
                    if(CheckOdometerReasonable == "True"){
                        
                        if(OdometerReasonabilityConditions == "1"){
                            
                            if(OdoLimit >= odometer && odometer >= PreviousOdo)
                            {
                                Vehicaldetails.sharedInstance.Errorcode = "0"
                                if (hours == "True"){
                                    self.performSegue(withIdentifier: "hour", sender: self)
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                }else
                                    if (IsExtraOther == "True"){
                                        self.performSegue(withIdentifier: "otherVehicle", sender: self)
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                    }
                                else{
                                    Vehicaldetails.sharedInstance.hours = ""
                                    if(isdept == "True"){
                                        self.countdata = 0
                                        self.stoptimergotostart.invalidate()
                                        self.performSegue(withIdentifier: "dept", sender: self)
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                    }
                                    else{
                                        if(isPPin == "True"){
                                            self.countdata = 0
                                            self.stoptimergotostart.invalidate()
                                            self.performSegue(withIdentifier: "pin", sender: self)
                                            self.Activity.stopAnimating()
                                            self.Activity.isHidden = true
                                        }
                                        else{
                                            if(isother == "True"){
                                                self.countdata = 0
                                                self.stoptimergotostart.invalidate()
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
                            else{
                                self.countdata += 1
                                
                                if(self.countdata > 3){
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
                                else{
                                    Vehicaldetails.sharedInstance.Errorcode = "0"
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                    self.showAlert(message: NSLocalizedString("Odometer_Reasonability", comment:""))
                                    self.viewWillAppear(true)
                                    print(self.countdata)
                                }
                            }
                            
                        } else if(OdometerReasonabilityConditions == "2"){
                            Vehicaldetails.sharedInstance.Errorcode = "0"
                            if(OdoLimit >= odometer && odometer >= PreviousOdo)
                            {
                                if (hours == "True"){
                                    self.performSegue(withIdentifier: "hour", sender: self)
                                    self.Activity.stopAnimating()
                                    self.Activity.isHidden = true
                                }else
                                    if (IsExtraOther == "True"){
                                        self.performSegue(withIdentifier: "otherVehicle", sender: self)
                                        self.Activity.stopAnimating()
                                        self.Activity.isHidden = true
                                    }
                                else{
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
                            else{
                                Vehicaldetails.sharedInstance.Errorcode = "0"
                                self.Activity.stopAnimating()
                                self.Activity.isHidden = true
                                self.showAlert(message: NSLocalizedString("Odometer_Reasonability", comment:""))
                                self.viewWillAppear(true)
                            }
                        }
                    }
                    else if (CheckOdometerReasonable == "False"){
                        
                        if (hours == "True"){
                            self.performSegue(withIdentifier: "hour", sender: self)
                        }else
                            if (IsExtraOther == "True"){
                                self.performSegue(withIdentifier: "otherVehicle", sender: self)
                             
                            }
                        else
                            if(isdept == "True"){
                                self.performSegue(withIdentifier: "dept", sender: self)
                            }
                            else
                                if(isPPin == "True"){
                                    self.performSegue(withIdentifier: "pin", sender: self)
                                }
                                else
                                    if(isother == "True"){
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
                    else{
                        self.Activity.stopAnimating()
                        self.Activity.isHidden = true
                        self.showAlert(message: NSLocalizedString("Odometer_Reasonability", comment:""))
                        self.viewWillAppear(true)
                    }
                }
            }
        }
    }
}

