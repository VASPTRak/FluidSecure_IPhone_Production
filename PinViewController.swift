//  PinViewController.swift
//  FuelSecure
//
//  Created by VASP on 6/30/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit

class PinViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var oview: UIView!
    @IBOutlet var Pin: UITextField!
    
    var stoptimergotostart:Timer = Timer()
    var web = Webservices()
    var confs = FuelquantityVC()
    var sysdata:NSDictionary!
    var cf = Commanfunction()
    var IsSavebuttontapped : Bool = false
    var countfailauth:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Pin.delegate = self
        Pin.font = UIFont(name: Pin.font!.fontName, size: 40)
        Pin.text = Vehicaldetails.sharedInstance.Personalpinno
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(OdometerVC.tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor.black
        Pin.returnKeyType = .done
        Pin.inputAccessoryView = doneButton
        Pin.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(PinViewController.gotostart), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }
    
    @objc func gotostart(){
        self.web.sentlog(func_name: "Personalpin_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func odometer(_ sender: Any) {
        checkMaxLength(textField: Pin, maxLength:10)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    @IBAction func reset(sender: AnyObject) {
        stoptimergotostart.invalidate()
        viewWillAppear(true)
        Pin.text = ""
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
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                print("ssID Match")
                self.performSegue(withIdentifier: "Go", sender: self)
            }
            else{
                if #available(iOS 11.0, *) {
                    self.web.wifisettings(pagename: "PersonalPin")
                } else {
                    // Fallback on earlier versions
                }
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
    
    func senddata(other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        let isppin = Pin.text
        let deptno = ""
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        countfailauth += 1
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:isppin!,isother:other)
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
                showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))
            }else{
                self.senddata(other:other)
            }
            stoptimergotostart.invalidate()
            viewWillAppear(true)
        }
        else
        {   countfailauth = 0
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
                    if #available(iOS 11.0, *) {
                        self.web.wifisettings(pagename: "PersonalPin")
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
                    self.mainPage()

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
                        self.performSegue(withIdentifier: "Dept", sender: self)
                    }else if(ValidationFailFor == "Odo")
                    {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "Odo", sender: self)
                    }
                    showAlert(message: "\(ResponceText)")
                    stoptimergotostart.invalidate()
                }
            }
        }
    }
    
    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 11.0, *) {
            self.web.wifisettings(pagename: "PersonalPin")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }
    
    @IBAction func saveButtontapped(sender: AnyObject) {
        IsSavebuttontapped = true
        stoptimergotostart.invalidate()
        
        tapAction()
        if(Pin.text == "")
        {
            showAlert(message: NSLocalizedString("EnterPin", comment:""))
            stoptimergotostart.invalidate()
            viewWillAppear(true)
        }
        else
        {
            let pinno = Pin.text!
            Vehicaldetails.sharedInstance.Personalpinno = "\(pinno)"
            Pin.text = Vehicaldetails.sharedInstance.Personalpinno
            let isother = Vehicaldetails.sharedInstance.IsOtherRequire
            
            if(isother == "True")
            {
                stoptimergotostart.invalidate()
                self.performSegue(withIdentifier: "other", sender: self)
            }
            else{
                let other = ""
                Vehicaldetails.sharedInstance.Other = ""
                self.senddata(other: other)
            }
        }
    }
}


