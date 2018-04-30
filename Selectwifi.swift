//
//  Selectwifi.swift
//  FuelSecureTest
//
//  Created by VASP on 5/25/17.
//  Copyright © 2017 VASP. All rights reserved.
//

import Foundation
import UIKit

class Selectwifi: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,StreamDelegate {
var cf = Commanfunction()
    var timer:Timer = Timer()

    override func viewDidLoad() {

        if(Vehicaldetails.sharedInstance.SSId == cf.getSSID())
        {
            showAlertSetting(message: "You are connected to \(Vehicaldetails.sharedInstance.SSId) Wi-Fi Press ok to Fueling.")
            print("ssID Match")
            self.performSegue(withIdentifier: "goconnect", sender: self)
        }
        else{
            showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
            print("ssID not Match")
            wifisettings()
        }
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.viewDidAppear(_:)), userInfo: nil, repeats: true)
    }

    override func viewDidAppear(_ animated: Bool) {

    if( cf.getSSID() != "" ) {
        print("SSID: \(cf.getSSID())")
    } else {
        // showAlert("SSID not found wifi is not connected.")
    }
}

    override func viewDidLayoutSubviews() {
        if(Vehicaldetails.sharedInstance.SSId == cf.getSSID())
        {
            showAlertSetting(message: "You are connected to \(Vehicaldetails.sharedInstance.SSId) Wi-Fi Press ok to Fueling.")
            print("ssID Match")
            self.performSegue(withIdentifier: "goconnect", sender: self)
        }
        else{
            showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
            print("ssID not Match")
            wifisettings()
        }
    }

    func wifisettings()
    {
        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared// .shared
        app.openURL(url! as URL)
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                print("ssID Match")
                self.performSegue(withIdentifier: "goconnect", sender: self)
            }
            else{
                //self.mainPage()
                self.wifisettings()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
