//
//  Vehicaldetails.swift
//  FuelSecuer
//
//  Created by VASP on 3/31/16.
//  Copyright © 2016 VASP. All rights reserved.
//


import UIKit
import CoreBluetooth

private let _Vehicaldetails = Vehicaldetails(Vehicleno:"",Barcodescanvalue:"",Odometeno :"",deptno:"", Personalpinno:"", Other:"", hours:"",buttonset:Bool(),SiteID:"",MinLimit:"",PulseRatio:"",VehicleId:"",FuelTypeId:"",PersonId:"",PhoneNumber:"",SSId:"",reachblevia:"",odometerreq:"",IsPersonnelPINRequire:"",IsOtherRequire:"",IsDepartmentRequire:"",IsHoursrequirs:"",siteName:"",date:"",PulserStopTime:"",IsHoseNameReplaced:"",HoseID:"",gohome:Bool(),setrelay0:Bool(),CheckOdometerReasonable:"",OdometerReasonabilityConditions:"",PreviousOdo:Int(),OdoLimit:Int(),Lat:Double(),Long:Double(),TransactionId:Int(),FilePath:"",FirmwareVersion:"",IsFirmwareUpdate:Bool(),FinalQuantitycount:"",MacAddress:"",BTMacAddress:"",Transaction_id:NSMutableArray(),IsUpgrade:"",password:"",TimeOut:"",Otherlable:"",pulsarCount:"",PulserTimingAdjust:"",IsBusy:"",IsDefective:"",CollectDiagnosticLogs:"",URL:"",Language:"",AppType:"",ReplaceableHoseName:"",HoursLimit:Int(),PreviousHours:Int(),pumpoff_time:"",IsVehicleNumberRequire:"",IsTLDdata:"",Last10transactions:NSMutableArray(),Errorcode:"",CompanyBarndName:"",CompanyBrandLogoLink:"",SupportEmail:"", SupportPhonenumber:"",IsUseBarcode:"",fsSSId:"",IsExtraOther:"",ExtraOtherLabel:"",ExtraOther:"",checkSSIDwithLink:"",ScreenNameForVehicle:"", ScreenNameForPersonnel:"",ScreenNameForOdometer:"", ScreenNameForHours:"",pumpon_time:"",FuelLimitPerTnx:"",FuelLimitPerDay:"",Last_transactionformLast10:"",PreAuthDataDwnldFreq:"",PreAuthDataDownloadDay:"",PreAuthVehicleDataFilePath:"", PreAuthDataDownloadTimeInHrs:"",PreAuthDataDownloadTimeInMin:"",PreAuthVehicleDataFilesCount:"",Warningunsync_transaction:"", ifStartbuttontapped: Bool(),Istankempty:"",LimitReachedMessage:"",LastTransactiondata:NSMutableArray(),IsFirstTimeUse:"", IsLinkFlagged:"",LinkFlaggedMessage:"",MacAddressfromlink:"",iotversion:"",DoNotAllowOfflinePreauthorizedTransactions:"",HubLinkCommunication: "",ifSubscribed:Bool(),peripherals: [CBPeripheral](), LastTransactionFuelQuantity: "", ScreenNameForDepartment: "", IsResetSwitchTimeBounce: "",PreAuthVehicleDataFilename:"",prevSSID: "",PreAuthDepartmentDataFilePath:"",OriginalNamesOfLink:NSMutableArray(), FuelLimitPerMonth: "")

class Vehicaldetails {

