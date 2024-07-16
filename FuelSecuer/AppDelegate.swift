//  AppDelegate.swift
//  FuelSecuer

//  Created by VASP on 3/28/16.
//  Copyright © 2016 VASP. All rights reserved.
import UIKit
import CoreData
import BackgroundTasks
import UserNotifications
import FirebaseMessaging
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, MessagingDelegate, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var reachability: Reachability!
    let gcmMessageIDKey = "gcm_msg"
    var web = Webservices()
    var unsync = Sync_Unsynctransactions()
    var cf = Commanfunction()
    var wificonnection:String = "False"
    let defaults = UserDefaults.standard
    var id:Int!
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //2443
        
       
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM

        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
        }
     
        application.registerForRemoteNotifications()
        registerForPushNotifications()
   
//        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
       
//        UIApplication.shared.setMinimumBackgroundFetchInterval(100)
//        registerBackgroundTasks()
        
        
        reachability = Reachability.init()
       
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
                    
                    if(defaults.string(forKey: "Register") == "0")
                    {
                        print("root VC if condition")
                        
                        let nav =  UINavigationController(rootViewController: initViewController)
                        self.window?.rootViewController = nav
                        self.web.sentlog(func_name: "App Goes to resgistration screen ", errorfromserverorlink: "", errorfromapp: "")
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
                      //      print(sid,id)
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
//        catch{
//            print("some problem in assigning root VC")
//        }
       
        DispatchQueue.global().async {
            self.cf.checkVersion()
            self.registerBackgroundTasks()
            
            
            let TopicNameForFCMForIPhone = self.defaults.string(forKey: "TopicNameForFCMForIPhone")
            //print(TopicNameForFCMForIPhone)
            if(TopicNameForFCMForIPhone == "" || TopicNameForFCMForIPhone == nil){
                Messaging.messaging().subscribe(toTopic:"FluidSecureAPPNotifications_Prod_IPhone")
                print( "Subscribed to FluidSecureAPPNotifications_IPhone topic")
            }
            else
            {
                print(TopicNameForFCMForIPhone!)
                Messaging.messaging().subscribe(toTopic:"\(TopicNameForFCMForIPhone!)")
                print("Subscribed to \(String(describing: TopicNameForFCMForIPhone)) topic")
            }
            
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                } else if let token = token {
                    print("FCM registration token: \(token)")
                    
                }
            }
        }
        return true
    }
    
   
    
    
    func preauthstart(){
        do{
            //self.web.sentlog(func_name: "Appdelegate Start()", errorfromserverorlink: "", errorfromapp: "")

            if(defaults.string(forKey: "Register") == nil) {

            }
            else{
                if(defaults.string(forKey: "Register") == "0")
                {

                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! RegisterTableViewController
                    let nav = UINavigationController(rootViewController: initViewController)
                    self.window?.rootViewController = nav
                    self.web.sentlog(func_name: "App Goes to resgistration screen not 1", errorfromserverorlink: "", errorfromapp: "")
                }
                else {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let _: UIViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! RegisterTableViewController
                    let loginViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController

                    if(defaults.array(forKey: "SSID") == nil) {
                        if(defaults.string(forKey: "Login") == "1")
                        {
                            let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
                            Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
                            let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as! PreauthVC
                            let nav =  UINavigationController(rootViewController: controller)
                            self.window?.rootViewController = nav
                        }
                        else if(defaults.string(forKey: "Login") != "1")
                        {
                            let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
                            Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
                            let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as! PreauthVC
                            let nav =  UINavigationController(rootViewController: controller)
                            self.window?.rootViewController = nav
                        }
                        else {
                            print("root VC else condition")
                            let nav =  UINavigationController(rootViewController: loginViewController)
                            self.window?.rootViewController = nav
                        }
                    }
                    else{
                        do
                        { let uid = defaults.array(forKey: "SSID")
                            let rowCount =  uid!.count
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
                        } //catch let error as NSError {}
                        
                        if(defaults.string(forKey: "Login") == "1")
                        {
                            let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
                            Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
                            let controller = storyboard.instantiateViewController(withIdentifier: "preauthInitialController") as! PreauthVC
                            let nav = UINavigationController(rootViewController: controller)
                            self.window?.rootViewController = nav
                        }
                        else{
                            print("root VC else condition")
                            let nav =  UINavigationController(rootViewController: loginViewController)
                            self.window?.rootViewController = nav
                        }
                        let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
                        Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
                        let controller = storyboard.instantiateViewController(withIdentifier: "preauthInitialController") as! PreauthVC


                        print(defaults.string(forKey: "Register")!)
                        if(defaults.string(forKey: "Register") != "\(1)"){
                            print("root VC if condition")
                            let nav =  UINavigationController(rootViewController: loginViewController)
                            self.window?.rootViewController = nav
                            self.web.sentlog(func_name: "App Goes to resgistration screen not 1", errorfromserverorlink: "", errorfromapp: "")
                        }
                        else{ }
                        if(wificonnection == "True"){
                            if (defaults.array(forKey: "SiteID") == nil) {}
                            else{

                                let nav =  UINavigationController(rootViewController: controller)
                                self.window?.rootViewController = nav
                            }
                        }
                        else if(wificonnection == "False"){
                            print("root VC else condition")
                            let nav =  UINavigationController(rootViewController: controller)
                            
                            self.window?.rootViewController = nav
                          
                        }
                    }
                }
            }
        }
//        catch let error as NSError {
//            print ("Error: \(error.domain)")
//        }

    }
    
    
    func registerBackgroundTasks() {
        // Declared at the "Permitted background task scheduler identifiers" in info.plist
        let backgroundAppRefreshTaskSchedulerIdentifier = "com.VASPLLP.FuelSecureTest.refresh"
        let backgroundProcessingTaskSchedulerIdentifier = "com.VASPLLP.FuelSecureTest.process"
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundProcessingTaskSchedulerIdentifier, using: nil) { task in

                task.setTaskCompleted(success: true)
                self.scheduleBackgroundProcessing()
            }
        } else {
            // Fallback on earlier versions
        }
        // Use the identifier which represents your needs
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
                print("BackgroundAppRefreshTaskScheduler is executed NOW!")
                self.handleAppRefresh(task: task as! BGProcessingTask)
                //                print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
