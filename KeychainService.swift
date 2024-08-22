//
//  KeychainService.swift
//  FuelSecure
//
//  Created by VASP on 12/13/18.
//  Copyright © 2018 VASP. All rights reserved.
//
//

import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
//let accessGroup = "SecuritySerivice"


/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */
var web = Webservices()
let passwordKey = "KeyForPassword"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainService: NSObject {

    /**
     * Exposed methods to perform save and load queries.
     */

    public class func savePassword(token: NSString) {
        self.save(service: passwordKey as NSString, data: token)
    }

    public class func loadPassword() -> NSString? {
        return self.load(service: passwordKey as NSString)
    }
    
    public class func removeItemForKey(key: String) {
        self.save(service: passwordKey as NSString, data: "")
    }

    /**
     * Internal methods for querying the keychain.
     */

    private class func save(service: NSString, data: NSString) {
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue , allowLossyConversion: false)! as NSData //dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!

        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)

        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    private class func load(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue!, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

        var dataTypeRef :AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
       

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
                web.sentlog(func_name:  " Status code \(status)", errorfromserverorlink: "contents Of Keychain \(contentsOfKeychain)" , errorfromapp:"")
            }
        } else {
            contentsOfKeychain = "";
            print("Nothing was retrieved from the keychain. Status code \(status)")
            web.sentlog(func_name:  "Nothing was retrieved from the keychain. Status code \(status)", errorfromserverorlink: "" , errorfromapp:"")
        }

        return contentsOfKeychain
    }
}