    var vehicleno:String = ""
    var Barcodescanvalue:String = ""
    var Odometerno :String = ""
    var Errorcode:String = "0"
    var deptno :String = ""
    var Personalpinno :String = ""
    var Other:String = ""
    var Otherlable:String = ""
    var hours: String = ""
    var buttonset:Bool!
    var setrelay0:Bool!
    var siteID:String = ""
    var MinLimit:String = ""
    var PulseRatio:String = ""
    var VehicleId:String = ""
    var FuelTypeId:String = ""
    var PersonId:String = ""
    var PhoneNumber:String = ""
    var SSId:String = ""
    var fsSSId:String = ""
    var reachblevia:String = ""
    var odometerreq:String = ""
    var IsDepartmentRequire:String = ""
    var IsPersonnelPINRequire:String = ""
    var IsOtherRequire:String = ""
    var TimeOut:String = ""
    var IsHoursrequirs:String = ""
    var siteName:String = ""
    var date:String = ""
    var PulserStopTime:String = ""
    var pumpoff_time:String = ""
    var pumpon_time:String = ""
    var IsHoseNameReplaced:String = ""
    var HoseID:String = ""
    var gohome:Bool!
    var CheckOdometerReasonable:String = ""
    var OdometerReasonabilityConditions:String = ""
    var PreviousOdo:Int = 0
    var OdoLimit:Int = 0
    var Lat:Double = 0.0
    var Long:Double = 0.0
    var TransactionId:Int = 0
    var FilePath:String = ""
    var FirmwareVersion :String = ""
    var IsFirmwareUpdate:Bool!
    var FinalQuantitycount:String = ""
    var MacAddress:String = ""
    var BTMacAddress:String = ""
    var FS_MacAddress:String = ""
    var Transaction_id :NSMutableArray!
    var IsUpgrade:String = ""
    var password:String = ""
    var pulsarCount:String = ""
    var PulserTimingAdjust:String = ""
    var IsBusy:String = ""
    var IsDefective:String = ""
    var CollectDiagnosticLogs:String = ""
    var URL:String = ""
    var Language:String = ""
    var AppType:String = ""
    var ReplaceableHoseName:String = ""
    var HoursLimit:Int = 0
    var PreviousHours:Int = 0
    var IsVehicleNumberRequire:String = ""
    var IsTLDdata = ""
    var Last10transactions:NSMutableArray!
    var CompanyBarndName = ""
    var CompanyBrandLogoLink = ""
    var SupportEmail = ""
    var SupportPhonenumber = ""
    var IsUseBarcode = ""
    var IsExtraOther = ""
    var ExtraOtherLabel = ""
    var ExtraOther = ""
    var checkSSIDwithLink = ""
    var ScreenNameForHours = ""
    var ScreenNameForOdometer = ""
    var ScreenNameForPersonnel = ""
    var ScreenNameForVehicle = ""
    var ScreenNameForDepartment = ""
    var FuelLimitPerDay = ""
    var FuelLimitPerMonth = ""
    var FuelLimitPerTnx = ""
    var Last_transactionformLast10 = ""
    var PreAuthDataDwnldFreq = ""
    var PreAuthDataDownloadDay = ""
    var PreAuthDataDownloadTimeInHrs = ""
    var PreAuthDataDownloadTimeInMin = ""
    var PreAuthVehicleDataFilePath = ""
    var PreAuthDepartmentDataFilePath = ""
    var PreAuthVehicleDataFilesCount = ""
    var Warningunsync_transaction = ""
    var ifStartbuttontapped: Bool!
    var Istankempty = ""
    var LimitReachedMessage = ""
    var LastTransactiondata:NSMutableArray!
    var IsFirstTimeUse:String = ""
    var LinkFlaggedMessage:String = ""
    var IsLinkFlagged: String = ""
    var MacAddressfromlink: String = ""
    var iotversion:String = ""
    var DoNotAllowOfflinePreauthorizedTransactions:String = ""
    var HubLinkCommunication = ""

    var ifSubscribed:Bool!
        //var blePeripheral : CBPeripheral?
    var peripherals: [CBPeripheral]
    var LastTransactionFuelQuantity: String = ""
    var IsResetSwitchTimeBounce = ""
    var PreAuthVehicleDataFilename = ""
    var prevSSID = ""
    var OriginalNamesOfLink:NSMutableArray
   
   

