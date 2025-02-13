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
        let boldString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font:UIFont(name: "Arial", size: 17)!])
        boldString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:text.count))
        self.append(boldString)
        return self
    }

    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let normal =  NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font:UIFont(name: "Arial", size: 15.0)!])
        self.append(normal)
        return self
    }
}



class VehiclenoVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var Vehicleno: UITextField!
    @IBOutlet var Mview: UIView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var save: UIButton!
    @IBOutlet weak var Barcodevalue: UILabel!
    @IBOutlet var barcodeimage: UIButton!

    @IBOutlet var VehicleLabel: UILabel!
    @IBOutlet weak var Activity: UIActivityIndicatorView!

    var scanvehicle = ""
    var Barcodescanvalue = ""
    var web = Webservices()

    var cf = Commanfunction()
    var sysdata:NSDictionary!

    var IsGobuttontapped : Bool = false
    var IsScanBarcode : Bool = false
    var odo = Vehicaldetails.sharedInstance.odometerreq
    var isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
    var isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
    var isother = Vehicaldetails.sharedInstance.IsOtherRequire
    var stoptimergotostart:Timer = Timer()
    var IsUseBarcode:String = ""
    var UseBarcodeScanOfVehicleOnly:String = ""
    var appisonVehicle = true
    var button = UIButton(type: UIButton.ButtonType.custom)

    var countfailauth:Int = 0
    var counthourauth:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Vehicleno.font = UIFont(name: Vehicleno.font!.fontName, size: 40)
        Vehicleno.textAlignment = NSTextAlignment.center
        Vehicleno.textColor = UIColor.white
        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            VehicleLabel.text = "Ingrese Numero de " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)"
        }
        else{
        VehicleLabel.text = "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number"
        }
        var myMutableStringTitle = NSMutableAttributedString()
         var Name = "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number"
        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
             Name = "Ingrese Numero de " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)"
        }
        else{
         Name = "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number"
        }
//                   let Name  = "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
                   Vehicleno.attributedPlaceholder = myMutableStringTitle
        Vehicleno.delegate = self
        Activity.isHidden = true
        
