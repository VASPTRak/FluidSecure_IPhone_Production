//
//  PreauthVehicleVC.swift
//  FuelSecure
//
//  Created by VASP on 9/13/17.
//  Copyright © 2017 VASP. All rights reserved.
//

import UIKit

class PreauthVehiclenoVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var Vehicleno: UITextField!
    @IBOutlet var Mview: UIView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var save: UIButton!
    
    var odometervc = OdometerVC()
    var cf = Commanfunction()
    var web = Webservices()
    var sysdata:NSDictionary!
    var RData:NSDictionary!
    var buttontype:String!
    var button = UIButton(type: UIButtonType.custom)
    let doneButton:UIButton = UIButton (frame: CGRect(x: 150, y: 150, width: 50, height: 44));
    let doneButton1:UIButton = UIButton (frame: CGRect(x: 150, y: 150, width: 50, height: 44));
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Vehicleno.font = UIFont(name: Vehicleno.font!.fontName, size: 40)
        Vehicleno.textAlignment = NSTextAlignment.center
        Vehicleno.textColor = UIColor.white
        Vehicleno.delegate = self
        save.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.Mview.endEditing(true)
        save.isHidden = false
        cancel.isHidden = false
    }
    
//    func showLetters()
//    {
//        buttontype = "Letters"
//        Vehicleno.font = UIFont(name: Vehicleno.font!.fontName, size: 40)
//        doneButton.setTitle("Press for Numbers", for: UIControlState.normal)
//        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
//        numberToolbar.barStyle = UIBarStyle.default
//        numberToolbar.items = [
//            UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.tapAction)),
//            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(title: "Press for Numbers", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.shownumbers))]
//        numberToolbar.sizeToFit()
//        numberToolbar.tintColor = UIColor.white
//        numberToolbar.barTintColor = UIColor.white
//        Vehicleno.inputAccessoryView = numberToolbar
//
//        self.Mview.endEditing(true)
//        let textFieldOutput = Vehicleno.text
//        let newString = textFieldOutput!.uppercased()
//        Vehicleno.text = newString
//        self.Vehicleno.autocapitalizationType = UITextAutocapitalizationType.allCharacters
//        self.Vehicleno.keyboardType = UIKeyboardType.default
//        self.Vehicleno.returnKeyType = UIReturnKeyType.default
//        self.Vehicleno.becomeFirstResponder()
//
//        doneButton.backgroundColor = UIColor.white
//
//        doneButton.setTitle("Press for Numbers", for: UIControlState.normal)
//        doneButton.addTarget(self, action: #selector(VehiclenoVC.shownumbers), for: UIControlEvents.touchUpInside)
//    }
//
//    func shownumbers()
//    {
//        buttontype = "Numbers"
//        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
//        numberToolbar.barStyle = UIBarStyle.default
//        numberToolbar.items = [
//            UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.tapAction)),
//            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(title: "Press for Letters", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.showLetters))]
//        numberToolbar.sizeToFit()
//        numberToolbar.tintColor = UIColor.white
//        numberToolbar.barTintColor = UIColor.white
//        Vehicleno.inputAccessoryView = numberToolbar
//
//        doneButton.setTitle("Press for letters", for: UIControlState.normal)
//        self.Mview.endEditing(true)
//        self.Vehicleno.keyboardType = UIKeyboardType.numberPad
//        self.Vehicleno.becomeFirstResponder()
//        self.Vehicleno.autocapitalizationType = UITextAutocapitalizationType.allCharacters
//        doneButton.addTarget(self, action: #selector(VehiclenoVC.showLetters), for: UIControlEvents.touchUpInside)
//        doneButton.backgroundColor = UIColor.white
//    }
//
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                print("ssID Match")
                self.performSegue(withIdentifier: "Go", sender: self)
            }
            else{
                self.web.wifisettings(pagename: "PreauthVehicle")//self.wifisettings()
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
    }
    
//    func wifisettings()
//    {
//        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
//        let app = UIApplication.shared// .shared
//        app.openURL(url! as URL)
//        mainPage()
//    }
    
    func mainPage()
    {
        cf.delay(2){
            self.performSegue(withIdentifier: "Go", sender: self)
        }
    }
    
    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        self.web.wifisettings(pagename: "PreauthVehicle")//wifisettings()
        mainPage()
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
    
    @IBAction func saveBtntapped(sender: AnyObject) {
        
        if(Vehicleno.text == "")
        {
            showAlert(message: NSLocalizedString("Entervehicelno", comment:""))//"Please Enter Vehicle Number.")
        }
        else{
            let vehicle_no = Vehicleno.text
            Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
            self.performSegue(withIdentifier: "odometer", sender: self)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            self.web.sentlog(func_name: "Preauthorized Transaction Vehicle number entered \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")

        }
        
        Vehicaldetails.sharedInstance.vehicleno = Vehicleno.text!
    }
}
