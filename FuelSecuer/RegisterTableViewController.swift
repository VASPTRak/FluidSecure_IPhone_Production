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
//    @IBOutlet weak var Countrycode: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var Company_Name: UITextField!
//    @IBOutlet var checked: UIButton!
//    @IBOutlet var unchecked: UIButton!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    var web = Webservices()
    var vc = ViewController()
    var cf = Commanfunction()
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
//            placeholderdata(name: "Código de país", textfield: Countrycode)
                    placeholderdata(name: "Ingrese el nombre de la empresa", textfield: Company_Name)

        }else  if(Vehicaldetails.sharedInstance.Language == "") ||  (Vehicaldetails.sharedInstance.Language == "en-US"){
            itembarbutton.title = "Spanish"
                    placeholderdata(name: "Enter Full Name", textfield: firstNameTextField)
                    placeholderdata(name: "Enter Email Address", textfield: emailTextField)
                    placeholderdata(name: "Enter Mobile Number", textfield: mobileNoTextField)
//                    placeholderdata(name: "Country Code", textfield: Countrycode)
                    placeholderdata(name: "Enter Company Name", textfield: Company_Name)

        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        mobileNoTextField.delegate = self
//        Countrycode.delegate = self
//        Countrycode.text = "+1"
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
        registerButton.isEnabled = false
        self.web.sentlog(func_name: "Register button tapped.", errorfromserverorlink: "", errorfromapp: "")
        delay(1){
            self.registerUser()
        }
    }

    func show_Alert(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        // Change Message With Color and Font
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
        //messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default, handler: nil)
  
//        let appDel = UIApplication.shared.delegate! as! AppDelegate
//        appDel.start()
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func register(){
                var uuid:String = UIDevice.current.identifierForVendor!.uuidString // remove the identifierForVender because it may get the message the IMEI already exits.
               // var uuid = UUID().uuidString  // create new UUID.
                KeychainService.savePassword(token: uuid as NSString)
                //activityindicator.sizeToFit()
                activityindicator.isHidden = false
                activityindicator.startAnimating()
                
                let password = KeychainService.loadPassword()
                if(password == nil){
                     uuid = UIDevice.current.identifierForVendor!.uuidString
                    KeychainService.savePassword(token: uuid as NSString)

                }
                else{
                    uuid = password! as String
                }
        
                let Name = firstNameTextField.text
                let Email = emailTextField.text
                let string = uuid + ":" + Email! + ":" + "Register" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
                let Base64 = convertStringToBase64(string: string)
                let mobile = mobileNoTextField.text
                let Companyname = Company_Name.text
//                let Country_code = Countrycode.text
                let data = web.registration(Name: Name!,Email:Email!,Base64:Base64,mobile:mobile!,uuid:uuid,company:Companyname!)
        //web.registration(Name: Name!,Email:Email!,Base64:Base64,mobile:mobile!,uuid:uuid,company:Companyname!,Countrycode:Country_code!)
               // let data = web.registration(Name: Name!,Email:Email!,Base64:Base64,mobile:mobile!,uuid:uuid,company:Companyname!)
                let Split = data.components(separatedBy: "#")
                let reply = Split[0]
               // _ = Split[1]

                print(reply)
                if(reply == "-1"){
                    activityindicator.isHidden = true
                    activityindicator.stopAnimating()
                    registerButton.isEnabled = true
                    show_Alert(message: NSLocalizedString("NoInternet", comment:"") )
                    self.web.sentlog(func_name: "On Registration page No internet.", errorfromserverorlink: "", errorfromapp: "")
                   
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
                    defaults.set(Company_Name.text, forKey: "company")
                        if(uuid == ""){}
                        else{
                            defaults.set(uuid, forKey: "uuid")
                        }
                    defaults.set(uuid,forKey: "\(brandname)")

                    
                    if(brandname == "FluidSecure"){
                    if(defaults.string(forKey: "\(brandname)") != nil) {
                        uuid = defaults.string(forKey: "\(brandname)")!//UUID().uuidString
                    }
                        KeychainService.savePassword(token: uuid as NSString)
                    }
                  
                    if(Message == "success") {
                        self.web.sentlog(func_name: "On Registration page register successful UUID \(uuid).,Brand \(brandname),Name \(firstNameTextField.text!),Email \(mobileNoTextField.text!), Phone \(emailTextField.text!)", errorfromserverorlink: "", errorfromapp: "")
                        showAlert(message: "\(ResponseText)" )
                    
                        defaults.set(0, forKey: "Login")
                        defaults.set(1, forKey: "Register")
                        if(currentlocation == nil)
                        {
                            let reply =  web.checkApprove(uuid: uuid as String,lat:"\(0)",long:"\(0)")
                            if(reply != "-1"){
                                cf.DeleteFileInApp(fileName: "getSites.txt")
                                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
                            }
                        }
                        else {
                            let sourcelat = currentlocation.coordinate.latitude
                            let sourcelong = currentlocation.coordinate.longitude
                            //print (sourcelat,sourcelong)
                            let reply = web.checkApprove(uuid: uuid,lat:"\(sourcelat)",long:"\(sourcelong)")
                            
                            
                            if(reply != "-1"){
                                cf.DeleteFileInApp(fileName: "getSites.txt")
                                cf.CreateTextFile(fileName: "getSites.txt", writeText: reply)
                            }
                        }
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        appDel.start()
                    }
                    else if(Message == "fail") {
                       // self.showAlert(message: "\(ResponseText)" )
                        activityindicator.isHidden = true
                        activityindicator.stopAnimating()
                        if(ResponseText == "IMEI already exists.")
                        {
                            
                            let reply =  web.checkApprove(uuid: uuid as String,lat:"\(0)",long:"\(0)")
                            print(reply)
                        }
                        else{
//                            if(ResponseText == "Please enter valid company.")
//                            {
                                registerButton.isEnabled = true
                                self.showAlert(message: "\(ResponseText)" )
                                activityindicator.stopAnimating()
                                activityindicator.isHidden = true
//                            }
                        }
                    }
                    else
                    {
                        activityindicator.isHidden = true
                        activityindicator.stopAnimating()
                        registerButton.isEnabled = true
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
            registerButton.isEnabled = true

            }
            else
            {
                let email_id = isValidEmail(testStr: emailTextField.text!)
                if(email_id != false){
                    let concatmob = mobileNoTextField.text!
                    
//                    if(Countrycode.text! == "+1" || Countrycode.text! == "1")
//                    {
//                        let concatmob = mobileNoTextField.text!//Countrycode.text! + " " + mobileNoTextField.text!
//                        let phoneno = validate_Phone(testStr: concatmob)
//                        print(phoneno)
//                        if(phoneno == true){
//                            register()
//                        }
//                        else
//                        {
//                            showAlert(message: NSLocalizedString("ValidPhone", comment:"") )//"Please enter valid Phone number.")
//                            activityindicator.stopAnimating()
//                            activityindicator.isHidden = true
//                        }
//
//                    }
//                    else{
                        let phoneno = validatephone(testStr: concatmob)
                        print(phoneno)
                        if(phoneno == true){
                            register()
                        }
                        else
                        {
                            showAlert(message: NSLocalizedString("ValidPhone", comment:"") )//"Please enter valid Phone number.")
                            activityindicator.stopAnimating()
                            activityindicator.isHidden = true
                            registerButton.isEnabled = true
                        }
//                    }
                }
                else{
                    showAlert(message: NSLocalizedString("checkEmail", comment:"") )//"please enter valid email.")
                    activityindicator.stopAnimating()
                    activityindicator.isHidden = true
                    registerButton.isEnabled = true
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
    
    func validate_Phone(testStr:String) -> Bool
    {
        //let phoneNumber = "+1 (123) 456-7890" //Replace it with the Phone number you want to validate
        let range = NSRange(location: 0, length: testStr.count)
        let regex = try! NSRegularExpression(pattern: "^\\+[1{1}]\\s\\d{3}-\\d{3}-\\d{4}$")
        if regex.firstMatch(in: testStr, options: [], range: range) != nil{
            print("Phone number is valid")
           
            return true
            
        }else{
            print("Phone number is not valid")
            return false
        }
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
    
    func showPopupWithTitle(title: String, message: String, interval: TimeInterval) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Change Message With Color and Font
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!])
        //messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        present(alertController, animated: true, completion: nil)
        self.perform(#selector(dismissAlertViewController), with: alertController, afterDelay: interval)
    }

    @objc func dismissAlertViewController(alertController: UIAlertController) {
        alertController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func q_button(_ sender: Any) {
        showPopupWithTitle(title: "", message: "USA is 1", interval: 2)
        showAlert(message: "USA is 1" )
    }
    
//    @IBAction func country_Code(_ sender: Any) {
//        if(Countrycode.text == ""){
//            showAlert(message: "USA is 1" )
//        }
//    }
//    @IBAction func countryCode(_ sender: Any) {
//
//
//        Countrycode.text!.filter{$0.isNumber}
//        if(((Countrycode.text?.contains("0"))) == true)
//        {
//
//            let Country_code = Countrycode.text!
//            let code = Country_code.replacingOccurrences(of: "^.0*", with: "", options: .regularExpression)
//            Countrycode.text = "+\(code)"
//        }
//        else
//        if(((Countrycode.text?.contains("+"))) == true)
//        {
//
//             let Country_code = Countrycode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            Countrycode.text = "\(Country_code)"
//        }
//        else
//        {
//
//             let Country_code = Countrycode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            Countrycode.text = "+\(Country_code)"
//        }
//    }
    
    private func formatPhone(_ number: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let format: [Character] = ["X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]

        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
    @IBAction func Mobilephone(_ sender: Any) {
        
        //let phoneFormatter = DefaultTextFormatter(textPattern: "### (###) ###-##-##")
//        if(Countrycode.text == "1" || Countrycode.text == "+1" ){
            mobileNoTextField.text = formatPhone(mobileNoTextField.text!)
            let concatmob = mobileNoTextField.text!
            let phoneno = validatephone(testStr: concatmob)
            print(phoneno)
            if(phoneno == true){
                //register()
            }
            else
            {
                showAlert(message: NSLocalizedString("ValidPhone", comment:"") )//"Please enter valid Phone number.")
                activityindicator.stopAnimating()
                activityindicator.isHidden = true
            }
//        }
//        else
//        {
           var phone = mobileNoTextField.text!.filter{$0.isNumber}
            mobileNoTextField.text = phone
//        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == mobileNoTextField)
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.init(charactersIn: "0123456789+-()").inverted)// .decimalDigits.inverted)
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
//            if( Countrycode.text == "+1" )
//            {
//                if length == 0 || (length > 14 && !hasLeadingOne) || length > 14
//                {
//                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
//
//                    return (newLength > 14) ? false : true
//                }
//            }
//            else{
                if length == 0 || (length > 15 && !hasLeadingOne) || length > 15
                {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    
                    return (newLength > 15) ? false : true
                }
//            }
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
//        if(textField == Countrycode)
//        {
//            let newString = (Countrycode.text! as NSString).replacingCharacters(in: range, with: string)
//            let components = newString.components(separatedBy: CharacterSet.init(charactersIn: "0123456789+-()").inverted)// .decimalDigits.inverted)
//            let decimalString = components.joined(separator: "") as NSString
//            let length = decimalString.length
//            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
//
//                if length == 0 || (length > 5 && !hasLeadingOne) || length > 5
//                {
//                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
//
//                    return (newLength > 5) ? false : true
//                }
//
//            var index = 0 as Int
//            let formattedString = NSMutableString()
//
//            if hasLeadingOne
//            {
//                formattedString.append("1 ")
//                index += 1
//            }
//
//            let remainder = decimalString.substring(from: index)
//            formattedString.append(remainder)
//            textField.text = formattedString as String
//            return false
//        }
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
