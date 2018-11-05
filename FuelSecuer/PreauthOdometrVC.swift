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
    var web = Webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Odometer.delegate = self
        Odometer.font = UIFont(name: Odometer.font!.fontName, size: 40)
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControlState.normal)
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
    
   @objc func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 11.0, *) {
            self.web.wifisettings(pagename: "PreauthVehicle")
        } else {
            // Fallback on earlier versions
        };if #available(iOS 11.0, *) {
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
             self.web.sentlog(func_name: "In Preauthorized Transaction Go button Tapped user need to select Wifi data Manually", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
            self.performSegue(withIdentifier: "Go", sender: self)
        }
    }
    
    func senddata()
    {
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){

            if #available(iOS 11.0, *) {
                self.web.wifisettings(pagename: "Odometer")
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
                    .normal(NSLocalizedString("Step1", comment:""))//("\nThe WiFi name is the name of the HOSE. Read Steps 1 to 5 below then click on Green bar below.\n\nFollow steps:\n1. Turn on the WiFi (it might already be on)\n\n2. Choose the WiFi \n named: ")
                    .bold("\(Vehicaldetails.sharedInstance.SSId)")
                    .normal(NSLocalizedString("Step2", comment:""))//(" \n\n3. First time it will ask for password,enter: 123456789\n\n4. It will have a check next to ")
                    .bold("\(Vehicaldetails.sharedInstance.SSId)")
                    .normal(NSLocalizedString("Step3", comment:""))//" and it will say \"No Internet Connection\" \n\n5.  Now, tap on the very top left corner that says \"FluidSecure\" - this returns you to allow fueling.\n\n\n\n\n")

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
       
        if(Odometer.text == "")
        {
            showAlert(message: NSLocalizedString("EneterOdometer", comment:""))//showAlert(message: "Please Enter Odometer Number.")
        }
        else
        {
            let odometer:Int! = Int(Odometer.text!)
                 Vehicaldetails.sharedInstance.Odometerno = "\(odometer!)"
            Odometer.text = Vehicaldetails.sharedInstance.Odometerno
            self.senddata()
        }
    }
}
