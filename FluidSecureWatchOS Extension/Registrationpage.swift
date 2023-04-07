//
//  Registrationpage.swift
//  FluidSecureWatchOS Extension
//
//  Created by apple on 03/05/21.
//  Copyright © 2021 VASP. All rights reserved.
//

import WatchKit
import UIKit

class Registrationpage: WKInterfaceController {

    
    var sysdata:NSDictionary!
    let locationManager = CLLocationManager()
    var currentlocation :CLLocation!
    let defaults = UserDefaults.standard
    var checkedstatus: Bool = false
    let web = Webservice()
    var Name :String = ""
    var Phone:String = ""
    var Email:String = ""
    var Companyname:String = ""
   

    
    @IBAction func userName(_ value: NSString?) {
        if(value == nil){}
        else{
            Name = value! as String
        }
    }
    
    @IBAction func userEmail(_ value: NSString?) {
        if(value == nil){}
        else{
            Email = value! as String
        }
    }
    @IBAction func userPhone(_ value: NSString?) {
        if(value == nil){}
        else{
            Phone = value! as String
        }
    }
    
    @IBAction func Company(_ value: NSString?) {
        if(value == nil){}
        else{
            Companyname = value! as String
        }
    }
    
    @IBAction func Register() {
        registerUser()
    }
    
