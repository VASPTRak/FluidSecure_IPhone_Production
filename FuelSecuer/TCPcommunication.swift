

//
//  TCPcommunication.swift
//  FuelSecure
//
//  Created by VASP on 8/29/18.
//  Copyright © 2018 VASP. All rights reserved.
//

import Foundation

class TCPCommunication:NSObject,StreamDelegate
{
    
    var inStream : InputStream?
    var outStream: OutputStream?
    let addr = "192.168.4.1"
    let port = 80
    var buffer = [UInt8](repeating: 0, count:4096)
    var stringbuffer:String = ""
    var status :String = ""
    var web = Webservices()
    var cf = Commanfunction()
    var sysdata1:NSDictionary!
    var bindata:NSData!
    var tlddatafromlink:String!
    var reply :String!
   // let defaults = UserDefaults.standard
    var replydata:NSData!
   
    
    
    //TCP Communication with the FS link using Follwing Method Functions.

        
//        func Getinfo()->String{
//            do{
//                try self.NetworkEnable()
//
//            }
//            catch let error as NSError {
//                print ("Error: \(error.domain)")
//                self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
//            }
//            //"http://192.168.4.1:80/client?command=info"
//            let datastring = "GET /client?command=info HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//
//            let data = datastring.data(using: String.Encoding.utf8)!
//
//            self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//            var outputdata :String = self.stringbuffer
//            //Thread.sleep(forTimeInterval:1)
//            if((outputdata.contains("iot_version")))
//            {
//                outputdata = "true"
//            }
//            else
//            {
//                outputdata = "false"
//            }
//            print(outputdata)
//            let text = self.stringbuffer
//
//    //        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//            let test = String((text.filter { !" \n".contains($0) }))
//            let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//            print(newString)
//            let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//            print(newString)
//            self.web.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString1)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
//
//    //        if(self.stringbuffer == ""){}
//    //        else{
//    //            if(outputdata.contains("{"))
//    //            {
//    //            let Split = outputdata.components(separatedBy: "{")
//    //            _ = Split[0]
//    //            let setrelay = Split[1]
//    //            let setrelaystatus = Split[2]
//    //            outputdata = setrelay + "{" + setrelaystatus
//    //            }
//    //        }
//            return outputdata
//        }
    
    //TCP Communication with the FS link using Follwing Method Functions.
    
    
    func setralaytcp()->String{
       
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        
        let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
        print(s.count)
        let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
        
        let data = datastring.data(using: String.Encoding.utf8)!
        
        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        var outputdata :String = self.stringbuffer
        Thread.sleep(forTimeInterval:1)
        print(outputdata)
        let text = self.stringbuffer
        
        //Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
        let test = String((text.filter { !" \n".contains($0) }))
        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
        print(newString)
        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
        print(newString)
        
        self.web.sentlog(func_name: "Sent Relay ON command to Link: http://192.168.4.1:80/config?command=relay { relay_request :{ Password : 12345678 , Status :1}}", errorfromserverorlink: "Response from link $$ \(newString1)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(cf.getSSID())")
        
        if(self.stringbuffer == ""){}
        else{
            if(outputdata.contains("{"))
            {
            let Split = outputdata.components(separatedBy: "{")
            _ = Split[0]
            let setrelay = Split[1]
            let setrelaystatus = Split[2]
            outputdata = setrelay + "{" + setrelaystatus
            }
        }
        return outputdata
        
    }
    
    // Remove the set pulsar set to 1
    //    func setpulsartcp()->String{
    //
    //        NetworkEnable()
    //
    //        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_request\":{\"counter_set\":1}}"
    //        let data : Data = datastring.data(using: String.Encoding.utf8)!
    //        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
    //        Thread.sleep(forTimeInterval:1)
    //        let outputdata = stringbuffer
    //        let text = self.stringbuffer
    //        let test = String((text.filter { !" \n".contains($0) }))
    //        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
    //        print(newString)
    //        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
    //        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
    //        print(stringbuffer)
    //        self.web.sentlog(func_name: "Fueling Page Set Pulsar oncommand Function with command:http://192.168.4.1:80/config?command=pulsar {pulsar_request:{counter_set:1}}", errorfromserverorlink: " Response from link \(newString1)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
    //        print(outputdata)
    //        return outputdata
    //    }
    
