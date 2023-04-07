//
//  SelectHose.swift
//  FluidSecureWatchOS Extension
//
//  Created by apple on 14/04/21.
//  Copyright © 2021 VASP. All rights reserved.
//

import WatchKit
import UIKit
import CoreLocation


extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}
class SelectHose: WKInterfaceController, CLLocationManagerDelegate {
    
    //remove duplicates SSID from an Array
    
    var reply :String!
    
    var  URL = "https://www.fluidsecure.net/"//"http://sierravistatest.cloudapp.net/"//"https://www.fluidsecure.net/"
//    var reply1 :String!

    let defaults = UserDefaults.standard
    var IsDepartmentRequire:String!
    var IsUseBarcode:String!
    var IsPersonnelPINRequire:String!
    var IsOtherRequire:String!
    var OtherLabel:String!
    var timeout:String!
    var IsOdoMeterRequire:String!
    var IsVehicleNumberRequire:String!
    var IsLoginRequire:String!
    var IsBusy :String!
    
    var currentlocation :CLLocation!
    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!
    
    var sysdata:NSDictionary!
    var systemdata:NSDictionary!
    var isnotapprove:Bool = false
    
    var ssid = [WKPickerItem]()
    var Pass = [String]()
    var location = [String]()
    var ReplaceableHosename = [String]()
    var Ulocation = [String]()
    var siteID = [String]()
    var HoseId = [String]()
    var Is_upgrade = [String]()
    var pulsartimeadjust = [String]()
    var IFISBusy = [String]()
    var Is_HoseNameReplaced = [String]()
    var IFIsDefective = [String]()
    var Uhosenumber = [String]()
    var TransactionId = [String]()
    var TLDCall = [String]()
    var IsTank_Empty = [String]()
    var Communication_Type = [String]()
    var groupAdminCompanyListCompanyID = [String]()
    var groupAdminCompanyList = [String]()
    var Bluetooth_MacAddress = [String]()
    var Mac_Address = [String]()
    var IsLink_Flagged = [String]()
    var LinkFlagged_Message = [String]()

    var IsGobuttontapped : Bool = false
    var now:Date!
    var selectedhose = ""
    
    var ResponceMessageUpload:String = ""
    var sysdata1:NSDictionary!
    var uuid:String = ""
    var web = Webservice()
    var fVC = InterfaceController()
//    var logindata = LoginViewController()
    
    
    
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var HoseList: WKInterfacePicker!
    @IBOutlet weak var Label: WKInterfaceTextField!
    
    @IBOutlet weak var register: WKInterfaceButton!
    
    @IBOutlet weak var refreshscreen: WKInterfaceButton!
    @IBOutlet weak var GOButton: WKInterfaceButton!
    @IBAction func GotoRegister() {
        
        contextForSegue(withIdentifier: "Registration")
       
    }
    
