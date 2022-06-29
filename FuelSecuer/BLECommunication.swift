////
////  BLECommunication.swift
////  FuelSecure
////
////  Created by apple on 12/07/21.
////  Copyright © 2021 VASP. All rights reserved.
////
//
//import Foundation
//import CoreBluetooth
//import Network
//
////BLE
//
//
//
//class BLECommunication:NSObject
//{
//    let kBLEService_UUID = "4c425346-0000-1000-8000-00805f9b34fb"
//    let kBLE_Characteristic_uuid_Tx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
//    let kBLE_Characteristic_uuid_Rx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
//
//    var txCharacteristic : CBCharacteristic?
//    var rxCharacteristic : CBCharacteristic?
//    var blePeripheral : CBPeripheral?
//    var characteristicASCIIValue = ""
//    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
//    var BLErescount = 0
//    var centralManager: CBCentralManager!
//
//    var myPeripheral: CBPeripheral!
//    var peripheral: CBPeripheral!
//    var RSSIs = [NSNumber]()
//    var data = NSMutableData()
//    var peripherals: [CBPeripheral] = []
//    var countfailBLEConn:Int = 0
//    //var ifSubscribed = false
//    var isdisconnected = false
//    var connectedperipheral = ""
//    var appdisconnects_automatically = false
//    var Last10transaction = ""
//    var web = Webservices()
//    // MARK: - BLE Functions
//    
//  
//    
//    
//   
//    
//    
//    @objc func FDcheckBLE()
//    {
//        var lastcount = ""
//        if(Last_Count == nil){
//            self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
//            self.outgoingData(inputText: "LK_COMM=FD_check")
//            Last_Count = "0"
//            self.web.sentlog(func_name: " Last_Count \(Last_Count!)", errorfromserverorlink:"", errorfromapp: "")
//        }
//        else
//        if(Last_Count == "0.0")
//        {
//            lastcount = Last_Count
//            lastcount = "0"
//        }else
//        {
//            lastcount = Last_Count
//        }
//        
//        print(lastcount)
//        if(lastcount == "")
//        {
//            
//            self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
//            self.outgoingData(inputText: "LK_COMM=FD_check")
//        }else{
//        if (Int(lastcount)! >= 0){
//        
//            self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
//            self.outgoingData(inputText: "LK_COMM=FD_check")
//           
//            //self.AppconnectedtoBLE = true
//           
//        }
//        else
//        {
//            if(iflinkison == false){
//                delay(0.2){
//                    self.web.sentlog(func_name: "Send Ralay On Command to BT link again from FD check function because we not receive quantity in first attempt. LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
//                    self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
//                    self.updateIncomingData()
//                }
//            }
//        }}
//    }
//    
//    
//  func GetPulserBLE(counts:String) {
//        
//        let dateFormatter = DateFormatter()
//        Warning.text = NSLocalizedString("Warningfueling", comment:"")
//        Warning.isHidden = false
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//        let defaultTimeZoneStr = dateFormatter.string(from: Date());
//        
//        print("before GetPulser" + defaultTimeZoneStr)
//   
//        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//        print("before send GetPulser" + defaultTimeZoneStr1)
//        
//        print(characteristicASCIIValue)
//        
//        if(self.counts == " 0" || self.counts == "0")
//        {
//            
//        }
//        else{
//            if (counts == ""){
//                self.emptypulsar_count += 1
//                if(self.emptypulsar_count == 3){
//                    Vehicaldetails.sharedInstance.gohome = true
//                    self.timerview.invalidate()
//                    do
//                    {
//                        try self.stoprelay()
//                    }
//                    catch{}
//                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//                    self.web.sentlog(func_name: "get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                    appDel.start()
//                }
//            }
//            else if (counts == "0")
//            {
//                if(Last_Count == nil){
//                    Last_Count = "0.0"
//                }
//                let v = self.quantity.count
//                self.quantity.append("0")
//                if(v >= 2){
//                    print(self.quantity[v-1],self.quantity[v-2],total_count)
//                    if(self.quantity[v-1] == self.quantity[v-2]){
//                        self.total_count += 1
//                        if(self.total_count == 3){
//                            Ispulsarcountsame = true
//                            stoptimerIspulsarcountsame.invalidate()
//                            Samecount = Last_Count
//                                                                               
//                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//                            
//                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                        }
//                    }
//                }
//            }
//            else
//            {
//                self.emptypulsar_count = 0
//                if (counts != "0"){
//                    
//                    self.start.isHidden = true
//                    self.cancel.isHidden = true
//                    // stoptimerIspulsarcountsame.invalidate()
//                    //transaction Status send only one time.
//                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                    if(reply_server == "")
//                    {
//                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
//                        reply_server = "Sendtransaction"
//                    }
//                    print(self.tpulse.text!, counts)
//                    
//                    if (self.tpulse.text! == (counts as String) as String){
//                        
//                    }
//                    if(Last_Count == nil){
//                        Last_Count = "0.0"
//                    }
//                    if(appdisconnects_automatically == true){
//                        
//                            if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
//                                Ispulsarcountsame = false
//                                stoptimerIspulsarcountsame.invalidate()
//                            }
//                        let pulsedata = defaults.string(forKey: "previouspulsedata")
//                        if((counts as NSString).doubleValue > (pulsedata! as NSString).doubleValue)
//                        {
//                           
//                            self.tpulse.text = "\(counts)"
//                            self.quantity.append("\(y) ")
//                                timer_quantityless_thanprevious.invalidate()
//                           
//                                self.Last_Count = "\(counts)" as String?
//                                let v = self.quantity.count
//                            let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts)!)
//                                let y = Double(round(100*FuelQuan)/100)
//                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                                    let y = Double(round(100*FuelQuan)/100)
//                                    self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                                    print(self.tquantity.text!)
//                                }
//                                else {
//                                    let y = Double(round(100*FuelQuan)/100)
//                                    self.tquantity.text = "\(y) "
//                                }
//
//                                    self.Last_Count = "\(counts)"
//    //                                let v = self.quantity.count
//    //                                let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//    //                                let y = Double(round(100*FuelQuan)/100)
//                                    if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                                        let y = Double(round(100*FuelQuan)/100)
//                                        self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                                        print(self.tquantity.text!)
//                                    }
//                                    else {
//                                        let y = Double(round(100*FuelQuan)/100)
//                                        self.tquantity.text = "\(y) "
//                                    }
//                                    self.tpulse.text = "\(counts)"
//                                    self.quantity.append("\(y) ")
//                               
//                                
//                                print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                                let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                                print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                                if(v >= 2){
//                                    print(self.quantity[v-1],self.quantity[v-2])
//                                    if(self.quantity[v-1] == self.quantity[v-2]){
//                                        self.total_count += 1
//                                        if(self.total_count == 3){
//                                            Ispulsarcountsame = true
//                                            stoptimerIspulsarcountsame.invalidate()
//                                            Samecount = Last_Count
//                                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//                                            
//                                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                        }
//                                    }
//                                    else
//                                    {
//                                        total_count = 0
//                                        if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
//                                        else{
//                                            
//                                            if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
//                                                
//                                                _ = self.web.SetPulser0()
//                                                print(Vehicaldetails.sharedInstance.MinLimit)
//                                                if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
//                                                self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
//                                                }
//                                                //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
//                                                self.stopButtontapped()
//                                            }
//                                        }
//                                    }
//                                }
//                        }
//                        else{
//                        
//                        let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
//                        self.tpulse.text = "\(totalpulsecount)"
//                        self.quantity.append("\(y) ")
//                            timer_quantityless_thanprevious.invalidate()
//                       
//                            self.Last_Count = "\(totalpulsecount)" as String?
//                            let v = self.quantity.count
//                            let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(totalpulsecount))
//                            let y = Double(round(100*FuelQuan)/100)
//                            if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                                let y = Double(round(100*FuelQuan)/100)
//                                self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                                print(self.tquantity.text!)
//                            }
//                            else {
//                                let y = Double(round(100*FuelQuan)/100)
//                                self.tquantity.text = "\(y) "
//                            }
//
//                                self.Last_Count = "\(totalpulsecount)"
////                                let v = self.quantity.count
////                                let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
////                                let y = Double(round(100*FuelQuan)/100)
//                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                                    let y = Double(round(100*FuelQuan)/100)
//                                    self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                                    print(self.tquantity.text!)
//                                }
//                                else {
//                                    let y = Double(round(100*FuelQuan)/100)
//                                    self.tquantity.text = "\(y) "
//                                }
//                                self.tpulse.text = "\(totalpulsecount)"
//                                self.quantity.append("\(y) ")
//                           
//                            
//                            print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                            let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                            print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                            if(v >= 2){
//                                print(self.quantity[v-1],self.quantity[v-2])
//                                if(self.quantity[v-1] == self.quantity[v-2]){
//                                    self.total_count += 1
//                                    if(self.total_count == 3){
//                                        Ispulsarcountsame = true
//                                        stoptimerIspulsarcountsame.invalidate()
//                                        Samecount = Last_Count
//                                        self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//                                        
//                                        self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                    }
//                                }
//                                else
//                                {
//                                    total_count = 0
//                                    if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
//                                    else{
//                                        
//                                        if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
//                                            
//                                            _ = self.web.SetPulser0()
//                                            print(Vehicaldetails.sharedInstance.MinLimit)
//                                            if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
//                                            self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
//                                            }
//                                            //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
//                                            self.stopButtontapped()
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    else{
//                    
//                    if((counts as NSString).doubleValue >= (Last_Count as NSString).doubleValue)
//                    {
//                        if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
//                            Ispulsarcountsame = false
//                            stoptimerIspulsarcountsame.invalidate()
//                        }
//                        timer_quantityless_thanprevious.invalidate()
//                        self.Last_Count = counts as String?
//                        let v = self.quantity.count
//                        let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                        let y = Double(round(100*FuelQuan)/100)
//                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                            let y = Double(round(100*FuelQuan)/100)
//                            self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                            print(self.tquantity.text!)
//                        }
//                        else {
//                            let y = Double(round(100*FuelQuan)/100)
//                            self.tquantity.text = "\(y) "
//                        }
//                          
//                            self.tpulse.text = (counts as String) as String
//                            self.quantity.append("\(y) ")
//                        defaults.set(counts, forKey: "previouspulsedata")
//                    
//                        print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                        print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                        if(v >= 2){
//                            print(self.quantity[v-1],self.quantity[v-2])
//                            if(self.quantity[v-1] == self.quantity[v-2]){
//                                self.total_count += 1
//                                if(self.total_count == 3){
//                                    Ispulsarcountsame = true
//                                    stoptimerIspulsarcountsame.invalidate()
//                                    Samecount = Last_Count
//                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//                                    
//                                    self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                }
//                            }
//                            else
//                            {
//                                total_count = 0
//                                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
//                                else{
//                                    
//                                    if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
//                                        
//                                        _ = self.web.SetPulser0()
//                                        print(Vehicaldetails.sharedInstance.MinLimit)
//                                        if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
//                                        self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
//                                        }
//                                        //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
//                                        self.stopButtontapped()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        timer_quantityless_thanprevious.invalidate()
//                        timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
//                        self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
//                        print("lower qty. than the prior one.")
//                    }
//                }
//                }
//                else{
//                    if(Last_Count == nil){
//                        Last_Count = "0.0"
//                    }
//                    let v = self.quantity.count
//                    let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                    let y = Double(round(100*FuelQuan)/100)
//                    
//                    self.quantity.append("\(y) ")
//                    
//                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                    let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                    print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                    if(v >= 2){
//                        if(self.self.quantity[v-1] == self.quantity[v-2]){
//                            self.total_count += 1
//                            if(self.total_count == 3){
//                                Ispulsarcountsame = true
//                                Samecount = Last_Count
//                                stoptimerIspulsarcountsame.invalidate()
//                                
//                                self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                
//                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func startScan() {
//        self.web.sentlog(func_name: "Start BT Scan...for \(kBLEService_UUID)", errorfromserverorlink:"", errorfromapp: "\(peripherals)")
//        self.peripherals = []
//        let BLEService_UUID = CBUUID(string: kBLEService_UUID)
//        print("Now Scanning...")
//        self.timer.invalidate()
//        centralManager?.scanForPeripherals(withServices: [BLEService_UUID] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
//       
//        Timer.scheduledTimer(withTimeInterval: 8, repeats: false) {_ in
//            self.web.sentlog(func_name: "Scan Stopped...", errorfromserverorlink:"", errorfromapp: "\(self.peripherals)")
//            self.cancelScan()
//            
//        }
//    }
//    
//    /*We also need to stop scanning at some point so we'll also create a function that calls "stopScan"*/
//    func cancelScan() {
//        self.centralManager?.stopScan()
//  
//        self.web.sentlog(func_name: "Scan Stopped", errorfromserverorlink: "Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(peripherals)")
//        if (peripherals.count == 0){
//            if(IsStartbuttontapped == true){}
//            else{
//                self.countfailBLEConn = self.countfailBLEConn + 1
//                if (self.countfailBLEConn == 3){
//                    
//                    self.web.sentlog(func_name: "App Not able to Connect and Subscribed peripheral Connection. Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
//                    Vehicaldetails.sharedInstance.HubLinkCommunication = "UDP"
//                    self.performSegue(withIdentifier: "GoUDP", sender: self)
//               
//                }
//                else{
//                    if(self.ifSubscribed == true){}
//                    else{
//                        self.web.sentlog(func_name: "Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
//                        self.startScan()
//                    }
//                }
//                displaytime.text = "BT link not found. please try again later."
//                // AppconnectedtoBLE = false
//                cancel.isHidden = false
//            }
//        }
//        else
//        {
//            if(peripherals.count == 0)
//            {
//                print(peripherals,peripherals.count)
//            }
//            else{
//                print(peripherals,peripherals.count)
//                for i in 0  ..< peripherals.count
//                {
//                    print(peripherals,peripherals.count)
//                    if(peripherals.count == 0)
//                    {
//                        print(peripherals,peripherals.count)
//                    }
//                    else{
//                        let peripheral = self.peripherals[i]
//                      
//                        if( Vehicaldetails.sharedInstance.SSId == peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines))
//                        {
//                            blePeripheral = self.peripherals[i]
//                            connectedperipheral = (blePeripheral?.name)!
//                            connectToDevice()
//                            
//                            break
//                        }
//                    }
//                }
//                if(self.connectedperipheral == "")
//                {
//                    if(IsStartbuttontapped == true){}
//                    else{
//                        self.countfailBLEConn = self.countfailBLEConn + 1
//                        
//                        self.web.sentlog(func_name: "Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
//                        
//                        if (self.countfailBLEConn == 5){
//                            
//                            self.web.sentlog(func_name: "App Not able to Connect BT Link and Subscribed peripheral Connection. Attempt  \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
//                            
//                            self.web.sentlog(func_name: "App Switches BT to UDP...", errorfromserverorlink: "", errorfromapp: "")
//                            self.performSegue(withIdentifier: "GoUDP", sender: self)
//                       
//                        }
//                        else{
//                            if(self.ifSubscribed == true){}
//                            else{
//                                self.web.sentlog(func_name: "Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
//                                self.startScan()
//                            }
//                        }
//                    }
//                }
//                self.viewDidAppear(true)
//            }
//        }
//    }
//    
//    /*
//     Called when the central manager discovers a peripheral while scanning. Also, once peripheral is connected, cancel scanning.
//     */
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        
//        blePeripheral = peripheral
//        self.peripherals.append(peripheral)
//        self.RSSIs.append(RSSI)
//        peripheral.delegate = self
//        //self.baseTableView.reloadData()
//        if blePeripheral == nil {
//            print("Found new pheripheral devices with services")
//            print("Peripheral name: \(String(describing: peripheral.name))")
//            print("**********************************")
//            print ("Advertisement Data : \(advertisementData)")
//        }
//  
//        print(Vehicaldetails.sharedInstance.SSId, peripheral.name!)
//    }
//    
//    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//       
//        if central.state == CBManagerState.poweredOn {
//            print("BLE powered on")
//            // Turned on
//            startScan()
//            //central.scanForPeripherals(withServices: [CBUUID(string: "000000ff-0000-1000-8000-00805f9b34fb")], options: nil)
//        }
//        else {
//            print("Something wrong with BLE")
//            // Not on, but can have different issues
//        }
//    }
//    
//    
//    /*
//     Invoked when a connection is successfully created with a peripheral.
//     This method is invoked when a call to connect(_:options:) is successful. You typically implement this method to set the peripheral’s delegate and to discover its services.
//     */
//    //-Connected
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        //let BLEService_UUID = CBUUID(string: kBLEService_UUID)
//        print("*****************************")
//        print("Connection complete")
//        print("Peripheral info: \(String(describing: blePeripheral))")
//        
//        //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
//        centralManager?.stopScan()
//        print("Scan Stopped")
//        
//        //Erase data that we might have
//        data.length = 0
//        
//        //Discovery callback
//        peripheral.delegate = self
//        //Only look for services that matches transmit uuid
//        peripheral.discoverServices([CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b6")])
//        
//        //Once connected, move to new view controller to manager incoming and outgoing data
//        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        //           let uartViewController = storyboard.instantiateViewController(withIdentifier: "UartModuleViewController") as! FuelquantityVC
//        //
//        //           uartViewController.peripheral = peripheral
//        //
//        //           navigationController?.pushViewController(uartViewController, animated: true)
//    }
//    
//    /*
//     Invoked when you discover the peripheral’s available services.
//     This method is invoked when your app calls the discoverServices(_:) method. If the services of the peripheral are successfully discovered, you can access them through the peripheral’s services property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
//     */
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        print("*******************************************************")
//        
//        if ((error) != nil) {
//            print("Error discovering services: \(error!.localizedDescription)")
//            return
//        }
//        
//        guard let services = peripheral.services else {
//            return
//        }
//        //We need to discover the all characteristic
//        print(services)
//        for service in services {
//            
//            peripheral.discoverCharacteristics(nil, for: service)
//            // bleService = service
//            print(service)
//        }
//        print("Discovered Services: \(services)")
//    }
//    
//    /*
//     Invoked when you discover the characteristics of a specified service.
//     This method is invoked when your app calls the discoverCharacteristics(_:for:) method. If the characteristics of the specified service are successfully discovered, you can access them through the service's characteristics property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
//     */
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        
//        print("*******************************************************")
//        
//        if ((error) != nil) {
//            print("Error discovering services: \(error!.localizedDescription)")
//            return
//        }
//        
//        guard let characteristics = service.characteristics else {
//            return
//        }
//        
//        print("Found \(characteristics.count) characteristics!")
//        
//        for characteristic in characteristics {
//            //looks for the right characteristic
//            
//            if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Rx))  {
//                rxCharacteristic = characteristic
//                
//                //Once found, subscribe to the this particular characteristic...
//                peripheral.setNotifyValue(true, for: rxCharacteristic!)
//                
//                // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
//                // didUpdateNotificationStateForCharacteristic method will be called automatically
//                peripheral.readValue(for: characteristic)
//                print("Rx Characteristic: \(characteristic.uuid)")
//            }
//            if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Tx)){
//                txCharacteristic = characteristic
//                print("Tx Characteristic: \(characteristic.uuid)")
//            }
//            peripheral.discoverDescriptors(for: characteristic)
//        }
//    }
//    
//    // MARK: - Getting Values From Characteristic
//    
//    /** After you've found a characteristic of a service that you are interested in, you can read the characteristic's value by calling the peripheral "readValueForCharacteristic" method within the "didDiscoverCharacteristicsFor service" delegate.
//     */
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard characteristic == rxCharacteristic,
//              let characteristicValue = characteristic.value,
//              let ASCIIstring = NSString(data: characteristicValue,
//                                         encoding: String.Encoding.utf8.rawValue)
//        else { return }
//        
//        characteristicASCIIValue = ASCIIstring as String
//        if((characteristicASCIIValue as String).contains("L10:"))
//        {
//            Last10transaction = (characteristicASCIIValue as String)
//            self.web.sentlog(func_name: " Get response from info command to link \(characteristicASCIIValue)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//        }
//        print("Value Recieved: \((characteristicASCIIValue as String))")
//        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
//    
//    }
//    
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        print("*******************************************************")
//        
//        if error != nil {
//            print("\(error.debugDescription)")
//            return
//        }
//        guard let descriptors = characteristic.descriptors else { return }
//        
//        descriptors.forEach { descript in
//            print("function name: DidDiscoverDescriptorForChar \(String(describing: descript.description))")
//            print("Rx Value \(String(describing: rxCharacteristic?.value))")
//            print("Tx Value \(String(describing: txCharacteristic?.value))")
//            //if it is subscribed the Notification has begun for: E49227E8-659F-4D7E-8E23-8C6EEA5B9173
//        }
//    }
//    
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        print("*******************************************************")
//        
//        if (error != nil) {
//            print("Error changing notification state:\(String(describing: error?.localizedDescription))")
//            ifSubscribed = false
//            
//        } else {
//            print("Characteristic's value subscribed")
//        }
//        
//        if (characteristic.isNotifying) {
//            ifSubscribed = true
//            print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
//        }
//        else
//        {
//            ifSubscribed = false
//        }
//    }
//    
//    
//    
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        if(self.IsStopbuttontappedBLE == false){
//            FDcheckBLEtimer.invalidate()
//            appdisconnects_automatically = true
//            self.connectToDevice()
//            delay(0.2){
//                self.viewDidAppear(true)
//            }
//            
//        }
//        else if(self.IsStopbuttontappedBLE == true)
//        {
//        print("Disconnected")
//        self.web.sentlog(func_name: "Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp:"\(error)")
//        if(Last_Count == nil){
//            Last_Count = "0"
//            self.web.sentlog(func_name: " Last_Count \(Last_Count!) Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
//        }
//        
//        if(Last_Count! == "0"){
//            self.connectToDevice()
//        }
//        else{
//            if (IsStopbuttontapped == true)
//            {
//                if(Last_Count! == "0.0"){
//                    do{
//                        try self.stoprelay()
//                        isdisconnected = true
//                    }
//                    catch let error as NSError {
//                        print ("Error: \(error.domain)")
//                    }
//                    isdisconnected = true
//                   // disconnectFromDevice()
//                }
//                else{
//                    disconnectFromDevice()
//                }
//            }
//            }
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        if error != nil {
//            print("Failed to connect to peripheral")
//            return
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard error == nil else {
//            print("Error discovering services: error \(error)")
//            return
//        }
//        print("Message sent")
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
//        guard error == nil else {
//            print("Error discovering services: error")
//            return
//        }
//        print("Succeeded!")
//    }
//    
//    //-Terminate all Peripheral Connection
//    /*
//     Call this when things either go wrong, or you're done with the connection.
//     This cancels any subscriptions if there are any, or straight disconnects if not.
//     (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
//     */
//    func disconnectFromDevice() {
//        if blePeripheral != nil {
//            //self.web.sentlog(func_name: "disconnectFromDevice \(rxCharacteristic!),\(blePeripheral!)", errorfromserverorlink: "", errorfromapp:"")
//            // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
//            // Therefore, we will just disconnect from the peripheral
//            // print(rxCharacteristic!)
//            print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
//            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
//            {
//                self.displaytime.text = ""//NSLocalizedString("MessageFueling", comment:"")
//                    if(self.AppconnectedtoBLE == true)
//                {
//                    let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
//                        self.renamelink(SSID:trimmedString)
//                        _ = self.web.SetHoseNameReplacedFlag()
//                }
//                self.isdisconnected = true
//            }
//            self.cf.delay(0.2){
//                if(self.rxCharacteristic == nil){}
//            else{
//                self.blePeripheral!.setNotifyValue(false, for: self.rxCharacteristic!)
//                
//            }
//        
//                self.centralManager.cancelPeripheralConnection(self.blePeripheral!)
//                self.centralManager.cancelPeripheralConnection(self.blePeripheral!)
//                self.isdisconnected = true
//            }
//            
//            self.web.sentlog(func_name: "disconnectFromDevice \(rxCharacteristic),\(blePeripheral)", errorfromserverorlink: "", errorfromapp:"")
//            print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
//            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
//            {
//                self.isdisconnected = true
//                cf.delay(1)
//                {
//                    self.centralManager = CBCentralManager(delegate: self, queue: nil)
//                //centralManager?.connect(blePeripheral!, options: nil)
//                self.start.isEnabled = false
//                self.start.isHidden = true
//                self.cancel.isHidden = true
//                //self.Pwait.isHidden = false
//                    self.UsageInfoview.isHidden = true
//                }
//
//
//                    cf.delay(2){
//                 if self.blePeripheral != nil {
//                        // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
//                        // Therefore, we will just disconnect from the peripheral
//                        self.blePeripheral!.setNotifyValue(false, for: self.rxCharacteristic!)
//                        self.centralManager?.cancelPeripheralConnection(self.blePeripheral!)
//                    self.UsageInfoview.isHidden = false
//                    self.isdisconnected = true
//                    print("disconnected")
//                    }
//                self.cf.delay(10){
//                    do{
//                        self.isdisconnected = true
//                        
//                        try self.stoprelay()
//                        //self.isdisconnected = true
//                       
//                    }
//
//                    catch let error as NSError {
//                        print ("Error: \(error.domain)")
//                    }
//                    
//                }
////
//                    }
////
////
////
//            }
//            else
//            {
//                do{
//                    
//                    try self.stoprelay()
//                    isdisconnected = true
//                }
//                catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                }
//            }
//        }
//    }
//    
//    //Peripheral Connections: Connecting, Connected, Disconnected
//    
//    //-Connection
//    func connectToDevice() {
//        self.web.sentlog(func_name: "connect To BT link Device \(blePeripheral!)", errorfromserverorlink:"", errorfromapp: "")
//        if(blePeripheral == nil)
//        {}
//        else{
//            centralManager?.connect(blePeripheral!, options: nil)
//        }
//    }
//    
//    // MARK: - write the data
//    // Write functions
//    func writeValue(data: String){
//        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
//        //change the "data" to valueString
//        if let blePeripheral = blePeripheral{
//            if let txCharacteristic = txCharacteristic
//            {
//                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
//            }
//        }
//    }
//    
//    func writeCharacteristic(val: Int8){
//        var val = val
//        let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
//        blePeripheral!.writeValue(ns as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withResponse)
//    }
//    
//    
//    func outgoingData (inputText:String) {
//        let appendString = "\n"
//        
//        let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
//        let myAttributes1 = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.blue]
//        
//        writeValue(data: inputText)
//        
//        let attribString = NSAttributedString(string: "[Outgoing]: " + inputText + appendString, attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributes1))
//        let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
//        newAsciiText.append(attribString)
//        consoleAsciiText = newAsciiText
//    }
//    
//    
//    func updateIncomingData() {
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){ [self]
//            notification in
//            let appendString = "\n"
//            
//            let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
//            let myAttributes2 = [self.convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, self.convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.red]
//            let attribString = NSAttributedString(string: "[Incoming]: " + (self.characteristicASCIIValue as String) + appendString, attributes: self.convertToOptionalNSAttributedStringKeyDictionary(myAttributes2))
//            let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
//            
//            newAsciiText.append(attribString)
//            
//            self.consoleAsciiText = newAsciiText
//            
//                                   
//            let Split = self.characteristicASCIIValue.components(separatedBy: ":")
//            if(Split.count == 2){
//                let reply1 = Split[0]
//                let count = Split[1]
//                let dc = count.trimmingCharacters(in: .whitespaces)
//                let datacount =  Int(dc as String)!
//                
//                if(reply1 == "pulse" ){
//                    print("\(characteristicASCIIValue)")
//                    self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
//                    
//                    self.GetPulserBLE(counts:"\(datacount)")
//                    
//                    self.displaytime.text = ""
//                    
//                }
//                
//                else if(self.characteristicASCIIValue == "pulse: 0")
//                {
//                }
//            }
//            print(self.characteristicASCIIValue)
//            
//            if(self.characteristicASCIIValue == "ON")
//            {
//                iflinkison = true
//            }
//            if(characteristicASCIIValue == "HO")
//            {
//                self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
//                Count_Fdcheck = 0
//            }
//            else if(characteristicASCIIValue == "DN")
//            {
//                self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
//                gotostartBLE_resDN()
//            }
//            else if(characteristicASCIIValue == "")
//            {
//                 self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
//                delay(1){
//                    Count_Fdcheck = Count_Fdcheck + 1
//                }
//                if(Count_Fdcheck == 3)
//                {
//                    gotostartBLE()
//                    
//                }
//            }
//            
//            if(self.characteristicASCIIValue == "OFF")
//            {
//                if (isdisconnected == true){}
//                else{
//                    self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
//                    IsStopbuttontapped = true
//                    self.disconnectFromDevice()
//                    
//                }
//            }
//        }
//    }
//    
//    // Helper function inserted by Swift 4.2 migrator.
//    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
//        return input.rawValue
//    }
//    
//    // Helper function inserted by Swift 4.2 migrator.
//    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
//        guard let input = input else { return nil }
//        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
//    }
//    
//    func getBLEinfo()
//    {
//        outgoingData(inputText: "LK_COMM=info")
//        self.web.sentlog(func_name: " Send info command to link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//        AppconnectedtoBLE = true
//    }
//    
//
//    }
//