    func preauthsetSamplingtime()->String
    {
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        Vehicaldetails.sharedInstance.PulserTimingAdjust = "20"
        let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = stringbuffer
        return outputdata
    }
    
    
    func setSamplingtime()->String
    {
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        
        
        let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = stringbuffer
//        let text = self.stringbuffer
//        let test = String((text.filter { !" \n".contains($0) }))
//        let responsestring = test.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString = responsestring.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//        print(newString)
        
        self.web.sentlog(func_name: "Sent Set Sampling time command to Link with command:http://192.168.4.1:80/config?command=pulsar { pulsar_status :{ sampling_time_ms:\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)", errorfromserverorlink: " "/*Response from link $$\(newString)!!*/,errorfromapp: "  Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        return outputdata
    }
    
    func setralay0tcp()->String
    {
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
        print(s.count)
        let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
        
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = stringbuffer
//        let text = self.stringbuffer
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
        self.web.sentlog(func_name: "Sent Relay OFF command to Link command:http://192.168.4.1:80/config?command=relay { relay_request :{ Password : 12345678 , Status :0}}", errorfromserverorlink: " "/*Response from link $$ \(newString1)!!*/,errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        return outputdata
    }
    
    // Remove the set pulsar set to 0
    //    func setpulsar0tcp()->String{
    //        NetworkEnable()
    //        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_request\":{\"counter_set\":0}}"
    //        let data : Data = datastring.data(using: String.Encoding.utf8)!
    //        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
    //        let outputdata = stringbuffer
    //        let text = self.stringbuffer
    //        let test = String((text.filter { !" \n".contains($0) }))
    //        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
    //        print(newString)
    //        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
    //        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
    //        self.web.sentlog(func_name: "Fueling Page Set Pulsar OFF command Function with command:http://192.168.4.1:80/config?command=pulsar {pulsar_request:{counter_set:0}}", errorfromserverorlink: " Response from link $$ \(newString1)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
    //        return outputdata
    //    }
    //
    //Remove the final_pulsar_request set to 0
    //    func final_pulsar_request() ->String {
    //
    //        NetworkEnable()
    //        let s:String = "{\"final_pulsar_request\":{\"time\":10}}"
    //        print(s.count)
    //        let datastring = "POST /config?command=pulsarX HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"final_pulsar_request\":{\"time\":10}}"
    //        let data : Data = datastring.data(using: String.Encoding.utf8)!
    //        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
    //        let outputdata = stringbuffer
    //        let text = self.stringbuffer
    //        let test = String((text.filter { !" \n".contains($0) }))
    //        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
    //        print(newString)
    //        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
    //        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
    //        self.web.sentlog(func_name: "Fueling Page final_pulsar_request Function with command:http://192.168.4.1:80/config?command=pulsarX { final_pulsar_request :{ time :10}}", errorfromserverorlink: " Response from link $$  \(newString1)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
    //        print(outputdata)
    //        return outputdata
    //    }
    
//    func tlddata()
//    {
//        do{
//            try self.NetworkEnable()
//
//        }
//        catch let error as NSError {
//            print ("Error: \(error.domain)")
//            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
//        }
//
//        let datastring = "GET /tld?level=info HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//        let outputdata = stringbuffer
//        let text = stringbuffer
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        self.web.sentlog(func_name: "tlddata Service Function", errorfromserverorlink: " Response from Link $$\(newString1)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//
//        print(outputdata)
//        print(datastring)
//        cf.delay(0.5){
//            let Split = outputdata.components(separatedBy: "{")
//            if(Split.count < 3){
//                _ = self.setralay0tcp()
//                // _ = self.setpulsar0tcp()
//                // self.fq.error400(message:NSLocalizedString("CheckFSunit", comment:""))// "Please check your FS unit, and switch off power and back on.")
//            }    // got invalid respose do nothing
//            else{
//                let reply = Split[1]
//                let setrelay = Split[2]
//                let Split1 = setrelay.components(separatedBy: "}")
//                let setrelay1 = Split1[0]
//                self.tlddatafromlink = "{" +  reply + "{" + setrelay1 + "}" + "}"
//                //self.sendtld(replytld: self.tlddatafromlink)
//            }
//        }
//    }
    
    
    //sendtld function is commentted
//    func sendtld(replytld: String)
//    {
//        print(replytld);
//        if(replytld == "nil" || replytld == "-1")
//        {
//        }
//        else{
//            let data1 = replytld.data(using: String.Encoding.utf8)!
//            do{
//                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//            }catch let error as NSError {
//                print ("Error: \(error.domain)")
//            }
//
//            if(self.sysdata1 == nil){}
//            else
//            {
//                let objUserData = self.sysdata1.value(forKey: "tld") as! NSDictionary
//                let Response_code = objUserData.value(forKey: "Response_code") as! NSNumber
//                let checksum = objUserData.value(forKey: "Checksum") as! NSNumber
//                let LSB = objUserData.value(forKey: "LSB") as! NSNumber
//                let MSB = objUserData.value(forKey: "MSB") as! NSNumber
//                let Mac_address = objUserData.value(forKey: "Mac_address") as! NSString
//                let TLDTemperature = objUserData.value(forKey: "Tem_data") as! NSNumber
//                print(LSB,MSB,Mac_address)
//                // let probereading = self.GetProbeReading(LSB:Int(LSB),MSB:Int(MSB))
//                let uuid = self.defaults.string(forKey: "uuid")
//                let siteid = Vehicaldetails.sharedInstance.siteID
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a" //9/25/2017 10:21:41 AM"
//                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//                let dtt: String = dateFormatter.string(from: NSDate() as Date)
//
//                let bodyData = try! JSONSerialization.data(withJSONObject: ["FromSiteId":siteid,"IMEI_UDID":uuid!,"LSB":LSB,"MSB":MSB,"TLDTemperature":TLDTemperature,"ReadingDateTime":dtt,"TLD":Mac_address,"Response_code":Response_code,"Checksum":checksum], options: [])
//                // let bodyData = "{\"FromSiteId\":\(siteid),\"IMEI_UDID\":\"\((uuid!))\",\"LSB\":\"\(LSB)\",\"MSB\":\"\(MSB)\",\"TLDTemperature\":\"\(TLDTemperature)\",\"ReadingDateTime\":\"\(dtt)\",\"TLD\":\"\(Mac_address)\"}"
//
//                let reply = self.web.tldsendserver(bodyData: bodyData)
//                print(reply)
//                if (reply == "-1")
//                {
//                    //let unsycnfileName =  dtt + "#" + "\(probereading)" + "#" + "\(siteid)"// + "#" + "SaveTankMonitorReading" //
//                    //                    if(bodyData != ""){
//                    //                        //  cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
//                    //                    }
//                }
//            }
//        }
//    }
    
    
    func changessidname(wifissid:String)
    {
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        let password = Vehicaldetails.sharedInstance.password
        let s:String = "{\"Request\":{\"Softap\":{\"Connect_Softap\":{\"authmode\":\"WPAPSK/WPA2PSK\",\"channel\":6,\"ssid\":\"\(wifissid)\",\"password\":\"\(password)\"}}}}"
        print(s.count)
        let datastring = "POST /config?command=wifi HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"Request\":{\"Softap\":{\"Connect_Softap\":{\"authmode\":\"WPAPSK/WPA2PSK\",\"channel\":6,\"ssid\":\"\(wifissid)\",\"password\":\"\(password)\"}}}}"
        
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        
        let outputdata = stringbuffer
        let text = stringbuffer
        let test = String((text.filter { !" \n".contains($0) }))
        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
        print(newString)
        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
        self.web.sentlog(func_name: "Sent changessidname \(wifissid)  request to link", errorfromserverorlink: " Response from Link $$\(newString1)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        
        print(outputdata)
        print(datastring)
        print(Vehicaldetails.sharedInstance.PulserStopTime)
    }
    
    
    ///set PulsarStoptime to hose.
    
//    func setpulsaroffTime()
//    {
//        print(Vehicaldetails.sharedInstance.PulserStopTime)
//        if(Vehicaldetails.sharedInstance.PulserStopTime == "nil")
//        {
//            Vehicaldetails.sharedInstance.PulserStopTime = "25"
//        }
//
//        let time:Int = (Int(Vehicaldetails.sharedInstance.PulserStopTime)!+3) * 1000
//        print(time)
//        NetworkEnable()
//        let s:String = "{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"
//        print(s.count)
//        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"
//
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//        let outputdata = stringbuffer
//        let text = stringbuffer
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//
//        self.web.sentlog(func_name: "Fueling Page Set Pulsar OFF Time Function with command:http://192.168.4.1:80/config?command=pulsar { pulsar_status :{ pulsar_off_time :\(time)}}", errorfromserverorlink: " Response from link $$ \(newString1)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//        print(outputdata)
//
//        print(datastring)
//
//        print(Vehicaldetails.sharedInstance.PulserStopTime)
//    }
    
    
    func settransaction_IDtoFS()
    {
        let count:Int = "\(Vehicaldetails.sharedInstance.TransactionId)".count
        var format = "0000000000"
        
        let range = format.index(format.endIndex, offsetBy: -count)..<format.endIndex
        format.removeSubrange(range)
        print(format)
        let txtnid:String = format + "\(Vehicaldetails.sharedInstance.TransactionId)"
        print(txtnid)
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        let s:String = "{\"txtnid\":\(txtnid)}"
        print(s.count)
        let datastring = "POST /config?command=txtnid HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"txtnid\":\(txtnid)}"
        
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        
        let outputdata = stringbuffer
       // let text = self.stringbuffer
       // let test = String((text.filter { !" \n".contains($0) }))
       // let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
        //print(newString)
        //let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
        //let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
        
        self.web.sentlog(func_name: "Sent TXTN command to Link: command:http://192.168.4.1:80/config?command=\(txtnid)", errorfromserverorlink: ""/* Response from link $$ \(newString1)!!*/,errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        print(outputdata)
        print(datastring)
    }
    
    func upgrade()
    {
        //upgrade link with new firmware
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        let datastring = "POST /upgrade?command=start HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata :String = stringbuffer
        self.web.sentlog(func_name: "Sent Upgrade Command to Link \(datastring)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        if(stringbuffer == ""){}
        else{
            print( stringbuffer)
        }
        print(outputdata)
        self.uploadbinfile()
        
        cf.delay(2){
            self.resetdata()
        }
    }
    
    func resetdata()
    {
        do{
            try self.NetworkEnable()
            
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
            self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
        }
        let datastring = "POST /upgrade?command=reset HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata :String = stringbuffer
        print( outputdata)
        
        self.web.sentlog(func_name: "Reset Link. completed the upgrade process.", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
    }
    
    func uploadbinfile()
    {
        //Download new link from Server using getbinfile and upload/Flash the file to FS link.
        self.bindata = self.getbinfile()
       
        self.web.sentlog(func_name: "Download binfile to flashthe FS link", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
       
        let Url:String = "http://192.168.4.1:80"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        // print(bindata)
        request.setValue("\(self.bindata.length)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = (self.bindata! as Data)
        // self.lable.text = "Start Upgrade...."
        self.web.sentlog(func_name: "Start upload bin file to Link", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                self.web.sentlog(func_name: "File uploaded \(bindata.count)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                // print(self.reply)
            }  else {
                print(error!)
                self.web.sentlog(func_name: "error uploading the file \(error!)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    func getbinfile() -> NSData
    {
        let Url:String = Vehicaldetails.sharedInstance.FilePath
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "GET"
        //request.timeoutInterval = 150
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task =  session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                //                print(data,String(data: data, encoding: String.Encoding.utf8)!)
                self.replydata = data as NSData
                self.web.sentlog(func_name: "File download Completed \(data.count)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            } else {
                self.web.sentlog(func_name: "error in download the file \(error!)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                print(error!)
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return replydata
    }
    
    func getuser()
    {
        if(Vehicaldetails.sharedInstance.reachblevia == "cellular"){
            do{
                try self.NetworkEnable()
                
            }
            catch let error as NSError {
                print ("Error: \(error.domain)")
                self.web.sentlog(func_name:" NetworkEnable", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
            }
            let datastring = "GET /upgrade?command=getuser HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
            let data : Data = datastring.data(using: String.Encoding.utf8)!
            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
            let outputdata = stringbuffer
            self.web.sentlog(func_name: "Sent Upgrade Command to Link \(datastring)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            print( outputdata)
            self.upgrade()
        }
    }
    
//    func closestreams()
//    {
//        print("Closing streams.")
//
//                inStream?.close()
//                outStream?.close()
//                inStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//                outStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//                inStream?.delegate = nil
//                outStream?.delegate = nil
//                inStream = nil
//                outStream = nil
//
////
////            if let inputStr = self.inStream{
////                            inputStr.close()
////                inputStr.delegate = nil
////
////
////
////                inputStr.remove(from: .main, forMode: RunLoop.Mode.default)
////            }
////            if let outputStr = self.outStream{
////                            outputStr.close()
////                            outputStr.remove(from: .main, forMode: RunLoop.Mode.default)
////
////                outputStr.delegate = nil
////
////
////            }
////            inStream?.remove(from: .init(), forMode: RunLoop.Mode.default)
////            outStream?.remove(from: .init(), forMode: RunLoop.Mode.default)
////
////            self.inStream?.close()
////            self.outStream?.close()
////        inStream?.delegate = nil
////        outStream?.delegate = nil
////        inStream = nil
////        outStream = nil
//
//
//        }
    
    
//    func setdefault()
//    {
//        stringbuffer = ""
//        //buffer = []
//    }
    //Network functions
    func NetworkEnable() throws
    {
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        {
           // self.web.sentlog(func_name: "Stream", errorfromserverorlink:" " , errorfromapp: "Connction lost with the lin")
        }
        else{
        print("NetworkEnable")
         //buffer = [UInt8](repeating: 0, count: 4096)
        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inStream, outputStream: &outStream)
        
        inStream?.delegate = self
        outStream?.delegate = self
        
        inStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
        outStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
        
        inStream?.open()
        outStream?.open()
        
        }
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event)
    {
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        {
            inStream?.delegate = nil
            outStream?.delegate = nil
            inStream?.close()
            outStream?.close()
            
//            
            inStream = nil
            outStream = nil
//            // self.web.sentlog(func_name: "Stream", errorfromserverorlink:" " , errorfromapp: "Connction lost with the lin")
        }
        else{

         
            
        switch eventCode {
        
        case Stream.Event.endEncountered:
            print("EndEncountered")
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//            inStream?.delegate = nil
//            outStream?.delegate = nil
//            inStream = nil
//            outStream = nil
          
        case Stream.Event.errorOccurred:
            print("ErrorOccurred")
//            closestreams()
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
            outStream?.close()
            outStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
            print("Close")
//            inStream?.delegate = nil
//            outStream?.delegate = nil
//            inStream = nil
//            outStream = nil
            
        case Stream.Event.hasBytesAvailable:
            print("HasBytesAvailable")
            status = "HasBytesAvailable"
            
            if aStream == inStream {
                var buffer = [UInt8](repeating: 0, count:4096)
                inStream!.read(&buffer, maxLength: buffer.count)
                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                stringbuffer += bufferStr! as String
                print(bufferStr!)
            }
            break
            
        case Stream.Event.hasSpaceAvailable:
            print("HasSpaceAvailable")
            
        case Stream.Event():
            print("None")
            
        case Stream.Event.openCompleted:
            print("OpenCompleted")
                    
        default:
            print("Unknown")
        }
            
        }
    }
}


//import Foundation
//
//
//class TCPCommunication:NSObject,StreamDelegate
//{
//
//    var inStream : InputStream?
//    var outStream: OutputStream?
//    let addr = "192.168.4.1"
//    let port = 80
//    var buffer = [UInt8](repeating: 0, count:4096)
//    var stringbuffer:String = ""
//    var status :String = ""
//    var web = Webservices()
//    var cf = Commanfunction()
//    var sysdata1:NSDictionary!
//    var bindata:NSData!
//    var tlddatafromlink:String!
//    var reply :String!
//    let defaults = UserDefaults.standard
//    var replydata:NSData!
//
//
//
////TCP Communication with the FS link using Follwing Method Functions.
//
//
//    func Getinfo()->String{
//        NetworkEnable()
//        //"http://192.168.4.1:80/client?command=info"
//        let datastring = "GET /client?command=info HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//
//        let data = datastring.data(using: String.Encoding.utf8)!
//
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        var outputdata :String = self.stringbuffer
//        //Thread.sleep(forTimeInterval:1)
//        if((outputdata.contains("iot_version")))
//        {
//            outputdata = "true"
//        }
//        else
//        {
//            outputdata = "false"
//        }
//        print(outputdata)
//        let text = self.stringbuffer
//
////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        print(newString)
//        self.web.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString1)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
//
////        if(self.stringbuffer == ""){}
////        else{
////            if(outputdata.contains("{"))
////            {
////            let Split = outputdata.components(separatedBy: "{")
////            _ = Split[0]
////            let setrelay = Split[1]
////            let setrelaystatus = Split[2]
////            outputdata = setrelay + "{" + setrelaystatus
////            }
////        }
//        return outputdata
//    }
//
//    func Getrelay()->String{
//        NetworkEnable()
//        //"http://192.168.4.1:80/client?command=info"
//        let datastring = "GET /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//
//        let data = datastring.data(using: String.Encoding.utf8)!
//
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        var outputdata :String = self.stringbuffer
//        //Thread.sleep(forTimeInterval:1)
//        print(outputdata)
//        let text = self.stringbuffer
//
////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        print(newString)
//        //labelres.setText(newString1)
//
//
//        if(self.stringbuffer == ""){}
//        else{
//            if(outputdata.contains("{"))
//            {
//            let Split = outputdata.components(separatedBy: "{")
//            _ = Split[0]
//            let setrelay = Split[1]
//            let setrelaystatus = Split[2]
//            outputdata = setrelay + "{" + setrelaystatus
//            }
//        }
//        return outputdata
//    }
//
//    func Getpulsar()->String{
//        NetworkEnable()
//        //"http://192.168.4.1:80/client?command=info"
//        let datastring = "GET /client?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//
//        let data = datastring.data(using: String.Encoding.utf8)!
//
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        var outputdata :String = self.stringbuffer
//        //Thread.sleep(forTimeInterval:1)
//        print(outputdata)
//        let text = self.stringbuffer
//
////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        print(newString)
//        //labelres.setText(newString1)
//
//
//        if(self.stringbuffer == ""){}
//        else{
//            if(outputdata.contains("{"))
//            {
//            let Split = outputdata.components(separatedBy: "{")
//            _ = Split[0]
//            let setrelay = Split[1]
//            let setrelaystatus = Split[2]
//            outputdata = setrelay + "{" + setrelaystatus
//            }
//        }
//        return outputdata
//    }
//
//    func setralaytcp()->String{
//        NetworkEnable()
//
//        let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
//        print(s.count)
//        let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
//
//        let data = datastring.data(using: String.Encoding.utf8)!
//
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        var outputdata :String = self.stringbuffer
//        Thread.sleep(forTimeInterval:1)
//        print(outputdata)
//        let text = self.stringbuffer
//
////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        print(newString)
//
//        self.web.sentlog(func_name: "Fueling Page Relay On Function with command:http://192.168.4.1:80/config?command=relay { relay_request :{ Password : 12345678 , Status :1}}", errorfromserverorlink: "Response from link $$ \(newString1)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(cf.getSSID())")
//
//        //"HTTP/1.0 200 OK\r\nContent-Length: 0\r\nServer: lwIP/1.4.0\r\n\n"
//
//        if(self.stringbuffer == ""){}
//        else{
//            if(outputdata.contains("{"))
//            {
//            let Split = outputdata.components(separatedBy: "{")
//            _ = Split[0]
//            let setrelay = Split[1]
//            let setrelaystatus = Split[2]
//            outputdata = setrelay + "{" + setrelaystatus
//            }
//        }
//        return outputdata
//    }
//
////    func setpulsartcp()->String{
////
////        NetworkEnable()
////
////        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_request\":{\"counter_set\":1}}"
////        let data : Data = datastring.data(using: String.Encoding.utf8)!
////        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////        Thread.sleep(forTimeInterval:1)
////        let outputdata = stringbuffer
////        let text = self.stringbuffer
////        let test = String((text.filter { !" \n".contains($0) }))
////        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
////        print(newString)
////        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
////        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
////        print(stringbuffer)
////        self.web.sentlog(func_name: "Fueling Page Set Pulsar oncommand Function with command:http://192.168.4.1:80/config?command=pulsar {pulsar_request:{counter_set:1}}", errorfromserverorlink: " Response from link \(newString1)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
////        print(outputdata)
////        return outputdata
////    }
//
//        func preauthsetSamplingtime()->String{
//
//            NetworkEnable()
//            Vehicaldetails.sharedInstance.PulserTimingAdjust = "20"
//            let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
//            print(s.count)
//            let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//            let outputdata = stringbuffer
//            return outputdata
//        }
//
//
//    func setSamplingtime()->String{
//
//        NetworkEnable()
//
//        let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
//        print(s.count)
//        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata = stringbuffer
////        let text = self.stringbuffer
////        let test = String((text.filter { !" \n".contains($0) }))
////        let responsestring = test.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
////        let newString = responsestring.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
////        print(newString)
//
//        self.web.sentlog(func_name: "Fueling Page Set Sampling time Function with command:http://192.168.4.1:80/config?command=pulsar { pulsar_status :{ sampling_time_ms:\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)", errorfromserverorlink: " "/*Response from link $$\(newString)!!"*/,errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//        return outputdata
//    }
//
//    func setralay0tcp()->String{
//        NetworkEnable()
//        let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
//        print(s.count)
//        let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
//
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata = stringbuffer
////        let text = self.stringbuffer
////        let test = String((text.filter { !" \n".contains($0) }))
////        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
////        print(newString)
////        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
////        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        self.web.sentlog(func_name: "Fueling Page Relay OFF Function with command:http://192.168.4.1:80/config?command=relay { relay_request :{ Password : 12345678 , Status :0}}", errorfromserverorlink: " "/*Response from link $$ \(newString1)!!"*/,errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//        return outputdata
//    }
//
////    func setpulsar0tcp()->String{
////        NetworkEnable()
////        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_request\":{\"counter_set\":0}}"
////        let data : Data = datastring.data(using: String.Encoding.utf8)!
////        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////        let outputdata = stringbuffer
////        let text = self.stringbuffer
////        let test = String((text.filter { !" \n".contains($0) }))
////        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
////        print(newString)
////        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
////        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
////        self.web.sentlog(func_name: "Fueling Page Set Pulsar OFF command Function with command:http://192.168.4.1:80/config?command=pulsar {pulsar_request:{counter_set:0}}", errorfromserverorlink: " Response from link $$ \(newString1)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
////        return outputdata
////    }
//
//
////    func final_pulsar_request() ->String {
////
////        NetworkEnable()
////        let s:String = "{\"final_pulsar_request\":{\"time\":10}}"
////        print(s.count)
////        let datastring = "POST /config?command=pulsarX HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"final_pulsar_request\":{\"time\":10}}"
////        let data : Data = datastring.data(using: String.Encoding.utf8)!
////        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////        let outputdata = stringbuffer
////        let text = self.stringbuffer
////        let test = String((text.filter { !" \n".contains($0) }))
////        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
////        print(newString)
////        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
////        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
////        self.web.sentlog(func_name: "Fueling Page final_pulsar_request Function with command:http://192.168.4.1:80/config?command=pulsarX { final_pulsar_request :{ time :10}}", errorfromserverorlink: " Response from link $$  \(newString1)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
////        print(outputdata)
////        return outputdata
////    }
//
//    func tlddata() {
//        NetworkEnable()
//
//        let datastring = "GET /tld?level=info HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//        let outputdata = stringbuffer
////        let text = stringbuffer
////        let test = String((text.filter { !" \n".contains($0) }))
////        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
////        print(newString)
////        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
////        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        self.web.sentlog(func_name: "tlddata Service Function", errorfromserverorlink: ""/* Response from Link $$\(newString1)!!"*/,errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//
//        print(outputdata)
//        print(datastring)
//        cf.delay(0.5){
//            let Split = outputdata.components(separatedBy: "{")
//            if(Split.count < 3){
//                _ = self.setralay0tcp()
//               // _ = self.setpulsar0tcp()
//               // self.fq.error400(message:NSLocalizedString("CheckFSunit", comment:""))// "Please check your FS unit, and switch off power and back on.")
//            }    // got invalid respose do nothing
//            else{
//                let reply = Split[1]
//                let setrelay = Split[2]
//                let Split1 = setrelay.components(separatedBy: "}")
//                let setrelay1 = Split1[0]
//                self.tlddatafromlink = "{" +  reply + "{" + setrelay1 + "}" + "}"
//                self.sendtld(replytld: self.tlddatafromlink)
//            }
//        }
//    }
//
//    func sendtld(replytld: String)
//    {
//        print(replytld);
//        if(replytld == "nil" || replytld == "-1")
//        {
//        }
//        else{
//            let data1 = replytld.data(using: String.Encoding.utf8)!
//            do{
//                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//            }catch let error as NSError {
//                print ("Error: \(error.domain)")
//            }
//
//            if(self.sysdata1 == nil){}
//            else
//            {
//                let objUserData = self.sysdata1.value(forKey: "tld") as! NSDictionary
//                let Response_code = objUserData.value(forKey: "Response_code") as! NSNumber
//                let checksum = objUserData.value(forKey: "Checksum") as! NSNumber
//                let LSB = objUserData.value(forKey: "LSB") as! NSNumber
//                let MSB = objUserData.value(forKey: "MSB") as! NSNumber
//                let Mac_address = objUserData.value(forKey: "Mac_address") as! NSString
//                let TLDTemperature = objUserData.value(forKey: "Tem_data") as! NSNumber
//                print(LSB,MSB,Mac_address)
//                // let probereading = self.GetProbeReading(LSB:Int(LSB),MSB:Int(MSB))
//                let uuid = self.defaults.string(forKey: "uuid")
//                let siteid = Vehicaldetails.sharedInstance.siteID
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a" //9/25/2017 10:21:41 AM"
//                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//                let dtt: String = dateFormatter.string(from: NSDate() as Date)
//
//                 let bodyData = try! JSONSerialization.data(withJSONObject: ["FromSiteId":siteid,"IMEI_UDID":uuid!,"LSB":LSB,"MSB":MSB,"TLDTemperature":TLDTemperature,"ReadingDateTime":dtt,"TLD":Mac_address,"Response_code":Response_code,"Checksum":checksum], options: [])
//               // let bodyData = "{\"FromSiteId\":\(siteid),\"IMEI_UDID\":\"\((uuid!))\",\"LSB\":\"\(LSB)\",\"MSB\":\"\(MSB)\",\"TLDTemperature\":\"\(TLDTemperature)\",\"ReadingDateTime\":\"\(dtt)\",\"TLD\":\"\(Mac_address)\"}"
//
//                let reply = self.web.tldsendserver(bodyData: bodyData)
//                print(reply)
//                if (reply == "-1")
//                {
//                    //let unsycnfileName =  dtt + "#" + "\(probereading)" + "#" + "\(siteid)"// + "#" + "SaveTankMonitorReading" //
////                    if(bodyData != ""){
////                        //  cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
////                    }
//                }
//            }
//        }
//    }
//
//
//    func changessidname(wifissid:String) {
//        NetworkEnable()
//        let password = Vehicaldetails.sharedInstance.password
//        let s:String = "{\"Request\":{\"Softap\":{\"Connect_Softap\":{\"authmode\":\"WPAPSK/WPA2PSK\",\"channel\":6,\"ssid\":\"\(wifissid)\",\"password\":\"\(password)\"}}}}"
//        print(s.count)
//        let datastring = "POST /config?command=wifi HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"Request\":{\"Softap\":{\"Connect_Softap\":{\"authmode\":\"WPAPSK/WPA2PSK\",\"channel\":6,\"ssid\":\"\(wifissid)\",\"password\":\"\(password)\"}}}}"
//
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//        let outputdata = stringbuffer
//        let text = stringbuffer
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        self.web.sentlog(func_name: "changessidname send request Service Function", errorfromserverorlink: " Response from Link $$\(newString1)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//
//        print(outputdata)
//        print(datastring)
//        print(Vehicaldetails.sharedInstance.PulserStopTime)
//    }
//
//
//    ///set PulsarStoptime to hose.
//
////    func setpulsaroffTime(){
////        print(Vehicaldetails.sharedInstance.PulserStopTime)
////        if(Vehicaldetails.sharedInstance.PulserStopTime == "nil")
////        {
////            Vehicaldetails.sharedInstance.PulserStopTime = "25"
////        }
////
////        let time:Int = (Int(Vehicaldetails.sharedInstance.PulserStopTime)!+3) * 1000
////        print(time)
////        NetworkEnable()
////        let s:String = "{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"
////        print(s.count)
////        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"
////
////        let data : Data = datastring.data(using: String.Encoding.utf8)!
////        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////
////        let outputdata = stringbuffer
//////        let text = stringbuffer
//////        let test = String((text.filter { !" \n".contains($0) }))
//////        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//////        print(newString)
//////        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//////        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
////
////        self.web.sentlog(func_name: "Fueling Page Set Pulsar OFF Time Function with command:http://192.168.4.1:80/config?command=pulsar { pulsar_status :{ pulsar_off_time :\(time)}}", errorfromserverorlink: " "/*Response from link $$ \(newString1)!!"*/,errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
////        print(outputdata)
////
////        print(datastring)
////
////        print(Vehicaldetails.sharedInstance.PulserStopTime)
////    }
//
//
//    func settransaction_IDtoFS(){
//        let count:Int = "\(Vehicaldetails.sharedInstance.TransactionId)".count
//        var format = "0000000000"
//
//        let range = format.index(format.endIndex, offsetBy: -count)..<format.endIndex
//        format.removeSubrange(range)
//        print(format)
//        let txtnid:String = format + "\(Vehicaldetails.sharedInstance.TransactionId)"
//        print(txtnid)
//        NetworkEnable()
//        let s:String = "{\"txtnid\":\(txtnid)}"
//        print(s.count)
//        let datastring = "POST /config?command=txtnid HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"txtnid\":\(txtnid)}"
//
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//        let outputdata = stringbuffer
//        let text = self.stringbuffer
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//
//        self.web.sentlog(func_name: "Fueling Page Set_Transaction_IDtoFS Function with command:http://192.168.4.1:80/config?command=txtnid", errorfromserverorlink: " Response from link $$ \(newString1)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//        print(outputdata)
//        print(datastring)
//    }
//
//    func upgrade() {
//        //upgrade link with new firmware
//        NetworkEnable()
//        let datastring = "POST /upgrade?command=start HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata :String = stringbuffer
//        if(stringbuffer == ""){}
//        else{
//            print( stringbuffer)
//        }
//        print(outputdata)
//        self.uploadbinfile()
//        cf.delay(2){
//            self.resetdata()
//        }
//    }
//
//    func resetdata()  {
//        NetworkEnable()
//        let datastring = "POST /upgrade?command=reset HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata :String = stringbuffer
//        print( outputdata)
//    }
//
//    func uploadbinfile(){
//        //Download new link from Server using getbinfile and upload/Flash the file to FS link.
//        self.bindata = self.getbinfile()
//        let Url:String = "http://192.168.4.1:80"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//       // print(bindata)
//        request.setValue("\(self.bindata.length)", forHTTPHeaderField: "Content-Length")
//        request.httpMethod = "POST"
//        request.httpBody = (self.bindata! as Data)
//       // self.lable.text = "Start Upgrade...."
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//               // print(self.reply)
//            }  else {
//                print(error!)
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//    }
//
//    func getbinfile() -> NSData
//    {
//        let Url:String = Vehicaldetails.sharedInstance.FilePath
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//        request.httpMethod = "GET"
//        //request.timeoutInterval = 150
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task =  session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
////                print(data,String(data: data, encoding: String.Encoding.utf8)!)
//                self.replydata = data as NSData
//            } else {
//                print(error!)
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return replydata
//    }
//
//    func getuser(){
//        if(Vehicaldetails.sharedInstance.reachblevia == "cellular"){
//            NetworkEnable()
//            let datastring = "GET /upgrade?command=getuser HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//            let outputdata = stringbuffer
//            print( outputdata)
//            self.upgrade()
//        }
//    }
//
//    func closestreams(){
//
//        if let inputStr = self.inStream{
//                        inputStr.close()
////            inputStr.remove(from: .main, forMode: RunLoop.Mode.tracking)
////            inputStr.remove(from: .main, forMode: RunLoop.Mode.common)
//            inputStr.remove(from: .main, forMode: RunLoop.Mode.default)
//        }
//        if let outputStr = self.outStream{
//                        outputStr.close()
//                        outputStr.remove(from: .main, forMode: RunLoop.Mode.default)
////            outputStr.remove(from: .main, forMode: RunLoop.Mode.tracking)
////            outputStr.remove(from: .main, forMode: RunLoop.Mode.common)
//        }
//        inStream?.remove(from: .init(), forMode: RunLoop.Mode.default)
//        outStream?.remove(from: .init(), forMode: RunLoop.Mode.default)
//        self.inStream?.close()
//        self.outStream?.close()
//        inStream?.delegate = nil
//        outStream?.delegate = nil
//
//
//    }
//
//    func setdefault(){
//        stringbuffer = ""
//        //buffer = []
//    }
//    //Network functions
//    func NetworkEnable() {
//
//        print("NetworkEnable")
//
//        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inStream, outputStream: &outStream)
//
//        inStream?.delegate = self
//        outStream?.delegate = self
//
//        inStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
//        outStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
//
//        inStream?.open()
//        outStream?.open()
//
//
//
//    }
//
//    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
//        var buffer = [UInt8](repeating: 0, count: 4096)
//        switch eventCode {
//
//        case Stream.Event.endEncountered:
//            print("EndEncountered")
//
//            inStream?.close()
//            inStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
//            outStream?.close()
//            print("Stop outStream currentRunLoop")
//            outStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//
//        case Stream.Event.errorOccurred:
//            print("ErrorOccurred")
//            inStream?.close()
//            inStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//            outStream?.close()
//            outStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//            print("Close")
//
//        case Stream.Event.hasBytesAvailable:
//            print("HasBytesAvailable")
//            status = "HasBytesAvailable"
//            if aStream == inStream {
//                inStream!.read(&buffer, maxLength: buffer.count)
//                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
//                stringbuffer += bufferStr! as String
//                print(bufferStr!)
//            }
//            break
//
//        case Stream.Event.hasSpaceAvailable:
//            print("HasSpaceAvailable")
//
//        case Stream.Event():
//            print("None")
//
//        case Stream.Event.openCompleted:
//            print("OpenCompleted")
//
//        default:
//            print("Unknown")
//        }
//    }
//
//}
//