    init(Vehicleno:String!,Barcodescanvalue:String,Odometeno:String!,deptno:String,Personalpinno :String,Other:String,hours: String,buttonset:Bool!,SiteID:String,MinLimit:String,PulseRatio:String,VehicleId:String,FuelTypeId:String,PersonId:String,PhoneNumber:String,SSId:String,reachblevia:String,odometerreq:String,IsPersonnelPINRequire:String,IsOtherRequire:String,IsDepartmentRequire:String,IsHoursrequirs:String,siteName:String,date:String,PulserStopTime:String,IsHoseNameReplaced:String,HoseID:String,gohome:Bool!,setrelay0:Bool!,CheckOdometerReasonable:String,OdometerReasonabilityConditions:String,PreviousOdo:Int,OdoLimit:Int,Lat:Double,Long:Double,TransactionId:Int,FilePath:String,FirmwareVersion :String,IsFirmwareUpdate:Bool!,FinalQuantitycount:String,MacAddress:String,BTMacAddress:String,Transaction_id:NSMutableArray,IsUpgrade:String,password:String,TimeOut:String,Otherlable:String,pulsarCount:String,PulserTimingAdjust:String,IsBusy:String,IsDefective:String,CollectDiagnosticLogs:String,URL:String,Language:String,AppType:String,ReplaceableHoseName:String,HoursLimit:Int,PreviousHours:Int,pumpoff_time:String,IsVehicleNumberRequire:String,IsTLDdata:String,Last10transactions:NSMutableArray,Errorcode:String,CompanyBarndName:String,CompanyBrandLogoLink:String,SupportEmail:String,SupportPhonenumber:String,IsUseBarcode:String,fsSSId:String,IsExtraOther:String,ExtraOtherLabel:String,ExtraOther:String,checkSSIDwithLink:String,ScreenNameForVehicle:String,ScreenNameForPersonnel:String,ScreenNameForOdometer:String,ScreenNameForHours:String,pumpon_time:String,FuelLimitPerTnx:String,FuelLimitPerDay:String,Last_transactionformLast10:String,PreAuthDataDwnldFreq:String,PreAuthDataDownloadDay:String,PreAuthVehicleDataFilePath:String,PreAuthDataDownloadTimeInHrs:String,PreAuthDataDownloadTimeInMin:String,PreAuthVehicleDataFilesCount:String,Warningunsync_transaction:String,ifStartbuttontapped:Bool,Istankempty:String,LimitReachedMessage:String,LastTransactiondata:NSMutableArray,IsFirstTimeUse:String,IsLinkFlagged:String,LinkFlaggedMessage:String,MacAddressfromlink:String,iotversion:String,DoNotAllowOfflinePreauthorizedTransactions:String,HubLinkCommunication:String,ifSubscribed:Bool,peripherals:[CBPeripheral],LastTransactionFuelQuantity:String,ScreenNameForDepartment:String,IsResetSwitchTimeBounce:String,PreAuthVehicleDataFilename:String,prevSSID:String,PreAuthDepartmentDataFilePath:String,OriginalNamesOfLink:NSMutableArray,FuelLimitPerMonth:String)
    {
        self.Odometerno = Odometeno
        self.Errorcode = Errorcode
        self.vehicleno = Vehicleno
        self.Barcodescanvalue = Barcodescanvalue
        self.deptno = deptno
        self.Personalpinno = Personalpinno
        self.Other = Other
        self.hours = hours
        self.buttonset = buttonset
        self.siteID = SiteID
        self.MinLimit = MinLimit
        self.PulseRatio = PulseRatio
        self.VehicleId = VehicleId
        self.FuelTypeId = FuelTypeId
        self.PersonId = PersonId
        self.PhoneNumber = PhoneNumber
        self.reachblevia = reachblevia
        self.SSId = SSId
        self.odometerreq = odometerreq
        self.siteName = siteName
        self.date = date
        self.PulserStopTime = PulserStopTime
        self.IsHoseNameReplaced = IsHoseNameReplaced
        self.HoseID = HoseID
        self.gohome = gohome
        self.setrelay0 = setrelay0
        self.IsDepartmentRequire = IsDepartmentRequire
        self.IsPersonnelPINRequire = IsPersonnelPINRequire
        self.IsOtherRequire = IsOtherRequire
        self.TimeOut = TimeOut
        self.IsHoursrequirs = IsHoursrequirs
        self.CheckOdometerReasonable = CheckOdometerReasonable
        self.OdometerReasonabilityConditions = OdometerReasonabilityConditions
        self.PreviousOdo = PreviousOdo
        self.OdoLimit = OdoLimit
        self.Lat = Lat
        self.Long = Long
        self.TransactionId = TransactionId
        self.FilePath = FilePath
        self.FirmwareVersion = FirmwareVersion
        self.IsFirmwareUpdate = IsFirmwareUpdate
        self.FinalQuantitycount = FinalQuantitycount
        self.MacAddress = MacAddress
        self.BTMacAddress = BTMacAddress
        self.Transaction_id = Transaction_id
        self.IsUpgrade = IsUpgrade
        self.password = password
        self.Otherlable = Otherlable
        self.pulsarCount = pulsarCount
        self.PulserTimingAdjust = PulserTimingAdjust
        self.IsBusy = IsBusy
        self.IsDefective = IsDefective
        self.CollectDiagnosticLogs = CollectDiagnosticLogs
        self.URL = URL
        self.Language = Language
        self.AppType = AppType
        self.ReplaceableHoseName = ReplaceableHoseName
        self.HoursLimit = HoursLimit
        self.PreviousHours = PreviousHours
        self.pumpoff_time = pumpoff_time
        self.IsVehicleNumberRequire = IsVehicleNumberRequire
        self.IsTLDdata = IsTLDdata
        self.Last10transactions = Last10transactions
        self.CompanyBarndName = CompanyBarndName
        self.CompanyBrandLogoLink = CompanyBrandLogoLink
        self.SupportEmail = SupportEmail
        self.SupportPhonenumber = SupportPhonenumber
        self.IsUseBarcode = IsUseBarcode
        self.fsSSId = fsSSId
        self.ExtraOtherLabel = ExtraOtherLabel
        self.IsExtraOther = IsExtraOther
        self.ExtraOther = ExtraOther
        self.checkSSIDwithLink = checkSSIDwithLink
        self.ScreenNameForVehicle = ScreenNameForVehicle
        self.ScreenNameForOdometer = ScreenNameForOdometer
        self.ScreenNameForHours = ScreenNameForHours
        self.ScreenNameForPersonnel = ScreenNameForPersonnel
        self.ScreenNameForDepartment = ScreenNameForDepartment
        self.pumpon_time = pumpon_time
        self.FuelLimitPerDay = FuelLimitPerDay
        self.FuelLimitPerTnx = FuelLimitPerTnx
        self.Last_transactionformLast10 = Last_transactionformLast10
        self.PreAuthDataDwnldFreq = PreAuthDataDwnldFreq
        self.PreAuthDataDownloadDay = PreAuthDataDownloadDay
        self.PreAuthVehicleDataFilePath = PreAuthVehicleDataFilePath
        self.PreAuthDataDownloadTimeInHrs = PreAuthDataDownloadTimeInHrs
        self.PreAuthDataDownloadTimeInMin = PreAuthDataDownloadTimeInMin
        self.PreAuthVehicleDataFilesCount = PreAuthVehicleDataFilesCount
        self.Warningunsync_transaction = Warningunsync_transaction
        self.ifStartbuttontapped = ifStartbuttontapped
        self.Istankempty = Istankempty
        self.LimitReachedMessage = LimitReachedMessage
        self.LastTransactiondata = LastTransactiondata
        self.IsFirstTimeUse = IsFirstTimeUse
        self.LinkFlaggedMessage = LinkFlaggedMessage
        self.IsLinkFlagged = IsLinkFlagged
        self.MacAddressfromlink = MacAddressfromlink
        self.iotversion = iotversion
        self.DoNotAllowOfflinePreauthorizedTransactions = DoNotAllowOfflinePreauthorizedTransactions
        self.HubLinkCommunication = HubLinkCommunication
        self.ifSubscribed = ifSubscribed
        self.peripherals = peripherals
        self.LastTransactionFuelQuantity = LastTransactionFuelQuantity
        self.IsResetSwitchTimeBounce = IsResetSwitchTimeBounce
        self.PreAuthVehicleDataFilename = PreAuthVehicleDataFilename
        self.prevSSID = prevSSID
        self.PreAuthDepartmentDataFilePath = PreAuthDepartmentDataFilePath
        self.OriginalNamesOfLink = OriginalNamesOfLink
        self.FuelLimitPerMonth = FuelLimitPerMonth

    }

