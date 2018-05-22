//  RegisterTableViewController.swift
//  FuelSecuer
//
//  Created by VASP on 18/05/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit
import CoreLocation

class RegisterTableViewController: UITableViewController,CLLocationManagerDelegate,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var Company_Name: UITextField!
    @IBOutlet var checked: UIButton!
    @IBOutlet var unchecked: UIButton!
    var web = Webservices()
    var sysdata:NSDictionary!
    let locationManager = CLLocationManager()
    var currentlocation :CLLocation!
    let defaults = UserDefaults.standard
    var checkedstatus: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        mobileNoTextField.delegate = self
        self.registerButton.layer.cornerRadius = 5
        checked.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonClicked(sender: AnyObject) {
        self.registerUser()
    }

    func register(){
        let uuid:String = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        let Name = firstNameTextField.text
        let Email = emailTextField.text
        let string = uuid + ":" + Email! + ":" + "Register"
        let Base64 = convertStringToBase64(string: string)
        let mobile = mobileNoTextField.text
        let Companyname = Company_Name.text
        let data = web.registration(Name: Name!,Email:Email!,Base64:Base64,mobile:mobile!,uuid:uuid,company:Companyname!)
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        let error = Split[1]

        print(reply)
        if(reply == "-1"){showAlert(message: "Internet connection is not available.\(error)")}
        else {
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(sysdata)

            let ResponceData = sysdata.value(forKey: "ResponceData") as! NSDictionary
            let MinLimit = ResponceData.value(forKey: "MinLimit") as! NSNumber
            let PulseRatio = ResponceData.value(forKey: "PulseRatio") as! NSNumber
            let VehicleId = ResponceData.value(forKey: "VehicleId") as! NSNumber
            let FuelTypeId = ResponceData.value(forKey: "FuelTypeId") as! NSNumber
            let PersonId = ResponceData.value(forKey: "PersonId") as! NSNumber
            let PhoneNumber = ResponceData.value(forKey: "PhoneNumber") as! NSString
            print(MinLimit,PersonId,PhoneNumber,FuelTypeId,VehicleId,PulseRatio)

            let Message = sysdata["ResponceMessage"] as! NSString
            let ResponseText = sysdata["ResponceText"] as! NSString

            defaults.set(firstNameTextField.text, forKey: "firstName")
            defaults.set(mobileNoTextField.text, forKey: "address")
            defaults.set(emailTextField.text, forKey: "mobile")
            defaults.set(uuid, forKey: "uuid")

            if(Message == "success") {
                showAlert(message: "\(ResponseText)")
                defaults.set(0, forKey: "Login")
                defaults.set(1, forKey: "Register")
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
            }
            else if(Message == "fail") {
                self.showAlert(message: "\(ResponseText)")
                if(ResponseText == "Please enter valid company.")
                {
                    self.showAlert(message: "\(ResponseText)")
                }
            }
            else
            {
                showAlert(message: "Please check your check your internet connection or Please contact your admin.")
            }
        }
    }


    func registerUser()  {
        print(checkedstatus)
        if(checkedstatus == true){
            let email_id = isValidEmail(testStr: emailTextField.text!)
            if(email_id != false){
                register()
            }
            else{
                showAlert(message: "please enter valid email.")
            }
        }
        else if(checkedstatus == false){
            if(firstNameTextField.text == "" || mobileNoTextField.text == "" ||  emailTextField.text == "" || Company_Name.text == "") {
                showAlert(message: "Please Select All Fields.")

            }
            else
            {
                let email_id = isValidEmail(testStr: emailTextField.text!)
                if(email_id != false){
                    let phoneno = validatephone(testStr: mobileNoTextField.text!)
                    print(mobileNoTextField.text)
                    print(phoneno)
                    if(phoneno == true){
                        register()
                    }
                    else
                    {
                        showAlert(message: "Please enter valid Phone number.")
                    }
                }
                else{
                    showAlert(message: "please enter valid email.")
                }
            }
        }
    }

    @IBAction func uncheckedButtontapped(sender: AnyObject) {
        checked.isHidden = false
        unchecked.isHidden = true
        firstNameTextField.isHidden = true
        mobileNoTextField.isHidden = true
        Company_Name.isHidden = true
        checkedstatus = true
    }

    @IBAction func Checkedbuttontapped(sender: AnyObject) {
        checked.isHidden = true
        unchecked.isHidden = false
        firstNameTextField.isHidden = false
        mobileNoTextField.isHidden = false
        Company_Name.isHidden = false
        checkedstatus = false
    }

    func isValidEmail(testStr:String) -> Bool {
        if(testStr == "")
        {
            showAlert(message: "Must be a valid email.")
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }

    func validatephone(testStr:String) -> Bool {
        if(mobileNoTextField.text!.count > 15) {
            return false
        }
        else if(mobileNoTextField.text!.count <= 15) {

            let PHONE_REGEX = "^[- +()0-9]*$" //"^[- +()]*[0-9][- +()0-9]*$" //"^(?:(?:\\+?1\\s*(?:[.-]\\s*)?)?(?:\\(\\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\s*\\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\\s*(?:[.-]\\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|x\\.?|ext\\.?|extension)\\s*(\\d+))?$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: testStr)
            return result
        }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == mobileNoTextField)
        {

//            let aSet = CharacterSet(charactersInString:"0123456789+-()").invertedSet
//            let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
//            let numberFiltered = compSepByCharInSet.joinWithSeparator("")
//            return string == numberFiltered

            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.init(charactersIn: "0123456789+-()").inverted)// .decimalDigits.inverted)
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            if length == 0 || (length > 15 && !hasLeadingOne) || length > 15
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                return (newLength > 15) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()

            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
//            if (length - index) > 3
//            {
//                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
//                formattedString.appendFormat("%@-", areaCode)
//                index += 3
//            }
//            if length - index > 3
//            {
//                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
//                formattedString.appendFormat("%@-", prefix)
//                index += 3
//            }

            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }

    func convertStringToBase64(string: String) -> String
    {
        let utf8str = string.data(using: String.Encoding.utf8)!
        let base64str = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        return base64str
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        if let headerView = view as? UITableViewHeaderFooterView {
            
            headerView.textLabel?.textColor = self.view.tintColor
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 32)
        }
    }
}
