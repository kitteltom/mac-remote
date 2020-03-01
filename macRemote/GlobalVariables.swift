//
//  GlobalVariables.swift
//  macRemote
//
//  Created by Thomas Kittel on 22.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

struct GlobalVariables {
    static var tcpClient: TCPClient!
    static var isConnected = false
    
    static func checkIPAddress(_ input: String?) -> Bool {
        let ipAddress = input ?? ""
        
        //count if there are 4 parts separated by a dot
        let correctFormat = ipAddress.components(separatedBy: ".").count == 4
        
        //check if the length is greater than 6 (at least 3 dots and 4 numbers)
        let correctLength = ipAddress.count >= 7
        
        //return the result
        return correctFormat && correctLength
    }
}

struct LayoutMetrics {
    static let cornerRadius: CGFloat = 20
    static let borderWidth: CGFloat = 5
    static let borderColor: CGColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    static let isConnectedAlpha: CGFloat = 1.0
    static let isNotConnectedAlpha: CGFloat = 0.2
    static let isTouchedAlpha: CGFloat = 0.5
    static let connectedText: String = "Connected"
    static let notConnectedText: String = "Disconnected"
}

extension Notification.Name {
    static let connectionIsReady = Notification.Name("connectionIsReady")
    static let connectionFailed = Notification.Name("connectionFailed")
    static let waitingForConnection = Notification.Name("waitingForConnection")
}
