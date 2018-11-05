


import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation
import CoreData

class PreauthFuelquantity: UIViewController,StreamDelegate,UITextFieldDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate,CLLocationManagerDelegate
{
    @IBOutlet var Waitp: UILabel!
    @IBOutlet var Pwait: UILabel!
    @IBOutlet var waitactivity: UIActivityIndicatorView!
    @IBOutlet var lable: UILabel!
    @IBOutlet var tpulse: UILabel!
    @IBOutlet var tquantity: UILabel!
    @IBOutlet var wait: UILabel!
    @IBOutlet var Activity: UIActivityIndicatorView!
    @IBOutlet var viewdata: UIView!
    @IBOutlet var scrollview: UIScrollView!

    var cf = Commanfunction()
    var tcpcon = TCPCommunication()
    let defaults = UserDefaults.standard
    var web = Webservices()
    var getdatafromsetting = false
    var string:String = ""
    var status :String = ""
    var tstring:String = ""
    var sysdata:NSDictionary!
    var sysdata1:NSDictionary!
    var relay_responsesysdata1:NSDictionary!
    var IsStartbuttontapped : Bool = false
    var setrelaysysdata:NSDictionary!
    var stoptimergotostart:Timer = Timer()
    // var IsStartbuttontapped : Bool = false
    var Cancel_Button_tapped :Bool = false
    var s1 :String!
    var iswifi :Bool!
    var Fquantity :Double!
    var quantity = [String]()
    var counts:String!
    var timer:Timer = Timer()
    var timerview:Timer = Timer()
    var stoptimer:Timer = Timer()
    var y :CGFloat = CGFloat()
    var results = [NSManagedObject]()
    var Transaction_ID = [NSManagedObject]()
    var beginfuel1 : Bool = false
    var stopbutton :Bool = false
    var fuelquantity:Double!
    var reply :String!
    var reply1 :String!
    var pulsardata:String!
    var startbutton:String = ""
    var currentlocation :CLLocation!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!
    var buffer = [UInt8](repeating: 0, count:1024)
    var stopdelaytime:Bool = false
    var isconect_toFS:String!
    var showstartbutton:String = ""
    var ifstartpulsar_status:Int = 0
    var total_count:Int = 0
    var Last_Count:String!
    var timer_noConnection_withlink = Timer()
    var timer_quantityless_thanprevious = Timer()
    var emptypulsar_count:Int = 0
    var ResponceMessageUpload:String = ""
    private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"

    let addr = "192.168.4.1"
    let port = 80

    var FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"

    //Network variables
    var inStream : InputStream?
    var outStream: OutputStream?

    //Mark IBOutlets

    @IBOutlet var Warning: UILabel!
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
    @IBOutlet var OKWait: UILabel!
    @IBOutlet var dataview: UIView!

