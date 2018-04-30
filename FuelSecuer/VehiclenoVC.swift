//
//  VehiclenoVC.swift
//  FuelSecuer
//
//  Created by VASP on 3/28/16.
//  Copyright © 2016 VASP. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        //let attrs:[String:AnyObject] = [NSFontAttributeName: UIFont(name: "Arial", size: 20)!]
        let boldString = NSMutableAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Arial", size: 17)!])//NSMutableAttributedString(string: text, attributes:attrs)
         boldString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:text.count))
        self.append(boldString)
        return self
    }

    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left

        let normal =  NSMutableAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Arial", size: 15.0)!])
        self.append(normal)
        return self
    }
}
class VehiclenoVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var Vehicleno: UITextField!
    @IBOutlet var Mview: UIView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var save: UIButton!

    var web = Webservices()
    var confs = FuelquantityVC()
    var odometervc = OdometerVC()
    var cf = Commanfunction()
    var sysdata:NSDictionary!
    var RData:NSDictionary!
    var IsGobuttontapped : Bool = false
    var odo = Vehicaldetails.sharedInstance.odometerreq
    var isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
    var isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
    var isother = Vehicaldetails.sharedInstance.IsOtherRequire
    var stoptimergotostart:Timer = Timer()
    var buttontype:String!
    var button = UIButton(type: UIButtonType.custom)
    let doneButton:UIButton = UIButton (frame: CGRect(x: 150, y: 150, width: 50, height: 44));
    let doneButton1:UIButton = UIButton (frame: CGRect(x: 150, y: 150, width: 50, height: 44))
 
    override func viewDidLoad() {
        super.viewDidLoad()
        Vehicleno.font = UIFont(name: Vehicleno.font!.fontName, size: 40)
        Vehicleno.textAlignment = NSTextAlignment.center
        Vehicleno.textColor = UIColor.white
        Vehicleno.delegate = self
        save.isEnabled = false

        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
//        cf.delay(Double(Vehicaldetails.sharedInstance.TimeOut)!*60){
//            if(self.IsGobuttontapped == false){
//                self.web.sentlog(func_name: "vehicletimeout")
//                let appDel = UIApplication.shared.delegate! as! AppDelegate
//                appDel.start()
//                print("hi")
//            }
//            else if(self.IsGobuttontapped == true)
//            {
//
//
//            }

 //       }
       // self.navigationController?.navigationBar.barTintColor = UIColor.blueColor()
        //self.navigationController?.navigationBar.tintColor = UIColor.blueColor()
       // self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
//        if(Vehicaldetails.sharedInstance.buttonset == true)
//        {
//            print(Vehicaldetails.sharedInstance.buttonset)
//            Vehicleno.delegate = self
//            Vehicleno.text = Vehicaldetails.sharedInstance.vehicleno
//            doneButton.setTitle("Press for Letters", forState: UIControlState.Normal)
//            doneButton.addTarget(self, action: #selector(VehiclenoVC.showLetters), forControlEvents: UIControlEvents.TouchUpInside);
//            doneButton.backgroundColor = UIColor.blackColor()
//            buttontype = "Numbers"
//            Vehicleno.returnKeyType = .Done
//            Vehicleno.inputAccessoryView = doneButton
//        }
//        else{
//        Vehicleno.delegate = self
//        Vehicleno.text = Vehicaldetails.sharedInstance.vehicleno
//        doneButton.setTitle("Press for Letters", forState: UIControlState.Normal)
//        doneButton.addTarget(self, action: #selector(VehiclenoVC.showLetters), forControlEvents: UIControlEvents.TouchUpInside);
//        doneButton.backgroundColor = UIColor .blackColor()
//        buttontype = "Numbers"
//        Vehicleno.returnKeyType = .Done
//        Vehicleno.inputAccessoryView = doneButton
//        Vehicleno.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
//        }
//
//        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
//        numberToolbar.barStyle = UIBarStyle.Default
//        numberToolbar.items = [
//            UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VehiclenoVC.tapAction)),
//            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(title: "Press for Letters", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VehiclenoVC.showLetters))]
//        numberToolbar.sizeToFit()
//        numberToolbar.tintColor = UIColor.whiteColor()
//        numberToolbar.barTintColor = UIColor.blackColor()
//        Vehicleno.inputAccessoryView = numberToolbar
    }

    override func viewWillAppear(_ animated: Bool) {
        
        stoptimergotostart.invalidate()
         stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(VehiclenoVC.gotostart), userInfo: nil, repeats: false)
    }

    override func viewWillDisappear(_ animated: Bool) {

        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }

    func gotostart(){

         self.web.sentlog(func_name: "vehicletimeout")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()

    }

    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.Mview.endEditing(true)
        save.isHidden = false
        cancel.isHidden = false
    }

    func showLetters()
    {
        buttontype = "Letters"
        Vehicleno.font = UIFont(name: Vehicleno.font!.fontName, size: 40)
        doneButton.setTitle("Press for Numbers", for: UIControlState.normal)
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
            numberToolbar.items = [
                UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.tapAction)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Press for Numbers", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.shownumbers))]
            numberToolbar.sizeToFit()
        numberToolbar.tintColor = UIColor.white
            numberToolbar.barTintColor = UIColor.white
            Vehicleno.inputAccessoryView = numberToolbar

        self.Mview.endEditing(true)
        let textFieldOutput = Vehicleno.text
        let newString = textFieldOutput!.uppercased()
        Vehicleno.text = newString
        self.Vehicleno.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        self.Vehicleno.keyboardType = UIKeyboardType.default
        self.Vehicleno.returnKeyType = UIReturnKeyType.default
        self.Vehicleno.becomeFirstResponder()

        doneButton.backgroundColor = UIColor.white
      //  Vehicleno.inputAccessoryView = doneButton
        doneButton.setTitle("Press for Numbers", for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(VehiclenoVC.shownumbers), for: UIControlEvents.touchUpInside)
    }

    func shownumbers()
    {
                buttontype = "Numbers"
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
            numberToolbar.items = [
                UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.tapAction)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Press for Letters", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclenoVC.showLetters))]
            numberToolbar.sizeToFit()
        numberToolbar.tintColor = UIColor.white
        numberToolbar.barTintColor = UIColor.white
            Vehicleno.inputAccessoryView = numberToolbar

        doneButton.setTitle("Press for letters", for: UIControlState.normal)
        self.Mview.endEditing(true)
        self.Vehicleno.keyboardType = UIKeyboardType.numberPad
        self.Vehicleno.becomeFirstResponder()
        self.Vehicleno.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        doneButton.addTarget(self, action: #selector(VehiclenoVC.showLetters), for: UIControlEvents.touchUpInside)
        doneButton.backgroundColor = UIColor.white
    }
    // required method for keyboard delegate protocol

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
    let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
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
            //self.mainPage()
            self.wifisettings()
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
        stoptimergotostart.invalidate()
         viewWillAppear(true)
    }
    func wifisettings()
    {
        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared// .shared
        app.openURL(url! as URL)
//UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=WIFI")!)
        mainPage()
    }
    func mainPage()
    {
        cf.delay(2){
            self.performSegue(withIdentifier: "Go", sender: self)
        }

    }

    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        let vehicle_no = Vehicleno.text

        let data = web.vehicleAuth(vehicle_no: vehicle_no!,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other)
          let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        let error = Split[1]
        if (reply == "-1")
        {//self.performSegueWithIdentifier("fcount", sender: self)
          // confs.setralay0sleep()// web.sleep()//confs.Recvhold()
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
            let ResponceText = sysdata.value(forKey:"ResponceText") as! NSString
            let ResponceData = sysdata.value(forKey:"ResponceData") as! NSDictionary
            //let Json = sysdata.valueForKey("result") as! NSArray
            let MinLimit = ResponceData.value(forKey:"MinLimit") as! NSNumber
            let PulseRatio = ResponceData.value(forKey:"PulseRatio") as! NSNumber
            let VehicleId = ResponceData.value(forKey:"VehicleId") as! NSNumber
            let FuelTypeId = ResponceData.value(forKey:"FuelTypeId") as! NSNumber
            let PersonId = ResponceData.value(forKey:"PersonId") as! NSNumber
            let PhoneNumber = ResponceData.value(forKey:"PhoneNumber") as! NSString
            let PulserStopTime = ResponceData.value(forKey:"PulserStopTime") as! NSString
            let ServerDate = ResponceData.value(forKey:"ServerDate") as! String
            let pumpoff_time = ResponceData.value(forKey: "PumpOffTime") as! String

            print(MinLimit,PersonId,PhoneNumber,FuelTypeId,VehicleId,PulseRatio)

            Vehicaldetails.sharedInstance.MinLimit = "\(MinLimit)"
            Vehicaldetails.sharedInstance.PulseRatio = "\(PulseRatio)"
            Vehicaldetails.sharedInstance.VehicleId = "\(VehicleId)"
            Vehicaldetails.sharedInstance.FuelTypeId = "\(FuelTypeId)"
            Vehicaldetails.sharedInstance.PersonId = "\(PersonId)"
            Vehicaldetails.sharedInstance.PhoneNumber = "\(PhoneNumber)"
            Vehicaldetails.sharedInstance.PulserStopTime = "\(pumpoff_time)" //Send pump off time to pulsar off time.
            Vehicaldetails.sharedInstance.date = "\(ServerDate)"

            if(ResponceMessage == "success") {
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
                        NSFontAttributeName : UIFont.systemFont(ofSize: 18), //your font here
                        NSForegroundColorAttributeName : UIColor.black
                        ])

                   // var wifiname = UILabel()
                   //  wifiname.text = "\(Vehicaldetails.sharedInstance.SSId)"