//        if(IsUseBarcode == "False")
//        {
//            barcodeimage.isHidden = true;
//            Barcodevalue.isHidden = true;
//        }
//        else if(IsUseBarcode == "True"){
//            barcodeimage.isHidden = false;
//            Barcodevalue.isHidden = false;
//                        if(self.UseBarcodeScanOfVehicleOnly == "True"){
//                            self.performSegue(withIdentifier: "barcodescan", sender: self)
//                            barcodeimage.isHidden = true;
//                            Barcodevalue.isHidden = true;
//                        }
//            
//        }
        
        if(scanvehicle == ""){}
        else
        {
            Barcodescanvalue = scanvehicle
            Barcodevalue.text = "Barcode " + scanvehicle
            Vehicaldetails.sharedInstance.Barcodescanvalue = Barcodescanvalue
//            Vehicaldetails.sharedInstance.odometerreq = "False"
            odo = Vehicaldetails.sharedInstance.odometerreq
            print(odo , Vehicaldetails.sharedInstance.odometerreq)
            
            self.getodometer()
            Vehicleno.text = Vehicaldetails.sharedInstance.vehicleno
            if(Vehicleno.text == ""){}
            else{
                IsScanBarcode = true
                
            }
        }
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if(IsUseBarcode == "True"){
//            if(self.UseBarcodeScanOfVehicleOnly == ""){
//                self.performSegue(withIdentifier: "barcodescan", sender: self)
//            }
//        }
        
        if(IsUseBarcode == "False")
        {
            barcodeimage.isHidden = true;
            Barcodevalue.isHidden = true;
        }
        else if(IsUseBarcode == "True"){
            barcodeimage.isHidden = false;
            Barcodevalue.isHidden = false;
                        if(self.UseBarcodeScanOfVehicleOnly == "True"){
                            self.performSegue(withIdentifier: "barcodescan", sender: self)
                            barcodeimage.isHidden = true;
                            Barcodevalue.isHidden = true;
                        }
            
        }
        
        IsScanBarcode = false
        Vehicleno.becomeFirstResponder()
//        UIKeyboardType.default
//        UIKeyboardAppearance.alert
        
        stoptimergotostart.invalidate()
        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(VehiclenoVC.gotostart), userInfo: nil, repeats: false)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        stoptimergotostart.invalidate()
        appisonVehicle = false
        super.viewWillDisappear(animated)
        stoptimergotostart.invalidate()
    }
    
    @objc func gotostart(){
        if(appisonVehicle == true){
        self.web.sentlog(func_name: "vehicle timeout, back to home screen", errorfromserverorlink: "", errorfromapp: "")
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
        }
    }
    
    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.Mview.endEditing(true)
        save.isHidden = false
        cancel.isHidden = false
    }

    @IBAction func Vno(_ sender: Any) {
        checkMaxLength(textField: Vehicleno,maxLength: 20)
        if(Vehicleno.text != "0")
        {
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


    func mainPage()
    {
        //        cf.delay(2){
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
        {
            self.performSegue(withIdentifier: "GoUDP", sender: self)
        }
        else{
        self.performSegue(withIdentifier: "Go", sender: self)
        }
        //        }
    }
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        let vehicle_no = Vehicleno.text
        
        countfailauth += 1
        let data = web.vehicleAuth(vehicle_no: vehicle_no!,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue: Barcodescanvalue)
        let Split = data.components(separatedBy: "#@*%*@#")
        let reply = Split[0]
        //let error = Split[1]
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
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
            if(sysdata == nil){
                
            }
            else{
            let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
            let ResponceText = sysdata.value(forKey:"ResponceText") as! NSString
//            let ResponceData = sysdata.value(forKey:"ResponceData") as! NSDictionary
//            let MinLimit = ResponceData.value(forKey:"MinLimit") as! NSNumber
//            let PulseRatio = ResponceData.value(forKey:"PulseRatio") as! NSNumber
//            let VehicleId = ResponceData.value(forKey:"VehicleId") as! NSNumber
//            let FuelTypeId = ResponceData.value(forKey:"FuelTypeId") as! NSNumber
//            let PersonId = ResponceData.value(forKey:"PersonId") as! NSNumber
//            let PhoneNumber = ResponceData.value(forKey:"PhoneNumber") as! NSString
//            // let PulserStopTime = ResponceData.value(forKey:"PulserStopTime") as! NSString
//            let ServerDate = ResponceData.value(forKey:"ServerDate") as! String
//            let pumpoff_time = ResponceData.value(forKey: "PumpOffTime") as! String
//            print(MinLimit,PersonId,PhoneNumber,FuelTypeId,VehicleId,PulseRatio)
//
//            Vehicaldetails.sharedInstance.MinLimit = "\(MinLimit)"
//            Vehicaldetails.sharedInstance.PulseRatio = "\(PulseRatio)"
//            Vehicaldetails.sharedInstance.VehicleId = "\(VehicleId)"
//            Vehicaldetails.sharedInstance.FuelTypeId = "\(FuelTypeId)"
//            Vehicaldetails.sharedInstance.PersonId = "\(PersonId)"
//            Vehicaldetails.sharedInstance.PhoneNumber = "\(PhoneNumber)"
//            Vehicaldetails.sharedInstance.pumpoff_time = "\(pumpoff_time)" //Send pump off time to pulsar off time.
//            Vehicaldetails.sharedInstance.date = "\(ServerDate)"

            if(ResponceMessage == "success") {
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){

                    if #available(iOS 12.0, *) {
                        self.mainPage()
                        self.web.wifisettings(pagename: "Vehicle")
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
//                        formattedString
//                            .normal(NSLocalizedString("Step1", comment:""))
//                            .bold("\(Vehicaldetails.sharedInstance.SSId)")
//                            .normal(NSLocalizedString("Step2", comment:""))
//                            .bold("\(Vehicaldetails.sharedInstance.SSId)")
//                            .normal(NSLocalizedString("Step3", comment:""))

                        alertController.setValue(formattedString, forKey: "attributedMessage")
                        alertController.setValue(attributedString, forKey: "attributedTitle")
                        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default){
                            action in
                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                            {
                                self.performSegue(withIdentifier: "GoUDP", sender: self)
                            }
                            else{
                            self.performSegue(withIdentifier: "Go", sender: self)
                            }
                        }
                        alertController.addAction(action)

                        self.present(alertController, animated: true, completion: nil)
                    }
                    // self.mainPage()
                }
                
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                    {
                        self.performSegue(withIdentifier: "GoUDP", sender: self)
                    }
                    else{
                    self.performSegue(withIdentifier: "Go", sender: self)
                    }
                    
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                    {
                        self.web.sentlog(func_name: "Vehicle Number Entered : \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp:"")
                        
                        self.web.sentlog(func_name: "Go button Tapped.", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)")
                    }
                    else{
                    self.web.sentlog(func_name: "Vehicle Number Entered : \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link : \(self.cf.getSSID())")

                    self.web.sentlog(func_name: "Go button Tapped.", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    }
                }
            }
            else {
                
                if(ResponceMessage == "fail")
                {
                    if(ResponceText == "Unauthorized vehicle")
                    {
                        
                    }
                    stoptimergotostart.invalidate()
                    viewWillAppear(true)
                    showAlert(message: "\(ResponceText)")
                }
            }
        }
        }
    }
    
    

    func Action(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        if #available(iOS 12.0, *) {
            self.web.wifisettings(pagename: "Vehicle")
        } else {
            // Fallback on earlier versions
        }
        self.mainPage()
    }
    
    func getodometer(){
        if(odo == "False")
        {
            let odom = "0"
            _ = Int(odom)
            let vehicle_no = Vehicleno.text
            Vehicaldetails.sharedInstance.vehicleno = vehicle_no!
//             = Barcodescanvalue
            print(Vehicaldetails.sharedInstance.Barcodescanvalue)
            let data = web.checkhour_odometer(vehicle_no!,Vehicaldetails.sharedInstance.Barcodescanvalue)
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
                    if(IsScanBarcode == true){
                   delay(1){
                        self.getodometer()
                        }
                    }
                    else if(IsScanBarcode == false)
                    {
                        getodometer()
                    }
                }
                showAlert(message: NSLocalizedString("Warningwait", comment:""))
                stoptimergotostart.invalidate()
                viewWillAppear(true)
            }
            else
            {
                counthourauth = 0
                let data1:Data = data.data(using: String.Encoding.utf8)!
                do{
                    sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                
               // print(sysdata)
                if(sysdata == nil){
                    
                }
                else{
                let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
                let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
                if(ResponceMessage == "success"){
                    
                    appisonVehicle = false
                    let ExtraOtherLabel = sysdata.value(forKey: "ExtraOtherLabel") as! NSString
                    let IsExtraOther = sysdata.value(forKey: "IsExtraOther") as! NSString
                    let IsHoursRequire = sysdata.value(forKey: "IsHoursRequire") as! NSString
                    let IsOdoMeterRequire = sysdata.value(forKey: "IsOdoMeterRequire") as! NSString
                    let CheckOdometerReasonable = sysdata.value(forKey: "CheckOdometerReasonable") as! NSString
                    let OdometerReasonabilityConditions = sysdata.value(forKey: "OdometerReasonabilityConditions") as! NSString
                    let PreviousOdo = sysdata.value(forKey: "PreviousOdo") as! NSString
                    let OdoLimit = sysdata.value(forKey: "OdoLimit") as! NSString
                    let PreviousHours = sysdata.value(forKey: "PreviousHours") as! NSString
                    let HoursLimit = sysdata.value(forKey: "HoursLimit")  as! NSString
                    let VehicleNumber = sysdata.value(forKey: "VehicleNumber") as! NSString
                    let LastTransactionFuelQuantity = sysdata.value(forKey: "LastTransactionFuelQuantity") as! NSString
                    

                    Vehicaldetails.sharedInstance.IsExtraOther = IsExtraOther as String
                    Vehicaldetails.sharedInstance.ExtraOtherLabel = ExtraOtherLabel as String
                    Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire as String
                    Vehicaldetails.sharedInstance.IsHoursrequirs = IsHoursRequire as String
                    Vehicaldetails.sharedInstance.CheckOdometerReasonable = CheckOdometerReasonable as String
                    Vehicaldetails.sharedInstance.OdometerReasonabilityConditions = OdometerReasonabilityConditions as String
                    Vehicaldetails.sharedInstance.PreviousOdo = Int(PreviousOdo as String)!
                    Vehicaldetails.sharedInstance.OdoLimit = Int(OdoLimit as String)!
                    Vehicaldetails.sharedInstance.HoursLimit = Int(HoursLimit as String)!
                    Vehicaldetails.sharedInstance.PreviousHours = Int(PreviousHours as String)!
                    Vehicaldetails.sharedInstance.vehicleno = VehicleNumber as String
                    Vehicaldetails.sharedInstance.LastTransactionFuelQuantity = LastTransactionFuelQuantity as String
                    
                    Activity.stopAnimating()
                    Activity.isHidden = true
                    let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
                    let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                    let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                    
                    if (IsOdoMeterRequire == "True"){

                        print(self.odo)
                        stoptimergotostart.invalidate()
                        delay(2){
                            self.stoptimergotostart.invalidate()
                        self.performSegue(withIdentifier: "odometer", sender: self)
                        }
                    }
                    else
                    {
                        if (IsHoursRequire == "True"){
                            stoptimergotostart.invalidate()
                            self.performSegue(withIdentifier: "hours", sender: self)
                        }
                        else if(IsExtraOther == "True")
                        {
                            stoptimergotostart.invalidate()
                            self.performSegue(withIdentifier: "OtherVehicle", sender: self)
                        }
                        else
                        {
                            Vehicaldetails.sharedInstance.hours = ""
                            if(isdept == "True"){
                                stoptimergotostart.invalidate()
                                self.performSegue(withIdentifier: "dept", sender: self)
                            }
                            else
                            {
                                if(isPPin == "True"){
                                    stoptimergotostart.invalidate()
                                    self.performSegue(withIdentifier: "pin", sender: self)
                                }
                                else
                                {
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
                                        stoptimergotostart.invalidate()
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
                         delay(1){
                             if(ResponceText.contains("Mobile is not registered in the system, Please contact administrator."))
                             {
                                 self.Alert(message: "Your device had been deactivated by your Manager. Please press register if you would like to have it reactivated")
                             }
                             else{
                                 self.showAlert(message: "\(ResponceText)")
                             }
                            self.stoptimergotostart.invalidate()
                         self.viewWillAppear(true)
                         self.Activity.stopAnimating()
                         self.Activity.isHidden = true
                        }

                    }
                }
            }
            }
            Vehicaldetails.sharedInstance.Odometerno = odom
        }
        else if(odo == "True"){
            stoptimergotostart.invalidate()
            self.performSegue(withIdentifier: "odometer", sender: self)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
    @IBAction func saveBtntapped(sender: AnyObject) {
        
        if(self.cf.getSSID() != "" && Vehicaldetails.sharedInstance.SSId != self.cf.getSSID() && Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP") {
            print("SSID: \(self.cf.getSSID())")
            self.showAlert(message:NSLocalizedString("SwitchoffyourWiFi", comment:""))

        }
        else{
            Activity.startAnimating()
            Activity.isHidden = false
            save.isEnabled = false
            delay(1){
                
                self.IsGobuttontapped = true
                self.stoptimergotostart.invalidate()
                if(self.Vehicleno.text == "")
                {
                    if(Vehicaldetails.sharedInstance.Language == "es-ES")
                    {
                        self.showAlert(message: NSLocalizedString("Entervehicelno", comment:""))
                    }
                    else{
                        self.showAlert(message:"Please Enter \(Vehicaldetails.sharedInstance.ScreenNameForVehicle) Number")
                    }
                    
                    self.viewWillAppear(true)
                    self.Activity.stopAnimating()
                    self.Activity.isHidden = true
                }
                else{
                    
                    if(self.IsScanBarcode == true){}
                    else{
                        self.getodometer()
                        Vehicaldetails.sharedInstance.vehicleno = self.Vehicleno.text!
                        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                        {
                            self.web.sentlog(func_name: "Vehicle number Entered : \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: "")
                        }
                        else{
                            self.web.sentlog(func_name: "Vehicle number Entered : \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link : \(self.cf.getSSID())")
                        }
                    }
                }
            }
        }
    }
    
    
    func Alert(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
        
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("REGISTER", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            self.web.sentlog(func_name: "Mobile is not registered in the system App Goes to resgistration screen ", errorfromserverorlink: "", errorfromapp: "")
            self.cf.delay(1){
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                // Call a method on the CustomController property of the AppDelegate
                defaults.set(0, forKey: "Register")
                appDel.start()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