    override func viewDidAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        scrollview.isHidden = false
        OKWait.isHidden = true
         self.timerview.invalidate()
        if(IsStartbuttontapped == true){}
        else{
            self.displaytime.text = NSLocalizedString("MessageFueling1", comment:"")//"Please wait while your connection is being established With FS link"
            print(string)
            cf.delay(3){
                self.Activity.hidesWhenStopped = true;
                print(self.cf.getSSID())

                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                    let isConect_toFS = self.getinfo()
                    if(isConect_toFS == "true"){
                        self.start.isEnabled = true
                        self.start.isHidden = false
                        self.Pwait.isHidden = true
                         self.Activity.stopAnimating()
                    }
                    else if(isConect_toFS == "false") {
                        self.start.isEnabled = false
                        self.start.isHidden = true
                        self.displaytime.text = NSLocalizedString("MessageFueling1", comment:"")//"Please wait while your connection is being established With FS link"
                        print("return  false  by info command")
                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + " \(Vehicaldetails.sharedInstance.SSId) " + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                    }
                    if(isConect_toFS == "-1")
                    {
                        print("return  -1  by info command")
                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                    }
                    if(isConect_toFS == "")
                    {
                        print("return \" \"  by info command")
                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                    }

                    self.timerview.invalidate()
                    self.iswifi = true
                    if(self.startbutton == "true")
                    {
                        print("startbutton")
                    }
                    self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")//"Please insert the nozzle into the tank \n Then tap start"
                }
                else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                {
                    self.web.sentlog(func_name: "In Preauthorized Transaction On Appearing Fueling screen lost Wifi connection with the link", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                    self.timerview.invalidate()
                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true
        stoptimergotostart.invalidate()
        start.isEnabled = false
        start.isHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        Warning.isHidden = true
    }

    override func viewDidLoad() {
        self.Activity.startAnimating()
        stoptimergotostart.invalidate()
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        wait.isHidden = true
        waitactivity.isHidden = true
        UsageInfoview.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        Vehicaldetails.sharedInstance.gohome = false
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControlState())
        doneButton.addTarget(self, action: #selector(FuelquantityVC.tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor.black

        FQ.isHidden = false
        Stop.isHidden = true
        start.isHidden = false
        cancel.isHidden = false
        getdatafromsetting = true
        start.isEnabled = false
        start.isHidden = true
        if(!timerview.isValid) {}
        Odometer.text = "\(Vehicaldetails.sharedInstance.Odometerno)"
        vehicleno.text = "\(Vehicaldetails.sharedInstance.vehicleno)"
    }

    func gotostart(){
        if(IsStartbuttontapped == false){
            self.cf.delay(0.5){
                _ = self.tcpcon.setralay0tcp()
                self.cf.delay(0.5){
                    _ = self.tcpcon.setpulsar0tcp()
                }
            }
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            self.web.sentlog(func_name: "Gotostart", errorfromserverorlink: "", errorfromapp: "")
            appDel.start()
            print("hi")
        }
        else if(IsStartbuttontapped == true)
        {

        }
    }

    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.endEditing(true)
    }

    func showFileWithPath(_ path: String) {
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL)
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath + "/filebin")
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }

    func getinfo() -> String {

        let Url:String = "http://192.168.4.1:80/client?command=info"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 6

        let semaphore = DispatchSemaphore(value: 0)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String

                print(self.reply)
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    let Version = self.sysdata.value(forKey: "Version") as! NSDictionary

                    let iot_version = Version.value(forKey: "iot_version") as! NSString
                    let mac_address = Version.value(forKey: "mac_address") as! NSString

                    self.showstartbutton = "true"
                    print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
                    if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)"){

                    }else {
                        print(Vehicaldetails.sharedInstance.FS_MacAddress)
                        Vehicaldetails.sharedInstance.FS_MacAddress = mac_address as String
                    }

                    if(Vehicaldetails.sharedInstance.FirmwareVersion == "\(iot_version)"){
                        Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                    }
                    else if(Vehicaldetails.sharedInstance.FirmwareVersion != "\(iot_version)"){
                        Vehicaldetails.sharedInstance.IsFirmwareUpdate = true
                        Vehicaldetails.sharedInstance.FirmwareVersion = "\(iot_version)"
                    }
                }
                catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.isconect_toFS = "false"
                    if(self.isconect_toFS == "true"){

                        self.showstartbutton = "false"

                    }else
                        if(self.isconect_toFS == "false"){

                            self.showstartbutton = "false"
                    }
                }
            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return showstartbutton//isconect_toFS;
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 1) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationBeginsFromCurrentState(true)
            self.view.frame = CGRect(x: 0,y: -140, width: self.view.frame.size.width, height: self.view.frame.size.height)
            UIView.commitAnimations()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func savetrans(lastpulsarcount:String,lasttransID:String) {

        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        let fuelquantity = (Double(lastpulsarcount))!/(PulseRatio as NSString).doubleValue
        if(fuelquantity == 0.0 || lasttransID == "-1"){}
        else{
            let bodyData = "{\"TransactionId\":\(lasttransID),\"FuelQuantity\":\((fuelquantity)),\"Pulses\":\"\(lastpulsarcount)\",\"TransactionFrom\":\"I\"}"
            let jsonstring: String = bodyData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            let unsycnfileName =  dtt1 + "#" + "transaction" + "#" + "lasttransID" + "#" + Vehicaldetails.sharedInstance.SSId
            cf.SaveTextFile(fileName: unsycnfileName, writeText: jsonstring)
        }
    }


    @IBAction func startButtontapped(sender: AnyObject)
    {
        if(Cancel_Button_tapped == true){}
        else{
            //Start the fueling with buttontapped
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            start.isEnabled = false
            IsStartbuttontapped = true

            stoptimergotostart.invalidate()
            self.cancel.isHidden = true

            self.timerview.invalidate()

            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.web.sentlog(func_name: "In Preauthorized Transaction startButtontapped lost Wifi connection with the link", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                self.timerview.invalidate()
                self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Your Connection with \(Vehicaldetails.sharedInstance.SSId) is lost. Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

            }else {

                let replygetrelay = self.web.getrelay()
                let defaultTimeZoneStr = formatter.string(from: Date());
                let Split = replygetrelay.components(separatedBy: "#")
                reply = Split[0]
                let error = Split[1]
                print(self.reply)
                if(self.reply == "-1"){
                    self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Your Connection with \(Vehicaldetails.sharedInstance.SSId) is lost. Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                }else{
                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                    do{
                        self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    }catch let error as NSError {
                        self.web.sentlog(func_name: "In Preauthorized Transaction startButtontapped GetRelay Function", errorfromserverorlink: "\(error)", errorfromapp:"\"Error: \(error.domain)")
                        print ("Error: \(error.domain)")
                    }

                    if(self.setrelaysysdata == nil){

                    }
                    else{
                        let objUserData = self.setrelaysysdata.value(forKey: "relay_response") as! NSDictionary

                        let relayStatus = objUserData.value(forKey: "status") as! NSNumber
                        let defaultTimeZoneStr1 = formatter.string(from: Date());
                        print("after get relay" + defaultTimeZoneStr1)
                        if(relayStatus == 0){
                            self.Pwait.text =  NSLocalizedString("Pleasewait", comment:"")//"Please wait ... "
                            self.Pwait.isHidden = false
                            self.start.isHidden = true
                            self.cancel.isHidden = true   /// hide the cancel Button.

                            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                            {
                                self.web.sentlog(func_name: "In Preauthorized Transaction startButtontapped lost Wifi connection with the link  after get relay.", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                                self.timerview.invalidate() /// set pulsar off time to FS link
                                self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                            }else {
                                let defaultTimeZoneStr = formatter.string(from: Date());
                                print("before setpulsaroffTime" + defaultTimeZoneStr)

                                self.tcpcon.setpulsaroffTime()
                                let defaultTimeZoneStr1 = formatter.string(from: Date());
                                print("after setpulsaroffTime" + defaultTimeZoneStr1)

                                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                {
                                    self.web.sentlog(func_name: "In Preauthorized Transaction startButtontapped lost Wifi connection with the link after setpulsaroffTime. ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                                    self.timerview.invalidate()
                                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                                }else {
                                    let defaultTimeZoneStr = formatter.string(from: Date());
                                    print("setpulsarofftime" + defaultTimeZoneStr)
                                    self.cf.delay(0.5){
                                        let st = self.tcpcon.preauthsetSamplingtime()
                                        let defaultTimeZoneStr1 = formatter.string(from: Date());
                                        print("setSamplingtime" + defaultTimeZoneStr1)
                                        print(st)
                                        let defaultTimeZoneStr = formatter.string(from: Date());
                                        print("before pulsarlastquantity" + defaultTimeZoneStr)
                                        self.cf.delay(0.5){
                                            self.start.isHidden = true
                                            self.web.pulsarlastquantity()
                                            let defaultTimeZoneStr1 = formatter.string(from: Date());
                                            print("pulsarlastquantity" + defaultTimeZoneStr1)

//                                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                                            _ = self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "1")/////
                                            let defaultTimeZoneStr = formatter.string(from: Date());
                                            print("before getlastTrans_ID" + defaultTimeZoneStr)

                                            self.cf.delay(0.5){

                                                let lasttransID = self.web.getlastTrans_ID()
                                                let defaultTimeZoneStr1 = formatter.string(from: Date());
                                                print("getlastTrans_ID" + defaultTimeZoneStr1)
                                                if(Vehicaldetails.sharedInstance.FinalQuantitycount == ""){}
                                                else{
                                                    self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                                                }
                                                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                                {
                                                    self.web.sentlog(func_name: "In Preauthorized Transaction startButtontapped lost Wifi connection with the link after getlastTrans_ID", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                                                    self.timerview.invalidate()
                                                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                                                } else {
                                                    let defaultTimeZoneStr = formatter.string(from: Date());
                                                    print("before settransaction_IDtoFS" + defaultTimeZoneStr)
                                                    self.cf.delay(0.5){

                                                        self.tcpcon.settransaction_IDtoFS()
                                                        let defaultTimeZoneStr1 = formatter.string(from: Date());
                                                        print("settransaction_IDtoFS" + defaultTimeZoneStr1)

                                                        self.beginfuel1 = false
                                                        // self.cancel.isHidden = true
                                                        ///hide start button
                                                        self.displaytime.text = NSLocalizedString("Fueling", comment:"")//"Fueling…"
                                                        self.Pwait.isHidden = true
                                                        //self.string = ""
                                                        self.tcpcon.setdefault()
                                                        self.iswifi = true
                                                        if(self.startbutton == "true")
                                                        {
                                                            print("startbutton")
                                                        }

                                                        if(self.iswifi == false){
                                                            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn"){
                                                                self.viewDidAppear(true)
                                                                self.startbutton = "true"
                                                            }
                                                            else{
                                                                self.showAlertSetting(message: NSLocalizedString("CheckWifi", comment:""))//"Please check your wifi connection")
                                                            }
                                                        }

                                                        self.Activity.isHidden = true
                                                        self.Activity.stopAnimating()
                                                        // self.record = []
                                                        self.cf.delay(0.5){

//                                                            self.string = ""
//                                                            self.inStream?.close()
//                                                            self.outStream?.close()
                                                            self.tcpcon.setdefault()
                                                            self.tcpcon.closestreams()
                                                            let defaultTimeZoneStr2 = formatter.string(from: Date());
                                                            print("before setpulsartcp" + defaultTimeZoneStr2)
                                                            self.cf.delay(0.5){
                                                                var setpulsar = self.tcpcon.setpulsartcp()
                                                                let defaultTimeZoneStr = formatter.string(from: Date());
                                                                print("Pulsar on0" + defaultTimeZoneStr)
                                                                self.cf.delay(0.5){
                                                                    if(setpulsar == ""){
                                                                        setpulsar = self.tcpcon.setpulsartcp()
                                                                        let defaultTimeZoneStr = formatter.string(from: Date());
                                                                        print("Pulsar on1" + defaultTimeZoneStr)
                                                                        //set pulsar
                                                                    }
                                                                    if(setpulsar == ""){
                                                                        self.cf.delay(0.5){
                                                                            _ = self.tcpcon.setralay0tcp()
                                                                            _ = self.tcpcon.setpulsar0tcp()
                                                                            self.error400(message: NSLocalizedString("CheckFSunit", comment:""))//"Please check your FS unit, and switch off power and back on.")
                                                                        }
                                                                    }
                                                                    else{

                                                                        let Split = setpulsar.components(separatedBy: "{")
                                                                        if(Split.count < 3){
                                                                            _ = self.tcpcon.setralay0tcp()
                                                                            _ = self.tcpcon.setpulsar0tcp()
                                                                            self.error400(message: NSLocalizedString("CheckFSunit", comment:""))//"Please check your FS unit, and switch off power and back on.")
                                                                        }    // got invalid respose do nothing
                                                                        else{

                                                                            let reply = Split[1]
                                                                            let setrelay = Split[2]
                                                                            let Split1 = setrelay.components(separatedBy: "}")
                                                                            let setrelay1 = Split1[0]
                                                                            let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
                                                                            let data1:Data = outputdata.data(using: String.Encoding.utf8)!
                                                                            do{
                                                                                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                                                            }catch let error as NSError {
                                                                                print ("Error: \(error.domain)")
                                                                            }
                                                                            print(self.sysdata1)

                                                                            let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
                                                                            self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                                                            let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
                                                                            self.ifstartpulsar_status = Int(truncating: pulsar_status)
                                                                            print(setpulsar)

                                                                            if(pulsar_status == 1)
                                                                            {
                                                                                let defaultTimeZoneStr1 = formatter.string(from: Date());
                                                                                print("before Relay on0" + defaultTimeZoneStr1)
                                                                                var setrelayd = self.tcpcon.setralaytcp()
                                                                                let defaultTimeZoneStr = formatter.string(from: Date());
                                                                                print("Relay on0" + defaultTimeZoneStr)
                                                                                print(setrelayd)
                                                                                self.cf.delay(0.5){
                                                                                    if(setrelayd == ""){        // if no response sent set relay command again
                                                                                        setrelayd = self.tcpcon.setralaytcp()
                                                                                        let defaultTimeZoneStr = formatter.string(from: Date());
                                                                                        print("Relay on1" + defaultTimeZoneStr)
                                                                                    }
                                                                                    if(setrelayd == ""){  // after 2 attempt stop relay goto home screen
                                                                                        self.cf.delay(0.5){
                                                                                            _ = self.tcpcon.setralay0tcp()
                                                                                            _ = self.tcpcon.setpulsar0tcp()
                                                                                            let defaultTimeZoneStr = formatter.string(from: Date());
                                                                                            print(defaultTimeZoneStr)
                                                                                            self.error400(message: NSLocalizedString("CheckFSunit", comment:""))//"Please check your FS unit, and switch off power and back on.")
                                                                                        }
                                                                                    }
                                                                                    else{

                                                                                        let Split:NSArray = setrelayd.components(separatedBy: "{") as NSArray
                                                                                        if(Split.count < 2){
                                                                                            _ = self.tcpcon.setralay0tcp()
                                                                                            _ = self.tcpcon.setpulsar0tcp()
                                                                                            self.error400(message: NSLocalizedString("CheckFSunit", comment:""))//"Please check your FS unit, and switch off power and back on.")
                                                                                        }    // got invalid respose do nothing goto home screen
                                                                                        else{
                                                                                            let reply = Split[0] as! String    // get valid respose proceed
                                                                                            let setrelay = Split[1]as! String
                                                                                            let Split1:NSArray = setrelay.components(separatedBy: "}") as NSArray
                                                                                            let setrelay1 = Split1[0] as! String
                                                                                            let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"  /// got valid data from FS unit
                                                                                            let defaultTimeZoneStr1 = formatter.string(from: Date());
                                                                                            print("getresponse relay on" + defaultTimeZoneStr1)
                                                                                            let data1:NSData = outputdata.data(using: String.Encoding.utf8)! as NSData
                                                                                            do{
                                                                                                self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                                                                            }catch let error as NSError {
                                                                                                print ("Error: \(error.domain)")
                                                                                            }
                                                                                            print(self.setrelaysysdata)
                                                                                            if(self.setrelaysysdata == nil){
                                                                                                self.showAlert(message: "please retry")
                                                                                            }
                                                                                        }
                                                                                        self.start.isHidden = true
                                                                                        self.Stop.isHidden = false
                                                                                        //self.string = ""
                                                                                         self.tcpcon.setdefault()
                                                                                        self.displaytime.text = ""
                                                                                        self.btnBeginFueling()
                                                                                        let defaultTimeZoneStr = formatter.string(from: Date());
                                                                                        print("Get Pulsar" + defaultTimeZoneStr)
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if(relayStatus == 1)
                        {
                            let alert = UIAlertController(title: "", message: NSLocalizedString("The link is busy, please try after some time.", comment:""), preferredStyle: UIAlertControllerStyle.alert)
                            let backView = alert.view.subviews.last?.subviews.last
                            backView?.layer.cornerRadius = 10.0
                            backView?.backgroundColor = UIColor.white
                            var messageMutableString = NSMutableAttributedString()
                            messageMutableString = NSMutableAttributedString(string: "The link is busy, please try after some time." as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
                            messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:"The link is busy, please try after some time.".count))
                            alert.setValue(messageMutableString, forKey: "attributedMessage")

                            let okAction = UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertActionStyle.default) { action in
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                // Call a method on the CustomController property of the AppDelegate
                                self.cf.delay(1) {     // takes a Double value for the delay in seconds
                                    appDel.start()
                                    self.Activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
                                    self.Activity.startAnimating()
                                }
                            }
                            alert.addAction(okAction)

                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }}


    @IBAction func cancelButtonTapped(sender: AnyObject) {
        Cancel_Button_tapped = true
        if(IsStartbuttontapped == true){}
        else{

            let alert = UIAlertController(title: "Confirm", message: NSLocalizedString("Cancelwarning", comment:""), preferredStyle: UIAlertControllerStyle.alert )
            let backView = alert.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.white
            var messageMutableString = NSMutableAttributedString()
            messageMutableString = NSMutableAttributedString(string:NSLocalizedString("Cancelwarning", comment:"") as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
            messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:NSLocalizedString("Cancelwarning", comment:"").count))
            alert.setValue(messageMutableString, forKey: "attributedMessage")

            let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertActionStyle.default) { action in
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                // Call a method on the CustomController property of the AppDelegate

                self.cf.delay(1) {
                    self.web.sentlog(func_name: "cancelButtonTapped", errorfromserverorlink: "", errorfromapp: "")
                    appDel.start()
                    self.Activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
                    self.Activity.startAnimating()
                }
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment:""), style: UIAlertActionStyle.cancel) { (submitn) -> Void in
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }}

    func calculate_fuelquantity(quantitycount: Int)-> Double
    {
        if(quantitycount == 0)
        {
            fuelquantity = 0
        }
        else{
            Vehicaldetails.sharedInstance.pulsarCount = "\(quantitycount)"
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            fuelquantity = (Double(quantitycount))/(PulseRatio as NSString).doubleValue
        }
        return fuelquantity
    }

    func error400(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            self.cf.delay(1){
                Vehicaldetails.sharedInstance.gohome = true
                self.IsStartbuttontapped = true
                self.stoptimergotostart.invalidate()
                self.timerview.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                self.web.sentlog(func_name: "Preauth error400", errorfromserverorlink: "", errorfromapp: "")
                appDel.start()
                self.stopdelaytime = true
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }



    func showAlertSetting(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("ConnectWifi", comment:""), style: UIAlertActionStyle.default) { action in //self.
            if #available(iOS 11.0, *) {
                // self.web.wifisettings(pagename: "FuelQuantityVC")

                let hotspotConfig = NEHotspotConfiguration(ssid: self.SSID, passphrase: "123456789", isWEP: false)
                hotspotConfig.joinOnce = true

                NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in

                    if let error = error {
                        // self.showError(error: error)
                        print("Error\(error)")
                        self.web.wifisettings(pagename:"Retry")
                    }
                    else {
                        self.web.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically from FuelquantityVC Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                        // self.showSuccess()
                        print("Connected")


                    }
                }
            } else {
                // Fallback on earlier versions

                let alertController = UIAlertController(title: NSLocalizedString("Title", comment:""), message: NSLocalizedString("Message", comment:"") + "\(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertControllerStyle.alert)
                let backView = alertController.view.subviews.last?.subviews.last
                backView?.layer.cornerRadius = 10.0
                backView?.backgroundColor = UIColor.white

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.left

                let paragraphStyle1 = NSMutableParagraphStyle()
                paragraphStyle1.alignment = NSTextAlignment.left

                let attributedString = NSAttributedString(string:NSLocalizedString("Subtitle", comment:""), attributes: [
                    NSAttributedStringKey.paragraphStyle:paragraphStyle1,
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20), //your font here
                    NSAttributedStringKey.foregroundColor : UIColor.black
                    ])

                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal(NSLocalizedString("Step1", comment:""))//("\nThe WiFi name is the name of the HOSE. Read Steps 1 to 5 below then click on Green bar below.\n\nFollow steps:\n1. Turn on the WiFi (it might already be on)\n\n2. Choose the WiFi \n named: ")
                    .bold("\(Vehicaldetails.sharedInstance.SSId)")
                    .normal(NSLocalizedString("Step2", comment:""))//(" \n\n3. First time it will ask for password,enter: 123456789\n\n4. It will have a check next to ")
                    .bold("\(Vehicaldetails.sharedInstance.SSId)")
                    .normal(NSLocalizedString("Step3", comment:""))//" and it will say \"No Internet Connection\" \n\n5.  Now, tap on the very top left corner that says \"FluidSecure\" - this returns you to allow fueling.\n\n\n\n\n")

                alertController.setValue(formattedString, forKey: "attributedMessage")
                alertController.setValue(attributedString, forKey: "attributedTitle")
                let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default){
                    action in
                    // self.cf.getSSID()

                }
                alertController.addAction(action)

                self.present(alertController, animated: true, completion: nil)
            }

            Vehicaldetails.sharedInstance.gohome = false
            self.resumetimer()
        }

        let home = UIAlertAction(title: NSLocalizedString("BacktoHome", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            self.getdatafromsetting = true
            Vehicaldetails.sharedInstance.gohome = true
            self.IsStartbuttontapped = true
            self.stoptimergotostart.invalidate()
            alertController.view.tintColor = UIColor.green
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            self.web.sentlog(func_name: "Preauth showAlertSetting", errorfromserverorlink: "", errorfromapp: "")
            appDel.start()
        }

        alertController.addAction(action)
        alertController.addAction(home)
        self.present(alertController, animated: true, completion: nil)
    }

    func resumetimer(){
        self.timerview.invalidate()
        self.timerview = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.viewDidAppear(_:)), userInfo: nil, repeats: true)
    }


    func okaction(sender:UIButton){

        Vehicaldetails.sharedInstance.gohome = false
        self.resumetimer()
    }

    func backaction(sender:UIButton){
        IsStartbuttontapped = true
        stoptimergotostart.invalidate()
        Vehicaldetails.sharedInstance.gohome = true
        self.timerview.invalidate()
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        self.web.sentlog(func_name: "Preauth backaction", errorfromserverorlink: "", errorfromapp: "")
        appDel.start()
    }

    func stopButtontapped()
    {
        Stop.isEnabled = false
        Stop.isHidden = true
        wait.isHidden = false
        waitactivity.isHidden = false
        waitactivity.startAnimating()
        self.timer.invalidate()
        string = ""
        cf.delay(0.5){
            self.timer.invalidate()
            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.web.sentlog(func_name: "In Preauthorized Transaction stopButtontapped lost Wifi connection with the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                self.timerview.invalidate()
                self.stoprelay()

            }else {
                print("Before relayoff 0" + self.cf.dateUpdated)
                var setrelayd = self.tcpcon.setralay0tcp()   //
                self.cf.delay(0.5){
                    if(setrelayd == ""){
                        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                        {
                            self.web.sentlog(func_name: "In Preauthorized Transaction stopButtontapped lost Wifi connection with the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                            self.timerview.invalidate()
                            self.stoprelay()

                        }else {
                            setrelayd = self.tcpcon.setralay0tcp()
                        }
                    }

                    print("Before relayoff 0" + self.cf.dateUpdated)
                    if(setrelayd == ""){
                        self.cf.delay(0.5){
                            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                            {
                                self.web.sentlog(func_name: "In Preauthorized Transaction stopButtontapped lost Wifi connection with the link", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                                self.timerview.invalidate()
                                self.stoprelay()

                            }else {
                                _ = self.tcpcon.setralay0tcp()
                                _ = self.tcpcon.setpulsar0tcp()
                                self.error400(message:NSLocalizedString("CheckFSunit", comment:""))// "Please check your FS unit, and switch off power and back on.")
                                self.stoprelay()
                            }
                        }
                    }
                    else{
                         print("after set relayoff 0" + self.cf.dateUpdated)
                        let Split = setrelayd.components(separatedBy: "{")
                        if(Split.count < 3){
                            _ = self.tcpcon.setralay0tcp()
                            _ = self.tcpcon.setpulsar0tcp()
                            _ = self.stoprelay()
                        }
                        else {
                            let reply = Split[1]
                            let setrelay = Split[2]
                            let Split1 = setrelay.components(separatedBy: "}")
                            let setrelay1 = Split1[0]
                            let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
                            let data1:Data = outputdata.data(using: String.Encoding.utf8)!
                            do{
                                self.relay_responsesysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            }catch let error as NSError {
                                print ("Error: \(error.domain)")
                            }
                            print(self.relay_responsesysdata1)
                            let objUserData = self.relay_responsesysdata1.value(forKey: "relay_response") as! NSDictionary
                           // let status = objUserData.value(forKey: "status") as! NSNumber
                            print(setrelayd)

                           // if(status == 0) {
                                //self.string = ""
                                 self.tcpcon.setdefault()
                                self.cf.delay(0.5){
                                    if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                    {
                                        self.web.sentlog(func_name: "In Preauthorized Transaction stopButtontapped lost Wifi connection with the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                                        self.timerview.invalidate()
                                        self.stoprelay()

                                    }else {

                                        print("before get final_pulsar_request" + self.cf.dateUpdated)

                                        self.timer.invalidate()
                                        //self.string = ""
                                         self.tcpcon.setdefault()
                                        var finalpulsar = self.tcpcon.final_pulsar_request()
                                        self.cf.delay(0.5){
                                            if(finalpulsar == ""){

                                                finalpulsar = self.tcpcon.final_pulsar_request()
                                            }
                                            print(finalpulsar)
                                            let Split = finalpulsar.components(separatedBy: "{")
                                            print("Splitcout\(Split.count)")
                                            if(Split.count < 3){  _ = self.tcpcon.setralay0tcp()

                                                _ = self.tcpcon.setpulsar0tcp()
                                                self.stoprelay()
                                            }
                                            else{
                                                    print("after get final_pulsar_request" + self.cf.dateUpdated)
                                                let reply = Split[1]
                                                let setrelay = Split[2]
                                                let Split1 = setrelay.components(separatedBy: "}")
                                                let setrelay1 = Split1[0]
                                                // let setrelaystatus = Split[2]as! String
                                                let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"

                                                let data1:Data = outputdata.data(using: String.Encoding.utf8)!
                                                do{
                                                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

                                                }catch let error as NSError {
                                                    print ("Error: \(error.domain)")
                                                }

                                                if(self.sysdata1 == nil){}
                                                else{
                                                    let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary

                                                    self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                                   // _ = objUserData.value(forKey: "pulsar_status") as! NSNumber
                                                    if (self.counts != "0"){
                                                    }
                                                    let fuelQuan = self.calculate_fuelquantity(quantitycount: Int(self.counts as String)!)
                                                   // let y = Double(round(100*fuelQuan)/100)

                                                    if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                                        let y = Double(round(100*fuelQuan)/100)
                                                        self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                                        print(self.tquantity.text!)
                                                    }
                                                    else {
                                                        let y = Double(round(100*fuelQuan)/100)
                                                        self.tquantity.text = "\(y) "

                                                    }


                                                   // self.tquantity.text = "\(y) "// + "Gallon"
                                                    self.tpulse.text = (self.counts as String) as String
                                                    self.Last_Count = (self.counts as String) as String
                                                }

                                                print(self.string)
                                                self.Stop.isHidden = true
                                                let SSID:String = self.cf.getSSID()
                                                print(SSID)
                                                print(Vehicaldetails.sharedInstance.SSId)
                                                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                    self.tcpcon.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
                                                }
                                                _ = self.tcpcon.setpulsar0tcp()
                                                if( Vehicaldetails.sharedInstance.SSId == SSID  || "FUELSECURE" == SSID)
                                                {
                                                    self.cf.delay(0.5) {     // takes a Double value for the delay in seconds
                                                        // put the delayed action/function here
                                                        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                            _ = self.web.SetHoseNameReplacedFlag()
                                                        }

                                                        self.cf.delay(0.5){
                                                            if(self.fuelquantity > 0){
                                                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                                                    self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                                                }
                                                                else {
                                                                    self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                                                }

//                                                                self.wait.isHidden = true
//                                                                self.waitactivity.isHidden = true
//                                                                self.waitactivity.stopAnimating()
                                                                self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                                                self.pulse.text = "\(self.counts!)"
                                                                self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")//"Thank you for using \nFluidSecure!"
                                                                self.UsageInfoview.isHidden = false
                                                                self.Warning.isHidden = true
                                                                self.cf.delay(1){
                                                                    self.Transaction(fuelQuantity: self.fuelquantity)
//                                                                    print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
//                                                                    if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
//                                                                    else if(Vehicaldetails.sharedInstance.FS_MacAddress != Vehicaldetails.sharedInstance.MacAddress){
                                                                        //self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
//                                                                    }

                                                                self.wait.isHidden = true
                                                                self.waitactivity.isHidden = true
                                                                self.waitactivity.stopAnimating()
                                                                self.UsageInfoview.isHidden = false
                                                                self.Warning.isHidden = true

//                                                                if(Vehicaldetails.sharedInstance.MacAddress == "nil"){
//                                                                    Vehicaldetails.sharedInstance.MacAddress = "not found"
//                                                                }
//
//                                                                self.web.sentlog(func_name: "StopButtonTapped MacAddresses", errorfromserverorlink: "FS Version \(Vehicaldetails.sharedInstance.FS_MacAddress)", errorfromapp: " \(Vehicaldetails.sharedInstance.MacAddress)" + " Connected link : \(self.cf.getSSID())")
                                                           }
                                                                self.cf.delay(10){

                                                                    if (self.stopdelaytime == true){}
                                                                    else{
                                                                        Vehicaldetails.sharedInstance.gohome = true
                                                                        self.timerview.invalidate()
                                                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                                        self.web.sentlog(func_name: "Preauth stopButtontapped", errorfromserverorlink: "", errorfromapp: "")
                                                                        appDel.start()
                                                                    }
                                                                }
                                                        }
                                                            else
                                                            {
                                                                self.error400(message: NSLocalizedString("ZeroQuantity", comment:""))//"your transaction is not proceed you fuel quantity is 0 please try agian")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                          //  }
                        }
                    }
                }
            }
        }
    }


    func stoprelay(){
        self.timer.invalidate()
        Stop.isHidden = true
        timer_noConnection_withlink.invalidate()
        timer_quantityless_thanprevious.invalidate()
        let SSID:String = cf.getSSID()
        print(SSID)
        print(Vehicaldetails.sharedInstance.SSId)
        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
            tcpcon.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
        }
        if(Vehicaldetails.sharedInstance.PulseRatio == "" || Vehicaldetails.sharedInstance.pulsarCount == "" ){
            self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
        } else{
            let quantitycount = Vehicaldetails.sharedInstance.pulsarCount
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue

            if( Vehicaldetails.sharedInstance.SSId == SSID)
            {

                cf.delay(0.5) {     // takes a Double value for the delay in seconds

                    // put the delayed action/function here
                    if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                        _ = self.web.SetHoseNameReplacedFlag()
                    }
                    if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == true){

                        Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                    }else{}
                    self.cf.delay(4){
                        if(self.fuelquantity == nil){}
                        else{
                            if(self.fuelquantity > 0){
                                self.wait.isHidden = true
                                self.waitactivity.isHidden = true
                                self.waitactivity.stopAnimating()
                                self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                self.pulse.text = "\(self.Last_Count!)"
                                self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")//"Thank you for using \nFluidSecure!"

                                self.UsageInfoview.isHidden = false
                                self.Warning.isHidden = true


                                self.cf.delay(1){
                                    self.Transaction(fuelQuantity: self.fuelquantity)
//                                    print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
//                                    if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
//                                    else{
//
//                                    }
                                }
                                self.cf.delay(10){
                                    if (self.stopdelaytime == true){}
                                    else{
                                        Vehicaldetails.sharedInstance.gohome = true
                                        self.timerview.invalidate()
                                        let appDel = UIApplication.shared.delegate! as! AppDelegate

                                        appDel.start()
                                    }
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
            else {
                cf.delay(0.5) {     // takes a Double value for the delay in seconds

                    // put the delayed action/function here
                    if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                        _ = self.web.SetHoseNameReplacedFlag()
                    }
                    if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == true){
                        // self.getuser()
                        Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                    }else{}
                    self.cf.delay(4){
                        if(self.fuelquantity == nil){}
                        else{
                            if(self.fuelquantity > 0){
                                self.wait.isHidden = true
                                self.waitactivity.isHidden = true
                                self.waitactivity.stopAnimating()
                                self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                self.pulse.text = "\(self.Last_Count!)"
                                self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")//"Thank you for using \nFluidSecure!"

                                self.UsageInfoview.isHidden = false
                                self.Warning.isHidden = true

                                self.cf.delay(1){
                                    self.Transaction(fuelQuantity: self.fuelquantity)
//                                    print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
//                                    if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
//                                    else{
//
//                                    }
                                }
                                self.cf.delay(10){
                                    if (self.stopdelaytime == true){}
                                    else{
                                        Vehicaldetails.sharedInstance.gohome = true
                                        self.timerview.invalidate()
                                        let appDel = UIApplication.shared.delegate! as! AppDelegate

                                        appDel.start()
                                    }
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
        }
    }


    func Transaction(fuelQuantity:Double)
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location

        if(currentlocation == nil)
        {


        }
        else {
            sourcelat = Vehicaldetails.sharedInstance.Lat//currentlocation.coordinate.latitude
            sourcelong = Vehicaldetails.sharedInstance.Long//currentlocation.coordinate.longitude
            print (sourcelat,sourcelong)
        }
        let siteid = Vehicaldetails.sharedInstance.siteID
        let FuelTypeId = Vehicaldetails.sharedInstance.FuelTypeId
        var Odomtr = Vehicaldetails.sharedInstance.Odometerno
        if(Odomtr == ""){
            Odomtr = "0"
        }
        let Wifyssid = Vehicaldetails.sharedInstance.SSId
        let pusercount = Vehicaldetails.sharedInstance.pulsarCount

        let TransactionId = "\(Vehicaldetails.sharedInstance.TransactionId)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" //9/25/2017 10:21:41 AM"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let dtt: String = dateFormatter.string(from: NSDate() as Date)

        print(Wifyssid)
        print(Odomtr)

        let bodyData = "{\"SiteId\":\(siteid),\"CurrentOdometer\":\(Odomtr),\"FuelQuantity\":\((fuelQuantity)),\"TransactionId\":\(TransactionId),\"FuelTypeId\":\(FuelTypeId),\"WifiSSId\":\"\(Wifyssid)\",\"TransactionDate\":\"\(dtt)\",\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"VehicleNumber\":\"\(Vehicaldetails.sharedInstance.vehicleno)\",\"CurrentLat\":\"\(sourcelat!)\",\"CurrentLng\":\"\(sourcelong!)\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
        print(bodyData)

        let reply = web.Transactiondetails(bodyData: bodyData)
        if (reply == "-1")
        {
            let jsonstring: String = bodyData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            let dtt1: String = dateFormatter.string(from: Date())

            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId //Vehicaldetails.sharedInstance.siteName
            cf.preauthSaveTextFile(fileName: unsycnfileName, writeText: jsonstring)
            cf.delay(0.2){

            }
        }

        else{

            let data1:Data = reply.data(using: String.Encoding.utf8)!
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(sysdata)

            self.notify(site: Vehicaldetails.sharedInstance.SSId)
            cf.delay(0.2){

            }
        }
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "TransactionID",in: managedObjectContext)
        let ID = TransactionID(entity: entityDescription!, insertInto: managedObjectContext)

        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TransactionID")
        fetchRequest.returnsObjectsAsFaults = false
        let resultPredicate2 = NSPredicate (format:"(transactionid == %@)",TransactionId)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate2])
        fetchRequest.predicate = compound
        do{
            results = []
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
            print(results)
        } catch let error as NSError {
            print ("Error: \(error.domain)")
        }
        Transaction_ID = []
        Transaction_ID = results
        print(results)

        if (results == [])
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
            request.returnsObjectsAsFaults = false
            ID.isactive = "false"
            ID.transactionid = TransactionId as String

            do{
                try managedObjectContext.save()
            }catch let error as NSError {
                print ("Error: \(error.domain)")

            }
        }
        else {

            let count = Transaction_ID.count
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
            request.returnsObjectsAsFaults = false

            for i in 0  ..< count
            {
                let certificate = self.Transaction_ID[i]
                certificate.setValue( "true" as String, forKey: "isactive")
                certificate.setValue( TransactionId as String, forKey: "transactionid")

                do{
                    try managedObjectContext.save()

                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }

                let Transactioniddeatils = Transaction_id(isactive: "true",TransactionID: TransactionId as String)
                Vehicaldetails.sharedInstance.Transaction_id.add(Transactioniddeatils)
            }
        }
    }

    func notify(site:String) {


        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "open"
        localNotification.alertBody = NSLocalizedString("Notify", comment:"") + "\(site)."//Your Transaction is Successfully Completed at \(site)."
        localNotification.fireDate = Date(timeIntervalSinceNow: 1)
        localNotification.soundName = "button-24.mp3"//UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }

    @IBAction func Stop(sender: AnyObject) {
        //record = []
        let label1 = UILabel(frame: CGRect(x: 40, y: 80, width: 500, height: 21))
        y = y + 20
        label1.center = CGPoint(x: 80,y: y)
        label1.textAlignment = NSTextAlignment.center
        label1.textColor = UIColor.white
        label1.text = "Output: \(string)"

        stopButtontapped()
    }


    @IBAction func thankyouButtontapped(sender: AnyObject) {

        Vehicaldetails.sharedInstance.buttonset = true

    }

    func unsyncTransaction() -> String
    {
        if(stopbutton == true){
            s1 = string
            print(s1)

            if (Vehicaldetails.sharedInstance.reachblevia == "cellular")
            {
                web.sentlogFile()

                let logdata = self.cf.ReadFile(fileName: "Sendlog.txt")
                print(logdata)

                var reportsArray: [AnyObject]!
                let fileManager: FileManager = FileManager()
                let readdata = cf.getDocumentsURL().appendingPathComponent("data/test/")
                let fromPath: String = (readdata!.path)
                do{

                    do{ if(!FileManager.default.fileExists(atPath: fromPath))
                    {
                        do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                        }
                        catch{print("error")}
                        }
                    }

                    reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                    for x in 0  ..< reportsArray.count
                    {

                        let filename: String = "\(reportsArray[x])"
                        let Split = filename.components(separatedBy: "#")
                        let Transaction_id = Split[1]
                        let quantity = Split[2]
                        let siteName = Split[3]
                        if(quantity == "0" ){
                            web.UpgradeTransactionStatus(Transaction_id:Transaction_id,Status: "1")
                            self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                        }else if(quantity == "" ){
                            self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                        }

                        let JData: String = cf.preauthReadReportFile(fileName: filename)
                        if(JData != "")

                        {
                            if(siteName == "SaveTankMonitorReading"){
                                Upload(jsonstring: JData,filename: filename,siteName:"SaveTankMonitorReading")
                            }

                            else {
                                Upload(jsonstring: JData,filename: filename,siteName:"TransactionComplete")
                            }
                            if(ResponceMessageUpload == "success"){
                                self.notify(site: siteName)
                            }
                        }
                    }
                }
            }

            else if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
            {
                var reportsArray: [AnyObject]!
                let fileManager: FileManager = FileManager()
                let readdata = cf.getDocumentsURL().appendingPathComponent("data/test/")
                let fromPath: String = (readdata!.path)
                do{

                    do{ if(!FileManager.default.fileExists(atPath: fromPath))
                    {
                        do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                        }
                        catch{print("error")}
                        }
                    }

                    reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                    for x in 0  ..< reportsArray.count
                    {
                        let filename: String = "\(reportsArray[x])"
                        let Split = filename.components(separatedBy: "#")

                        let siteName = Split[1]

                        let JData: String = cf.preauthReadReportFile(fileName: filename)
                        if(JData != "")
                        {
                            Upload(jsonstring: JData,filename: filename,siteName:"TransactionComplete")
                        }
                    }
                }
            }
            stopbutton = false
        }
        return "False"
    }


    func preauthunsyncTransaction() -> String
    {
        if (Vehicaldetails.sharedInstance.reachblevia == "cellular")
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/preauth/")
            let fromPath: String = (readdata!.path)
            do{

                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                    }
                }


                reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                for x in 0  ..< reportsArray.count
                {
                    let filename: String = "\(reportsArray[x])"
                    let Split = filename.components(separatedBy: "#")
                    let siteName = Split[1]

                    let JData: String = cf.preauthReadReportFile(fileName: filename)
                    if(JData != "")
                    {
                        Upload(jsonstring: JData,filename: filename,siteName:"SavePreAuthTransactions")
                        return "true"
                    }
                }
            }
        }

        else if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/preauth/")
            let fromPath: String = (readdata!.path)
            do{

                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                    }
                }

                reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                for x in 0  ..< reportsArray.count
                {
                    let filename: String = "\(reportsArray[x])"
                    let Split = filename.components(separatedBy: "#")

                    let siteName = Split[1]

                    let JData: String = cf.preauthReadReportFile(fileName: filename)
                    if(JData != "")
                    {
                        Upload(jsonstring: JData,filename: filename,siteName:"SavePreAuthTransactions")
                    }
                }
            }
        }
        return "False"
    }

    @IBAction func Fuelhistory(sender: AnyObject) {


    }

//
    func Upload(jsonstring: String,filename:String,siteName:String)
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + siteName + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = cf.convertStringToBase64(string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        print(jsonstring)
        request.httpBody = jsonstring.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                print(self.sysdata1)

                let ResponceText = self.sysdata1.value(forKey: "ResponceText") as! NSString

                self.ResponceMessageUpload = (self.sysdata1.value(forKey: "ResponceMessage") as! NSString) as String

                if(self.ResponceMessageUpload == "fail"){
                    if(ResponceText == "TransactionId not found."){
                        self.cf.preauthDeleteReportTextFile(fileName: filename, writeText: "")
                    }
                    self.cf.preauthDeleteReportTextFile(fileName: filename, writeText: "")
                }
                if(self.ResponceMessageUpload == "success"){
                    self.cf.preauthDeleteReportTextFile(fileName: filename, writeText: "")
                }

            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }


    @IBAction func beginFueling(sender: AnyObject) {


    }

    func btnBeginFueling() {

        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        let defaultTimeZoneStr2 = formatter.string(from: Date());
        print("before GetPulser" + defaultTimeZoneStr2)
        self.cf.delay(0.2){

            self.GetPulser() ///
            self.quantity = []

            let defaultTimeZoneStr = formatter.string(from: Date());
            print("Get Pulsar1" + defaultTimeZoneStr)
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
            let defaultTimeZoneStr1 = formatter.string(from: Date());
            print("after GetPulser" + defaultTimeZoneStr1)
            print(self.timer)
        }
    }


    @objc func GetPulser() {
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
        {
            self.web.sentlog(func_name: "In Preauthorized Transaction Getpulsar function lost Wifi connection with the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
            cf.delay(1) {
                self.timer.invalidate()
                self.Stop.isHidden = true
                self.displaytime.text = "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("LostWifi", comment:"")// WiFi Connection lost with mobile."
                self.timer.invalidate()
                // put the delayed action/function here
                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                    _ = self.web.SetHoseNameReplacedFlag()
                }

                if(Vehicaldetails.sharedInstance.PulseRatio == "" || Vehicaldetails.sharedInstance.pulsarCount == "" ){
                    self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                } else{
                    let quantitycount = Vehicaldetails.sharedInstance.pulsarCount
                    let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
                    self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
                    self.cf.delay(1){
                        if(self.fuelquantity == nil){
                            self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                        }
                        else{
                            if(self.fuelquantity > 0){
                                self.wait.isHidden = true
                                self.waitactivity.isHidden = true
                                self.waitactivity.stopAnimating()
                                self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                self.pulse.text = "\(self.Last_Count!)"
                                print(self.counts)
                                self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")//"Thank you for using \nFluidSecure!"
                                self.UsageInfoview.isHidden = false
                                self.Warning.isHidden = true
                                self.cf.delay(1){
                                    self.Transaction(fuelQuantity: self.fuelquantity)

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
                                            let appDel = UIApplication.shared.delegate! as! AppDelegate
                                            self.web.sentlog(func_name: "stoprelay function", errorfromserverorlink: "", errorfromapp: "")
                                            appDel.start()
                                        }
                                    }
                                    if (self.stopdelaytime == true){}
                                    else{
                                        Vehicaldetails.sharedInstance.gohome = true
                                        self.timerview.invalidate()
                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                                        self.web.sentlog(func_name: "stoprelay function", errorfromserverorlink: "", errorfromapp: "")
                                        appDel.start()
                                    }
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
            self.timerview.invalidate()
        }
        else {
            let dateFormatter = DateFormatter()
            Warning.text = NSLocalizedString("Warningfueling", comment:"")
            Warning.isHidden = false
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let defaultTimeZoneStr = dateFormatter.string(from: Date());

            print("before GetPulser" + defaultTimeZoneStr)
            //cf.delay(0.5) {
            let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
            print("before send GetPulser" + defaultTimeZoneStr1)
            let replyGetpulsar1 = web.GetPulser()

            print(replyGetpulsar1)
            let Split = replyGetpulsar1.components(separatedBy: "#")
            reply1 = Split[0]
            let error = Split[1]

            if(self.reply1 == nil || self.reply1 == "-1")
            {
                let text = reply1//error.localizedDescription + error.debugDescription
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.web.sentlog(func_name: "In Preauthorized Transaction StartButtontapped GetPulsar Function", errorfromserverorlink: "\(newString)", errorfromapp: "")
                timer_noConnection_withlink = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
            }
            else{
                timer_noConnection_withlink.invalidate()
                let data1 = self.reply1.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    let text = error.localizedDescription + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    print ("Error: \(error.domain)")
                    self.web.sentlog(func_name: "In Preauthorized Transaction StartButtontapped GetPulsar Function ", errorfromserverorlink: "\(newString)", errorfromapp: "")
                }

                if(self.sysdata1 == nil){}
                else
                {
                    let text = reply1
                    let test = String((text?.filter { !" \n".contains($0) })!)
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    self.web.sentlog(func_name: "In Preauthorized Transaction StartButtontapped GetPulsar Function ", errorfromserverorlink: "Response from link $$ \(newString)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                    let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary

                    let counts = objUserData.value(forKey: "counts") as! NSString
                    let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
                    let pulsar_secure_status = objUserData.value(forKey: "pulsar_secure_status") as! NSNumber

                    if (counts == ""){
                        self.emptypulsar_count += 1
                        if(self.emptypulsar_count == 3){
                            Vehicaldetails.sharedInstance.gohome = true
                            self.timerview.invalidate()
                            let appDel = UIApplication.shared.delegate! as! AppDelegate
                            self.web.sentlog(func_name: "In Preauthorized Transaction get emptypulsar_count function", errorfromserverorlink: "", errorfromapp: "")
                            appDel.start()
                        }

                    } else {
                        self.emptypulsar_count = 0
                        if (counts != "0"){


                            print(self.tpulse.text!, counts)
                            if (self.tpulse.text! == (counts as String) as String){

                            }
                            if(Last_Count == nil){
                                Last_Count = "0.0"
                            }

                            if(counts.doubleValue >= (Last_Count as NSString).doubleValue)
                            {
                                timer_quantityless_thanprevious.invalidate()
                                self.Last_Count = counts as String?
                                let v = self.quantity.count
                                let fuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                                let y = Double(round(100*fuelQuan)/100)

                               // self.tquantity.text = "\(y)"// + "Gallon"
                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                    let y = Double(round(100*fuelQuan)/100)
                                    self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                    print(self.tquantity.text!)
                                }
                                else {
                                    let y = Double(round(100*fuelQuan)/100)
                                    self.tquantity.text = "\(y) "

                                }

                                self.tpulse.text = (counts as String) as String
                                self.quantity.append("\(y) ")

                                print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
                                let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                                print("Inside loop GetPulser" + defaultTimeZoneStr1)
                                if(v >= 2){
                                    print(self.quantity[v-1],self.quantity[v-2])
                                    if(self.quantity[v-1] == self.quantity[v-2]){
                                        self.total_count += 1
                                        if(self.total_count == 3){

                                            self.cf.delay((Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue){
                                                self.timer.invalidate()
                                                _ = self.tcpcon.setralay0tcp()
                                                _ = self.tcpcon.setpulsar0tcp()
                                                self.displaytime.text = NSLocalizedString("autostop", comment:"")//"app autostop because pulsecount getting is same."
                                                self.Stop.isHidden = true
                                                self.stoprelay()
                                            }
                                        }
                                    }
                                    else {
                                        self.total_count = 0


                                        if(pulsar_secure_status == 0){

                                        }
                                        else if(pulsar_secure_status == 1)
                                        {
                                            self.displaytime.text = "5"
                                        }

                                        else if(pulsar_secure_status == 2)
                                        {
                                            self.displaytime.text = "4"
                                        }

                                        else if(pulsar_secure_status == 3)
                                        {
                                            self.displaytime.text = "3"
                                        }

                                        else if(pulsar_secure_status == 4)
                                        {
                                            self.displaytime.text = "2"
                                        }

                                        else if(pulsar_secure_status == 5)
                                        {
                                            self.displaytime.text = "1 \n \n " + NSLocalizedString("Pulsardisconnected", comment: "")//"1 \n \n Pulsar disconnected"
                                            self.stopButtontapped()
                                        }

                                        if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                                        else{

                                            if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(fuelQuan)){

                                                _ = self.web.SetPulser0()
                                                print(Vehicaldetails.sharedInstance.MinLimit)
                                                self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:""))//"You are fuel day limit reached.")
                                                self.stopButtontapped()
                                            }
                                        }
                                    }
                                }
                            }
                            else{
                                timer_quantityless_thanprevious.invalidate()
                                timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
                                print("lower qty. than the prior one.")
                            }
                            if(pulsar_status == 0)
                            {
                                _ = self.tcpcon.setpulsar0tcp()
                                self.stoprelay()
                            }
                        }
                        else{

                            let v = self.quantity.count
                            let fuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                            let y = Double(round(100*fuelQuan)/100)

                            self.quantity.append("\(y) ")

                            print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
                            let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                            print("Inside loop GetPulser" + defaultTimeZoneStr1)
                            if(v >= 2){
                                if(self.self.quantity[v-1] == self.quantity[v-2]){
                                    self.total_count += 1
                                    if(self.total_count == 3){

                                        self.cf.delay((Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue){
                                            self.timer.invalidate()
                                            _ = self.tcpcon.setralay0tcp()
                                            _ = self.tcpcon.setpulsar0tcp()
                                            self.displaytime.text = NSLocalizedString("autostop", comment:"")//"app autostop because pulsecount getting is same."
                                            self.Stop.isHidden = true
                                            self.stoprelay()
                                        }
                                    }
                                }
                            }
                        }
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

        timer.invalidate()
        stoptimergotostart.invalidate()
        self.cf.delay(0.1){
            Vehicaldetails.sharedInstance.gohome = true
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
            self.web.sentlog(func_name: "OKbuttontapped", errorfromserverorlink: "", errorfromapp: "")
            self.stopdelaytime = true
        }
    }
}

