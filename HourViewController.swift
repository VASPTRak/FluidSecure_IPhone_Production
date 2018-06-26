//  HourViewController.swift
//  FuelSecure
//
//  Created by VASP on 6/30/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit

class HourViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var oview: UIView!
    @IBOutlet var Hour: UITextField!

    var web = Webservices()
    var confs = FuelquantityVC()
    var sysdata:NSDictionary!
    var cf = Commanfunction()
    var stoptimergotostart:Timer = Timer()
    var IsSavebuttontapped : Bool = false
    var countfailauth:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Hour.delegate = self
        Hour.font = UIFont(name: Hour.font!.fontName, size: 40)
        Hour.text = Vehicaldetails.sharedInstance.hours
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle("Return", for: UIControlState())
        doneButton.addTarget(self, action: #selector(tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        Hour.returnKeyType = .done
        Hour.inputAccessoryView = doneButton
        Hour.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }

    override func viewWillAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(HourViewController.gotostart), userInfo: nil, repeats: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }

    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }

    func gotostart(){
        self.web.sentlog(func_name: "Hour_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAlert(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        // Change Message With Color and Font
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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
        stoptimergotostart.invalidate()
        viewWillAppear(true)
        Hour.text = ""
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
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                print("ssID Match")
                self.performSegue(withIdentifier: "Go", sender: self)
            }
            else{
                self.web.wifisettings(pagename: "Hour")//self.wifisettings()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    //AUTHENTICATION FUNCTION CALL

    func mainPage()
    {
        self.performSegue(withIdentifier: "Go", sender: self)
    }

    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other)
        countfailauth += 1
        let Split = data.components(separatedBy: "#")
        let reply = Split[0] 
        //let error = Split[1]
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
                showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))//"Please wait momentarily check your internet connection & try again.")//"\(error) \n Please try again later")
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
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString

            if(ResponceMessage == "success")
            {
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                    let alertController = UIAlertController(title: NSLocalizedString("Title", comment:""), message: NSLocalizedString("Message", comment:"") + "\(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertControllerStyle.alert)
                    // Background color.
                    let backView = alertController.view.subviews.last?.subviews.last
                    backView?.layer.cornerRadius = 10.0
                    backView?.backgroundColor = UIColor.white

                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = NSTextAlignment.left

                    let paragraphStyle1 = NSMutableParagraphStyle()
                    paragraphStyle1.alignment = NSTextAlignment.left

                    let attributedString = NSAttributedString(string:NSLocalizedString("Subtitle", comment:""), attributes: [
                        NSParagraphStyleAttributeName:paragraphStyle1,
                        NSFontAttributeName : UIFont.systemFont(ofSize: 20), //your font here
                        NSForegroundColorAttributeName : UIColor.black
                        ])

                    let formattedString = NSMutableAttributedString()
                    formattedString
                        .normal(NSLocalizedString("Step1", comment:""))//("\nThe WiFi name is the name of the HOSE. Read Steps 1 to 5 below then click on Green bar below.\n\nFollow steps:\n1. Turn on the WiFi (it might already be on)\n\n2. Choose the WiFi \n named: ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(NSLocalizedString("Step2", comment:""))//(" \n\n3. First time it will ask for password,enter: 123456789\n\n4. It will have a check next to ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(NSLocalizedString("Step3", comment:""))//" and it will say \"No Internet Connection\" \n\n5.  Now, tap on the very top left corner that says \"FluidSecure\" - this returns you to allow fueling.\n\n\n\n\n")

                    alertController.setValue(formattedString, forKey: "attributedMessage")
                    alertController.setValue(attributedString, forKey: "attributedTitle")

                    // Action.

                    let btnsetting = UIImage(named: "Button-Green")!
                    let imageButtonws : UIButton = UIButton(frame: CGRect(x: 5, y: 500, width: 260, height: 40))
                    imageButtonws.setBackgroundImage(btnsetting, for: UIControlState())
                    imageButtonws.setTitle("Go To WiFi Settings", for: UIControlState.normal)
                    imageButtonws.setTitleColor(UIColor.white, for: UIControlState.normal)
                    imageButtonws.addTarget(self, action: #selector(OdometerVC.Action(sender:)), for:.touchUpInside)

                    alertController.view.addSubview(imageButtonws)
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
                    showAlert(message: "\(ResponceText)")
                }
            }
        }
    }

    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        self.web.wifisettings(pagename: "Hour")//wifisettings()
        mainPage()
    }

    @IBAction func saveButtontapped(sender: AnyObject) {
        IsSavebuttontapped = true
        stoptimergotostart.invalidate()
        tapAction()
        if(Hour.text == "")
        {
            showAlert(message: NSLocalizedString("EnterHour", comment:""))//"Please Enter Hour.")
            stoptimergotostart.invalidate()
            viewWillAppear(true)
        }
        else
        {
            let hour:Int! = Int(Hour.text!)
            Vehicaldetails.sharedInstance.hours = "\(hour!)"
            Hour.text = Vehicaldetails.sharedInstance.hours
            let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
            let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
            let isother = Vehicaldetails.sharedInstance.IsOtherRequire

            if(isdept == "True"){
                stoptimergotostart.invalidate()
                self.performSegue(withIdentifier: "dept", sender: self)
            }
            else{
                if(isPPin == "True"){
                    stoptimergotostart.invalidate()
                    self.performSegue(withIdentifier: "pin", sender: self)
                }
                else{
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
                        self.senddata(deptno: deptno,ppin:ppin,other:other)
                    }
                }
            }
        }
    }
}