    @IBAction func Hose_List(_ value: Int) {
        
        let data = ssid[value]
        selectedhose = String(data.title!)
        print(selectedhose)
        Vehicaldetails.sharedInstance.SSId = selectedhose
        let siteid = siteID[value]
       
        let hoseid = HoseId[value]
        let Password = Pass[value]
        //self.HoseList.setItems(ssid[0])
        let isupgrade = Is_upgrade[value]
        let pulsartime_adjust = pulsartimeadjust[value]
        let CommunicationLinkType = Communication_Type[value]
        Vehicaldetails.sharedInstance.siteID = siteid
        //Vehicaldetails.sharedInstance.SSId = ssId[0].title
        Vehicaldetails.sharedInstance.HoseID = hoseid
        Vehicaldetails.sharedInstance.password = Password
        Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
        Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
        Vehicaldetails.sharedInstance.IsBusy = IsBusy
        Vehicaldetails.sharedInstance.IsDefective = IFIsDefective[value]
     Vehicaldetails.sharedInstance.HubLinkCommunication = CommunicationLinkType
        Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[value]
        Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[value]
        Vehicaldetails.sharedInstance.IsLinkFlagged = IsLink_Flagged[value]
        Vehicaldetails.sharedInstance.LinkFlaggedMessage = LinkFlagged_Message[value]
        Vehicaldetails.sharedInstance.FS_MacAddress = Mac_Address[value]
        Vehicaldetails.sharedInstance.BTMacAddress = Bluetooth_MacAddress[value]
        Vehicaldetails.sharedInstance.URL = "https://www.fluidsecure.net/"//"http://sierravistatest.cloudapp.net/"//"https://www.fluidsecure.net"
        print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced)
        
        }
    
    override func awake(withContext context: Any?) {
        
       // let checkaprovedata = checkApprove(uuid: "6F90251E-71F2-449D-A721-31C1D1669E24" as String,lat:"\(18.479963)",long:"\(73.821659)")
//        var info = Getinfo()
        
        register.setHidden(true)
        image.setHidden(false)
        HoseList.setHidden(false)
        GOButton.setHidden(false)
        refreshscreen.setHidden(true)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        
        var password = KeychainService.loadPassword()
        if(password == nil || password == "" || defaults.string(forKey: "uuid") == "")
        {
            uuid = WKInterfaceDevice.current().identifierForVendor!.uuidString
            print(uuid)
            KeychainService.savePassword(token: uuid as NSString)
            //let uuid:String = WKInterfaceDevice.current().identifierForVendor!.uuidString
           
        }
        else{
             password = KeychainService.loadPassword()
            print(password!)//used this paasword (uuid)
            if(password == "")
            {
                uuid = defaults.string(forKey: "uuid")!
            }
            else{
                
            uuid = password! as String
            }
        }
        web.sentlogFile()
        getdata()
        Vehicaldetails.sharedInstance.URL = "https://www.fluidsecure.net/"//"http://sierravistatest.cloudapp.net/"//"https://www.fluidsecure.net"
        
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
    
    let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.default) {
            print("Ok")
        
        }
    
    func getdata()
    {
      
        //let UUID = logindata.keychaindata()
       // print(UUID)
        
        
        sourcelat = currentlocation.coordinate.latitude
        sourcelong = currentlocation.coordinate.longitude
        print (sourcelat!,sourcelong!)
        Vehicaldetails.sharedInstance.Lat = sourcelat!
        let checkaprovedata = checkApprove(uuid: uuid,lat:"\(sourcelat!)",long:"\(sourcelong!)")

        print(checkaprovedata)
        if(checkaprovedata == "-1")
        {
            getdata()
            
        }
        else{
        let data1:Data = checkaprovedata.data(using: String.Encoding.utf8)!
        do {
            sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
        }catch let error as NSError {
            
            print ("Error: \(error.domain)")
        }
       // print(sysdata)
        if(sysdata == nil){
        }
        else{
         groupAdminCompanyList = []
         groupAdminCompanyListCompanyID = []
            
            let Message = sysdata["ResponceMessage"] as! NSString
            let ResponseText = sysdata["ResponceText"] as! NSString
            if(Message == "success") {
               
                let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
                let CompanyName = objUserData.value(forKey: "CompanyName") as! NSString
                let Email = objUserData.value(forKey: "Email") as! NSString
                let IMEI_UDID = objUserData.value(forKey: "IMEI_UDID") as! NSString
                let IsApproved = objUserData.value(forKey: "IsApproved") as! NSString
                let PersonName = objUserData.value(forKey: "PersonName") as! NSString
                let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
             
                let CollectDiagnosticLogs = objUserData.value(forKey: "CollectDiagnosticLogs") as! NSString
                IsVehicleNumberRequire = objUserData.value(forKey: "IsVehicleNumberRequire") as! NSString as String
                let ScreenNameForHours = objUserData.value(forKey: "ScreenNameForHours") as! String
                let ScreenNameForOdometer = objUserData.value(forKey: "ScreenNameForOdometer") as! String
                let ScreenNameForPersonnel = objUserData.value(forKey: "ScreenNameForPersonnel") as! String
                let ScreenNameForVehicle = objUserData.value(forKey: "ScreenNameForVehicle") as! String

                Vehicaldetails.sharedInstance.ScreenNameForVehicle = ScreenNameForVehicle
                Vehicaldetails.sharedInstance.ScreenNameForPersonnel = ScreenNameForPersonnel
                Vehicaldetails.sharedInstance.ScreenNameForHours = ScreenNameForHours
                Vehicaldetails.sharedInstance.ScreenNameForOdometer = ScreenNameForOdometer
               

                IsOdoMeterRequire = objUserData.value(forKey: "IsOdoMeterRequire") as! NSString as String
                IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
                IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
                IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
                IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
                OtherLabel = objUserData.value(forKey:"OtherLabel") as!NSString as String
                timeout = objUserData.value(forKey:"TimeOut") as!NSString as String
                IsUseBarcode = objUserData.value(forKey: "UseBarcode") as! NSString as String
                Vehicaldetails.sharedInstance.CompanyBarndName = (objUserData.value(forKey: "CompanyBrandName") as! NSString) as String
                Vehicaldetails.sharedInstance.CompanyBrandLogoLink = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
                Vehicaldetails.sharedInstance.IsVehicleNumberRequire = IsVehicleNumberRequire
            // self.navigationItem.title = Vehicaldetails.sharedInstance.CompanyBarndName
                setTitle(Vehicaldetails.sharedInstance.CompanyBarndName)
             
            
             
                if(IsVehicleNumberRequire == "False")
                {
                   // Vehicaldetails.sharedInstance.vehicleno = ""
                  //  Vehicaldetails.sharedInstance.Odometerno = "0"
                }
                else if(IsVehicleNumberRequire == "True"){

                }

//                infotext.text =  NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") +  ": \(Email) \n"
                
//                Companynamelabel.text = NSLocalizedString("Company Name", comment:"") + ": \(CompanyName)"
//                Companynamelabel.lineBreakMode = .byWordWrapping
//                infotext.lineBreakMode = .byWordWrapping
                
             
                Vehicaldetails.sharedInstance.CollectDiagnosticLogs = CollectDiagnosticLogs as String
                Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
                Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
                Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
                Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
                Vehicaldetails.sharedInstance.Otherlable = OtherLabel
                Vehicaldetails.sharedInstance.TimeOut = timeout
                                       // Vehicaldetails.sharedInstance.IsUseBarcode = IsUseBarcode

                defaults.set(PersonName, forKey: "firstName")
                defaults.set(Email, forKey: "address")
                defaults.set(PhoneNumber, forKey: "mobile")
                defaults.set(uuid, forKey: "uuid")
                defaults.set(1, forKey: "Register")
               // Vehicaldetails.sharedInstance.AppType = "AuthTransaction"
                print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)

           //  web.sentlog(func_name: "Name : \(PersonName)", errorfromserverorlink: "Company : \(CompanyName)", errorfromapp: "Email : \(Email)")
             
             //Vehicaldetails.sharedInstance.SupportPhonenumber = (objUserData.value(forKey: "SupportPhonenumber") as! NSString) as String
                             //   Vehicaldetails.sharedInstance.SupportEmail = (objUserData.value(forKey: "SupportEmail") as! NSString) as String
                             //   Vehicaldetails.sharedInstance.CompanyBarndName = (objUserData.value(forKey: "CompanyBrandName") as! NSString) as String
                let companybrandlogo = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
                if(defaults.string(forKey: "companylogolink") == nil)
                {
                    defaults.set("", forKey: "companylogolink")
                }
               // print(defaults.string(forKey: "companylogolink")!,Vehicaldetails.sharedInstance.CompanyBrandLogoLink)
//                if(defaults.string(forKey: "companylogolink") != Vehicaldetails.sharedInstance.CompanyBrandLogoLink || defaults.string(forKey: "companylogolink") == "")
//                {
//                    defaults.set(companybrandlogo, forKey: "companylogolink")
//                    cf.createDirectory()
//                    weak var LogoImage:UIImage? = web.downloadCompanylogoImage()
//                    cf.saveImageDocumentDirectory(Image: LogoImage!)
//                image.image = LogoImage
//                }
//                else if(defaults.string(forKey: "companylogolink") == Vehicaldetails.sharedInstance.CompanyBrandLogoLink)
//                {   //    Get Image from Document Directory :
//
//                    let fileManager = FileManager.default
//
//                    let imagePAth = (cf.getDirectoryPath() as NSString).appendingPathComponent("logoimage.jpg")
//
//                    if fileManager.fileExists(atPath: imagePAth){
//                        let url = Bundle.main.url(forAuxiliaryExecutable: imagePAth)// (forResource: "image", withExtension: "png")!
//                            let imageData = try! Data(contentsOf: url!)
//                                                  // let _ = UIImage(data: imageData)
//                        self.Companylogo.image = UIImage(data: imageData)//UIImage(contentsOfFile: imagePAth)
//
//                        //self.Companylogo.image = UIImage(contentsOfFile: imagePAth)
//
//                    }else{
//                        print("No Image")
//                    }
//                }
            }

            else if(Message == "fail"){ }

           // defaults.set(uuid, forKey: "uuid")
            if(Message == "success") {
                refreshscreen.setHidden(true)
                //isnotapprove = true
                image.setHidden(false)
                HoseList.setHidden(false)
                register.setHidden(true)
                GOButton.setHidden(false)
//                scrollview.isHidden = false
//                version.isHidden = true
//                warningLable.isHidden = true
//                refreshButton.isHidden = true
//                preauth.isHidden = true

//                supportinfo.text = "Support:\(Vehicaldetails.sharedInstance.SupportEmail) or " + "\(Vehicaldetails.sharedInstance.SupportPhonenumber)"
//                self.wifiNameTextField.placeholder = NSLocalizedString("Touch Here To Select Hose", comment:"")
//
//                self.wifiNameTextField.textColor = UIColor.white
//                self.wifiNameTextField.inputView = pickerViewLocation
//                self.pickerViewLocation.delegate = self

                do {
                    _ = defaults.string(forKey: "firstName")
                    _ = defaults.string(forKey: "address")
                    _ = defaults.string(forKey: "mobile")
                    _ = defaults.string(forKey: "uuid")

                    //IF USER IF Approved Get information from server like site,ssid,pwd,hose
                    do{
                        systemdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    }catch let error as NSError {
                        print ("Error: \(error.domain)")
                        print ("Error: \(error)")
                    }
                   // print(systemdata)
                    ssid = []
                    IFISBusy = []
                    IsTank_Empty = []
                    HoseId = []
                    Pass = []
                    Is_upgrade = []
                    IFIsDefective = []
                    Uhosenumber = []
                    Is_HoseNameReplaced = []
                    ReplaceableHosename = []
                    IsLink_Flagged = []
                    LinkFlagged_Message = []
                     Bluetooth_MacAddress = []
                     Mac_Address = []
                
                    defaults.removeObject(forKey: "SSID")
                    let Json = systemdata.value(forKey: "SSIDDataObj") as! NSArray
                    let rowCount = Json.count
                    let index: Int = 0
                    for i in 0  ..< rowCount
                    {
                        let JsonRow = Json[i] as! NSDictionary
                        let Message = JsonRow["ResponceMessage"] as! NSString
                        let ResponseText = JsonRow["ResponceText"] as! NSString
                        if(Message == "success") {

                            let JsonRow = Json[i] as! NSDictionary
                            let SiteName = JsonRow["SiteName"] as! NSString
                            location.append(SiteName as String)
                            let ReplaceableHoseName = JsonRow["ReplaceableHoseName"] as! NSString
                            ReplaceableHosename.append(ReplaceableHoseName as String)

                            print(ssid)
                            //defaults.set(ssid, forKey: "SSID")
                            defaults.set(siteID, forKey: "SiteID")
                            Ulocation = location.removeDuplicates()

                            if(Ulocation[index] == SiteName as String){
                                let WifiSSId = JsonRow["WifiSSId"] as! NSString
                                let Password = JsonRow["Password"] as! NSString
                                let hosename = JsonRow["HoseNumber"] as! NSString
                                let Sitid = JsonRow["SiteId"] as! NSString
                                let HoseID = JsonRow["HoseId"] as! NSString
                                let IsUpgrade = JsonRow["IsUpgrade"] as! NSString
                                let IsHoseNameReplaced = JsonRow["IsHoseNameReplaced"] as! NSString
                                IsBusy = JsonRow["IsBusy"] as! NSString as String
                                 let IsTankEmpty = JsonRow["IsTankEmpty"] as! NSString as String
                                //                                        let MacAddress = JsonRow["MacAddress"] as! NSString
                                let PulserTimingAdjust = JsonRow["PulserTimingAdjust"] as! NSString
                                let IsDefective = JsonRow["IsDefective"] as!NSString
                                let IsTLDCall = JsonRow["IsTLDCall"] as! NSString
                                let IsLinkFlagged = JsonRow["IsLinkFlagged"] as! NSString  as String
                                let LinkFlaggedMessage =  JsonRow["LinkFlaggedMessage"] as! NSString as String
                                let MacAddress = JsonRow["MacAddress"] as! NSString as String
                                let BluetoothMacAddress = JsonRow["BluetoothMacAddress"] as! NSString as String
                             let HubLinkCommunication = JsonRow["HubLinkCommunication"] as! NSString
                                print(WifiSSId)
                                if (WifiSSId != ""){
                                let k = WKPickerItem()
                                k.title = WifiSSId as String
                                ssid.append(k)
                                    HoseList.setItems(ssid)
                                    HoseList.setEnabled(true)
                                }
                                
                                IFISBusy.append(IsBusy as String)
                                location.append(SiteName as String)
                                Pass.append(Password as String)
                                Uhosenumber.append(hosename as String)
                                siteID.append(Sitid as String)
                                HoseId.append(HoseID as String)
                                Is_upgrade.append(IsUpgrade as String)
                                IFIsDefective.append(IsDefective as String)
                                pulsartimeadjust.append(PulserTimingAdjust as String)
                                Is_HoseNameReplaced.append(IsHoseNameReplaced as String)
                                TLDCall.append(IsTLDCall as String)
                                Communication_Type.append(HubLinkCommunication as String)
                             IsTank_Empty.append(IsTankEmpty as String)
                                IsLink_Flagged.append(IsLinkFlagged as String)
                                LinkFlagged_Message.append(LinkFlaggedMessage as String)
                                Bluetooth_MacAddress.append(BluetoothMacAddress as String)
                                Mac_Address.append(MacAddress as String)
                                print(Uhosenumber)
                            }

                         
/// let obj_UserData = sysdata.value(forKey: "groupAdminCompanyListObj") as! NSDictionary
                         

let objUserData = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
                          
                                               //get Fuel limit per day from server
let FuelLimitPerDay = objUserData.value(forKey: "FuelLimitPerDay") as! NSString
let FuelLimitPerTxn = objUserData.value(forKey:"FuelLimitPerTxn") as! NSString
let PreAuthDataDwnldFreq = objUserData.value(forKey: "PreAuthDataDwnldFreq") as! NSString
let PreAuthDataDownloadDay = objUserData.value(forKey:"PreAuthDataDownloadDay") as! NSString
let PreAuthDataDownloadTimeInHrs = objUserData.value(forKey: "PreAuthDataDownloadTimeInHrs") as! NSString
let PreAuthDataDownloadTimeInMin = objUserData.value(forKey:"PreAuthDataDownloadTimeInMin") as! NSString
let PreAuthVehicleDataFilePath = objUserData.value(forKey: "PreAuthVehicleDataFilePath") as! NSString as String
let PreAuthVehicleDataFilesCount = objUserData.value(forKey:"PreAuthVehicleDataFilesCount") as! NSString
                      
//            Vehicaldetails.sharedInstance.PreAuthDataDwnldFreq = PreAuthDataDwnldFreq as String
//           Vehicaldetails.sharedInstance.PreAuthDataDownloadDay = PreAuthDataDownloadDay as String
//                            Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath = PreAuthVehicleDataFilePath.trimmingCharacters(in: .whitespacesAndNewlines)
//                            Vehicaldetails.sharedInstance.PreAuthDataDownloadTimeInMin = PreAuthDataDownloadTimeInMin as String
//                            Vehicaldetails.sharedInstance.PreAuthDataDownloadTimeInHrs = PreAuthDataDownloadTimeInHrs as String
//                            Vehicaldetails.sharedInstance.PreAuthVehicleDataFilesCount = PreAuthVehicleDataFilesCount as String
                            
                            
                            
                            let PreAuthJson = objUserData.value(forKey: "TransactionObj") as! NSArray
                            let PreAuthrowCount = PreAuthJson.count
                         if(PreAuthrowCount > 0 )
                         {
//                             let data = web.GetVehiclesForPhone()
//                             print(data)
                         }
                            for i in 0  ..< PreAuthrowCount
                            {
                                let PreAuthJsonRow = PreAuthJson[i] as! NSDictionary
                                let MessageTransactionObj = PreAuthJsonRow["ResponceMessage"] as! NSString

                             if(MessageTransactionObj == "success"){
                                    let T_Id = PreAuthJsonRow["TransactionId"] as! NSString
                                    TransactionId.append(T_Id as String)
                                }
                            }
                        }
                        else if(Message == "fail")
                        {
//                            self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//                            scrollview.isHidden = true
//                            version.isHidden = false
//                            warningLable.isHidden = false
//                            refreshButton.isHidden = false
                            Label.setText("\(ResponseText)")//no hose found Please contact administrater"
                        }
                    }
                    
                    
                    if(Uhosenumber.count == 1)
                    {
                        let siteid = siteID[0]
                        let ssId = ssid[0]
                        let hoseid = HoseId[0]
                        let Password = Pass[0]
                        //self.HoseList.setItems(ssid[0])
                        let isupgrade = Is_upgrade[0]
                        let pulsartime_adjust = pulsartimeadjust[0]
                        let CommunicationLinkType = Communication_Type[0]
                        Vehicaldetails.sharedInstance.siteID = siteid
                        let data = ssid[0]
                        selectedhose = String(data.title!)
                        print(selectedhose)
                        Vehicaldetails.sharedInstance.SSId = selectedhose
                        
                        print(Vehicaldetails.sharedInstance.SSId)
                        Vehicaldetails.sharedInstance.HoseID = hoseid
                        Vehicaldetails.sharedInstance.password = Password
                        Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
                        Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
                        Vehicaldetails.sharedInstance.IsBusy = IsBusy
                        Vehicaldetails.sharedInstance.IsDefective = IFIsDefective[0]
                     Vehicaldetails.sharedInstance.HubLinkCommunication = CommunicationLinkType
                        Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[0]
                        Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[0]
                        Vehicaldetails.sharedInstance.IsLinkFlagged = IsLink_Flagged[0]
                        Vehicaldetails.sharedInstance.LinkFlaggedMessage = LinkFlagged_Message[0]
                        Vehicaldetails.sharedInstance.FS_MacAddress = Mac_Address[0]
                        Vehicaldetails.sharedInstance.BTMacAddress = Bluetooth_MacAddress[0]
//                        print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced)

                       
//                        delay(0.2){
                            if( self.IsGobuttontapped == true){

                            }
                            else{

                            }
//                        }
                    }
                }
            }

                //USER IS NOT REGISTER TO SYSTEM
            else if(ResponseText == "New Registration") {
                presentAlert(withTitle: "", message:"Please Register", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                register.setHidden(false)
                image.setHidden(true)
                Label.setText("Please Register.")
                HoseList.setHidden(true)
                GOButton.setHidden(true)
                
                contextForSegue(withIdentifier: "Registration")
                //(withNamesAndContexts: [(name: "Registration", context: AnyObject)]) //reloadRootPageControllers(withNames: ["Registration"], contexts: [Any]?, orientation: WKPageOrientation, pageIndex: Int)
                    
                //self.presentController(withName: "Registration", context: nil)
//                let appDel = UIApplication.shared.delegate! as! AppDelegate
//                defaults.set(0, forKey: "Register")
//                self.web.sentlog(func_name: "New Registration", errorfromserverorlink: "", errorfromapp: "")
//                // Call a method on the CustomController property of the AppDelegate
//                appDel.start()
            }

            else if(Message == "fail") {

                if(ResponseText == "New Registration")
                {
                    register.setHidden(false)
                    image.setHidden(false)
                    Label.setText("Please Register your self.")
                    HoseList.setHidden(false)

                }
                else
                    if(ResponseText == "notapproved")
                    {
                        presentAlert(withTitle: "", message:NSLocalizedString("Regisration", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                        defaults.set("false", forKey: "checkApproved")
                        refreshscreen.setTitle("Refresh")
                        refreshscreen.setHidden(false)
                        isnotapprove = true
                        image.setHidden(true)
                        HoseList.setHidden(true)
                        register.setHidden(true)
                        GOButton.setHidden(true)
//                        scrollview.isHidden = true
//                        version.isHidden = false
//                        warningLable.isHidden = false
//                        refreshButton.isHidden = false
//                        preauth.isHidden = true
//                        self.navigationItem.title = "Thank you for registering"
//                        warningLable.text = NSLocalizedString("Regisration", comment:"")
//                         + " " +  defaults.string(forKey: "address")! + " " +  NSLocalizedString("registration1", comment:"")
                    }else
                    {
//                        scrollview.isHidden = true
//                        version.isHidden = false
//                        warningLable.isHidden = false
//                        refreshButton.isHidden = false
//                        self.navigationItem.title = NSLocalizedString("Error",comment:"")
//                        warningLable.text = ResponseText as String
                }

                //                        defaults.set("false", forKey: "checkApproved")
                //                        scrollview.isHidden = true
                //                        version.isHidden = false
                //                        warningLable.isHidden = false
                //                        refreshButton.isHidden = false
                //                        self.navigationItem.title = NSLocalizedString("Error",comment:"")
                //                        warningLable.text = NSLocalizedString("Regisration", comment:"")
                //                    } else if(ResponseText == "New Registration") {
                //                        performSegue(withIdentifier: "Register", sender: self)
            }
        }
    
    
        }
    
    // Do any additional setup after loading the view, typically from a nib.
    
}
    
    func convertStringToBase64(_ string: String) -> String
    {
        let plainData = string.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
    
    func checkApprove(uuid:String,lat:String!,long:String!)->String {
//        if(Vehicaldetails.sharedInstance.Language == ""){
//            ///Vehicaldetails.sharedInstance.Language = "en-ES"
//        }
        defaults.set("", forKey: "address")
        let Url:String = URL + "HandlerTrak.ashx"
        var Email :String
        if(defaults.string(forKey: "address") == nil){
            Email = ""
        }else {
            Email = defaults.string(forKey: "address")!
        }
        let string = uuid + ":" + Email + ":" + "Other" + ":" + "\(Vehicaldetails.sharedInstance.Language)" + ":" + "FluidSecure"
       
       // let string = uuid + ":" + Email + ":" + "Other" + ":" + ""
        let Base64 = convertStringToBase64(string)
        print(Base64)
        self.web.sentlog(func_name: "checkApprove command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        //request.timeoutInterval = 10
        let bodyData = "Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
        // print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        var TransactionId = 0;
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
               // print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                // print(self.reply)
                let text = self.reply
                if text!.contains("ResponceMessage"){
                    
                }else{
                    self.reply = "-1"
                }
                //                var check = String((text?.{ !"ResponceMessage".contains($0)})!)
                
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.web.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),uuid(\(uuid)), App_version 1.18(1)", errorfromserverorlink: " ",errorfromapp: "")
                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.web.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!), App_version 1.18(1)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " ")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }

    @IBAction func refresh() {
        if (isnotapprove == true)
        {
            getdata()
            isnotapprove = false
        }
        else{}
    }
    @IBAction func GObuttontapped() {
        
        if (Vehicaldetails.sharedInstance.SSId == "")
        {
            presentAlert(withTitle: "", message:NSLocalizedString("NoInternet", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])
        }
        else{
            if(Vehicaldetails.sharedInstance.IsLinkFlagged == "True")
            {
                presentAlert(withTitle: "",message: "\(Vehicaldetails.sharedInstance.LinkFlaggedMessage)", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
            }
            else{
            web.sentlogFile()
                    web.unsyncTransaction()
            self.fVC.ConnecttoBLE()
        self.presentController(withName: "vehicle", context: nil)
            }
    }
    }
  
}
