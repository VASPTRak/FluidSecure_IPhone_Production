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
            doneButton.setTitle("Return", for: UIControlState.normal)
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

    func gotostart(){
        self.web.sentlog(func_name: "Personalpin_screen_timeout")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
       
        appDel.start()

    }

    override func viewDidAppear(_ animated: Bool) {
       // Pin.text = Vehicaldetails.sharedInstance.Personalpinno
    }

        func tapAction() {//(sender: UITapGestureRecognizer) {
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
            messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
            messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
            alertController.setValue(messageMutableString, forKey: "attributedMessage")

            // Action.
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
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
                      self.wifisettings()
                }
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }

        //AUTHENTICATION FUNCTION CALL
        func wifisettings()
        {
             let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
            let app = UIApplication.shared
            app.openURL(url! as URL)
            mainPage()
        }

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
            let error = Split[1]
            if (reply == "-1")
            {
                if(countfailauth>2)
                {
                    showAlert(message: "Please wait momentarily check your internet connection & try again.")//"\(error) \n Please try again later")

                }else{

                    self.senddata(other:other)

                }
              //showAlert(message: "\(error) \n Please try again later" )
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
                        let imageButtonws : UIButton = UIButton(frame: CGRect(x: 5, y: 500, width: 260, height: 40))
                        imageButtonws.setBackgroundImage(btnsetting, for: UIControlState())
                        imageButtonws.setTitle("Go To WiFi Settings", for: UIControlState.normal)
                        imageButtonws.setTitleColor(UIColor.white, for: UIControlState.normal)
                        imageButtonws.addTarget(self, action: #selector(OdometerVC.Action(sender:)), for:.touchUpInside)

                       // alertController.view.addSubview(imageButton)
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
        wifisettings()
    }
//    func createSwitch() -> UISwitch{
//
//        let switchControl = UISwitch(frame:CGRect(x: 100, y: 210, width: 0, height: 0));
//        if(Vehicaldetails.sharedInstance.reachblevia == "wificonn"){
//            switchControl.isOn = false
//            switchControl.setOn(true, animated: false);
//            switchControl.isEnabled = false
//            return switchControl
//        }
//        else if(Vehicaldetails.sharedInstance.reachblevia != "wificonn"){
//            switchControl.isOn = true
//            switchControl.setOn(true, animated: false);
//            switchControl.isEnabled = false
//          return switchControl
//        }
//        return switchControl
//    }

        @IBAction func saveButtontapped(sender: AnyObject) {
            IsSavebuttontapped = true
             stoptimergotostart.invalidate()
            
           // viewDidLoad()
            tapAction()
            if(Pin.text == "")
            {
                showAlert(message: "Please Enter Personnel PIN Number.")
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

