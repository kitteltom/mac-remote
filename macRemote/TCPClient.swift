//
//  TCPClient.swift
//  macRemote
//
//  Created by Thomas Kittel on 21.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import Foundation
import Network

class TCPClient {
    
    //MARK: Properties
    var tcpQueue: DispatchQueue
    var connection: NWConnection
    
    //MARK: Init
    init(withHostIP ipAddress: String) {
        
        //create the queue where the tcp communication takes place
        tcpQueue = DispatchQueue(label: "TCPqueue");
        
        //initialize the connection
        connection = NWConnection(host: NWEndpoint.Host(ipAddress), port: 789, using: .tcp)
        connection.parameters.prohibitedInterfaceTypes = [.cellular]
        
        //set up the state update handler
        connection.stateUpdateHandler = { (newState) in
            print(newState)
            switch newState {
            case .ready:
                GlobalVariables.isConnected = true
                NotificationCenter.default.post(name: .connectionIsReady, object: nil)
            case .failed, .cancelled:
                GlobalVariables.isConnected = false
                NotificationCenter.default.post(name: .connectionFailed, object: nil)
            /*case .waiting:
                GlobalVariables.isConnected = false
                NotificationCenter.default.post(name: .waitingForConnection, object: nil)*/
            default:
                break
            }
        }
        
        //start the connection
        connection.start(queue: tcpQueue)
        
        //check if connection was established
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            switch self.connection.state {
            case .preparing, .waiting:
                GlobalVariables.isConnected = false
                NotificationCenter.default.post(name: .waitingForConnection, object: nil)
            default: break
            }
        }
    }
    
    //MARK: Communication methods
    func send(_ message: String) {
        
        //append a newLine for the readLine method
        let messageToServer = message + "\n"
        
        //encode the string
        let dataToServer = messageToServer.data(using: .utf8)
        
        //send the message
        connection.send(content: dataToServer, completion: .contentProcessed({ (error) in
            if let error = error {
                print("Send error: \(error)")
            }
        }))
    }
}
