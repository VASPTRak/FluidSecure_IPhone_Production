//  RegisterTableViewController.swift
//  FuelSecuer
//
//  Created by VASP on 18/05/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit
import CoreLocation

class RegisterTableViewController: UITableViewController,CLLocationManagerDelegate,UITextFieldDelegate {

    @IBOutlet var itembarbutton: UIBarButtonItem!
    @IBOutlet var version: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var Company_Name: UITextField!
//    @IBOutlet var checked: UIButton!
//    @IBOutlet var unchecked: UIButton!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    var web = Webservices()
    var sysdata:NSDictionary!
    let locationManager = CLLocationManager()
    var currentlocation :CLLocation!
    let defaults = UserDefaults.standard
    var checkedstatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Vehicaldetails.sharedInstance.Language)
        activityindicator.isHidden = true
        version.text = "Version \(Version)"
        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
            itembarbutton.title = "English"
                    placeholderdata(name: "Ingrese su nombre completo", textfield: firstNameTextField)
                    placeholderdata(name: "Introducir la dirección de correo electrónico", textfield: emailTextField)
                    placeholderdata(name: "Ingrese el número de celular", textfield: mobileNoTextField)
                    placeholderdata(name: "Ingrese el nombre de la empresa", textfield: Company_Name)

        }else  if(Vehicaldetails.sharedInstance.Language == "") ||  (Vehicaldetails.sharedInstance.Language == "en-US"){
            itembarbutton.title = "Spanish"
                    placeholderdata(name: "Enter Full Name", textfield: firstNameTextField)
                    placeholderdata(name: "Enter Email Address", textfield: emailTextField)
                    placeholderdata(name: "Enter Mobile Number", textfield: mobileNoTextField)
                    placeholderdata(name: "Enter Company Name", textfield: Company_Name)

        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        mobileNoTextField.delegate = self
        self.registerButton.layer.cornerRadius = 5
//        checked.isHidden = true

    }

    func placeholderdata(name:String,textfield:UITextField )
    {
        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = name // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
        textfield.attributedPlaceholder = myMutableStringTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.monospacedSystemFont(ofSize: 20, weight: .black)
            ]
            appearance.largeTitleTextAttributes = attrs
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    self.navigationController?.navigationBar.tintColor = UIColor.white
                    self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }


    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonClicked(sender: AnyObject) {
        activityindicator.isHidden = false
        activityindicator.startAnimating()
        self.registerUser()
    }


    func register(){
//        var uuid:String //= //UIDevice.current.identifierForVendor!.uuidString
        var uuid = UUID().uuidString
        KeychainService.savePassword(token: uuid as NSString)
        //activityindicator.sizeToFit()
        activityindicator.isHidden = false
        activityindicator.startAnimating()
        
//        let password = KeychainService.loadPassword()
//        if(password == nil){
//             uuid = UIDevice.current.identifierForVendor!.uuidString
//            KeychainService.savePassword(token: uuid as NSString)
//
//        }
//        else{
//            uuid = password! as String
//        }
        let Name = firstNameTextField.text
        let Email = emailTextField.text
        let string = uuid + ":" + Email! + ":" + "Register" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let mobile = mobileNoTextField.text
        let Companyname = Company_Name.text
        let data = web.registration(Name: Name!,Email:Email!,Base64:Base64,mobile:mobile!,uuid:uuid,company:Companyname!)
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
       // _ = Split[1]

        print(reply)
        if(reply == "-1"){
            showAlert(message: NSLocalizedString("NoInternet", comment:"") )

        }//"Internet connection is not available.\(error)")}
        else {
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            //print(sysdata)
            if(sysdata == nil){
                
            }
            else{
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
            defaults.set(mobileNoTextField.text, forKey: "mobile")
            defaults.set(emailTextField.text, forKey: "address")
            //defaults.set(uuid, forKey: "uuid")
            defaults.set(uuid,forKey: "\(brandname)")
            
            
            if(brandname == "FluidSecure"){
            if(defaults.string(forKey: "\(brandname)") != nil) {
                uuid = defaults.string(forKey: "\(brandname)")!//UUID().uuidString
            }
                KeychainService.savePassword(token: uuid as NSString)
            }

            if(Message == "success") {
                showAlert(message: "\(ResponseText)" )
                defaults.set(0, forKey: "Login")
                defaults.set(1, forKey: "Register")
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
            }
            else if(Message == "fail") {
                self.showAlert(message: "\(ResponseText)" )
                activityindicator.isHidden = true
                activityindicator.stopAnimating()
                if(ResponseText == "Please enter valid company.")
                {
                    self.showAlert(message: "\(ResponseText)" )
                    activityindicator.stopAnimating()
                    activityindicator.isHidden = true
                }
            }
            else
            {
                activityindicator.isHidden = true
                activityindicator.stopAnimating()
                showAlert(message: NSLocalizedString("Checkinternet", comment:"") )//"Please check your check your internet connection or Please contact your admin.")
            }
        }
        }
    }

    
    @IBAction func Spanish(_ sender: Any) {
        if(itembarbutton.title == "English"){
            Vehicaldetails.sharedInstance.Language = ""
            Bundle.setLanguage("en")
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
        }else if(itembarbutton.title == "Spanish"){
            Bundle.setLanguage("es")
            Vehicaldetails.sharedInstance.Language = "es-ES"
            //itembarbutton.title = "Eng"
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
        }

    }


    func registerUser()  {
//        print(checkedstatus)
//        if(checkedstatus == true){
//            let email_id = isValidEmail(testStr: emailTextField.text!)
//            if(email_id != false){
//                register()
//            }
//            else{
//                showAlert(message: NSLocalizedString("checkEmail", comment:"") )//"please enter valid email.")
//            }
//        }
//        else if(checkedstatus == false){
            if(firstNameTextField.text == "" || mobileNoTextField.text == "" ||  emailTextField.text == "" || Company_Name.text == "") {
                showAlert(message: NSLocalizedString("SelectallFields", comment:"") )//"Please Select All Fields.")
                activityindicator.stopAnimating()
                activityindicator.isHidden = true

            }
            else
            {
                let email_id = isValidEmail(testStr: emailTextField.text!)
                if(email_id != false){
                    let phoneno = validatephone(testStr: mobileNoTextField.text!)
                    print(phoneno)
                    if(phoneno == true){
                        register()
                    }
                    else
                    {
                        showAlert(message: NSLocalizedString("ValidPhone", comment:"") )//"Please enter valid Phone number.")
                        activityindicator.stopAnimating()
                        activityindicator.isHidden = true
                    }
                }
                else{
                    showAlert(message: NSLocalizedString("checkEmail", comment:"") )//"please enter valid email.")
                    activityindicator.stopAnimating()
                    activityindicator.isHidden = true
                }
            }
        //}
    }

//    @IBAction func uncheckedButtontapped(sender: AnyObject) {
//        checked.isHidden = false
//        unchecked.isHidden = true
//        firstNameTextField.isHidden = true
//        mobileNoTextField.isHidden = true
//        Company_Name.isHidden = false
//        checkedstatus = true
//    }
//
//    @IBAction func Checkedbuttontapped(sender: AnyObject) {
//        checked.isHidden = true
//        unchecked.isHidden = false
//        firstNameTextField.isHidden = false
//        mobileNoTextField.isHidden = false
//        Company_Name.isHidden = false
//        checkedstatus = false
//    }

    func isValidEmail(testStr:String) -> Bool {
        if(testStr == "")
        {
            showAlert(message: NSLocalizedString("checkEmail", comment:"") )
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }

    func validatephone(testStr:String) -> Bool {
        if(mobileNoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){}
               else{
        if(mobileNoTextField.text!.count > 15) {
            return false
        }
        else if(mobileNoTextField.text!.count <=  15) {
           
            let PHONE_REGEX = "^[- +()0-9]*$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: testStr)
            return result
        }
            
        }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == mobileNoTextField)
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.init(charactersIn: "0123456789+-().").inverted)// .decimalDigits.inverted)
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