    class var sharedInstance: Vehicaldetails
    {
        return _Vehicaldetails
    }
}



//import UIKit
//import CoreBluetooth
//private let _Vehicaldetails = Vehicaldetails(Vehicleno:"",Barcodescanvalue:"",Odometeno :"",deptno:"", Personalpinno:"", Other:"", hours:"",buttonset:Bool(),SiteID:"",MinLimit:"",PulseRatio:"",VehicleId:"",FuelTypeId:"",PersonId:"",PhoneNumber:"",SSId:"",reachblevia:"",odometerreq:"",IsPersonnelPINRequire:"",IsOtherRequire:"",IsDepartmentRequire:"",IsHoursrequirs:"",siteName:"",date:"",PulserStopTime:"",IsHoseNameReplaced:"",HoseID:"",gohome:Bool(),setrelay0:Bool(),CheckOdometerReasonable:"",OdometerReasonabilityConditions:"",PreviousOdo:Int(),OdoLimit:Int(),Lat:Double(),Long:Double(),TransactionId:Int(),FilePath:"",FirmwareVersion:"",IsFirmwareUpdate:Bool(),FinalQuantitycount:"",MacAddress:"",FS_MacAddress:"",Transaction_id:NSMutableArray(),IsUpgrade:"",password:"",TimeOut:"",Otherlable:"",pulsarCount:"",PulserTimingAdjust:"",IsBusy:"",Istankempty:"",IsDefective:"",CollectDiagnosticLogs:"",URL:"",Language:"",AppType:"",ReplaceableHoseName:"",HoursLimit:Int(),PreviousHours:Int(),pumpoff_time:"",IsVehicleNumberRequire:"",IsTLDdata:"",Last10transactions:NSMutableArray(),Errorcode:"",CompanyBarndName:"",CompanyBrandLogoLink:"",SupportEmail:"", SupportPhonenumber:"",IsUseBarcode:"",fsSSId:"",IsExtraOther:"",ExtraOtherLabel:"",ExtraOther:"",checkSSIDwithLink:"",ScreenNameForVehicle:"", ScreenNameForPersonnel:"",ScreenNameForOdometer:"", ScreenNameForHours:"",pumpon_time:"",FuelLimitPerTnx:"",FuelLimitPerDay:"",Last_transactionformLast10:"",PreAuthDataDwnldFreq:"",PreAuthDataDownloadDay:"",PreAuthVehicleDataFilePath:"", PreAuthDataDownloadTimeInHrs:"",PreAuthDataDownloadTimeInMin:"",PreAuthVehicleDataFilesCount:"",Warningunsync_transaction:"",ifStartbuttontapped:Bool(),HubLinkCommunication:"",LimitReachedMessage:"",ifSubscribed:Bool(),peripherals:[CBPeripheral]())
//
//class Vehicaldetails {
//


