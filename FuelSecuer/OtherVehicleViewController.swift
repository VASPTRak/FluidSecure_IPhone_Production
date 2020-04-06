//
//  OtherVehicleViewController.swift
//  FuelSecure
//
//  Created by VASP on 7/27/19.
//  Copyright © 2019 VASP. All rights reserved.


import UIKit

class OtherVehicleViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var Other: UITextField!
    @IBOutlet var ExtraOtherLabel: UILabel!
    @IBOutlet var oview: UIView!
    @IBOutlet var Activity: UIActivityIndicatorView!
    
    @IBOutlet var Go: UIButton!
    
    var web = Webservices()
    var sysdata:NSDictionary!
    var cf = Commanfunction()
    var stoptimergotostart:Timer = Timer()
    var IsSavebuttontapped : Bool = false
    var countfailauth:Int = 0
    var countdata = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Other.delegate = self
        Other.font = UIFont(name: Other.font!.fontName, size: 40)
        ExtraOtherLabel.text  = Vehicaldetails.sharedInstance.ExtraOtherLabel
        
        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = "Enter Other" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        Other.attributedPlaceholder = myMutableStringTitle
        
        //        Other.text = Vehicaldetails.sharedInstance.ExtraOtherLabel
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State())
        doneButton.addTarget(self, action: #selector(tapAction), for: UIControl.Event.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        Other.returnKeyType = .done
        Other.inputAccessoryView = doneButton
        Other.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        Activity.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(HourViewController.gotostart), userInfo: nil, repeats: false)
        Go.isEnabled = true
        Activity.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }
    
    @objc func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.oview.endEditing(true)
    }
    
    @objc func gotostart(){
        self.web.sentlog(func_name: "Hour_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hour(_ sender: Any) {
        checkMaxLength(textField: Other, maxLength:7)
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
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
        countfailauth += 1
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
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
            // print(sysdata)
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString
            
            if(ResponceMessage == "success")
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                    if #available(iOS 11.0, *) {
                        self.web.wifisettings(pagename: "Hour")
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
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
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
        if #available(iOS 11.0, *) {
            self.web.wifisettings(pagename: "Hour")
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
            self.IsSavebuttontapped = true
            self.stoptimergotostart.invalidate()
            self.tapAction()
            if(self.Other.text == "")
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                self.showAlert(message: NSLocalizedString("EnterExtraother", comment:""))
                self.stoptimergotostart.invalidate()
                self.viewWillAppear(true)
            }
            else
            {
                let ExtraOther = self.Other.text!
                Vehicaldetails.sharedInstance.ExtraOther = "\(ExtraOther)"
                let hours = Vehicaldetails.sharedInstance.IsHoursrequirs
                let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
                let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                let CheckOdometerReasonable = Vehicaldetails.sharedInstance.CheckOdometerReasonable
                let OdometerReasonabilityConditions = Vehicaldetails.sharedInstance.OdometerReasonabilityConditions
                let Hourlimit:Int = Vehicaldetails.sharedInstance.HoursLimit
                let Previoushours:Int = Vehicaldetails.sharedInstance.PreviousHours
                
                if(isdept == "True"){
                    self.countdata = 0
                    self.stoptimergotostart.invalidate()
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    self.performSegue(withIdentifier: "dept", sender: self)
                }
                else{
                    if(isPPin == "True"){
                        self.countdata = 0
                        self.stoptimergotostart.invalidate()
                        self.Activity.stopAnimating()
                        self.Activity.isHidden = true
                        self.performSegue(withIdentifier: "pin", sender: self)
                    }
                    else{
                        if(isother == "True"){
                            self.Activity.stopAnimating()
                            self.Activity.isHidden = true
                            self.countdata = 0
                            self.stoptimergotostart.invalidate()
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
}



