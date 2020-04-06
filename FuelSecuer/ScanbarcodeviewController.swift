//
//  ScanbarcodeviewController.swift
//  FuelSecure
//
//  Created by VASP on 2/22/19.
//  Copyright © 2019 VASP. All rights reserved.
//

import UIKit
import AVFoundation

class ScanbarcodeviewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    private var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer!

//    var cf = Commanfunction()

    @IBOutlet var Message: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        //videoPermission = VideoPermission()
        
        

        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
            try videoCaptureDevice?.lockForConfiguration()
            captureSession.beginConfiguration()
            // autofocus settings and focus on middle point
            videoCaptureDevice?.autoFocusRangeRestriction = .near
            videoCaptureDevice?.focusMode = .continuousAutoFocus
            videoCaptureDevice?.exposureMode = .continuousAutoExposure
            
            if let currentInput = captureSession.inputs.filter({$0 is AVCaptureDeviceInput}).first {
                captureSession.removeInput(currentInput)
            }
            // Set the input device on the capture session.
            
            if videoCaptureDevice?.supportsSessionPreset(.hd1920x1080) == true {
                captureSession.sessionPreset = .hd1920x1080
            } else if videoCaptureDevice!.supportsSessionPreset(.high) == true {
                captureSession.sessionPreset = .high
            }
            
            
//            captureSession = videoCaptureDevice
            
            
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
            captureSession.usesApplicationAudioSession = false
            captureSession.commitConfiguration()
            if #available(iOS 10.0, *) {
                captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            } else {
                // Fallback on earlier versions
            }
            if videoCaptureDevice?.isLowLightBoostSupported == true {
                videoCaptureDevice?.automaticallyEnablesLowLightBoostWhenAvailable = true
            }
            videoCaptureDevice?.unlockForConfiguration()
            captureDevice = videoCaptureDevice
        } else {
            failed();
            return;
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.interleaved2of5,AVMetadataObject.ObjectType.face, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.code93 ]//,AVMetadataObject.ObjectType.qr ]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        view.layer.addSublayer(previewLayer);

        captureSession.startRunning();
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue!);

        }

       //dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        Message.text = code
        Vehicaldetails.sharedInstance.Barcodescanvalue = self.Message.text!
        self.performSegue(withIdentifier: "scan_vehicleno", sender: self)
         self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)! - 2)
        
//        showAlertSetting(message: code)
    }

    func showAlertSetting(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
       // messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let home = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { action in //
//            Vehicaldetails.sharedInstance.Barcodescanvalue = self.Message.text!
            //self.performSegue(withIdentifier: "scan_vehicleno", sender: self)
            
//            self.popoverPresentationController
        }

        alertController.addAction(home)
        self.present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "scan_vehicleno")
        {
            let v_no = segue.destination as! VehiclenoVC
            v_no.scanvehicle = Message.text!

        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
