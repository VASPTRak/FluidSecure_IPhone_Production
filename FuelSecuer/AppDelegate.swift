//  AppDelegate.swift
//  FuelSecuer
//
//  Created by VASP on 3/28/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var reachability: Reachability!
    var reg = RegisterTableViewController()
    var cf = Commanfunction()
    var vc = ViewController()
    var wificonnection:String = "False"
    var wificonn:String!
    let defaults = UserDefaults.standard
    var id:Int!
    var jc = FuelquantityVC()
    var web = Webservices()
    var preauth = PreauthFuelquantity()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            //print(var backgroundTimeRemaining: TimeInterval { get })
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func doBackgroundTask() {
        DispatchQueue.main.async(execute: {
            self.beginBackgroundUpdateTask()
            self.jc.stopbutton = true
            _ = self.jc.unsyncTransaction()
            _ = self.preauth.preauthunsyncTransaction()
            // End the background task.
            self.endBackgroundUpdateTask()
        })
    }
    
    func displayAlert() {
        let note = UILocalNotification()
        note.alertBody = "Your Transaction is successfully completed."
        note.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(note)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         doBackgroundTask()
        do {
            reachability = try Reachability.init()
        } catch {
            print("Unable to create Reachability")
            return true;
        }
        reachability = Reachability()!
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability.startNotifier()
        }
        catch {
            print("Reachability started")
            return true;
        }
        do{
            if(defaults.string(forKey: "Register") == nil) {
            }
            else{
                if(defaults.array(forKey: "SSID") == nil) {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let LogViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    let nav = UINavigationController(rootViewController: LogViewController)
                    self.window?.rootViewController = nav
                }
                else{
                    let uid = defaults.array(forKey: "SSID")
                    let rowCount = uid!.count
                    for i in 0  ..< rowCount
                    {
                        if(cf.getSSID() == uid![i] as! String)
                        {
                            wificonnection = "True"
                            id = i
                            Vehicaldetails.sharedInstance.SSId = uid![i] as! String
                            break
                        }
                        else
                        {
                            wificonnection = "False"
                        }
                    }
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! RegisterTableViewController
                    let LogViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    
                    if(defaults.string(forKey: "Register") != "\(1)"){
                        print("root VC if condition")
                        
                        let nav =  UINavigationController(rootViewController: initViewController)
                        self.window?.rootViewController = nav
                    }
                    else{
                        print("root VC else condition")
                        let nav =  UINavigationController(rootViewController: LogViewController)
                        self.window?.rootViewController = nav
                    }
                    
                    if(wificonnection == "True"){
                        if(defaults.array(forKey: "SiteID") == nil) {}
                        else {
                            let siteid = defaults.array(forKey: "SiteID")
                            let sid = siteid![id]
                            print(sid,id)
                            Vehicaldetails.sharedInstance.siteID = sid as! String
                            
                            print("root VC if condition")
                            let nav =  UINavigationController(rootViewController: LogViewController)//thirdViewController)
                            self.window?.rootViewController = nav
                        }
                    }
                    else if(wificonnection == "False"){
                        print("root VC else condition")
                        let nav = UINavigationController(rootViewController: LogViewController)
                        self.window?.rootViewController = nav
                    }
                }
            }
        }
        catch{
            print("some problem in assigning root VC")
        }
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge , .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        return true
    }
    
    func start()
    {
        do{
            if(defaults.string(forKey: "Register") == nil) {
                
            }
            else{
                if(defaults.string(forKey: "Register") == "0")
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! RegisterTableViewController
                    let nav =  UINavigationController(rootViewController: initViewController)
                    self.window?.rootViewController = nav
                }
                else {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let _: UIViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! RegisterTableViewController
                    let loginViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    
                    if(defaults.array(forKey: "SSID") == nil) {
                        if(defaults.string(forKey: "Login") == "1")
                        {
                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                        }
                        else if(defaults.string(forKey: "Login") != "1")
                        {
                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                        }
                        else {
                            print("root VC else condition")
                            let nav =  UINavigationController(rootViewController: loginViewController)
                            self.window?.rootViewController = nav
                        }
                    }
                    else{
                        let uid = defaults.array(forKey: "SSID")
                        let rowCount = uid!.count
                        for i in 0  ..< rowCount
                        {
                            if(cf.getSSID() == uid![i] as! String)
                            {
                                wificonnection = "True"
                                id = i
                            }
                            else
                            {
                                wificonnection = "False"
                            }
                        }
                        if(defaults.string(forKey: "Login") == "1")
                        {
                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                        }
                        else{
                            print("root VC else condition")
                            let nav =  UINavigationController(rootViewController: loginViewController)
                            self.window?.rootViewController = nav
                        }
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let _ : UIViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! RegisterTableViewController
                        let loginViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                        
                        let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                        let thirdViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                        
                        print(defaults.string(forKey: "Register")!)
                        if(defaults.string(forKey: "Register") != "\(1)"){
                            print("root VC if condition")
                            let nav =  UINavigationController(rootViewController: loginViewController)
                            self.window?.rootViewController = nav
                        }
                        else{ }
                        if(wificonnection == "True"){
                            if (defaults.array(forKey: "SiteID") == nil) {}
                            else{
                                let siteid = defaults.array(forKey: "SiteID")
                                let sid = siteid![id]
                                print(sid,id)
                                Vehicaldetails.sharedInstance.siteID = sid as! String
                                print("root VC if condition")
                                let nav =  UINavigationController(rootViewController: thirdViewController)
                                self.window?.rootViewController = nav
                            }
                        }
                        else if(wificonnection == "False"){
                            print("root VC else condition")
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                            //self.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge], categories: nil))
        let settings = UIUserNotificationSettings(types: [.alert, .badge , .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        self.web.sentlog(func_name: "Application Enter In Background", errorfromserverorlink:  "Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")
        sleep(10)
//                cf.delay(10){
//        //            self.doBackgroundTask()
//        //        }// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        self.web.sentlog(func_name: "Application Enter In Foreground", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")
        doBackgroundTask()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
            _ = jc.setralay0tcp()
            _ = jc.setpulsar0tcp()
        }
        
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        let pusercount = Vehicaldetails.sharedInstance.pulsarCount
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        
        if(pusercount == "" || PulseRatio == "" || TransactionId == 0){
            
        }else {
            let fuelQuantity = (Double(pusercount))!/(PulseRatio as NSString).doubleValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            
            
            let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"1.15.18\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
            
            
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            //let unsycnfileName =  dtt1 + "transaction" + "#" + Vehicaldetails.sharedInstance.siteName
            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId//Vehicaldetails.sharedInstance.siteName
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
            }
        }

        self.web.sentlog(func_name: "Application Will Terminate", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        sleep(5)
        self.saveContext()

    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.VASPLLP.FuelSecuer" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "FuelSecuer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: Reachability callback
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi......")
                Vehicaldetails.sharedInstance.reachblevia = "wificonn"
                doBackgroundTask()
            } else {
                print("Reachable via Cellular......")
                Vehicaldetails.sharedInstance.reachblevia = "cellular"
                doBackgroundTask()
            }
        } else {
            print("Not reachable..........")
            Vehicaldetails.sharedInstance.reachblevia = "notreachable"
        }
    }
}

