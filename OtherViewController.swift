//  OtherViewController.swift
//  FuelSecure
//
//  Created by VASP on 6/30/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit

class OtherViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet var oview: UIView!
    @IBOutlet var Other: UITextField!
    @IBOutlet var Otherlable: UILabel!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet var Go: UIButton!

    var stoptimergotostart:Timer = Timer()
    var web = Webservices()
    var sysdata:NSDictionary!
    var cf = Commanfunction()
    var IsSavebuttontapped : Bool = false
    var countfailauth:Int = 0
    var otherlbl:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Other.delegate = self
        Otherlable.text = "\(NSLocalizedString("Enter", comment:"")) " + Vehicaldetails.sharedInstance.Otherlable
        Other.font = UIFont(name: Other.font!.fontName, size: 40)
        Other.text = Vehicaldetails.sharedInstance.Other
//        Other.keyboardType = UIKeyboardType.numberPad
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State())
        doneButton.addTarget(self, action: #selector(OdometerVC.tapAction), for: UIControl.Event.touchUpInside);
        doneButton.backgroundColor = UIColor.black
        Other.returnKeyType = .done
        Other.inputAccessoryView = doneButton
        Other.autocapitalizationType = UITextAutocapitalizationType.allCharacters

        var myMutableStringTitle = NSMutableAttributedString()
        var Name  = "Enter Other" // PlaceHolderText
        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            Name = "Entrar en otro"
        }
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        Other.attributedPlaceholder = myMutableStringTitle
        Activity.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(OtherViewController.gotostart), userInfo: nil, repeats: false)
        Go.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }

   override func viewDidAppear(_ animated: Bool)
    {
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
    }

   @objc func gotostart()
    {
        self.web.sentlog(func_name: "Other_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
    }

   @objc func tapAction()
    {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func other(_ sender: Any)
    {
        checkMaxLength(textField: Other, maxLength:10)
    }

    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }

    @IBAction func reset(sender: AnyObject) {
        stoptimergotostart.invalidate()
        viewWillAppear(true)
        Other.text = ""
    }
    

    //AUTHENTICATION FUNCTION CALL

    func mainPage()
    {
        self.performSegue(withIdentifier: "Go", sender: self)
    }

    func senddata()
    {
        let odom = "0"
        let odometer = Int(odom)
        let other = Other.text
        let deptno = ""
        let pin = ""
        countfailauth += 1
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:pin,isother:other!,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
       
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
                showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))//"Please wait momentarily check your internet connection & try again.")//"\(error) \n Please try again later")
            }else{

                self.senddata()
            }
            stoptimergotostart.invalidate()
            viewWillAppear(true)
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
                print(sysdata!)
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString

            if(ResponceMessage == "success") {
                Activity.stopAnimating()
                Activity.isHidden = true
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                    if #available(iOS 11.0, *) {
                        self.web.wifisettings(pagename: "Other")
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
                        .normal(NSLocalizedString("Step1", comment:""))//("\nThe WiFi name is the name of the HOSE. Read Steps 1 to 5 below then click on Green bar below.\n\nFollow steps:\n1. Turn on the WiFi (it might already be on)\n\n2. Choose the WiFi \n named: ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(NSLocalizedString("Step2", comment:""))//(" \n\n3. First time it will ask for password,enter: 123456789\n\n4. It will have a check next to ")
                        .bold("\(Vehicaldetails.sharedInstance.SSId)")
                        .normal(NSLocalizedString("Step3", comment:""))//" and it will say \"No Internet Connection\" \n\n5.  Now, tap on the very top left corner that says \"FluidSecure\" - this returns you to allow fueling.\n\n\n\n\n")

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
                    Activity.stopAnimating()
                    Activity.isHidden = true
                    
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
                    else if(ValidationFailFor == "Pin")
                    {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "Pin", sender: self)
                    }
                    showAlert(message: "\(ResponceText)")
                    stoptimergotostart.invalidate()
                }
            }
            }
        }
    }

    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 11.0, *) {
            self.web.wifisettings(pagename: "Other")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }

    @IBAction func saveButtontapped(sender: AnyObject) {
        Activity.startAnimating()
        Activity.isHidden = false
         Go.isEnabled = false
        cf.delay(1){
            self.tapAction()
            self.stoptimergotostart.invalidate()
            self.IsSavebuttontapped = true

            if(self.Other.text == "")
        {
            self.showAlert(message: NSLocalizedString("WarningEmptytext", comment:""))// "Please Enter something.")
            self.stoptimergotostart.invalidate()
            self.viewWillAppear(true)
            self.Activity.stopAnimating()
            self.Activity.isHidden = true
        }
        else
        {
            Vehicaldetails.sharedInstance.Other = self.Other.text!
            self.Other.text = Vehicaldetails.sharedInstance.Other
            self.senddata()
            }
        }
    }
}