//    var Odometerno :String = ""















//    var SSId:String = ""
//    var fsSSId:String = ""






//    var FilePath:String = ""

//    var HubLinkCommunication = ""

//    var ifSubscribed:Bool!
//    //var blePeripheral : CBPeripheral?
//    var peripherals: [CBPeripheral]
//
//
//    init(Vehicleno:String!,Barcodescanvalue:String,Odometeno:String!,deptno:String,Personalpinno :String,Other:String,hours: String,buttonset:Bool!,SiteID:String,MinLimit:String,PulseRatio:String,VehicleId:String,FuelTypeId:String,PersonId:String,PhoneNumber:String,SSId:String,reachblevia:String,odometerreq:String,IsPersonnelPINRequire:String,IsOtherRequire:String,IsDepartmentRequire:String,IsHoursrequirs:String,siteName:String,date:String,PulserStopTime:String,IsHoseNameReplaced:String,HoseID:String,gohome:Bool!,setrelay0:Bool!,CheckOdometerReasonable:String,OdometerReasonabilityConditions:String,PreviousOdo:Int,OdoLimit:Int,Lat:Double,Long:Double,TransactionId:Int,FilePath:String,FirmwareVersion :String,IsFirmwareUpdate:Bool!,FinalQuantitycount:String,MacAddress:String,FS_MacAddress:String,Transaction_id:NSMutableArray,IsUpgrade:String,password:String,TimeOut:String,Otherlable:String,pulsarCount:String,PulserTimingAdjust:String,IsBusy:String,Istankempty:String,IsDefective:String,CollectDiagnosticLogs:String,URL:String,Language:String,AppType:String,ReplaceableHoseName:String,HoursLimit:Int,PreviousHours:Int,pumpoff_time:String,IsVehicleNumberRequire:String,IsTLDdata:String,Last10transactions:NSMutableArray,Errorcode:String,CompanyBarndName:String,CompanyBrandLogoLink:String,SupportEmail:String,SupportPhonenumber:String,IsUseBarcode:String,fsSSId:String,IsExtraOther:String,ExtraOtherLabel:String,ExtraOther:String,checkSSIDwithLink:String,ScreenNameForVehicle:String,ScreenNameForPersonnel:String,ScreenNameForOdometer:String,ScreenNameForHours:String,pumpon_time:String,FuelLimitPerTnx:String,FuelLimitPerDay:String,Last_transactionformLast10:String,PreAuthDataDwnldFreq:String,PreAuthDataDownloadDay:String,PreAuthVehicleDataFilePath:String,PreAuthDataDownloadTimeInHrs:String,PreAuthDataDownloadTimeInMin:String,PreAuthVehicleDataFilesCount:String,Warningunsync_transaction:String,ifStartbuttontapped:Bool,HubLinkCommunication:String,LimitReachedMessage:String,ifSubscribed:Bool,peripherals: [CBPeripheral])
//    {
//        self.Odometerno = Odometeno
//        self.Errorcode = Errorcode
//        self.vehicleno = Vehicleno
//        self.Barcodescanvalue = Barcodescanvalue
//        self.deptno = deptno
//        self.Personalpinno = Personalpinno
//        self.Other = Other
//        self.hours = hours
//        self.buttonset = buttonset
//        self.siteID = SiteID
//        self.MinLimit = MinLimit
//        self.PulseRatio = PulseRatio
//        self.VehicleId = VehicleId
//        self.FuelTypeId = FuelTypeId
//        self.PersonId = PersonId
//        self.PhoneNumber = PhoneNumber
//        self.reachblevia = reachblevia
//        self.SSId = SSId
//        self.odometerreq = odometerreq
//        self.siteName = siteName
//        self.date = date
//        self.PulserStopTime = PulserStopTime
//        self.IsHoseNameReplaced = IsHoseNameReplaced
//        self.HoseID = HoseID
//        self.gohome = gohome
//        self.setrelay0 = setrelay0
//        self.IsDepartmentRequire = IsDepartmentRequire
//        self.IsPersonnelPINRequire = IsPersonnelPINRequire
//        self.IsOtherRequire = IsOtherRequire
//        self.TimeOut = TimeOut
//        self.IsHoursrequirs = IsHoursrequirs
//        self.CheckOdometerReasonable = CheckOdometerReasonable
//        self.OdometerReasonabilityConditions = OdometerReasonabilityConditions
//        self.PreviousOdo = PreviousOdo
//        self.OdoLimit = OdoLimit
//        self.Lat = Lat
//        self.Long = Long
//        self.TransactionId = TransactionId
//        self.FilePath = FilePath
//        self.FirmwareVersion = FirmwareVersion
//        self.IsFirmwareUpdate = IsFirmwareUpdate
//        self.FinalQuantitycount = FinalQuantitycount
//        self.MacAddress = MacAddress
//        self.FS_MacAddress = FS_MacAddress
//        self.Transaction_id = Transaction_id
//        self.IsUpgrade = IsUpgrade
//        self.password = password
//        self.Otherlable = Otherlable
//        self.pulsarCount = pulsarCount
//        self.PulserTimingAdjust = PulserTimingAdjust
//        self.IsBusy = IsBusy
//        self.Istankempty = Istankempty
//        self.IsDefective = IsDefective
//        self.CollectDiagnosticLogs = CollectDiagnosticLogs
//        self.URL = URL
//        self.Language = Language
//        self.AppType = AppType
//        self.ReplaceableHoseName = ReplaceableHoseName
//        self.HoursLimit = HoursLimit
//        self.PreviousHours = PreviousHours
//        self.pumpoff_time = pumpoff_time
//        self.IsVehicleNumberRequire = IsVehicleNumberRequire
//        self.IsTLDdata = IsTLDdata
//        self.Last10transactions = Last10transactions
//        self.CompanyBarndName = CompanyBarndName
//        self.CompanyBrandLogoLink = CompanyBrandLogoLink
//        self.SupportEmail = SupportEmail
//        self.SupportPhonenumber = SupportPhonenumber
//        self.IsUseBarcode = IsUseBarcode
//        self.fsSSId = fsSSId
//        self.ExtraOtherLabel = ExtraOtherLabel
//        self.IsExtraOther = IsExtraOther
//        self.ExtraOther = ExtraOther
//        self.checkSSIDwithLink = checkSSIDwithLink
//        self.ScreenNameForVehicle = ScreenNameForVehicle
//        self.ScreenNameForOdometer = ScreenNameForOdometer
//        self.ScreenNameForHours = ScreenNameForHours
//        self.ScreenNameForPersonnel = ScreenNameForPersonnel
//        self.pumpon_time = pumpon_time
//        self.FuelLimitPerDay = FuelLimitPerDay
//        self.FuelLimitPerTnx = FuelLimitPerTnx
//        self.Last_transactionformLast10 = Last_transactionformLast10
//        self.PreAuthDataDwnldFreq = PreAuthDataDwnldFreq
//        self.PreAuthDataDownloadDay = PreAuthDataDownloadDay
//        self.PreAuthVehicleDataFilePath = PreAuthVehicleDataFilePath
//        self.PreAuthDataDownloadTimeInHrs = PreAuthDataDownloadTimeInHrs
//        self.PreAuthDataDownloadTimeInMin = PreAuthDataDownloadTimeInMin
//        self.PreAuthVehicleDataFilesCount = PreAuthVehicleDataFilesCount
//        self.Warningunsync_transaction = Warningunsync_transaction
//        self.ifStartbuttontapped = ifStartbuttontapped
//        self.HubLinkCommunication = HubLinkCommunication
//        self.LimitReachedMessage = LimitReachedMessage
//        self.ifSubscribed = ifSubscribed
//        //self.blePeripheral = blePeripheral
//        self.peripherals = peripherals
//
//    }
//
//    class var sharedInstance: Vehicaldetails
//    {
//        return _Vehicaldetails
//    }
//}