//                    let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
//                    let att1 = NSMutableAttributedString(string:wifiname.text!, attributes:attrs)
//
//
//                    //let att = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 20)]
//
//                    let boldwifi = att1 //NSMutableAttributedString(string:wifiname, attributes:att)
//print(boldwifi)

                    let formattedString = NSMutableAttributedString()
                    
                    formattedString
                        .normal("\nThe WiFi name is the name of the HOSE. Read Steps 1 to 5 below then click on Green bar below.\n\nFollow steps:\n1. Turn on the WiFi (it might already be on)\n\n2. Choose the WiFi \n named: ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(" \n\n3. First time it will ask for password,enter: 123456789\n\n4. It will have a check next to ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(" and it will say \"No Internet Connection\" \n\n5.  Now, tap on the very top left corner that says \"FluidSecure\" - this returns you to allow fueling.\n\n\n\n\n")

//                    let lbl = UILabel()
//                    lbl.attributedText = formattedString


//                    let message  = "\nThe WiFi name is the name of the HOSE. Read directions and click on Green bar below.\nFollow steps:\n1. Turn on the WiFi (it might already be on)\n\n2. Choose the WiFi \n named: \(boldwifi.string).\n\n3. First time it will ask for password,enter: 123456789\n\n4. It will have a check next to \(boldwifi.string) and it will say \"No Internet Connection\" \n\n5.  Now, tap on the very top left corner that says \"FluidSecure\" - this returns you to allow fueling.\n\n\n\n"
//
//                    var messageMutableString = NSMutableAttributedString()
//                    messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Arial", size: 15.0)!])
//                    messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))


                    alertController.setValue(formattedString, forKey: "attributedMessage")
                    alertController.setValue(attributedString, forKey: "attributedTitle")


                    // Change Message With Color and Font
//                    var wifinameMutableString = NSMutableAttributedString()
//                    wifinameMutableString = NSMutableAttributedString(string: wifiname as String, attributes: [NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Arial", size: 16.0)!])
//                    wifinameMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:wifiname.count))
//                    print(wifinameMutableString.string)


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
//            {
//                let alertController = UIAlertController(title: "", message: "Please Connect Wifi \(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertControllerStyle.Alert)
//                // Background color.
//                let backView = alertController.view.subviews.last?.subviews.last
//                backView?.layer.cornerRadius = 10.0
//                backView?.backgroundColor = UIColor.whiteColor()
//
//                // Change Message With Color and Font
//                let message  = "PLEASE READ: \n 1.You will now be taken to the iPhone WiFi screen to choice a WiFi. \n" +
//                    "2. Once there, first turn on the WiFi by tapping button. It might be on already. \n" +
//                    "3. Wait for the WiFi Fuel Hose Name to appear. \n" +
//                    "4. Select the WiFi hose \"\(Vehicaldetails.sharedInstance.SSId)\".\n" +
//                "5. Once it connects, return by tapping the FLUIDSECURE name in the upper left corner of screen."// "Please Connect Wifi \(Vehicaldetails.sharedInstance.SSId)."
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.alignment = NSTextAlignment.Left
//                var messageMutableString = NSMutableAttributedString()
//                messageMutableString = NSMutableAttributedString(string: message as String, attributes: [ NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont(name: "Georgia", size: 24.0)!])
//
//                //var messageMutableString = NSMutableAttributedString()
//                // messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
//                messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSRange(location:0,length:message.characters.count))
//                alertController.setValue(messageMutableString, forKey: "attributedMessage")
//                // Action.
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (submity) -> Void in
//                    self.wifisettings()
//                }
//                alertController.addAction(okAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
            else {

                if(ResponceMessage == "fail")
                {
                    if(ResponceText == "Unauthorized vehicle")
                    {
                        //self.performSegueWithIdentifier("vehicle", sender: self)
                    }
                    stoptimergotostart.invalidate()
                    viewWillAppear(true)
                    showAlert(message: "\(ResponceText)")
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
//       let switchControl = UISwitch(frame:CGRect(x: 100, y: 210, width: 0, height: 0));
//        if(Vehicaldetails.sharedInstance.reachblevia == "wificonn"){
//            switchControl.isOn = false
//            switchControl.setOn(true, animated: false);
//            switchControl.isEnabled = false
//            //switchControl.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged);
//
//            return switchControl
//        }
//        else if(Vehicaldetails.sharedInstance.reachblevia != "wificonn"){
//            switchControl.isOn = true
//            switchControl.setOn(true, animated: false);
//            switchControl.isEnabled = false
//            // switchControl.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged);
//
//            return switchControl
//
//        }
//        return switchControl
//    }



    @IBAction func saveBtntapped(sender: AnyObject) {
            IsGobuttontapped = true

            stoptimergotostart.invalidate()

            if(Vehicleno.text == "")
            {
                showAlert(message: "Please Enter Vehicle Number.")
                viewWillAppear(true)
            }
        else{
                if(odo == "False"){

                        let odom = "0"
                        _ = Int(odom)
                        let vehicle_no = Vehicleno.text
                        Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
                    let data = web.checkhour_odometer(vehicle_no!)
                        //let data = web.vehicleAuth(vehicle_no!,Odometer:odometer!)
                          let Split = data.components(separatedBy: "#")
                        let reply = Split[0]
                        let error = Split[1]
                        if (reply == "-1")
                        {//self.performSegueWithIdentifier("fcount", sender: self)
                            //confs.setralay0sleep() //web.sleep()//confs.Recvhold()
                            showAlert(message: "\(error) \n Please try again later" )

                            stoptimergotostart.invalidate()
                             viewWillAppear(true)
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
                            if(ResponceMessage == "success"){
                                let IsHoursRequire = sysdata.value(forKey: "IsHoursRequire") as! NSString
                                let IsOdoMeterRequire = sysdata.value(forKey: "IsOdoMeterRequire") as! NSString

                                let CheckOdometerReasonable = sysdata.value(forKey: "CheckOdometerReasonable") as! NSString
                                let OdometerReasonabilityConditions = sysdata.value(forKey: "OdometerReasonabilityConditions") as! NSString
                                let PreviousOdo = sysdata.value(forKey: "PreviousOdo") as! NSString
                                let OdoLimit = sysdata.value(forKey: "OdoLimit") as! NSString

                                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire as String
                                Vehicaldetails.sharedInstance.IsHoursrequirs = IsHoursRequire as String
                                Vehicaldetails.sharedInstance.CheckOdometerReasonable = CheckOdometerReasonable as String
                                Vehicaldetails.sharedInstance.OdometerReasonabilityConditions = OdometerReasonabilityConditions as String
                                Vehicaldetails.sharedInstance.PreviousOdo = Int(PreviousOdo as String)!
                                Vehicaldetails.sharedInstance.OdoLimit = Int(OdoLimit as String)!
                                let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
                                let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                                let isother = Vehicaldetails.sharedInstance.IsOtherRequire


                                    if (IsOdoMeterRequire == "True"){

                                        print(self.odo)
                                        stoptimergotostart.invalidate()
                                        self.performSegue(withIdentifier: "odometer", sender: self)
                                    }
                                    else{
                                        
                                        if (IsHoursRequire == "True"){
                                            self.performSegue(withIdentifier: "hours", sender: self)
                                        }
                                        else{
                                            Vehicaldetails.sharedInstance.hours = ""

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
                                                Vehicaldetails.sharedInstance.Odometerno = "0"
                                                self.senddata(deptno: deptno,ppin:ppin,other:other)
                                                }
                                            }
                                        }

                                    }
                                }
                             }
                            else {

                                if(ResponceMessage == "fail")
                                {
                                    showAlert(message: "\(ResponceText)")
                                    stoptimergotostart.invalidate()
                                    viewWillAppear(true)
                                }
                            }
                        }
                        Vehicaldetails.sharedInstance.Odometerno = odom
                        // self.performSegueWithIdentifier("Vgo", sender: self)
                    Vehicaldetails.sharedInstance.Odometerno = odom
                   // self.performSegueWithIdentifier("Vgo", sender: self)
                }
                else if(odo == "True"){
                    stoptimergotostart.invalidate()
                    self.performSegue(withIdentifier: "odometer", sender: self)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                }
        }
        Vehicaldetails.sharedInstance.vehicleno = Vehicleno.text!
    }
}
