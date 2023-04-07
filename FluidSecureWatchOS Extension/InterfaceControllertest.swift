////
////  InterfaceControllertest.swift
////  FluidSecureWatchOS Extension
////
////  Created by apple on 10/05/21.
////  Copyright © 2021 VASP. All rights reserved.
////
//
//import WatchKit
//import Foundation
//
//
//class InterfaceControllertest: WKInterfaceController {
//
//    var reply :String!
//    
//    var  URL = "https://www.fluidsecure.net/"//"http://sierravistatest.cloudapp.net/"//"https://www.fluidsecure.net"
////    var reply1 :String!
//
//    let defaults = UserDefaults.standard
//    var IsDepartmentRequire:String!
//    var IsUseBarcode:String!
//    var IsPersonnelPINRequire:String!
//    var IsOtherRequire:String!
//    var OtherLabel:String!
//    var timeout:String!
//    var IsOdoMeterRequire:String!
//    var IsVehicleNumberRequire:String!
//    var IsLoginRequire:String!
//    var IsBusy :String!
//    
//    var sysdata:NSDictionary!
//    var systemdata:NSDictionary!
//    
//    
//    var ssid = [WKPickerItem]()
//    var Pass = [String]()
//    var location = [String]()
//    var ReplaceableHosename = [String]()
//    var Ulocation = [String]()
//    var siteID = [String]()
//    var HoseId = [String]()
//    var Is_upgrade = [String]()
//    var pulsartimeadjust = [String]()
//    var IFISBusy = [String]()
//    var Is_HoseNameReplaced = [String]()
//    var IFIsDefective = [String]()
//    var Uhosenumber = [String]()
//    var TransactionId = [String]()
//    var TLDCall = [String]()
//    var IsTank_Empty = [String]()
//    var Communication_Type = [String]()
//    var groupAdminCompanyListCompanyID = [String]()
//    var groupAdminCompanyList = [String]()
//    var web = Webservice()
//    var IsGobuttontapped : Bool = false
//    var now:Date!
//    var selectedhose = ""
//    
//      var ResponceMessageUpload:String = ""
//     var sysdata1:NSDictionary!
//    var uuid:String = ""
//    
//    override func awake(withContext context: Any?) {
//        super.awake(withContext: context)
//        getdata()
//        // Configure interface objects here.
//    }
//
//    override func willActivate() {
//        // This method is called when watch view controller is about to be visible to user
//        super.willActivate()
//    }
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//        super.didDeactivate()
//    }
//
//    func getdata()
//    {
//            var password = KeychainService.loadPassword()
//            if(password == nil || password == ""){
//                uuid = UUID().uuidString
//                KeychainService.savePassword(token: uuid as NSString)
//            }
//            else{
//                 password = KeychainService.loadPassword()
//                print(password!)//used this paasword (uuid)
//                uuid = password! as String
//            }
//            
//        let checkaprovedata = web.checkApprove(uuid: uuid,lat:"\(18.479963)",long:"\(73.821659)")
//    //        var info = Getinfo()  4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C
//            print(checkaprovedata)
//            let data1:Data = checkaprovedata.data(using: String.Encoding.utf8)!
//            do {
//                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//            }catch let error as NSError {
//                
//                print ("Error: \(error.domain)")
//            }
//           // print(sysdata)
//            if(sysdata == nil){
//            }
//            else{
//             groupAdminCompanyList = []
//             groupAdminCompanyListCompanyID = []
//                let Message = sysdata["ResponceMessage"] as! NSString
//                let ResponseText = sysdata["ResponceText"] as! NSString
//                if(Message == "success") {
//                   
//                    let objUserData = sysdata.value(forKey: "objUserData") as! NSDictionary
//                    let CompanyName = objUserData.value(forKey: "CompanyName") as! NSString
//                    let Email = objUserData.value(forKey: "Email") as! NSString
//                    let IMEI_UDID = objUserData.value(forKey: "IMEI_UDID") as! NSString
//                    let IsApproved = objUserData.value(forKey: "IsApproved") as! NSString
//                    let PersonName = objUserData.value(forKey: "PersonName") as! NSString
//                    let PhoneNumber = objUserData.value(forKey: "PhoneNumber") as! NSString
//                 
//                    let CollectDiagnosticLogs = objUserData.value(forKey: "CollectDiagnosticLogs") as! NSString
//                    IsVehicleNumberRequire = objUserData.value(forKey: "IsVehicleNumberRequire") as! NSString as String
//                    let ScreenNameForHours = objUserData.value(forKey: "ScreenNameForHours") as! String
//                    let ScreenNameForOdometer = objUserData.value(forKey: "ScreenNameForOdometer") as! String
//                    let ScreenNameForPersonnel = objUserData.value(forKey: "ScreenNameForPersonnel") as! String
//                    let ScreenNameForVehicle = objUserData.value(forKey: "ScreenNameForVehicle") as! String
//
//                    Vehicaldetails.sharedInstance.ScreenNameForVehicle = ScreenNameForVehicle
//                    Vehicaldetails.sharedInstance.ScreenNameForPersonnel = ScreenNameForPersonnel
//                    Vehicaldetails.sharedInstance.ScreenNameForHours = ScreenNameForHours
//                    Vehicaldetails.sharedInstance.ScreenNameForOdometer = ScreenNameForOdometer
//                   
//
//                    IsOdoMeterRequire = objUserData.value(forKey: "IsOdoMeterRequire") as! NSString as String
//                    IsLoginRequire = objUserData.value(forKey: "IsLoginRequire") as! NSString as String
//                    IsDepartmentRequire = objUserData.value(forKey: "IsDepartmentRequire") as! NSString as String
//                    IsPersonnelPINRequire = objUserData.value(forKey: "IsPersonnelPINRequire") as! NSString as String
//                    IsOtherRequire = objUserData.value(forKey: "IsOtherRequire") as! NSString as String
//                    OtherLabel = objUserData.value(forKey:"OtherLabel") as!NSString as String
//                    timeout = objUserData.value(forKey:"TimeOut") as!NSString as String
//                    IsUseBarcode = objUserData.value(forKey: "UseBarcode") as! NSString as String
//                    Vehicaldetails.sharedInstance.CompanyBarndName = (objUserData.value(forKey: "CompanyBrandName") as! NSString) as String
//                    Vehicaldetails.sharedInstance.CompanyBrandLogoLink = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
//                    Vehicaldetails.sharedInstance.IsVehicleNumberRequire = IsVehicleNumberRequire
//                // self.navigationItem.title = Vehicaldetails.sharedInstance.CompanyBarndName
//                 
//                
//                 
//                    if(IsVehicleNumberRequire == "False")
//                    {
//                       // Vehicaldetails.sharedInstance.vehicleno = ""
//                      //  Vehicaldetails.sharedInstance.Odometerno = "0"
//                    }
//                    else if(IsVehicleNumberRequire == "True"){
//
//                    }
//
//    //                infotext.text =  NSLocalizedString("Name", comment:"") + ": \(PersonName)\n" + NSLocalizedString("Mobile", comment:"") + ":\(PhoneNumber)\n" + NSLocalizedString("Email", comment:"") +  ": \(Email) \n"
//                    
//    //                Companynamelabel.text = NSLocalizedString("Company Name", comment:"") + ": \(CompanyName)"
//    //                Companynamelabel.lineBreakMode = .byWordWrapping
//    //                infotext.lineBreakMode = .byWordWrapping
//                    
//                 
//                    Vehicaldetails.sharedInstance.CollectDiagnosticLogs = CollectDiagnosticLogs as String
//                    Vehicaldetails.sharedInstance.odometerreq = IsOdoMeterRequire
//                    Vehicaldetails.sharedInstance.IsDepartmentRequire = IsDepartmentRequire
//                    Vehicaldetails.sharedInstance.IsPersonnelPINRequire = IsPersonnelPINRequire
//                    Vehicaldetails.sharedInstance.IsOtherRequire = IsOtherRequire
//                    Vehicaldetails.sharedInstance.Otherlable = OtherLabel
//                    Vehicaldetails.sharedInstance.TimeOut = timeout
//                                           // Vehicaldetails.sharedInstance.IsUseBarcode = IsUseBarcode
//
//                    defaults.set(PersonName, forKey: "firstName")
//                    defaults.set(Email, forKey: "address")
//                    defaults.set(PhoneNumber, forKey: "mobile")
//                    defaults.set(uuid, forKey: "uuid")
//                    defaults.set(1, forKey: "Register")
//                   // Vehicaldetails.sharedInstance.AppType = "AuthTransaction"
//                    print(IMEI_UDID,IsApproved,PhoneNumber,PersonName,Email)
//
//               //  web.sentlog(func_name: "Name : \(PersonName)", errorfromserverorlink: "Company : \(CompanyName)", errorfromapp: "Email : \(Email)")
//                 
//                 //Vehicaldetails.sharedInstance.SupportPhonenumber = (objUserData.value(forKey: "SupportPhonenumber") as! NSString) as String
//                                 //   Vehicaldetails.sharedInstance.SupportEmail = (objUserData.value(forKey: "SupportEmail") as! NSString) as String
//                                 //   Vehicaldetails.sharedInstance.CompanyBarndName = (objUserData.value(forKey: "CompanyBrandName") as! NSString) as String
//                    let companybrandlogo = (objUserData.value(forKey: "CompanyBrandLogoLink") as! NSString) as String
//                    if(defaults.string(forKey: "companylogolink") == nil)
//                    {
//                        defaults.set("", forKey: "companylogolink")
//                    }
//                   // print(defaults.string(forKey: "companylogolink")!,Vehicaldetails.sharedInstance.CompanyBrandLogoLink)
//    //                if(defaults.string(forKey: "companylogolink") != Vehicaldetails.sharedInstance.CompanyBrandLogoLink || defaults.string(forKey: "companylogolink") == "")
//    //                {
//    //                    defaults.set(companybrandlogo, forKey: "companylogolink")
//    //                    cf.createDirectory()
//    //                    weak var LogoImage:UIImage? = web.downloadCompanylogoImage()
//    //                    cf.saveImageDocumentDirectory(Image: LogoImage!)
//    //                image.image = LogoImage
//    //                }
//    //                else if(defaults.string(forKey: "companylogolink") == Vehicaldetails.sharedInstance.CompanyBrandLogoLink)
//    //                {   //    Get Image from Document Directory :
//    //
//    //                    let fileManager = FileManager.default
//    //
//    //                    let imagePAth = (cf.getDirectoryPath() as NSString).appendingPathComponent("logoimage.jpg")
//    //
//    //                    if fileManager.fileExists(atPath: imagePAth){
//    //                        let url = Bundle.main.url(forAuxiliaryExecutable: imagePAth)// (forResource: "image", withExtension: "png")!
//    //                            let imageData = try! Data(contentsOf: url!)
//    //                                                  // let _ = UIImage(data: imageData)
//    //                        self.Companylogo.image = UIImage(data: imageData)//UIImage(contentsOfFile: imagePAth)
//    //
//    //                        //self.Companylogo.image = UIImage(contentsOfFile: imagePAth)
//    //
//    //                    }else{
//    //                        print("No Image")
//    //                    }
//    //                }
//                }
//
//                else if(Message == "fail"){ }
//
//               // defaults.set(uuid, forKey: "uuid")
//                if(Message == "success") {
//
//    //                scrollview.isHidden = false
//    //                version.isHidden = true
//    //                warningLable.isHidden = true
//    //                refreshButton.isHidden = true
//    //                preauth.isHidden = true
//
//    //                supportinfo.text = "Support:\(Vehicaldetails.sharedInstance.SupportEmail) or " + "\(Vehicaldetails.sharedInstance.SupportPhonenumber)"
//    //                self.wifiNameTextField.placeholder = NSLocalizedString("Touch Here To Select Hose", comment:"")
//    //
//    //                self.wifiNameTextField.textColor = UIColor.white
//    //                self.wifiNameTextField.inputView = pickerViewLocation
//    //                self.pickerViewLocation.delegate = self
//
//                    do {
//                        _ = defaults.string(forKey: "firstName")
//                        _ = defaults.string(forKey: "address")
//                        _ = defaults.string(forKey: "mobile")
//                        _ = defaults.string(forKey: "uuid")
//
//                        //IF USER IF Approved Get information from server like site,ssid,pwd,hose
//                        do{
//                            systemdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                        }catch let error as NSError {
//                            print ("Error: \(error.domain)")
//                            print ("Error: \(error)")
//                        }
//                       // print(systemdata)
//                        ssid = []
//                        IFISBusy = []
//                     IsTank_Empty = []
//                        HoseId = []
//                        Pass = []
//                        Is_upgrade = []
//                        IFIsDefective = []
//                        Uhosenumber = []
//                        Is_HoseNameReplaced = []
//                        ReplaceableHosename = []
//                    
//                        defaults.removeObject(forKey: "SSID")
//                        let Json = systemdata.value(forKey: "SSIDDataObj") as! NSArray
//                        let rowCount = Json.count
//                        let index: Int = 0
//                        for i in 0  ..< rowCount
//                        {
//                            let JsonRow = Json[i] as! NSDictionary
//                            let Message = JsonRow["ResponceMessage"] as! NSString
//                            let ResponseText = JsonRow["ResponceText"] as! NSString
//                            if(Message == "success") {
//
//                                let JsonRow = Json[i] as! NSDictionary
//                                let SiteName = JsonRow["SiteName"] as! NSString
//                                location.append(SiteName as String)
//                                let ReplaceableHoseName = JsonRow["ReplaceableHoseName"] as! NSString
//                                ReplaceableHosename.append(ReplaceableHoseName as String)
//
//                                print(ssid)
//                                //defaults.set(ssid, forKey: "SSID")
//                                defaults.set(siteID, forKey: "SiteID")
//                                Ulocation = location.removeDuplicates()
//
//                                if(Ulocation[index] == SiteName as String){
//                                    let WifiSSId = JsonRow["WifiSSId"] as! NSString
//                                    let Password = JsonRow["Password"] as! NSString
//                                    let hosename = JsonRow["HoseNumber"] as! NSString
//                                    let Sitid = JsonRow["SiteId"] as! NSString
//                                    let HoseID = JsonRow["HoseId"] as! NSString
//                                    let IsUpgrade = JsonRow["IsUpgrade"] as! NSString
//                                    let IsHoseNameReplaced = JsonRow["IsHoseNameReplaced"] as! NSString
//                                    IsBusy = JsonRow["IsBusy"] as! NSString as String
//                                     let IsTankEmpty = JsonRow["IsTankEmpty"] as! NSString as String
//                                    //                                        let MacAddress = JsonRow["MacAddress"] as! NSString
//                                    let PulserTimingAdjust = JsonRow["PulserTimingAdjust"] as! NSString
//                                    let IsDefective = JsonRow["IsDefective"] as!NSString
//                                    let IsTLDCall = JsonRow["IsTLDCall"] as! NSString
//                                 let HubLinkCommunication = JsonRow["HubLinkCommunication"] as! NSString
//                                    print(WifiSSId)
//                                    if (WifiSSId != ""){
//                                    let k = WKPickerItem()
//                                    k.title = WifiSSId as String
//                                    ssid.append(k)
//                                      //  HoseList.setItems(ssid)
//                                       // HoseList.setEnabled(true)
//                                    }
//                                    
//                                    IFISBusy.append(IsBusy as String)
//                                    location.append(SiteName as String)
//                                    Pass.append(Password as String)
//                                    Uhosenumber.append(hosename as String)
//                                    siteID.append(Sitid as String)
//                                    HoseId.append(HoseID as String)
//                                    Is_upgrade.append(IsUpgrade as String)
//                                    IFIsDefective.append(IsDefective as String)
//                                    pulsartimeadjust.append(PulserTimingAdjust as String)
//                                    Is_HoseNameReplaced.append(IsHoseNameReplaced as String)
//                                    TLDCall.append(IsTLDCall as String)
//                                    Communication_Type.append(HubLinkCommunication as String)
//                                 IsTank_Empty.append(IsTankEmpty as String)
//                                    print(Uhosenumber)
//                                }
//
//                             
//    /// let obj_UserData = sysdata.value(forKey: "groupAdminCompanyListObj") as! NSDictionary
//                             
//
//    let objUserData = sysdata.value(forKey: "PreAuthTransactionsObj") as! NSDictionary
//                              
//                                                   //get Fuel limit per day from server
//    let FuelLimitPerDay = objUserData.value(forKey: "FuelLimitPerDay") as! NSString
//    let FuelLimitPerTxn = objUserData.value(forKey:"FuelLimitPerTxn") as! NSString
//    let PreAuthDataDwnldFreq = objUserData.value(forKey: "PreAuthDataDwnldFreq") as! NSString
//    let PreAuthDataDownloadDay = objUserData.value(forKey:"PreAuthDataDownloadDay") as! NSString
//    let PreAuthDataDownloadTimeInHrs = objUserData.value(forKey: "PreAuthDataDownloadTimeInHrs") as! NSString
//    let PreAuthDataDownloadTimeInMin = objUserData.value(forKey:"PreAuthDataDownloadTimeInMin") as! NSString
//    let PreAuthVehicleDataFilePath = objUserData.value(forKey: "PreAuthVehicleDataFilePath") as! NSString as String
//    let PreAuthVehicleDataFilesCount = objUserData.value(forKey:"PreAuthVehicleDataFilesCount") as! NSString
//                          
//    //            Vehicaldetails.sharedInstance.PreAuthDataDwnldFreq = PreAuthDataDwnldFreq as String
//    //           Vehicaldetails.sharedInstance.PreAuthDataDownloadDay = PreAuthDataDownloadDay as String
//    //                            Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath = PreAuthVehicleDataFilePath.trimmingCharacters(in: .whitespacesAndNewlines)
//    //                            Vehicaldetails.sharedInstance.PreAuthDataDownloadTimeInMin = PreAuthDataDownloadTimeInMin as String
//    //                            Vehicaldetails.sharedInstance.PreAuthDataDownloadTimeInHrs = PreAuthDataDownloadTimeInHrs as String
//    //                            Vehicaldetails.sharedInstance.PreAuthVehicleDataFilesCount = PreAuthVehicleDataFilesCount as String
//                                
//                                
//                                
//                                let PreAuthJson = objUserData.value(forKey: "TransactionObj") as! NSArray
//                                let PreAuthrowCount = PreAuthJson.count
//                             if(PreAuthrowCount > 0 )
//                             {
//    //                             let data = web.GetVehiclesForPhone()
//    //                             print(data)
//                             }
//                                for i in 0  ..< PreAuthrowCount
//                                {
//                                    let PreAuthJsonRow = PreAuthJson[i] as! NSDictionary
//                                    let MessageTransactionObj = PreAuthJsonRow["ResponceMessage"] as! NSString
//
//                                 if(MessageTransactionObj == "success"){
//                                        let T_Id = PreAuthJsonRow["TransactionId"] as! NSString
//                                        TransactionId.append(T_Id as String)
//                                    }
//                                }
//                            }
//                            else if(Message == "fail")
//                            {
//    //                            self.navigationItem.title = NSLocalizedString("Error",comment:"")//"Error"
//    //                            scrollview.isHidden = true
//    //                            version.isHidden = false
//    //                            warningLable.isHidden = false
//    //                            refreshButton.isHidden = false
//                                //Label.setText("\(ResponseText)")//no hose found Please contact administrater"
//                            }
//                        }
//                        
//                        
//                        if(Uhosenumber.count == 1)
//                        {
//                            let siteid = siteID[0]
//                            let ssId = ssid[0]
//                            let hoseid = HoseId[0]
//                            let Password = Pass[0]
//                            //self.HoseList.setItems(ssid[0])
//                            let isupgrade = Is_upgrade[0]
//                            let pulsartime_adjust = pulsartimeadjust[0]
//                            let CommunicationLinkType = Communication_Type[0]
//                            Vehicaldetails.sharedInstance.siteID = siteid
//                            //Vehicaldetails.sharedInstance.SSId = ssId[0].title
//                            Vehicaldetails.sharedInstance.HoseID = hoseid
//                            Vehicaldetails.sharedInstance.password = Password
//                            Vehicaldetails.sharedInstance.IsUpgrade = isupgrade
//                            Vehicaldetails.sharedInstance.PulserTimingAdjust = pulsartime_adjust
//                            Vehicaldetails.sharedInstance.IsBusy = IsBusy
//                            Vehicaldetails.sharedInstance.IsDefective = IFIsDefective[0]
//                         Vehicaldetails.sharedInstance.HubLinkCommunication = CommunicationLinkType
//                            Vehicaldetails.sharedInstance.IsHoseNameReplaced = Is_HoseNameReplaced[0]
//                            Vehicaldetails.sharedInstance.ReplaceableHoseName = ReplaceableHosename[0]
//                            print(Vehicaldetails.sharedInstance.IsUpgrade,Vehicaldetails.sharedInstance.password,Vehicaldetails.sharedInstance.HoseID,Vehicaldetails.sharedInstance.SSId,Vehicaldetails.sharedInstance.siteID,Vehicaldetails.sharedInstance.IsHoseNameReplaced)
//
//                           
//    //                        delay(0.2){
//                                if( self.IsGobuttontapped == true){
//
//                                }
//                                else{
//
//                                }
//    //                        }
//                        }
//                    }
//                }
//
//                    //USER IS NOT REGISTER TO SYSTEM
//                else if(ResponseText == "New Registration") {
//                    contextForSegue(withIdentifier: "Registration")//(withNamesAndContexts: [(name: "Registration", context: AnyObject)]) //reloadRootPageControllers(withNames: ["Registration"], contexts: [Any]?, orientation: WKPageOrientation, pageIndex: Int)
//                        
//                    //self.presentController(withName: "Registration", context: nil)
//    //                let appDel = UIApplication.shared.delegate! as! AppDelegate
//    //                defaults.set(0, forKey: "Register")
//    //                self.web.sentlog(func_name: "New Registration", errorfromserverorlink: "", errorfromapp: "")
//    //                // Call a method on the CustomController property of the AppDelegate
//    //                appDel.start()
//                }
//
//                else if(Message == "fail") {
//
//                    if(ResponseText == "New Registration")
//                    {
//                        
//    //                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//    //                    // Call a method on the CustomController property of the AppDelegate
//    //                    defaults.set(0, forKey: "Register")
//    //                    appDel.start()
//                    }
//                    else
//                        if(ResponseText == "notapproved")
//                        {
//                            defaults.set("false", forKey: "checkApproved")
//    //                        scrollview.isHidden = true
//    //                        version.isHidden = false
//    //                        warningLable.isHidden = false
//    //                        refreshButton.isHidden = false
//    //                        preauth.isHidden = true
//    //                        self.navigationItem.title = "Thank you for registering"
//    //                        warningLable.text = NSLocalizedString("Regisration", comment:"")
//                             //+ " " +  defaults.string(forKey: "address")! + " " +  NSLocalizedString("registration1", comment:"")
//                        }else
//                        {
//    //                        scrollview.isHidden = true
//    //                        version.isHidden = false
//    //                        warningLable.isHidden = false
//    //                        refreshButton.isHidden = false
//    //                        self.navigationItem.title = NSLocalizedString("Error",comment:"")
//    //                        warningLable.text = ResponseText as String
//                    }
//
//                    //                        defaults.set("false", forKey: "checkApproved")
//                    //                        scrollview.isHidden = true
//                    //                        version.isHidden = false
//                    //                        warningLable.isHidden = false
//                    //                        refreshButton.isHidden = false
//                    //                        self.navigationItem.title = NSLocalizedString("Error",comment:"")
//                    //                        warningLable.text = NSLocalizedString("Regisration", comment:"")
//                    //                    } else if(ResponseText == "New Registration") {
//                    //                        performSegue(withIdentifier: "Register", sender: self)
//                }
//            }
//        
//        
//        
//        
//        // Do any additional setup after loading the view, typically from a nib.
//        
//    }
//    
//}