    override func awake(withContext context: Any?)
    {
        let uuid:String
        let password = KeychainService.loadPassword()
        if(password == nil || password == ""){
             uuid = UUID().uuidString
            //UIDevice.current.identifierForVendor!.uuidString
            KeychainService.savePassword(token: uuid as NSString)

        }
        else{
            
            
        }
    }
    
    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    
    let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.default) {
            print("Ok")
        }

    
    
    func register(){
        let uuid:String
        
        
        
      
//        activityindicator.sizeToFit()
//        activityindicator.isHidden = false
        //activityindicator.startAnimating()
        let password = KeychainService.loadPassword()
        if(password == nil || password == ""){
             uuid = UUID().uuidString
            //UIDevice.current.identifierForVendor!.uuidString
            KeychainService.savePassword(token: uuid as NSString)

        }
        else{
            uuid = password! as String
            self.presentController(withName: "Hose", context: nil)
            
        }
        
       // let Name = firstNameTextField.text
        let string = uuid + ":" + Email + ":" + "Register" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
//        let mobile = mobileNoTextField.text
//        let Companyname = Company_Name.text
        let data = web.registration(Name: Name,Email:Email,Base64:Base64,mobile:Phone,uuid:uuid,company:Companyname)
        let Split = data.components(separatedBy: "#")
        let reply = Split[0]
        _ = Split[1]

        print(reply)
        if(reply == "-1"){
            presentAlert(withTitle: "", message:NSLocalizedString("NoInternet", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
           // showAlert(message: NSLocalizedString("NoInternet", comment:"") )

        }//"Internet connection is not available.\(error)")}
        else {
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            //print(sysdata)

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

            defaults.set(Name, forKey: "firstName")
            defaults.set(Phone, forKey: "mobile")
            defaults.set(Email, forKey: "address")
            defaults.set(uuid, forKey: "uuid")

            if(Message == "success") {
              //  showAlert(message: "\(ResponseText)" )
                defaults.set(0, forKey: "Login")
                defaults.set(1, forKey: "Register")
                self.presentController(withName: "Hose", context: nil)
//                let appDel = UIApplication.shared.delegate! as! AppDelegate
//                appDel.start()
            }
            else if(Message == "fail") {
//                self.showAlert(message: "\(ResponseText)" )
//                activityindicator.isHidden = true
//                activityindicator.stopAnimating()
//                if(ResponseText == "Please enter valid company.")
//                {
                    presentAlert(withTitle: "", message: "\(ResponseText)", preferredStyle: WKAlertControllerStyle.alert, actions:[action])// self.showAlert(message: "\(ResponseText)" )
//                }
            }
            else
            {
//                activityindicator.isHidden = true
//                activityindicator.stopAnimating()
                presentAlert(withTitle: "", message:  NSLocalizedString("Checkinternet", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                //showAlert(message: NSLocalizedString("Checkinternet", comment:"") )//"Please check your check your internet connection or Please contact your admin.")
            }
        }
    }

    
//    @IBAction func Spanish(_ sender: Any) {
//        if(itembarbutton.title == "English"){
//            Vehicaldetails.sharedInstance.Language = ""
//            Bundle.setLanguage("en")
//            let appDel = UIApplication.shared.delegate! as! AppDelegate
//            appDel.start()
//        }else if(itembarbutton.title == "Spanish"){
//            Bundle.setLanguage("es")
//            Vehicaldetails.sharedInstance.Language = "es-ES"
//            //itembarbutton.title = "Eng"
//            let appDel = UIApplication.shared.delegate! as! AppDelegate
//            appDel.start()
//        }
//
//    }


    func registerUser()  {
        print(checkedstatus)
        if(checkedstatus == true){
            let email_id = isValidEmail(testStr: Email)
            if(email_id != false){
                register()
            }
            else{
                presentAlert(withTitle: "", message:  NSLocalizedString("checkEmail", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                //showAlert(message: NSLocalizedString("checkEmail", comment:"") )//"please enter valid email.")
            }
        }
        else if(checkedstatus == false){
            if(Name == "" || Phone == "" ||  Email == "" || Companyname == "") {
                presentAlert(withTitle: "", message:  NSLocalizedString("SelectallFields", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
               // showAlert(message: NSLocalizedString("SelectallFields", comment:"") )//"Please Select All Fields.")

            }
            else
            {
                let email_id = isValidEmail(testStr: Email)
                if(email_id != false){
                    let phoneno = validatephone(testStr: Phone)
                    print(phoneno)
                    if(phoneno == true){
                        register()
                    }
                    else
                    {
                        presentAlert(withTitle: "", message:  NSLocalizedString("ValidPhone", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                        //showAlert(message: NSLocalizedString("ValidPhone", comment:"") )//"Please enter valid Phone number.")
                    }
                }
                else{
                    presentAlert(withTitle: "", message:  NSLocalizedString("checkEmail", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                    //showAlert(message: NSLocalizedString("checkEmail", comment:"") )//"please enter valid email.")
                }
            }
        }
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
            presentAlert(withTitle: "", message:  NSLocalizedString("checkEmail", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
            //showAlert(message: NSLocalizedString("checkEmail", comment:"") )
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }

    func validatephone(testStr:String) -> Bool {
        if(Phone.trimmingCharacters(in: .whitespacesAndNewlines) == ""){}
               else{
        if(Phone.count > 15) {
            return false
        }
        else if(Phone.count <=  15) {
           
            let PHONE_REGEX = "^[- +()0-9]*$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: testStr)
            return result
        }
            
        }
        return false
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        if (textField == mobileNoTextField)
//        {
//            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            let components = newString.components(separatedBy: CharacterSet.init(charactersIn: "0123456789+-().").inverted)// .decimalDigits.inverted)
//            let decimalString = components.joined(separator: "") as NSString
//            let length = decimalString.length
//            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
//            if length == 0 || (length > 15 && !hasLeadingOne) || length > 15
//            {
//                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
//
//                return (newLength > 15) ? false : true
//            }
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
//        else
//        {
//            return true
//        }
//    }

    func convertStringToBase64(string: String) -> String
    {
        let utf8str = string.data(using: String.Encoding.utf8)!
        let base64str = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        return base64str
    }
    // MARK: - Table view data source
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//        if let headerView = view as? UITableViewHeaderFooterView {
//
//            headerView.textLabel?.textColor = self.view.tintColor
//            headerView.textLabel?.font = UIFont.systemFont(ofSize: 32)
//        }
//    }
}
