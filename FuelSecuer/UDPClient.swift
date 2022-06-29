////
////  UDPClient.swift
////  FuelSecure
////
////  Created by apple on 31/12/20.
////  Copyright © 2020 VASP. All rights reserved.
////
//
//import Foundation
//import Network
//
//@available(iOS 12.0, *)
class UDPClient {
//
//    var cf = Commanfunction()
//    var connection: NWConnection
//    var address: NWEndpoint.Host
//    var port: NWEndpoint.Port
//    //var delegate: UDPListener?
//    private var listening = true
//
//    var resultHandler = NWConnection.SendCompletion.contentProcessed { NWError in
//        guard NWError == nil else {
//            print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
//            return
//        }
//    }
//
//    init?(address newAddress: String, port newPort: Int32, listener isListener: Bool = true) {
//        guard let codedAddress = IPv4Address(newAddress),
//            let codedPort = NWEndpoint.Port(rawValue: NWEndpoint.Port.RawValue(newPort)) else {
//                print("Failed to create connection address")
//                return nil
//        }
//        address = .ipv4(codedAddress)
//        port = codedPort
//        listening = isListener
//        let hostUDP: NWEndpoint.Host = "192.168.4.1"
//        let portUDP: NWEndpoint.Port = 80
//        connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
//
//        //self.connection = NWConnection(host: address, port: port, using: .udp)
//        connectToUDP()
//        //connect()
//    }
//
////    func connect() {
////        connection.stateUpdateHandler = { newState in
////            switch (newState) {
////            case .ready:
////                print("State: Ready")
////                if self.listening { self.listen() }
////            case .setup:
////                print("State: Setup")
////            case .cancelled:
////                print("State: Cancelled")
////            case .preparing:
////                print("State: Preparing")
////            default:
////                print("ERROR! State not defined!\n")
////            }
////        }
////        connection.start(queue: .global())
////    }
//
////    func send(_ data: Data) {
////        connection.send(content: data, completion: resultHandler)
////    }
////
////    private func listen() {
////        while listening {
////            connection.receiveMessage { data, context, isComplete, error in
////                print("Receive isComplete: " + isComplete.description)
////                guard let data = data else {
////                    print("Error: Received nil Data")
////                    return
////                }
////                print("Data Received")
////            }
////        }
////    }
//
//    //    @available(iOS 12.0, *)
//        func connectToUDP() {
//                // Transmited message:
//                let messageToUDP = "LK_COMM=info"
//
//            //self.connection = NWConnection(host: address, port: port, using: .udp)
//                //self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
//
//            self.connection.stateUpdateHandler = { (newState) in
//                    print("This is stateUpdateHandler:")
//                    switch (newState) {
//                        case .ready:
//                            print("State: Ready\n")
//                            self.sendUDP(messageToUDP)
//                            self.cf.delay(1){
//                            self.receiveUDP(
//                                )}
//                        case .setup:
//                            print("State: Setup\n")
//                        case .cancelled:
//                            print("State: Cancelled\n")
//                        case .preparing:
//                            print("State: Preparing\n")
//                        default:
//                            print("ERROR! State not defined!\n")
//                    }
//                }
//
//            self.connection.start(queue: .global())
//            }
//
////            func sendUDP(_ content: Data) {
////                self.connection.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
////                    if (NWError == nil) {
////                        print("Data was sent to UDP")
////                    } else {
////                        print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
////                    }
////                })))
////            }
//
////            func sendUDP(_ content: String) {
////                let contentToSendUDP = content.data(using: String.Encoding.utf8)
////                self.connection.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
////                    if (NWError == nil) {
////                        print("Data was sent to UDP")
////                    } else {
////                        print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
////                    }
////                })))
////            }
//
//            func receiveUDP() {
//                print(connection.receiveMessage)
//                self.connection.receiveMessage { (data, context, isComplete, error) in
//                    if (isComplete) {
//                        print("Receive is complete")
//                        if (data != nil) {
//                            let backToString = String(decoding: data!, as: UTF8.self)
//                            print("Received message: \(backToString)")
//                        } else {
//                            print("Data == nil")
//                        }
//                    }
//                }
//            }
}