//                task.expirationHandler = {
//                    task.setTaskCompleted(success: false)
//                }
//
//                // Do some data fetching and call setTaskCompleted(success:) asap!
//                let isFetchingSuccess = true
//                task.setTaskCompleted(success: isFetchingSuccess)
                
            }
        } else {
            // Fallback on earlier versions
        }
       }
   
    
   
    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGProcessingTask) {
            scheduleAppRefresh()
            
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
        unsync.unsyncTransaction()
        unsync.unsyncP_typestatus()
        unsync.Send10trans()
       _ = unsync.preauthunsyncTransaction()
            // increment instead of a fixed number
//            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "bgtask")+1, forKey: "bgtask")

            task.setTaskCompleted(success: true)
        }
    
    @available(iOS 13.0, *)
    func scheduleAppRefresh() {
        
        let request = BGProcessingTaskRequest(identifier: "com.VASPLLP.FuelSecureTest.refresh")
//        request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
//        request.requiresExternalPower = false // Need to true if your task requires a device connected to power source. Defaults to false.

        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Process after 5 minutes.
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Process after 5 minutes.

        do {
            try BGTaskScheduler.shared.submit(request)
            print("background refresh scheduled \(request)")
        } catch {
            print("Could not schedule image fetch: (error)")
        }
        
//        if #available(iOS 13.0, *) {
////            let timeDelay = 10.0
//            let dateFormatter = DateFormatter()
////            dateFormatter.dateFormat = "ddMMyyyyhhmmss ZZZ"
////            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
//            let request = BGAppRefreshTaskRequest(identifier: "com.VASPLLP.FuelSecureTest.refresh")
//
////            var Currentdate = dateFormatter.date(from: dtt1)! as Date
////            print(Currentdate,dtt1)
////            request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)
//
//
//            var currentDate = Date()
////
////            // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
//            let timezoneOffset =  TimeZone.current.secondsFromGMT()
////
////            // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
//            let epochDate = currentDate.timeIntervalSince1970
////
////            // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
////            //    local date since 1970.
////            //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
////            //    calculates correctly.
//            let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
////
////            // 4) Finally, create a date using the seconds offset since 1970 for the local date.
//            let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
////            print("timeZoneOffsetDate:\(timeZoneOffsetDate),timezoneEpochOffset:\(timezoneEpochOffset),epochDate:\(epochDate),timezoneOffset :\(timezoneOffset),currentDate:\(currentDate)")
//
////                dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss ZZZ"
////                let after_add_time = dateFormatter.string(from: date)
////
////           let localISOFormatter = ISO8601DateFormatter()
////            localISOFormatter.timeZone = TimeZone.current
////
////            // Printing a Date
////            let date = Date()
////            print(localISOFormatter.string(from: date))
////
////            // Parsing a string timestamp representing a date
//////            let dateString = "2020-05-30T23:32:27-05:00"
////            let localDate = localISOFormatter.date(from: localISOFormatter.string(from: date))
////            let currentdate = dateFormatter.date(from: after_add_time)
//
////            let addminutes = timeZoneOffsetDate.addingTimeInterval(2*60)
////            print(after_add_time, currentdate! ,addminutes,localDate)
//            //Date(timeIntervalSinceNow: 5 * 60)
//            request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60)
//            //request.earliestBeginDate = addminutes
//      do {
//        try BGTaskScheduler.shared.submit(request)
//        print("background refresh scheduled \(request)")
//      } catch {
//        print("Couldn't schedule app refresh \(error.localizedDescription)")
//      }
//        } else {
            // Fallback on earlier versions
//        }
    }
    
    @available(iOS 13.0, *)
       func scheduleBackgroundProcessing() {
           let request = BGProcessingTaskRequest(identifier: "com.VASPLLP.FuelSecureTest.process")
           request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
           request.requiresExternalPower = false // Need to true if your task requires a device connected to power source. Defaults to false.

           request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Process after 5 minutes.

           do {
               try BGTaskScheduler.shared.submit(request)
               print("background refresh scheduled \(request)")
           } catch {
               print("Could not schedule image fetch: (error)")
           }
       }
    

    
    
    func start()
    {
        do{
      //  self.web.sentlog(func_name: "Appdelegate Start()", errorfromserverorlink: "", errorfromapp: "")

            if(defaults.string(forKey: "Register") == nil) {
                
            }
            else{
                 if(defaults.string(forKey: "Register") == "0")
                {

                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! RegisterTableViewController
                    let nav = UINavigationController(rootViewController: initViewController)
                    self.window?.rootViewController = nav
                    self.web.sentlog(func_name: "App Goes to resgistration screen not 1", errorfromserverorlink: "", errorfromapp: "")
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
                        if(defaults.string(forKey: "Companyname") == "Company2")
                        {
                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "CompanyVC") as! CompanyViewController
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                        }
                        else if(defaults.string(forKey: "Companyname") != "Company1")
                        {
                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                        }
                        
                    }
                    else{
                        do
                        {
                        let uid = try defaults.array(forKey: "SSID")
                
                        let rowCount =  uid!.count
                            
                        for i in 0  ..< rowCount
                        {
                            if(cf.getSSID() == uid![i] as! String)
                            {
                                wificonnection = "True"
                                id = i
//                                break
                            }
                            else
                            {
                                wificonnection = "False"
                            }
                        }
                        } catch let error as NSError {}
                        if(defaults.string(forKey: "Login") == "1")
                        {
                            let nav =  UINavigationController(rootViewController: loginViewController)
                            self.window?.rootViewController = nav
//                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
//                            let nav = UINavigationController(rootViewController: secondViewController)
//                            self.window?.rootViewController = nav
                        }
                        else{
                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                            let nav = UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                            
                            print("root VC else condition")
//                            let nav =  UINavigationController(rootViewController: loginViewController)
//                            self.window?.rootViewController = nav
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
                            self.web.sentlog(func_name: "App Goes to resgistration screen not 1", errorfromserverorlink: "", errorfromapp: "")
                        }
                        else{ }
                        if(wificonnection == "True"){
                            if (defaults.array(forKey: "SiteID") == nil) {}
                            else{
//                                let siteid = defaults.array(forKey: "SiteID")
//                                let sid = siteid![id]
//                                print(sid,id)
//                                Vehicaldetails.sharedInstance.siteID = sid as! String
//                                print("root VC if condition")
                                let nav =  UINavigationController(rootViewController: thirdViewController)
                                self.window?.rootViewController = nav
                            }
                        }
                        else if(wificonnection == "False"){
                            print("root VC else condition")
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                           // self.web.sentlog(func_name: "Appdelegate Start goto select hose screen", errorfromserverorlink: "", errorfromapp: "")
                            //self.window?.makeKeyAndVisible()
                        }
                        if(defaults.string(forKey: "Companyname") == "Company2")
                        {
                            let Company_ViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "CompanyVC") as! CompanyViewController
                            let nav =  UINavigationController(rootViewController: Company_ViewController)
                            self.window?.rootViewController = nav
                        }
                        else if(defaults.string(forKey: "Companyname") != "Company1")
                        {
                            let secondViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "thirdVC") as! ViewController
                            let nav =  UINavigationController(rootViewController: secondViewController)
                            self.window?.rootViewController = nav
                        }
                    }
                }
            }
        }
        catch let error as NSError {
            print ("Error: \(error.domain)")
        }
    }
    
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge], categories: nil))
//        let settings = UIUserNotificationSettings(types: [.alert, .badge , .sound], categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        
        self.web.sentlog(func_name: "Application Enter In Background", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")
        //        //        }// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        //        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //        }
        if #available(iOS 13, *) {
            self.scheduleAppRefresh()
//            self.scheduleBackgroundProcessing()
        }
        else{
            if #available(iOS 13.0, *) {
                scheduleAppRefresh()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        self.web.sentlog(func_name: "Application Enter In Foreground", errorfromserverorlink: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected wifi: \(self.cf.getSSID())")
        cf.showUpdateWithForce()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(Date()) perfom bg fetch")
        self.web.sentlog(func_name: "\(Date()) perfom bg fetch", errorfromserverorlink: " ", errorfromapp: " ")
        let uuid = defaults.string(forKey: "uuid")
        if(uuid == nil){}
        else{
            unsync.unsyncTransaction()
            unsync.unsyncP_typestatus()
            unsync.Send10trans()
          _ = unsync.preauthunsyncTransaction()
            completionHandler(.newData)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        if(Vehicaldetails.sharedInstance.ifStartbuttontapped == true){}  /// Is Start button tapped is true then do nothing
        else {
        
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")//did not press start (start appeared, was never pressed):  User did not Press Start
            }
            else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
            {
                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
                //potentialfix()
            }
        }
        
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        let pusercount = Vehicaldetails.sharedInstance.pulsarCount
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        var bodyData = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        if(pusercount == "" || PulseRatio == "" || TransactionId == 0){
            
        }else {

            let fuelQuantity = (Double(pusercount))!/(PulseRatio as NSString).doubleValue
            if(Vehicaldetails.sharedInstance.AppType == "AuthTransaction"){

             bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
            }
            else if(Vehicaldetails.sharedInstance.AppType == "preAuthTransaction"){
                

                
                   let sourcelat = Vehicaldetails.sharedInstance.Lat//currentlocation.coordinate.latitude
                    let sourcelong = Vehicaldetails.sharedInstance.Long//currentlocation.coordinate.longitude
                let siteid = Vehicaldetails.sharedInstance.siteID
                let FuelTypeId = Vehicaldetails.sharedInstance.FuelTypeId
                var Odomtr = Vehicaldetails.sharedInstance.Odometerno
                if(Odomtr == ""){
                    Odomtr = "0"
                }
                
                var Hours = Vehicaldetails.sharedInstance.hours
                if(Hours == ""){
                    Hours = "0"
                }
//
                let datepreauthFormatter = DateFormatter()
                datepreauthFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" //9/25/2017 10:21:41 AM"
                datepreauthFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                let dtt: String = datepreauthFormatter.string(from: NSDate() as Date)
                let Wifyssid = Vehicaldetails.sharedInstance.SSId
                //let pulser_count = Vehicaldetails.sharedInstance.pulsarCount
                 let preauthbodyData = "{\"SiteId\":\(siteid),\"CurrentOdometer\":\(Odomtr),\"FuelQuantity\":\((fuelQuantity)),\"TransactionId\":\(TransactionId),\"FuelTypeId\":\(FuelTypeId),\"WifiSSId\":\"\(Wifyssid)\",\"TransactionDate\":\"\(dtt)\",\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"VehicleNumber\":\"\(Vehicaldetails.sharedInstance.vehicleno)\",\"ErrorCode\":\"\(Vehicaldetails.sharedInstance.Errorcode)\",\"DepartmentNumber\":\"\(Vehicaldetails.sharedInstance.deptno)\",\"Hours\":\(Hours),\"VehicleExtraOther\":\"\(Vehicaldetails.sharedInstance.ExtraOther)\",\"Other\":\"\(Vehicaldetails.sharedInstance.Other)\",\"PersonnelPIN\":\"\(Vehicaldetails.sharedInstance.Personalpinno)\",\"CurrentLng\":\"\(sourcelong)\",\"CurrentLat\":\"\(sourcelat)\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
                print(preauthbodyData)
                //let unsycnfileName =  dtt1 + "transaction" + "#" + Vehicaldetails.sharedInstance.siteName
                let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId//Vehicaldetails.sharedInstance.siteName
                if(preauthbodyData != ""){
                    cf.preauthSaveTextFile(fileName: unsycnfileName, writeText: preauthbodyData)
                }

                
               // preauth.Transaction(fuelQuantity: (Double(pusercount))!/(PulseRatio as NSString).doubleValue)
            }

            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            //let unsycnfileName =  dtt1 + "transaction" + "#" + Vehicaldetails.sharedInstance.siteName
            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId//Vehicaldetails.sharedInstance.siteName
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
            }
        }
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT"){
            let pulsercount = Vehicaldetails.sharedInstance.pulsarCount
            if(pulsercount == "")
            {
                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
            }
       // jc.Stopconnection()
        }
        
        unsync.unsyncTransaction()
        unsync.unsyncP_typestatus()
        unsync.Send10trans()
        _ = unsync.preauthunsyncTransaction()
        
        self.web.sentlog(func_name: "Application Will Terminate", errorfromserverorlink: " Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link : \(self.cf.getSSID())")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        sleep(5)
        //self.saveContext()

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
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi......")
                Vehicaldetails.sharedInstance.reachblevia = "wificonn"
               
            } else {
                print("Reachable via Cellular......")
                Vehicaldetails.sharedInstance.reachblevia = "cellular"
                
            }
        } else {
            print("Not reachable..........")
            Vehicaldetails.sharedInstance.reachblevia = "notreachable"
        }
    }
}


// Push Notificaion
extension AppDelegate {
func registerForPushNotifications() {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] (granted, error) in
            print("Permission granted: \(granted)")

            guard granted else {
                print("Please enable \"Notifications\" from App Settings.")
//                self?.showPermissionAlert()
                return
            }

            self?.getNotificationSettings()
        }
    } else {
        let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
}

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken;
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
        let userNotificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                            repeats: false)
            let request = UNNotificationRequest(identifier: "testNotification",
                                                content: notificationContent,
                                                trigger: trigger)
            
            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }}
    }
    
@available(iOS 10.0, *)
func getNotificationSettings() {

    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}


func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
}

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken!))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

    // If your app was running and in the foreground
    // Or
    // If your app was running or suspended in the background and the user brings it to the foreground by tapping the push notification

    print("didReceiveRemoteNotification /(userInfo)")

    guard let dict = userInfo["aps"]  as? [String: Any], let msg = dict ["alert"] as? String else {
        print("Notification Parsing Error")
        let userNotificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                            repeats: false)
            let request = UNNotificationRequest(identifier: "testNotification",
                                                content: notificationContent,
                                                trigger: trigger)
            
            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
        return
    }
  }
}
