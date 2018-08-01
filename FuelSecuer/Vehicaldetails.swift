//
//  Vehicaldetails.swift
//  FuelSecuer
//
//  Created by VASP on 3/31/16.
//  Copyright © 2016 VASP. All rights reserved.
//

import UIKit
private let _Vehicaldetails = Vehicaldetails(Vehicleno:"",Odometeno :"",deptno:"",Personalpinno:"",Other:"",hours:"",buttonset:Bool(),SiteID:"",MinLimit:"",PulseRatio:"",VehicleId:"",FuelTypeId:"",PersonId:"",PhoneNumber:"",SSId:"",reachblevia:"",odometerreq:"",IsPersonnelPINRequire:"",IsOtherRequire:"",IsDepartmentRequire:"",IsHoursrequirs:"",siteName:"",date:"",PulserStopTime:"",IsHoseNameReplaced:"",HoseID:"",gohome:Bool(),setrelay0:Bool(),CheckOdometerReasonable:"",OdometerReasonabilityConditions:"",PreviousOdo:Int(),OdoLimit:Int(),Lat:Double(),Long:Double(),TransactionId:Int(),FilePath:"",FirmwareVersion:"",IsFirmwareUpdate:Bool(),FinalQuantitycount:"",MacAddress:"",FS_MacAddress:"",Transaction_id:NSMutableArray(),IsUpgrade:"",password:"",TimeOut:"",Otherlable:"",pulsarCount:"",PulserTimingAdjust:"",IsBusy:"",IsDefective:"",CollectDiagnosticLogs:"",URL:"",Language:"",AppType:"")

class Vehicaldetails {

    var vehicleno:String = ""
    var Odometerno :String = ""
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





    init(Vehicleno:String!,Odometeno:String!,deptno:String,Personalpinno :String,Other:String,hours: String,buttonset:Bool!,SiteID:String,MinLimit:String,PulseRatio:String,VehicleId:String,FuelTypeId:String,PersonId:String,PhoneNumber:String,SSId:String,reachblevia:String,odometerreq:String,IsPersonnelPINRequire:String,IsOtherRequire:String,IsDepartmentRequire:String,IsHoursrequirs:String,siteName:String,date:String,PulserStopTime:String,IsHoseNameReplaced:String,HoseID:String,gohome:Bool!,setrelay0:Bool!,CheckOdometerReasonable:String,OdometerReasonabilityConditions:String,PreviousOdo:Int,OdoLimit:Int,Lat:Double,Long:Double,TransactionId:Int,FilePath:String,FirmwareVersion :String,IsFirmwareUpdate:Bool!,FinalQuantitycount:String,MacAddress:String,FS_MacAddress:String,Transaction_id:NSMutableArray,IsUpgrade:String,password:String,TimeOut:String,Otherlable:String,pulsarCount:String,PulserTimingAdjust:String,IsBusy:String,IsDefective:String,CollectDiagnosticLogs:String,URL:String,Language:String,AppType:String)
    {
        self.Odometerno = Odometeno
        self.vehicleno = Vehicleno
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
        self.FS_MacAddress = FS_MacAddress
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

        

    }

    class var sharedInstance: Vehicaldetails
    {
        return _Vehicaldetails
    }
}
