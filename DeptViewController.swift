//  DeptViewController.swift
//  FuelSecure
//
//  Created by VASP on 6/30/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit

class DeptViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var oview: UIView!
    @IBOutlet var Dept: UITextField!
    @IBOutlet weak var Activity: UIActivityIndicatorView!  ///ActivityIndicator
    @IBOutlet var GO: UIButton!

    var stoptimergotostart:Timer = Timer()
    var web = Webservices()
    var sysdata:NSDictionary!
    var dept_data:NSDictionary!
    var cf = Commanfunction()
    var IsSavebuttontapped : Bool = false
    var countfailauth:Int = 0
    var counthourauth:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Activity.isHidden = true
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        Dept.delegate = self
        Dept.font = UIFont(name: Dept.font!.fontName, size: 40)
        Dept.text =  Vehicaldetails.sharedInstance.deptno

        var myMutableStringTitle = NSMutableAttributedString()
        var Name  = "Enter Department" // PlaceHolderText
        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            Name = "Ingresar departamento"
        }
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        Dept.attributedPlaceholder = myMutableStringTitle


        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State.normal)
        doneButton.addTarget(self, action: #selector(OdometerVC.tapAction), for: UIControl.Event.touchUpInside);
        doneButton.backgroundColor = UIColor .black
        Dept.returnKeyType = .done
        Dept.inputAccessoryView = doneButton
        Dept.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }

    override func viewWillAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(DeptViewController.gotostart), userInfo: nil, repeats: false)
        GO.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
    }

    @objc func gotostart(){
        self.web.sentlog(func_name: "Department_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
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

    @IBAction func department(_ sender: Any)
    {
        checkMaxLength(textField: Dept, maxLength:20)
    }

    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }

    @IBAction func reset(sender: AnyObject) {
        stoptimergotostart.invalidate()
        viewWillAppear(true)
        Dept.text = ""
    }

    //AUTHENTICATION FUNCTION CALL

    func mainPage()
    {
        self.performSegue(withIdentifier: "Go", sender: self)
    }

    func senddata(ppin:String,other:String)
    {
        let odom = "0"
        let odometer:Int! = Int(odom)
        let isdept = Dept.text
        let vehicle_no = Vehicaldetails.sharedInstance.vehicleno
        countfailauth += 1
        let data = web.vehicleAuth(vehicle_no: vehicle_no,Odometer:odometer,isdept:isdept!,isppin:ppin,isother:other,Barcodescanvalue:Vehicaldetails.sharedInstance.Barcodescanvalue)
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
                self.senddata(ppin:ppin,other:other)
            }
            stoptimergotostart.invalidate()
            viewWillAppear(true)
        }
        else
        {
            countfailauth = 0
            let data1:Data = reply.data(using: String.Encoding.utf8)! as Data
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
          //  print(sysdata)
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            let ValidationFailFor = sysdata.value(forKey: "ValidationFailFor") as! NSString
            
            if(ResponceMessage == "success")
            {
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){

                    if #available(iOS 11.0, *) {
                        self.web.wifisettings(pagename: "Department")
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
                if(ResponceMessage == "fail")
                {
                    self.GO.isEnabled = true
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                    if(ValidationFailFor == "Vehicle") {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "Vehicle", sender: self)

                    }else if(ValidationFailFor == "Odo")
                    {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "Odo", sender: self)
                    }
                    else if(ValidationFailFor == "Pin")
                    {
                        stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "pin", sender: self)
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
            self.web.wifisettings(pagename: "Department")
        } else {
            // Fallback on earlier versions
        }
        mainPage()
    }

    func validatedepartmentno() -> String
    {
        let departmentno = Dept.text!
        let data = web.departmentAuth(departmentno)
        counthourauth += 1
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        if (reply == "-1")
        {
            if(counthourauth>2)
            {
                showAlert(message: NSLocalizedString("CheckyourInternet", comment:""))
            }
            else
            {
                cf.delay(1){
                    _ = self.validatedepartmentno()
                }
            }
            showAlert(message: NSLocalizedString("Warningwait", comment:""))
            stoptimergotostart.invalidate()
            viewWillAppear(true)
        }
        else
        {
            counthourauth = 0
            let data1:Data = reply.data(using: String.Encoding.utf8)!
            do{
                dept_data = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }

           // print(dept_data)
            let ResponceMessage = dept_data.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = dept_data.value(forKey: "ResponceText") as! NSString
            if(ResponceMessage == "success")
            {
                return ResponceMessage as String
            }
            else{
                return ResponceText as String
            }
        }
        return ""
    }


    @IBAction func saveButtontapped(sender: AnyObject) {
        Activity.startAnimating()
        Activity.isHidden = false
        GO.isEnabled = false
        cf.delay(1){
            self.IsSavebuttontapped = true
            self.stoptimergotostart.invalidate()
            self.tapAction()
            if(self.Dept.text == "")
            {
                self.showAlert(message: NSLocalizedString("Enterdept", comment:""))
                self.Activity.stopAnimating()
                self.Activity.isHidden = true
                self.stoptimergotostart.invalidate()
                self.viewWillAppear(true)
            }
            else {
                let server_res = self.validatedepartmentno()
                if(server_res == "success"){
                    let deptno = self.Dept.text
                    Vehicaldetails.sharedInstance.deptno = deptno!
                    self.Dept.text = Vehicaldetails.sharedInstance.deptno

                    let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                    let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                    if(isPPin == "True"){
                        self.Activity.stopAnimating()
                        self.Activity.isHidden = true
                        self.stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "pin", sender: self)
                    }
                    else{
                        if(isother == "True"){
                            self.Activity.stopAnimating()
                            self.Activity.isHidden = true
                            self.stoptimergotostart.invalidate()
                            self.performSegue(withIdentifier: "other", sender: self)
                        }
                        else{
                            let ppin = ""
                            let other = ""
                            Vehicaldetails.sharedInstance.Personalpinno = ""
                            Vehicaldetails.sharedInstance.Other = ""
                            self.senddata(ppin: ppin,other:other)
                        }
                    }
                }
                else{
                    self.GO.isEnabled = true
                    self.showAlert(message: server_res)
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                }
            }
        }
    }
}


