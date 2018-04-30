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

    var cf = Commanfunction()
    var countdata = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Odometer.delegate = self
        Odometer.font = UIFont(name: Odometer.font!.fontName, size: 40)
       let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle("Return", for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(OdometerVC.tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        Odometer.returnKeyType = .done
        Odometer.inputAccessoryView = doneButton
        Odometer.autocapitalizationType = UITextAutocapitalizationType.allCharacters
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
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

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
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:message.characters.count))
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
        else{
                self.performSegue(withIdentifier: "Go", sender: self)
        }
    }

    func senddata()
    {
       // let odom = "0"
       // let odometer:Int! = Int(odom)!
      //  let vehicle_no = Vehicaldetails.sharedInstance.vehicleno


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
//                    let alertController = UIAlertController(title: "FluidSecure needs to connect to Hose via WiFi", message: "Please Connect Wifi \(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertControllerStyle.alert)
//                    // Background color.
//                    let backView = alertController.view.subviews.last?.subviews.last
//                    backView?.layer.cornerRadius = 10.0
//                    backView?.backgroundColor = UIColor.white
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//                    paragraphStyle.alignment = NSTextAlignment.right
//
//                    let paragraphStyle1 = NSMutableParagraphStyle()
//                    paragraphStyle1.alignment = NSTextAlignment.left
//
//
//                    let attributedString = NSAttributedString(string:"FluidSecure needs to connect to Hose via WiFi", attributes: [
//                        NSParagraphStyleAttributeName:paragraphStyle1,
//                        NSFontAttributeName : UIFont.systemFont(ofSize: 20), //your font here
//                        NSForegroundColorAttributeName : UIColor.black
//                        ])
////                    let okAction = UIAlertAction(title: "Go To WiFi Settings", style: UIAlertActionStyle.Default){ (submity) -> Void in
////                        self.wifisettings()
////                    }
//
//                    let wifiname = "\(Vehicaldetails.sharedInstance.SSId)"
//
//                    // Change Message With Color and Font
//                    let message  = "\nYou will now be redirected to the \nWiFi Screen to choose a Hose. \n\n\t1. Turn on the WiFi             \n\n\t(it might already be on)\n\n\t   2. Choose a Network, select the Hose you wish to connect to. Once connected, you will see a check next to the name of the Hose. Tap the Hose name on the top upper left screen to return.\n\n\t  3. Click go to Wifi Settings to proceed.\n\n\n\n"
//
//                    var messageMutableString = NSMutableAttributedString()
//                    messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Arial", size: 15.0)!])
//                    messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.characters.count))
//
//                    //alertController.setValue(attributedStringwifiname, forKey: "attributedMessage")
//                    alertController.setValue(messageMutableString, forKey: "attributedMessage")
//                    alertController.setValue(attributedString, forKey: "attributedTitle")
//
//                    // Action.
//
//                    alertController.view.addSubview(createSwitch())
//
//                    // alertController.view.tintColor = UIColor.greenColor()
//
//                    let btnImage = UIImage(named: "checkbox-checked")!
//                    let imageButton : UIButton = UIButton(frame: CGRect(x: 10, y: 180, width: 40, height: 40))
//                    imageButton.setBackgroundImage(btnImage, for: UIControlState())
//
//
//                    let btnsetting = UIImage(named: "Button-Green")!
//                    let imageButtonws : UIButton = UIButton(frame: CGRect(x: 20, y: 360, width: 240, height: 40))
//                    imageButtonws.setBackgroundImage(btnsetting, for: UIControlState())
//                    imageButtonws.setTitle("Go To WiFi Settings", for: UIControlState.normal)
//                    imageButtonws.setTitleColor(UIColor.white, for: UIControlState.normal)
//                    imageButtonws.addTarget(self, action: #selector(OdometerVC.Action(sender:)), for:.touchUpInside)
//
//                    alertController.view.addSubview(imageButton)
//                    //alertController.view.addSubview(imageButtonwifi)
//                    alertController.view.addSubview(imageButtonws)
//
//                    //alertController.addAction(okAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }


            }
                    else  if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                        self.performSegue(withIdentifier: "Go", sender: self)
        }
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

    @IBAction func saveButtontapped(sender: UIButton) {

        tapAction()
        Vehicaldetails.sharedInstance.MinLimit = "0"
        Vehicaldetails.sharedInstance.PulseRatio = "10"
        if(Odometer.text == "")
        {
            showAlert(message: "Please Enter Odometer Number.")
        }
        else
        {
            let odometer:Int! = Int(Odometer.text!)
           // let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
            Vehicaldetails.sharedInstance.Odometerno = "\(odometer!)"
            Odometer.text = Vehicaldetails.sharedInstance.Odometerno
            self.senddata()
        }
    }
}
