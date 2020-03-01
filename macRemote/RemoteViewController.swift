//
//  ViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 20.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit
import Network

class RemoteViewController: UIViewController {
    
    //MARK: Properties
    var remoteButtonViews = [UIView]()
    var connectionStateButton: UIBarButtonItem!
    
    //MARK: Actions
    @objc func remoteAction(recognizedBy recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            //touch down
            GlobalVariables.tcpClient.send(recognizer.view!.restorationIdentifier!)
            recognizer.view!.alpha = LayoutMetrics.isTouchedAlpha
        case .ended:
            //touch up
            updateRemoteButtonViews()
        default: break
        }
    }
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the bar button item
        connectionStateButton = UIBarButtonItem(title: LayoutMetrics.connectedText, style: .plain, target: self, action: nil)
        connectionStateButton.isEnabled = false
        navigationItem.rightBarButtonItem = connectionStateButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //add all the observers
        NotificationCenter.default.addObserver(self, selector: #selector(onConnectionStateReady(_:)),
                                               name: .connectionIsReady, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onConnectionStateFailed(_:)),
                                               name: .connectionFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onConnectionStateWaiting(_:)),
                                               name: .waitingForConnection, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove all the observers
        NotificationCenter.default.removeObserver(self, name: .connectionIsReady, object: nil)
        NotificationCenter.default.removeObserver(self, name: .connectionFailed, object: nil)
        NotificationCenter.default.removeObserver(self, name: .waitingForConnection, object: nil)
    }
    
    //MARK: Methods
    func updateRemoteButtonViews() {
        
        //disable/enable the remoteButtons
        for view in remoteButtonViews {
            view.isUserInteractionEnabled = GlobalVariables.isConnected
            view.alpha = GlobalVariables.isConnected ? LayoutMetrics.isConnectedAlpha : LayoutMetrics.isNotConnectedAlpha
        }
        
        //update the title of the connectionStateButton
        connectionStateButton.title = GlobalVariables.isConnected ? LayoutMetrics.connectedText : LayoutMetrics.notConnectedText
    }
    
    func initRemoteButtonViews() {
        
        //setup the remoteButtons
        for view in remoteButtonViews {
            view.layer.cornerRadius = LayoutMetrics.cornerRadius
            view.layer.borderWidth = LayoutMetrics.borderWidth
            view.layer.borderColor = LayoutMetrics.borderColor
            view.tintColorDidChange()
        }
    }
    
    func setupRecognizer(for remoteButtonView: UIView, withID identifier: String) {
        
        //initialize the gestureRecognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(remoteAction(recognizedBy:)))
        
        //the long Press should start immediately
        longPress.minimumPressDuration = 0.001
        
        //the identifier equals the message to be sent
        remoteButtonView.restorationIdentifier = identifier
        
        //add the gestureRecognizer to the view
        remoteButtonView.addGestureRecognizer(longPress)
    }
    
    func afterSwipeSend(message id: String, recognizedBy recognizer: UISwipeGestureRecognizer) {
        
        //send message when swipe ended
        switch recognizer.state {
        case .ended:
            if GlobalVariables.isConnected {
                GlobalVariables.tcpClient.send(id)
            }
        default: break
        }
    }
    
    //MARK: Notification listeners
    @objc func onConnectionStateReady(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateRemoteButtonViews()
        }
    }
    
    @objc func onConnectionStateFailed(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateRemoteButtonViews()
        }
    }
    
    @objc func onConnectionStateWaiting(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateRemoteButtonViews()
        }
    }
}


