//
//  FuelquantityVCUDP.swift
//  FuelSecure
//
//  Created by apple on 06/01/21.
//  Copyright © 2021 VASP. All rights reserved.

import UIKit
//import SystemConfiguration.CaptiveNetwork
import Foundation
import CoreLocation
//import CoreBluetooth
import Network



@available(iOS 12.0, *)
class FuelquantityVCUDP: UIViewController,StreamDelegate,UITextFieldDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate
{
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL)
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath + ("/filebin"))
        
        if fileManager.fileExists(atPath: destinationURLForFile.path!){
            showFileWithPath(path: destinationURLForFile.path!)
        }
        else{
            do {
                try fileManager.moveItem(at: location as URL, to: destinationURLForFile as URL)
                // show file
                showFileWithPath(path: destinationURLForFile.path!)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }

    
    var cf = Commanfunction()
    var web = Webservices()
        
    
    var IsStartbuttontapped : Bool = false
    var IsStopbuttontapped:Bool = false
    var Ispulsarcountsame :Bool = false
    var Cancel_Button_tapped :Bool = false
    var stopdelaytime:Bool = false
    
    var sysdata:NSDictionary!
    
    var quantity = [String]()
    var counts:String!
    var reply_server:String = ""

    var timerFDCheck:Timer = Timer()
    var timer:Timer = Timer()    // #selector(self.GetPulser) call the Getpulsar function.
    var timerview:Timer = Timer()  // #selector(ViewController.viewDidAppear(_:)) call viewController timerview
    var isUDPConnectstoptimer:Timer = Timer()  // Add timer to send UDP Connection function after connect the Link. and stops time after get the valid output.
    var stoptimergotostart:Timer = Timer() ///#selector(call gotostart function)
    var stoptimer_gotostart:Timer = Timer() ///#selector(gotostart from viewWillapeared)
    var stoptimerIspulsarcountsame:Timer = Timer()  ///call stopIspulsarcountsame for
    // var timer_noConnection_withlink = Timer()
    var timer_quantityless_thanprevious = Timer()  ///#selector(FuelquantityVC.stoprelay) to stop the app
    
    var y :CGFloat = CGFloat()
    
    var fuelquantity:Double!
   
    
    var string:String = ""
    
    var emptypulsar_count:Int = 0
    var total_count:Int = 0
    var Last_Count:String!
    var Samecount:String!
    var renameconnectedwifi:Bool = false
    var connectedwifi:String!
    var InterruptedTransactionFlag = true
    var showstart = ""
    var countfailConn:Int = 0
    var countfailUDPConn:Int = 0
    
    //    UDP
    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host = "192.168.4.1"
    var portUDP: NWEndpoint.Port = 8080
   
    var backToString = ""
    var pulsedata = ""
    var IFUDPConnectedGetinfo = false
    var IFUDPSendtxtid = false
    var IFUDPConnected = false
    var Last10transaction = ""
    
    private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    let defaults = UserDefaults.standard
    //Mark IBOutlets
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var start: UIButton!
    @IBOutlet var Stop: UIButton!
    @IBOutlet var Odometer: UILabel!
    @IBOutlet var vehicleno: UILabel!
    @IBOutlet var displaytime: UILabel!
    @IBOutlet var CQ: UILabel!
    @IBOutlet var FQ: UILabel!
    @IBOutlet var UsageInfoview: UIView!
    @IBOutlet var totalquantityinfo: UILabel!
    @IBOutlet var Quantity1: UILabel!
    @IBOutlet var pulse: UILabel!
    @IBOutlet var Warning: UILabel!
    @IBOutlet var Pwait: UILabel!
    @IBOutlet var waitactivity: UIActivityIndicatorView!
    @IBOutlet var lable: UILabel!
    @IBOutlet var tpulse: UILabel!
    @IBOutlet var tquantity: UILabel!
    @IBOutlet var wait: UILabel!
    @IBOutlet var Activity: UIActivityIndicatorView!
    @IBOutlet var OKWait: UILabel!
    @IBOutlet var dataview: UIView!
    @IBOutlet weak var ConnectUDP: UIButton!
    
    
    ///view did Appear every time we visit this page and we see this page below fuction is called.
    override func viewDidAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        self.timerview.invalidate()
        scrollview.isHidden = false
        OKWait.isHidden = true
        self.timerview.invalidate()
        self.web.sentlog(func_name:" In viewDidAapear", errorfromserverorlink: "", errorfromapp: "")
    
            self.displaytime.text = NSLocalizedString("MessageFueling1" , comment:"")
            
            self.start.isEnabled = false
            self.start.isHidden = true
            self.cancel.isHidden = true
            
        cf.delay(0.5){
                self.Activity.hidesWhenStopped = true;
                //                print(Vehicaldetails.sharedInstance.SSId,self.cf.getSSID())
                if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
                    Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
                }
                
                if(self.IFUDPConnected == true)
                {
                    if(self.IFUDPConnectedGetinfo == true){
                        
                    self.start.isEnabled = true
                    self.start.isHidden = false
                    self.cancel.isHidden = false
                    self.ConnectUDP.isHidden = true
                    // self.Pwait.isHidden = true
                    self.Activity.stopAnimating()
                    self.timerview.invalidate()
                    self.stoptimergotostart.invalidate()
                    self.isUDPConnectstoptimer.invalidate()
                   
                        if(self.IFUDPSendtxtid == false)
                        {
                            self.IFUDPSendtxtid = true
                    let messageToUDP = "LK_COMM=txtnid:\(Vehicaldetails.sharedInstance.TransactionId)"
                    self.sendUDP(messageToUDP)
                    self.web.sentlog(func_name: " Send Transaction id to link \(messageToUDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                    //let responseudpdata = self.receiveUDP()
                            self.receiveUDP()
                            
                    self.web.sentlog(func_name: "stoptimer gotostart starts, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "Connetced link \( self.cf.getSSID())")
                        }
                    self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                    }
                }
                else
                if(self.IFUDPConnected == false)
                {
                    self.start.isEnabled = false
                    self.start.isHidden = true
                    self.cancel.isHidden = true
                    self.displaytime.text =  NSLocalizedString("MessageFueling1", comment:"")
                    print("return  false  by info command")
                }
            }
        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
        {
            if(self.IFUDPConnected == false){
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                {
                    if(IFUDPConnected == true){}
                    else{
                        self.web.sentlog(func_name:" Send Command to UDP Link from viewDidAapear", errorfromserverorlink: "", errorfromapp: "")
                    connectToUDP(hostUDP,portUDP)
                    }
                }
            }
        }
    }
    
    
    @objc func gotostart(){
        //isgotostartcalled = true
        self.timerview.invalidate()
        self.stoptimergotostart.invalidate()
        self.stoptimer_gotostart.invalidate()
        self.timerview.invalidate()
        if(Cancel_Button_tapped == true)
        {
            self.web.sentlog(func_name:" Go to start cancel_botto tapped", errorfromserverorlink: "", errorfromapp: "")
        }
        else{
            if(IsStartbuttontapped == true){}  /// Is Start button tapped is true then do nothing
            else {
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                {
                    if(self.showstart == "true") {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")//did not press start (start appeared, was never pressed):  User did not Press Start
                    }
                    else if(self.showstart == "false")
                    {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                    }
                }
                else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                {
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
//                   // potentialfix()
                }
                
                self.web.sentlog(func_name:" Fueling_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
                self.connection?.cancel()
                self.stoptimerIspulsarcountsame.invalidate()
                self.timerview.invalidate()
                self.timer.invalidate()
               
                self.timerFDCheck.invalidate()
                self.timer_quantityless_thanprevious.invalidate()
                self.stoptimergotostart.invalidate()
                self.stoptimer_gotostart.invalidate()
                self.isUDPConnectstoptimer.invalidate()
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        print(Vehicaldetails.sharedInstance.PulseRatio)
        UIApplication.shared.isIdleTimerDisabled = true
        stoptimer_gotostart.invalidate()
        stoptimergotostart.invalidate()
        self.timerview.invalidate()
        //if user goes to the back ground and then come into the foreground and do nothing for 60 sec then it go to home screen
        stoptimer_gotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(FuelquantityVCUDP.gotostart), userInfo: nil, repeats: false)
        
        start.isEnabled = false
        start.isHidden = true
        
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
    
        
        Warning.isHidden = true
        self.timerview.invalidate()
    }
    
    
    func isUDPConnocted(funcname:String)
    {
        self.web.sentlog(func_name:" Connect UDP Link \(funcname)", errorfromserverorlink: "", errorfromapp: "")
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        {
            web.wifi_settings_check(pagename: "UDP")
            self.web.sentlog(func_name:" Connect UDP Link ", errorfromserverorlink: "", errorfromapp: "")
           
            delay(5)
            {
                self.viewDidAppear(true)
                self.web.sentlog(func_name:" is UDP Connocted viewDidAppear ", errorfromserverorlink: "", errorfromapp: "")
            }
        }
        else if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
        {
            self.web.sentlog(func_name:" Connected to UDP Link \(funcname)", errorfromserverorlink: "", errorfromapp: "")
            self.viewDidAppear(true)
        }
    }

   
    override func viewDidLoad() {
        self.Activity.startAnimating()
        stoptimergotostart.invalidate()
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "ConnectUDP"), object: self)
            let isConnect =  web.wifi_settings_check(pagename: "UDP")
            
            self.web.sentlog(func_name:" Connect UDP Link \(isConnect)", errorfromserverorlink: "", errorfromapp: "")
            print(isConnect)
            self.isUDPConnectstoptimer.invalidate()
            
            self.isUDPConnectstoptimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(connectUDPlink), userInfo: nil, repeats: true)
        }
        
        //isUDPConnocted(funcname: "ViewDidLoad1")
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        self.wait.isHidden = true
        self.waitactivity.isHidden = true
        self.UsageInfoview.isHidden = true
        self.Pwait.isHidden = true
        self.ConnectUDP.isHidden = true
        
        self.connectedwifi = Vehicaldetails.sharedInstance.SSId
        self.FQ.isHidden = false
        self.Stop.isHidden = true
        self.cancel.isHidden = false
        //  getdatafromsetting = true
        self.start.isEnabled = false
        self.start.isHidden = true
        self.Odometer.text = "\(Vehicaldetails.sharedInstance.Odometerno)"
        self.vehicleno.text = "\(Vehicaldetails.sharedInstance.vehicleno)"
        
        self.web.sentlog(func_name: " Communication Method Type \(Vehicaldetails.sharedInstance.HubLinkCommunication)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID()) ")
    }
    
       
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savetrans(lastpulsarcount:String,lasttransID:String){
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        let fuelquantity = (Double(lastpulsarcount))!/(PulseRatio as NSString).doubleValue
        if(fuelquantity == 0.0 || lasttransID == "-1"){}
        else{
            let bodyData = "{\"TransactionId\":\(lasttransID),\"FuelQuantity\":\((fuelquantity)),\"Pulses\":\"\(lastpulsarcount)\",\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"Transaction\":\"LastTransaction\"}"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            let unsycnfileName =  dtt1 + "#" + "transaction" + "#" + "lasttransID" + "#" + Vehicaldetails.sharedInstance.SSId
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
                self.web.sentlog(func_name:" Saved Last Transaction to Phone, Date\(dtt1) TransactionId:\(lasttransID),FuelQuantity:\((fuelquantity)),Pulses:\(lastpulsarcount)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
            }
        }
    }
    
   
    func Startfueling()
    {
        self.btnBeginFueling()
    }
    
    

    @IBAction func startButtontapped(sender: AnyObject) {
       
        if(Cancel_Button_tapped == true){}
        else{
            //Start the fueling with buttontapped
            self.displaytime.text = ""
            start.isEnabled = false
            IsStartbuttontapped = true
            stoptimergotostart.invalidate()
            self.stoptimer_gotostart.invalidate()
            self.timerview.invalidate()
            self.ConnectUDP.isHidden = true
            Vehicaldetails.sharedInstance.pulsarCount = ""
            
            let messageToUDP = "LK_COMM=relay:12345=ON"
            self.web.sentlog(func_name: " Send Relay On Command to link \(messageToUDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
            sendUDP(messageToUDP)
            self.receiveUDP()
            
            self.cf.delay(1){
                
                self.start.isHidden = true
                self.cancel.isHidden = true
                self.Stop.isHidden = false
//                self.displaytime.text = NSLocalizedString("Fueling", comment:"")
            }
            
            getlast10transaction()
            self.btnBeginFueling()
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.timerview.invalidate()
        Cancel_Button_tapped = true
        if(IsStartbuttontapped == true){}
        else{
           
            let alert = UIAlertController(title: "Confirm", message: NSLocalizedString("Cancelwarning", comment:""), preferredStyle: UIAlertController.Style.alert)
            let backView = alert.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.white
            var messageMutableString = NSMutableAttributedString()
            messageMutableString = NSMutableAttributedString(string: NSLocalizedString("Cancelwarning", comment:"") as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
            // messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:NSLocalizedString("Cancelwarning", comment:"").count))
            alert.setValue(messageMutableString, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertAction.Style.default) { action in
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                // Call a method on the CustomController property of the AppDelegate
                self.cf.delay(0.5) {
                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                    {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")//did not press start (start appeared, was never pressed):  User did not Press Start
                        
                    }
                    else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                    {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
//                        self.potentialfix()
                    }
                    // put the delayed action/function here
                    let systemVersion = UIDevice.current.systemVersion
                    print("iOS\(systemVersion)")
                    
                    //iPhone or iPad
                    let model = UIDevice.current.model
                    
                    print("device type=\(model)")
                    self.web.sentlog(func_name: " CancelButtonTapped", errorfromserverorlink: "", errorfromapp: "")
                    appDel.start()
                    self.Activity.style = UIActivityIndicatorView.Style.gray;
                    self.Activity.startAnimating()
                    self.stoptimerIspulsarcountsame.invalidate()
                    self.timerview.invalidate()
                    self.timer.invalidate()
                    self.timerFDCheck.invalidate()
                    self.timer_quantityless_thanprevious.invalidate()
                    self.stoptimergotostart.invalidate()
                    self.stoptimer_gotostart.invalidate()
                    self.isUDPConnectstoptimer.invalidate()
                }
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment:""), style: UIAlertAction.Style.cancel) { (submitn) -> Void in
                self.Cancel_Button_tapped = false
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func error400(message: String)
    {
        self.timerview.invalidate()
        
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        {
            if(Last_Count == "0.0" || Last_Count == nil){
                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
//                potentialfix()
            }
        }
        
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
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            
            self.cf.delay(1){
               
                Vehicaldetails.sharedInstance.gohome = true
                self.IsStartbuttontapped = true
                self.stoptimerIspulsarcountsame.invalidate()
                self.timerview.invalidate()
                self.timer.invalidate()
                self.timerFDCheck.invalidate()
                self.timer_quantityless_thanprevious.invalidate()
                self.stoptimergotostart.invalidate()
                self.stoptimer_gotostart.invalidate()
                self.isUDPConnectstoptimer.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                self.web.sentlog(func_name:" error400 Message ", errorfromserverorlink: "", errorfromapp: message)
                appDel.start()
                self.connection?.cancel()
                self.stopdelaytime = true
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
  
    @objc func stopButtontapped()
    {
        //self.receiveUDP()
        
        let MessageuDP = "LK_COMM=relay:12345=OFF"
            self.sendUDP(MessageuDP)
        self.web.sentlog(func_name: " Send Relay OFF Command to link \(MessageuDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
            self.receiveUDP()
       
            Stop.isEnabled = false
            Stop.isHidden = true
            wait.isHidden = false
            waitactivity.isHidden = false
            waitactivity.startAnimating()
            self.timer.invalidate()
        self.timerFDCheck.invalidate()
            self.timerview.invalidate()
            self.stoptimerIspulsarcountsame.invalidate()
            
            if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true")
            {
                Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
            }
            print("stopButtontapped" + cf.dateUpdated)
            string = ""
            
            self.timer.invalidate()
        self.timerFDCheck.invalidate()
            self.timerview.invalidate()
            if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.web.sentlog(func_name:" StopButtontapped lost Wifi connection with the link ",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                
                self.timerview.invalidate()
                do{
                    try self.stoprelay()
                }
                catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.web.sentlog(func_name:" stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                }
            }else {
                
                print("Before relayoff 0" + self.cf.dateUpdated)
                
                if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                {
                    self.web.sentlog(func_name:" StopButtontapped lost Wifi connection with the link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                    
                    self.timerview.invalidate()
                    //  self.stoprelay()
                    do{
                        try self.stoprelay()
                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                        self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                    }
                }else {
                    
                    do{
                        try self.stoprelay()
                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                        self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                    }
                }
           }
      }

    
    
    func SenddataTransaction(quantitycount:String,PulseRatio:String){
        cf.delay(0.5) {     // takes a Double value for the delay in seconds
            // put the delayed action/function here
            
            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
                self.web.sentlog(func_name: " StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                //self.tcpcon.getuser()   ///Upgrade firmware
            }else{}
            self.cf.delay(1){
                self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
                if(self.fuelquantity == nil){
                    
                    self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                }
                else{
                    print(self.fuelquantity!)
                    if(self.fuelquantity > 0){
                        
                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                        }
                        else {
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                        }
                        
                        self.pulse.text = "\(self.Last_Count!)"
                        // print(self.Last_Count)
                        self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")//"Thank you for using \nFluidSecure!"
                        
                        self.cf.delay(0.5){
                            self.Transaction(fuelQuantity: self.fuelquantity)
                           // self.tcpcon.setdefault()
                            
                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                            {
                            }
                            else {
                                // let replytld = self.tcpcon.tlddata()
                                //                            if(Vehicaldetails.sharedInstance.IsTLDdata == "True")
                                //                            {
                                //                                let replytld = self.web.tldlevel()
                                //                                if(replytld == "" || replytld == "nil"){}
                                //                                else{
                                //                                    self.tcpcon.sendtld(replytld: replytld)
                                //                                }
                                //                            }
                            }
                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.UsageInfoview.isHidden = false
                            self.Warning.isHidden = true
                        }
                        self.cf.delay(10){
                            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                            {
                                _ = self.web.getinfo()
                                if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                    _ = self.web.UpgradeCurrentVersiontoserver()
                                }
                                Vehicaldetails.sharedInstance.IsUpgrade = "N"

                                self.cf.delay(30){
                                    Vehicaldetails.sharedInstance.gohome = true
                                    self.timerview.invalidate()
                                    self.stoptimerIspulsarcountsame.invalidate()
                                    self.timerview.invalidate()
                                    self.timer.invalidate()
                                    self.timerFDCheck.invalidate()
                                    self.timer_quantityless_thanprevious.invalidate()
                                    self.stoptimergotostart.invalidate()
                                    self.stoptimer_gotostart.invalidate()
                                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                                    self.web.sentlog(func_name: "stoprelay function 30 delay ", errorfromserverorlink: "", errorfromapp: "")
                                    appDel.start()
                                }
                            }
                            if (self.stopdelaytime == true){}
                            else{
                                Vehicaldetails.sharedInstance.gohome = true
                        self.stoptimerIspulsarcountsame.invalidate()
                        self.timerview.invalidate()
                        self.timer.invalidate()
                                self.timerFDCheck.invalidate()
                        self.timer_quantityless_thanprevious.invalidate()
                        self.stoptimergotostart.invalidate()
                        self.stoptimer_gotostart.invalidate()
                        self.isUDPConnectstoptimer.invalidate()
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                self.web.sentlog(func_name: "stoprelay function ", errorfromserverorlink: "", errorfromapp: "")
                                appDel.start()
                               self.connection?.cancel()
                            }
                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.UsageInfoview.isHidden = false
                            self.Warning.isHidden = true
                        }
                    }
                    else
                    {
                        self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                    }
                }
            }
        }
    }
    
    @objc func stoprelay() throws  {
        if(Last_Count == nil){
            Last_Count = "0.0"
        }
        //check here if it is connected to BLE or Link.
        
        if(self.IFUDPConnected == true){}
        
        self.stoptimerIspulsarcountsame.invalidate()
        self.timerview.invalidate()
        self.timer.invalidate()
        self.timerFDCheck.invalidate()
        Stop.isHidden = true
        //timer_noConnection_withlink.invalidate()
        timer_quantityless_thanprevious.invalidate()
        stoptimergotostart.invalidate()
        stoptimer_gotostart.invalidate()
        let SSID:String = cf.getSSID()
        print(SSID)
        print(Vehicaldetails.sharedInstance.SSId)
        print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
        {
            let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
            renamelink(SSID:trimmedString)
        }
        if(self.InterruptedTransactionFlag == true)
        {
            self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "y") /// 1168 if relay off is not working then app sends to server Transaction id.
        }
        
        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
            _ = self.web.SetHoseNameReplacedFlag()
        }
        if(Vehicaldetails.sharedInstance.PulseRatio == "" || Vehicaldetails.sharedInstance.pulsarCount == "" )
        {
            self.web.sentlog(func_name: " PulsarCount,PulseRatio is null or nil" , errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
            
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
            self.connection?.cancel()
            self.stoptimerIspulsarcountsame.invalidate()
            self.timerview.invalidate()
            self.timer.invalidate()
            self.timerFDCheck.invalidate()
            self.timer_quantityless_thanprevious.invalidate()
            self.stoptimergotostart.invalidate()
            self.stoptimer_gotostart.invalidate()
            self.isUDPConnectstoptimer.invalidate()
        }
        else
        {
            let quantitycount = self.Last_Count! //Vehicaldetails.sharedInstance.pulsarCount
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
            
            if( Vehicaldetails.sharedInstance.SSId == SSID)
            {
                SenddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
            }
            else {
                SenddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
            }
        }
    }
    
    
    func Transaction(fuelQuantity:Double)
    {
        let Odomtr = Vehicaldetails.sharedInstance.Odometerno
        let Wifyssid = Vehicaldetails.sharedInstance.SSId
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        let pusercount :String
        if(self.Last_Count == nil){
            pusercount = Vehicaldetails.sharedInstance.pulsarCount
        }else{
            pusercount = self.Last_Count!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        
        print(Wifyssid)
        print(Odomtr)
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"Transaction\":\"Current_Transaction\"}"
        
        let reply = "-1"//web.Transaction_details(bodyData: bodyData)
        if (reply == "-1")
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            
            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId //
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
                self.web.sentlog(func_name: " Saved Current Transaction to Phone, Date\(dtt1) TransactionId:\(TransactionId),FuelQuantity:\((fuelQuantity)),Pulses:\(pusercount)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
            }
        }
        else{
            Warning.isHidden = true
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            self.notify(site: Vehicaldetails.sharedInstance.SSId)
        }
    }
    
    
    func notify(site:String) {
        let userNotificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "FluidSecure"
            notificationContent.body = NSLocalizedString("Notify", comment:"") + "\(site)."
        notificationContent.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                            repeats: false)
            let request = UNNotificationRequest(identifier: "testNotification",
                                                content: notificationContent,
                                                trigger: trigger)
            
            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
    }
    
    @IBAction func Stop(sender: AnyObject)
    {
        let label1 = UILabel(frame: CGRect(x: 40, y: 80, width: 500, height: 21))
        y = y + 20
        label1.center = CGPoint(x: 80,y: y)
        label1.textAlignment = NSTextAlignment.center
        label1.textColor = UIColor.white
        label1.text = "Output: \(string)"
        stopButtontapped()
    }
    
   
    func btnBeginFueling()
    {
        print("before GetPulser" + cf.dateUpdated)
      
        self.quantity = []
        self.countfailConn = 0
        print("Get Pulsar1" + self.cf.dateUpdated)
        timer.invalidate()
        timerFDCheck.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
        self.timerFDCheck = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDCheck), userInfo: nil, repeats: true)
        print("after GetPulser" + self.cf.dateUpdated)
        print(self.timer)
    }
    
    @objc func FDCheck()
    {
        let MessageuDP = "LK_COMM=FD_check"
            self.sendUDP(MessageuDP)
        self.web.sentlog(func_name: "UDP Function ", errorfromserverorlink: "Send FD check",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
       self.receiveUDP()
    }
    
    @available(iOS 12.0, *)
    @objc func GetPulser()
    {
        self.receiveUDP()
               
        if(self.pulsedata == "")
        {
            let messageToUDP = "LK_COMM=relay:12345=ON"
            self.web.sentlog(func_name: " Send Relay On Command to link \(messageToUDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")

                self.sendUDP(messageToUDP)

          self.receiveUDP()
        }
        else if(self.pulsedata != ""){
            print(self.pulsedata)
            
            let counts = self.pulsedata.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
            self.web.sentlog(func_name: "UDP Function ", errorfromserverorlink: "Count from link $$ \(counts)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
            
            if (counts == ""){
                self.emptypulsar_count += 1
                if(self.emptypulsar_count == 3){
                    Vehicaldetails.sharedInstance.gohome = true
                    self.timerview.invalidate()
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    self.web.sentlog(func_name: " Get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                    
                    appDel.start()
                    self.connection?.cancel()
                }
            }
            else if (counts == "0")
            {
                if(self.Last_Count == nil){
                    self.Last_Count = "0.0"
                }
                let v = self.quantity.count
                self.quantity.append("0")
                if(v >= 2){
                    print(self.quantity[v-1],self.quantity[v-2])
                    if(self.quantity[v-1] == self.quantity[v-2]){
                        self.total_count += 1
                        if(self.total_count == 3){
                            self.Ispulsarcountsame = true
                            self.stoptimerIspulsarcountsame.invalidate()
                            self.Samecount = self.Last_Count
                            self.stoptimerIspulsarcountsame.invalidate()
                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVCUDP.stopIspulsarcountsame), userInfo: nil, repeats: false)
                            
                            self.web.sentlog(func_name:"Get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                        }}}
            }
            else{
                
                self.emptypulsar_count = 0
                if (counts != "0"){
                    
                    self.start.isHidden = true
                    self.cancel.isHidden = true
                    
                    //transaction Status send only one time.
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    if(self.reply_server == "")
                    {
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
                        self.reply_server = "Sendtransaction"
                    }
                    print(self.tpulse.text!, self.pulsedata)
                                            
                    if (self.tpulse.text! == (self.pulsedata as String) as String){
                        
                    }
                    if(self.Last_Count == nil){
                        self.Last_Count = "0.0"
                    }
                    
                    if(counts.doubleValue >= (self.Last_Count as NSString).doubleValue)
                    {
                        if(counts.doubleValue > (self.Last_Count as NSString).doubleValue){
                            self.Ispulsarcountsame = false
                            self.stoptimerIspulsarcountsame.invalidate()
                        }
                        self.timer_quantityless_thanprevious.invalidate()
                        self.Last_Count = counts as String?
                        let v = self.quantity.count
                        let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                        let y = Double(round(100*FuelQuan)/100)
                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                            let y = Double(round(100*FuelQuan)/100)
                            self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                            print(self.tquantity.text!)
                        }
                        else {
                            let y = Double(round(100*FuelQuan)/100)
                            self.tquantity.text = "\(y) "
                        }
                        
                        self.tpulse.text = (counts as String) as String
                        self.quantity.append("\(y) ")
                        
                        print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
                        
                        if(v >= 2){
                            print(self.quantity[v-1],self.quantity[v-2])
                            if(self.quantity[v-1] == self.quantity[v-2]){
                                self.total_count += 1
                                if(self.total_count == 3){
                                    self.Ispulsarcountsame = true
                                    self.stoptimerIspulsarcountsame.invalidate()
                                    self.Samecount = self.Last_Count
                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVCUDP.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                    
                                    self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                }
                            }
                            else {
                                self.total_count = 0
                                
                                
                                
                                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                                else{
                                    
                                    if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
                                        
                                        _ = self.web.SetPulser0()
                                        print(Vehicaldetails.sharedInstance.MinLimit)
                                        self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
                                        self.stopButtontapped()
                                    }
                                }
                            }
                        }
                    }
                    else{
                        self.timer_quantityless_thanprevious.invalidate()
                        self.timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVCUDP.stoprelay), userInfo: nil, repeats: false)
                        self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
                        print("lower qty. than the prior one.")
                    }
                }
                else{
                    if(self.Last_Count == nil){
                        self.Last_Count = "0.0"
                    }
                    let v = self.quantity.count
                    let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                    let y = Double(round(100*FuelQuan)/100)
                    
                    self.quantity.append("\(y) ")
                    
                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
                    
                    if(v >= 2){
                        if(self.self.quantity[v-1] == self.quantity[v-2]){
                            self.total_count += 1
                            if(self.total_count == 3){
                                self.Ispulsarcountsame = true
                                self.Samecount = self.Last_Count
                                self.stoptimerIspulsarcountsame.invalidate()
                                
                                self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                                
                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVCUDP.stopIspulsarcountsame), userInfo: nil, repeats: false)
                            }
                        }
                    }
                }
            }
        }
    }
  
    
    @objc func stopIspulsarcountsame(){
        if(self.IsStopbuttontapped == true){
            
        }
        else {
            if(self.Ispulsarcountsame == true){
                if(Last_Count == nil){
                    Last_Count = "0.0"
                }
                if(Last_Count == "0.0" || Last_Count == "0")
                {
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "4")/////
                }
                //print(Last_Count,Samecount)
                if(Samecount == Last_Count){
                    
                    self.timer.invalidate()
                    self.timerFDCheck.invalidate()
                    self.web.sentlog(func_name: "Stoprelay stopIspulsarcountsame", errorfromserverorlink: "", errorfromapp:"")
                    // _ = self.tcpcon.setralay0tcp()
                    //                    _ = self.tcpcon.setpulsar0tcp()
                    self.displaytime.text = NSLocalizedString("autostop", comment:"")//"app autostop because pulsecount getting is same."
                    self.Stop.isHidden = true
                    do{
                        try self.stoprelay()
                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                        self.web.sentlog(func_name: "stoprelay stopIspulsarcountsame", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                    }
                }
            }
        }
    }
    
    @IBAction func OKbuttontapped(sender: AnyObject) {
        UsageInfoview.isHidden = true
        IsStartbuttontapped = true
        scrollview.isHidden = false
        dataview.isHidden = true
        OKWait.isHidden = false
     
        self.cf.delay(0.1){
            Vehicaldetails.sharedInstance.gohome = true
          
            self.stoptimerIspulsarcountsame.invalidate()
            self.timerview.invalidate()
            self.timer.invalidate()
            self.timerFDCheck.invalidate()
            self.timer_quantityless_thanprevious.invalidate()
            self.stoptimergotostart.invalidate()
            self.stoptimer_gotostart.invalidate()
            self.isUDPConnectstoptimer.invalidate()
            
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
            self.connection?.cancel()
            self.web.sentlog(func_name: " OK buttontapped", errorfromserverorlink: "", errorfromapp: "")
            self.stopdelaytime = true
        }
    }
    
    func getlast10transaction()
    {
        if(Last10transaction != "")
        {
            if(Last10transaction.contains("--"))
            {}else
            {
                let Splitdata = Last10transaction.components(separatedBy: ".\n")
                let Splitdata1 = Splitdata[0];
                let Splitdata2 = Splitdata1.components(separatedBy: ":")
                    let dataafterL10 = Splitdata2[1]
                let Splitdata3 = dataafterL10.trimmingCharacters(in: .whitespacesAndNewlines) .components(separatedBy: ",")
                for i in 0  ..< Splitdata3.count
                {
                    let Split = Splitdata3[i].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "-")
                    
                    let transid = Split[0];
                    let pulses = Split[1];
                    if(pulses == "N/A"){}
                    else
                    {
                        let quantity = self.cf.calculate_fuelquantity(quantitycount: Int(pulses as String)!)
                        let transaction_details = Last10Transactions(Transaction_id: transid, Pulses: pulses, FuelQuantity: "\(quantity)", vehicle:"", date:"", dflag: "")
                        Vehicaldetails.sharedInstance.Last10transactions.add(transaction_details)
                    }
                }
            }
        }
        
    }
    
    @objc func gotostartUDP_resDN()
    {
            self.web.sentlog(func_name: " UDP res DN", errorfromserverorlink:"Response from link is DN", errorfromapp: "")
            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")

        Stop.isEnabled = false
        Stop.isHidden = true
        wait.isHidden = false
        waitactivity.isHidden = false
   
        //isgotostartcalled = true
        self.stoptimerIspulsarcountsame.invalidate()
        self.timerview.invalidate()
        self.timer.invalidate()
        self.timerFDCheck.invalidate()
        self.timer_quantityless_thanprevious.invalidate()
        self.stoptimergotostart.invalidate()
        self.stoptimer_gotostart.invalidate()
        self.isUDPConnectstoptimer.invalidate()
        self.connection?.cancel()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
    }
    
    
//    func potentialfix()
//    {
//        if(Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
//        {
//            self.web.file()  // if internet is not availble here then log save into the files and we have to send it when internet is available.
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
//            let strDate = dateFormatter.string(from: NSDate() as Date)
//            print(strDate)
//            
//            defaults.set(strDate, forKey: "potentialfix_ErrorGET_Date")
//            defaults.set("True", forKey: "CollectDiagnosticLogs_Whengettingerror")
//            
//            print(defaults.string(forKey: "potentialfix_ErrorGET_Date")!)
//        }
//    }
   
    
    //    UDP Connect
    //    @available(iOS 12.0, *)
   
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        // Transmited message:
        let messageToUDP = "LK_COMM=info"
        self.web.sentlog(func_name: " Send info command to link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        
        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
            case .ready:
                print("State: Ready\n")
                self.web.sentlog(func_name: " State: Ready\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                self.sendUDP(messageToUDP)
             
                self.receiveUDP()
                self.IFUDPConnected = true
            
            case .setup:
                print("State: Setup\n")
                self.web.sentlog(func_name: " State: Setup\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
            case .cancelled:
                print("State: Cancelled\n")
                self.web.sentlog(func_name: " State: Cancelled\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
            case .preparing:
                print("State: Preparing\n")
                self.web.sentlog(func_name: " State: Preparing\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
            default:
                print("ERROR! State not defined!\n")
                self.web.sentlog(func_name: " ERROR! State not defined!\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
            }
        }
        
        self.connection?.start(queue: .global())
    }
    
    
    @objc func connectUDPlink()
    {
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                if(self.IFUDPConnected == false)
                {
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                    {
                        self.web.sentlog(func_name:" Send Command to UDP Link from viewDidload", errorfromserverorlink: "", errorfromapp: "")
                        self.connectToUDP(self.hostUDP,self.portUDP)
                    }
                }
                else if(self.IFUDPConnected == true)
                {
                   // isUDPConnectstoptimer.invalidate()
                }
                
                if(self.IFUDPConnectedGetinfo == false)
                {
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                    {
                        self.delay(0.5){
                            self.web.sentlog(func_name:" Send Command to UDP Link from connectUDPlink attempt \(self.countfailUDPConn)", errorfromserverorlink: "", errorfromapp: "")
                            self.connectToUDP(self.hostUDP,self.portUDP)
                            self.countfailUDPConn = self.countfailUDPConn + 1
                            if (self.countfailUDPConn == 10)
                            {
                                self.isUDPConnectstoptimer.invalidate()
                                self.showAlert(message: "No response from the link please try again later." )
                                self.delay(2)
                                    {
                                    self.web.sentlog(func_name:"No response from the link Fueling_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
                                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                                    appDel.start()
                                    self.connection?.cancel()
                                    self.stoptimerIspulsarcountsame.invalidate()
                                    self.timerview.invalidate()
                                    self.timer.invalidate()
                                    self.timerFDCheck.invalidate()
                                    self.timer_quantityless_thanprevious.invalidate()
                                    self.stoptimergotostart.invalidate()
                                    self.stoptimer_gotostart.invalidate()
                                }
                            }
                        }
                        
                    }
                }
                else if(self.IFUDPConnectedGetinfo == true)
                {
                   // isUDPConnectstoptimer.invalidate()
                }
            }
            else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
            {
                    web.wifi_settings_check(pagename: "UDP")
                    self.web.sentlog(func_name:" Connect UDP Link ", errorfromserverorlink: "", errorfromapp: "")
                   
                print("Link not connected ")
            }
    }
    
    
   
    @IBAction func sendinfocommand(_ sender: Any) {}
    
    
    func renamelink(SSID:String)
    {
        let MessageuDP = "LK_COMM=name:\(SSID)"
        sendUDP(MessageuDP)
        self.receiveUDP()
    }
    
    //Send the request data to UDP link
   
    func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    
    ///Receive the reponse from UDP
    func receiveUDP() {
              
        var backToString = ""
        
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                
                print("Receive is complete")
                if (data != nil) {
                    backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                    //self.web.sentlog(func_name:" Received message: \(backToString) from UDP link", errorfromserverorlink: "", errorfromapp: "")
                    if(backToString.contains("records"))
                    {
                        self.web.sentlog(func_name: " Get response from info command to link \(backToString)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
                        self.IFUDPConnectedGetinfo = true
                        self.viewDidAppear(true)
                    }
                    else
                    if(backToString.contains("HO"))
                    {
                        
                    }
                    else if(backToString.contains("DN"))
                    {
                        self.gotostartUDP_resDN()
                    }
                    if(backToString.contains("L10:"))
                    {
                        self.Last10transaction = backToString
                        self.web.sentlog(func_name: " Get response from info command to link \(backToString)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
                        self.IFUDPConnectedGetinfo = true
                        self.viewDidAppear(true)
                    }
                    if(backToString.contains("pulse:"))
                    {
                       // self.web.sentlog(func_name: " Get response from relay on getting pulses from link \(backToString)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
                        let Split = backToString.components(separatedBy: ":")
                        self.pulsedata = Split[1]
                        print(self.pulsedata)
                        self.pulsedata = (self.pulsedata.trimmingCharacters(in: .whitespacesAndNewlines) as NSString) as String
                    }
                }
            }
        }
    }
}
