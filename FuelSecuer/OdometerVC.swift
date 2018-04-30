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

    var web = Webservices()
    var confs = FuelquantityVC()
    var sysdata:NSDictionary!
    var cf = Commanfunction()
    var countdata = 0
    var IsSavebuttontapped : Bool = false
    var IsGobuttontapped : Bool = false
    var stoptimergotostart:Timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Odometer.delegate = self
        Odometer.font = UIFont(name: Odometer.font!.fontName, size: 40)
        //Odometer.text = Vehicaldetails.sharedInstance.Odometerno
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle("Return", for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(OdometerVC.tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        Odometer.returnKeyType = .done
        Odometer.inputAccessoryView = doneButton
        Odometer.autocapitalizationType = UITextAutocapitalizationType.allCharacters

    }
    override func viewWillAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()

     stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(OdometerVC.gotostart), userInfo: nil, repeats: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }

    func gotostart(){

        self.web.sentlog(func_name: "Odometer")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()

    }

   func tapAction() {//(sender: UITapGestureRecognizer) {
       self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
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

        // Change Message With Color and Font
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.characters.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func odometer(_ sender: Any)
    {
        checkMaxLength(textField: Odometer, maxLength:6)
    }

    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }

    @IBAction func reset(sender: AnyObject) {
        Odometer.text = ""
        viewWillAppear(true)
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.characters.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
          let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                print("ssID Match")
                self.performSegue(withIdentifier: "Go", sender: self)
            }
            else
            {
                self.wifisettings()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func Action(sender:UIButton!)
    {
       self.dismiss(animated: true, completion: nil)
       wifisettings()
    }

    //AUTHENTICATION FUNCTION CALL
    func wifisettings()
    {
        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared// .shared
        app.openURL(url! as URL)
        mainPage()
    }

    func mainPage()
    {
        if(Vehicaldetails.sharedInstance.SSId == cf.getSSID())
        {
           self.performSegue(withIdentifier: "Go", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "Go", sender: self)
        }

    }

    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer:Int! = Int(odom)!
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other)
        let Split = data.components(separatedBy: "#")
        let reply = Split[0] as! String
        let error = Split[1]as! String
        if (reply == "-1")
        {
            showAlert(message: "\(error) \n Please try again later" )
        }
        else
        {
            let data1:Data = reply.data(using: String.Encoding.utf8)! 
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(sysdata)
            //defaults.removeObjectForKey("SSID")
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString

            if(ResponceMessage == "success")
            {
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                    let alertController = UIAlertController(title: "FluidSecure needs to connect to Hose via WiFi", message: "Please Connect Wifi \(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertControllerStyle.alert)
                    // Background color.
                    let backView = alertController.view.subviews.last?.subviews.last
                    backView?.layer.cornerRadius = 10.0
                    backView?.backgroundColor = UIColor.white

                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = NSTextAlignment.left

                    let paragraphStyle1 = NSMutableParagraphStyle()
                    paragraphStyle1.alignment = NSTextAlignment.left

                    let attributedString = NSAttributedString(string:"FluidSecure needs to connect to HOSE via WiFi\nYou will now be redirected to the WiFi setup", attributes: [
                        NSParagraphStyleAttributeName:paragraphStyle1,
                        NSFontAttributeName : UIFont.systemFont(ofSize: 20), //your font here
                        NSForegroundColorAttributeName : UIColor.black
                        ])


                    var formattedString = NSMutableAttributedString()
                    
                    formattedString
                        .normal("\nThe WiFi name is the name of the HOSE. Read Steps 1 to 5 below then click on Green bar below.\n\nFollow steps:\n1. Turn on the WiFi (it might already be on)\n\n2. Choose the WiFi \n named: ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(" \n\n3. First time it will ask for password,enter: 123456789\n\n4. It will have a check next to ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(" and it will say \"No Internet Connection\" \n\n5.  Now, tap on the very top left corner that says \"FluidSecure\" - this returns you to allow fueling.\n\n\n\n\n\n")

                    
                    alertController.setValue(formattedString, forKey: "attributedMessage")
                    alertController.setValue(attributedString, forKey: "attributedTitle")

                    // Action.

                    //alertController.view.addSubview(createSwitch())

                    // alertController.view.tintColor = UIColor.greenColor()

                    let btnImage = UIImage(named: "checkbox-checked")!
                    let imageButton : UIButton = UIButton(frame: CGRect(x: 220, y: 235, width: 20, height: 20))
                    imageButton.setBackgroundImage(btnImage, for: UIControlState())


                    let btnsetting = UIImage(named: "Button-Green")!
                    let imageButtonws : UIButton = UIButton(frame: CGRect(x: 1, y: 500, width: 270, height: 40))
                    imageButtonws.setBackgroundImage(btnsetting, for: UIControlState())
                    imageButtonws.setTitle("Go To WiFi Settings", for: UIControlState.normal)
                    imageButtonws.setTitleColor(UIColor.white, for: UIControlState.normal)
                    imageButtonws.addTarget(self, action: #selector(OdometerVC.Action(sender:)), for:.touchUpInside)

                    //alertController.view.addSubview(imageButton)
                    //alertController.view.addSubview(imageButtonwifi)
                    alertController.view.addSubview(imageButtonws)

                    //alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                    self.performSegue(withIdentifier: "Go", sender: self)
                }
            }

            else {

                if(ResponceMessage == "fail")
                {
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

//    func createSwitch() -> UISwitch{
//
//       let switchControl = UISwitch(frame:CGRect(x: 100, y: 210, width: 0, height: 0));
//       if(Vehicaldetails.sharedInstance.reachblevia == "wificonn"){
//        switchControl.isOn = false
//        switchControl.setOn(true, animated: false);
//        //switchControl.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged);
//         switchControl.isEnabled = false
//        return switchControl
//        }
//        else if(Vehicaldetails.sharedInstance.reachblevia != "wificonn"){
//        switchControl.isOn = true
//            switchControl.setOn(true, animated: false);
//        switchControl.isEnabled = false
//
//            return switchControl
//        }
//        return switchControl
//    }

    func switchValueDidChange(sender:UISwitch!){
        
        print("Switch Value : \(sender.isOn))")
    }

    @IBAction func saveButtontapped(sender: UIButton) {

        tapAction()
        stoptimergotostart.invalidate()
        // viewWillAppear(true)
         IsGobuttontapped = true
     //   viewDidLoad()
        if(Odometer.text == "")
        {
            showAlert(message: "Please Enter Odometer Number.")
            viewWillAppear(true)
        }
        else
        {
            let odometer:Int! = Int(Odometer.text!)
            Vehicaldetails.sharedInstance.Odometerno = "\(odometer!)"
            Odometer.text = Vehicaldetails.sharedInstance.Odometerno
            let hours = Vehicaldetails.sharedInstance.IsHoursrequirs
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
                        if (hours == "True"){
                            self.performSegue(withIdentifier: "hour", sender: self)
                        }
                        else{
                            Vehicaldetails.sharedInstance.hours = ""
                        if(isdept == "True"){
                            countdata = 0
                            stoptimergotostart.invalidate()
                            self.performSegue(withIdentifier: "dept", sender: self)
                        }
                        else{
                            if(isPPin == "True"){
                                 countdata = 0
                                stoptimergotostart.invalidate()
                                self.performSegue(withIdentifier: "pin", sender: self)
                            }
                            else{
                                if(isother == "True"){
                                     countdata = 0
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
                                      self.senddata(deptno: deptno,ppin:ppin,other:other)
                                    }
                                }
                            }
                        }
                    }
                    else{
                        countdata += 1

                        if(countdata >  3){
                            if (hours == "True"){
                                self.performSegue(withIdentifier: "hour", sender: self)
                            }
                            else{
                                Vehicaldetails.sharedInstance.hours = ""
                        if(isdept == "True"){
                             countdata = 0
                            self.performSegue(withIdentifier: "dept", sender: self)
                        }
                        else{
                            if(isPPin == "True"){
                                 countdata = 0
                                self.performSegue(withIdentifier: "pin", sender: self)
                            }
                            else{
                                if(isother == "True"){
                                     countdata = 0
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
                    }
                        else{
                                showAlert(message: "The odometer entered is not within the reasonability your administrator has assigned, please contact your administrator.")
                            viewWillAppear(true)
                                print(countdata)
                            }
                        }

                } else if(OdometerReasonabilityConditions == "2"){

                    if(OdoLimit >= odometer && odometer >= PreviousOdo)
                    {
                        if (hours == "True"){
                            self.performSegue(withIdentifier: "hour", sender: self)
                        }
                        else{
                            Vehicaldetails.sharedInstance.hours = ""
                        if(isdept == "True"){
                             countdata = 0
                            self.performSegue(withIdentifier: "dept", sender: self)
                        }
                        else{
                            if(isPPin == "True"){
                                 countdata = 0
                                self.performSegue(withIdentifier: "pin", sender: self)
                            }
                            else{
                                if(isother == "True"){
                                     countdata = 0
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
                    }

                else{
                        showAlert(message: "The odometer entered is not within the reasonability your administrator has assigned, please contact your administrator.")
                        viewWillAppear(true)
                        
                    }
                }
            }
            else if (CheckOdometerReasonable == "False"){
                if(odometer >= PreviousOdo)
                {
                if(isdept == "True"){
                    self.performSegue(withIdentifier: "dept", sender: self)
                }
                else{
                    if(isPPin == "True"){
                        self.performSegue(withIdentifier: "pin", sender: self)
                    }
                    else{
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
                     }
                 }
                else{
                    showAlert(message: "The odometer entered is not within the reasonability your administrator has assigned, please contact your administrator.")
                    viewWillAppear(true)
                }
             }
          }
       }
    }
