//
//  Vehicleviewcontroller.swift
//  FluidSecureWatchOS Extension
//
//  Created by apple on 26/04/21.
//  Copyright © 2021 VASP. All rights reserved.
//

import WatchKit
import SwiftUI

struct ContentView: View {

    @State var name: String = ""

    var body: some View {
        VStack {
            TextField("Enter some text", text: $name)
                .background(Color.blue)
        }
    }
}

class Vehicleviewcontroller: WKInterfaceController {
    
    @IBOutlet weak var vehiclepagetitle: WKInterfaceLabel!
    @IBOutlet weak var vehiclenolable: WKInterfaceTextField!
    var sysdata:NSDictionary!

    var Barcodescanvalue = ""
    var IsGobuttontapped : Bool = false
    var IsScanBarcode : Bool = false

    var stoptimergotostart:Timer = Timer()
    var IsUseBarcode:String = ""
    var web = Webservice()
//    var button = UIButton(type: UIButton.ButtonType.custom)

    var countfailauth:Int = 0
    var counthourauth:Int = 0
    var odo = Vehicaldetails.sharedInstance.odometerreq
    
    let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.default) {
            print("Ok")
        
        }
    
    override func awake(withContext context: Any?) {
        
        
       // let checkaprovedata = checkApprove(uuid: "6F90251E-71F2-449D-A721-31C1D1669E24" as String,lat:"\(18.479963)",long:"\(73.821659)")
//        var info = Getinfo()
        setTitle("\(Vehicaldetails.sharedInstance.SSId)")
        
        getdata()
       // image.setImageNamed( "fuel_secure_lock.png")
//        if(info == "false")
//        {
//             info = Getinfo()
//        }
//        self.connectToUDP(self.hostUDP,self.portUDP)
//        if( ifSubscribed == false){
       
        
//        }
        // Configure interface objects here.
    }
    
        
    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func gobuttontapped() {
        
        if(Vehicaldetails.sharedInstance.vehicleno == ""){
            presentAlert(withTitle: "", message:"Please Enter Vehicle.", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
        }
        else{
        
        presentAlert(withTitle: "", message:"Verifying with Cloud, please wait.", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
        sleep(1)
        getodometer()
        }
    }
    
    
    func getdata(){

        if(Vehicaldetails.sharedInstance.Language == "es-ES")
        {
            vehiclepagetitle.setText( "Ingrese Numero de " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)")
        }
        else{
            vehiclepagetitle.setText( "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number")
        }
//        var myMutableStringTitle = NSMutableAttributedString()
    vehiclepagetitle.setText( "Enter " + "\(Vehicaldetails.sharedInstance.ScreenNameForVehicle)" + " Number")
 

        //self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        IsScanBarcode = false
//        Vehicleno.becomeFirstResponder()
//        UIKeyboardType.default
//        UIKeyboardAppearance.alert
//
//        stoptimergotostart.invalidate()
//        stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(VehiclenoVC.gotostart), userInfo: nil, repeats: false)
//    }
    
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//
//        stoptimergotostart.invalidate()
//        super.viewWillDisappear(animated)
//    }
    
//    @objc func gotostart(){
//
//        self.web.sentlog(func_name: "vehicle timeout", errorfromserverorlink: "", errorfromapp: "")
//        let appDel = UIApplication.shared.delegate! as! AppDelegate
//        appDel.start()
//    }
    
//    func tapAction() {
//        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        self.Mview.endEditing(true)
//        save.isHidden = false
//        cancel.isHidden = false
//    }

//    @IBAction func Vno(_ sender: Any) {
//        checkMaxLength(textField: Vehicleno,maxLength: 20)
//        if(Vehicleno.text != "0")
//        {
//            save.isEnabled = true
//        }
//    }
//    

    
   
 





//    func mainPage()
//    {
//        //        cf.delay(2){
//        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
//        {
//            self.performSegue(withIdentifier: "GoUDP", sender: self)
//        }
//        else{
//        self.performSegue(withIdentifier: "Go", sender: self)
//        }
//        //        }
//    }
//

    @IBAction func vehiclenumbertext(_ value: NSString?) {
        let vehnum = value
        if(value == nil)
        {
            presentAlert(withTitle: "", message:"Please Enter Vehicle.", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
        }
        else{
        print(vehnum)
        Vehicaldetails.sharedInstance.vehicleno = value! as String
      }
    }
    
    func senddata(deptno:String,ppin:String,other:String)
    {
        let odom = "0"
        let odometer = Int(odom)
        
        
        countfailauth += 1
        let data = web.vehicleAuth(vehicle_no:Vehicaldetails.sharedInstance.vehicleno,Odometer:odometer!,isdept:deptno,isppin:ppin,isother:other,Barcodescanvalue: Barcodescanvalue)
        let Split = data.components(separatedBy: "#@*%*@#")
        let reply = Split[0]
        //let error = Split[1]
        if (reply == "-1")
        {
            if(countfailauth>2)
            {
//                showAlert(message: NSLocalizedString("CheckyourInternet", comment:"") )

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
               // pushController(withName: "go", context: nil)
                WKInterfaceController.reloadRootPageControllers(withNames: ["Fueling"], contexts: ["Fueling"], orientation: WKPageOrientation.horizontal, pageIndex: 0) //.reloadRootControllers(withNames: ["Fueling"], contexts: ["Fueling"])
                //self.presentController(withName: "Fueling", context: nil)
                
//                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
//
//                    if #available(iOS 12.0, *) {
//                        //self.mainPage()
//                        self.web.wifisettings(pagename: "Vehicle")
//                    } else {
//                        // Fallback on earlier versions
//
//                      //  let alertController = UIAlertController(title: NSLocalizedString("Title", comment:""), message: NSLocalizedString("Message", comment:"") + "\(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertController.Style.alert)
//                        let backView = alertController.view.subviews.last?.subviews.last
//                        backView?.layer.cornerRadius = 10.0
//                        backView?.backgroundColor = UIColor.white
//
//                        let paragraphStyle = NSMutableParagraphStyle()
//                        paragraphStyle.alignment = NSTextAlignment.left
//
//                        let paragraphStyle1 = NSMutableParagraphStyle()
//                        paragraphStyle1.alignment = NSTextAlignment.left
//
//                        let attributedString = NSAttributedString(string:NSLocalizedString("Subtitle", comment:""), attributes: [
//                            NSAttributedString.Key.paragraphStyle:paragraphStyle1,
//                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), //your font here
//                            NSAttributedString.Key.foregroundColor : UIColor.black
//                            ])
//
//                        let formattedString = NSMutableAttributedString()
////                        formattedString
////                            .normal(NSLocalizedString("Step1", comment:""))
////                            .bold("\(Vehicaldetails.sharedInstance.SSId)")
////                            .normal(NSLocalizedString("Step2", comment:""))
////                            .bold("\(Vehicaldetails.sharedInstance.SSId)")
////                            .normal(NSLocalizedString("Step3", comment:""))
//
//                        alertController.setValue(formattedString, forKey: "attributedMessage")
//                        alertController.setValue(attributedString, forKey: "attributedTitle")
//                        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default){
//                            action in
//                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
//                            {
//                                self.performSegue(withIdentifier: "GoUDP", sender: self)
//                            }
//                            else{
//                            self.performSegue(withIdentifier: "Go", sender: self)
//                            }
//                        }
//                        alertController.addAction(action)
//
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                    // self.mainPage()
//                }
                
//                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
//                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
//                    {
//                        self.performSegue(withIdentifier: "GoUDP", sender: self)
//                    }
//                    else{
//                    self.performSegue(withIdentifier: "Go", sender: self)
//                    }
                    self.web.sentlog(func_name: "Vehicle number entered \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink:"" , errorfromapp:"" )
//
//                    self.web.sentlog(func_name: "Go button Tapped NO need to select Wifi data Manually", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                }
            }
            else {
                
                if(ResponceMessage == "fail")
                {
                    if(ResponceText == "Unauthorized vehicle")
                    {
                        
                    }
                    stoptimergotostart.invalidate()
//                    viewWillAppear(true)
//                    showAlert(message: "\(ResponceText)" )
                }
            }
        }
    }
    
//    
//    
//
//    func Action(sender:UIButton!)
//    {
//        self.dismiss(animated: true, completion: nil)
//        if #available(iOS 12.0, *) {
//            self.web.wifisettings(pagename: "Vehicle")
//        } else {
//            // Fallback on earlier versions
//        }
//        self.mainPage()
//    }
//
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "Fueling"
        {
            return ["segue": "go",
                                "data":"Passed through hierarchical navigation"]
        }
        return nil
    }
    
    func getodometer(){
       
        if(odo == "False")
        {
            let odom = "0"
            _ = Int(odom)
            //let vehicle_no = "1"//Vehicleno.text
            //Vehicaldetails.sharedInstance.vehicleno = vehicle_no
//             = Barcodescanvalue
            print(Vehicaldetails.sharedInstance.Barcodescanvalue)
            let data = web.checkhour_odometer(vehicle_no: Vehicaldetails.sharedInstance.vehicleno,Barcodescanvalue: Vehicaldetails.sharedInstance.Barcodescanvalue)
            counthourauth += 1
            
            let Split = data.components(separatedBy: "#")
            let reply = Split[0]
            if (reply == "-1")
            {
                if(counthourauth>2)
                {
                    //showAlert(message: NSLocalizedString("CheckyourInternet", comment:"") )
                }
                else
                {
                    if(IsScanBarcode == true){
                   //delay(1){
                        self.getodometer()
                        }
                   // }
                    else if(IsScanBarcode == false)
                    {
                        getodometer()
                    }
                }
               // showAlert(message: NSLocalizedString("Warningwait", comment:"") )
                //stoptimergotostart.invalidate()
                //viewWillAppear(true)
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
                let ResponceMessage = sysdata.value(forKey: "ResponceMessage") as! NSString
                let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
                if(ResponceMessage == "success"){
                   // self.web.sentlog(func_name: "Vehicle number entered \(Vehicaldetails.sharedInstance.vehicleno)", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link : \(self.cf.getSSID())")

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
                  //  Activity.stopAnimating()
                  //  Activity.isHidden = true
                    let isdept = Vehicaldetails.sharedInstance.IsDepartmentRequire
                    let isPPin = Vehicaldetails.sharedInstance.IsPersonnelPINRequire
                    let isother = Vehicaldetails.sharedInstance.IsOtherRequire
                    
                    if (IsOdoMeterRequire == "True"){

                        print(self.odo)
                        stoptimergotostart.invalidate()
                     //   delay(2){
                            self.stoptimergotostart.invalidate()
                        //self.performSegue(withIdentifier: "odometer", sender: self)
                      //  }
                    }
//                    else
//                    {
//                        if (IsHoursRequire == "True"){
//                            stoptimergotostart.invalidate()
//                            self.performSegue(withIdentifier: "hours", sender: self)
//                        }
//                        else if(IsExtraOther == "True")
//                        {
//                            stoptimergotostart.invalidate()
//                            self.performSegue(withIdentifier: "OtherVehicle", sender: self)
//                        }
//                        else
//                        {
//                            Vehicaldetails.sharedInstance.hours = ""
//                            if(isdept == "True"){
//                                stoptimergotostart.invalidate()
//                                self.performSegue(withIdentifier: "dept", sender: self)
//                            }
//                            else
//                            {
//                                if(isPPin == "True"){
//                                    stoptimergotostart.invalidate()
//                                    self.performSegue(withIdentifier: "pin", sender: self)
//                                }
//                                else
//                                {
//                                    if(isother == "True"){
//                                        stoptimergotostart.invalidate()
//                                        self.performSegue(withIdentifier: "other", sender: self)
//                                    }
//                                    else{
                                        let deptno = ""
                                        let ppin = ""
                                        let other = ""
//                                        Vehicaldetails.sharedInstance.deptno = ""
//                                        Vehicaldetails.sharedInstance.Personalpinno = ""
//                                        Vehicaldetails.sharedInstance.Other = ""
//                                        Vehicaldetails.sharedInstance.Odometerno = "0"
//                                        stoptimergotostart.invalidate()
                                       self.senddata(deptno: deptno,ppin:ppin,other:other)
//                                    }
//                                }
//                            }
//                        }
//                    }
//               }
//                else {
                    
//                    if(ResponceMessage == "fail")
//                    {
////                         delay(1){
//                            self.showAlert(message: "\(ResponceText)" )
//                            self.stoptimergotostart.invalidate()
//                         self.viewWillAppear(true)
//                         self.Activity.stopAnimating()
//                         self.Activity.isHidden = true
//                        }

//                    }
                }
            }
            Vehicaldetails.sharedInstance.Odometerno = odom
        }
//        else if(odo == "True"){
//            stoptimergotostart.invalidate()
////            self.performSegue(withIdentifier: "odometer", sender: self)
//            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//            //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
//        }
    }
//    
//    @IBAction func saveBtntapped(sender: AnyObject) {
//        Activity.startAnimating()
//        Activity.isHidden = false
//        save.isEnabled = false
//        delay(1){
//
//            self.IsGobuttontapped = true
//            self.stoptimergotostart.invalidate()
//            if(self.Vehicleno.text == "")
//            {
//                if(Vehicaldetails.sharedInstance.Language == "es-ES")
//                {
//                    self.showAlert(message: NSLocalizedString("Entervehicelno", comment:"") )
//                }
//                else{
//                    self.showAlert(message:"Please Enter \(Vehicaldetails.sharedInstance.ScreenNameForVehicle) Number" )
//                }
//
//                self.viewWillAppear(true)
//                self.Activity.stopAnimating()
//                self.Activity.isHidden = true
//            }
//            else{
//                if(self.IsScanBarcode == true){}
//                else{
//                self.getodometer()
//                Vehicaldetails.sharedInstance.vehicleno = self.Vehicleno.text!
//                }
//            }
//        }
//    }
//    
    
}
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



    
    
   
   
