//
//  Preauth_othervehicle.swift
//  FuelSecure
//
//  Created by apple on 29/11/22.
//  Copyright © 2022 VASP. All rights reserved.
//

import UIKit

class Preauth_otherVehicle: UIViewController,UITextFieldDelegate {

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
        Other.keyboardType = UIKeyboardType.asciiCapable
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
        Other.becomeFirstResponder()
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(self.gotostart), userInfo: nil, repeats: false)
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
        self.web.sentlog(func_name: "OtherVehiclescreen_timeout, back to home screen.", errorfromserverorlink: "", errorfromapp: "")
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
        Go.isEnabled = true
        Other.text = ""
    }

    //AUTHENTICATION FUNCTION CALL

    func mainPage()
    {
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
        {
          self.performSegue(withIdentifier: "GoUDP", sender: self)
        }
        else{
        self.performSegue(withIdentifier: "Go", sender: self)
        }
       // self.performSegue(withIdentifier: "Go", sender: self)
    }

    

    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 12.0, *) {
            self.web.wifisettings(pagename: "Hour")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }

    func isValidOther(testStr:String) -> Bool {
        if(testStr == "")
        {
            showAlert(message: NSLocalizedString("checkEmail", comment:"") )
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]" //+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
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
                self.showAlert(message: NSLocalizedString("EnterExtraother", comment:"") )
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
//                                            Vehicaldetails.sharedInstance.MinLimit = "0"
                                            self.performSegue(withIdentifier: "Go", sender: self)
                                        }
                                    }
                                }

            }
        }
    }
}

