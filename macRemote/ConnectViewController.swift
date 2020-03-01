//
//  connectViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 22.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Actions
    @IBAction func connect(_ sender: UIButton) {
        
        //cancel any ongoing connection
        if(GlobalVariables.tcpClient != nil) {
            GlobalVariables.tcpClient.connection.cancel()
        }
        
        //start a new connection
        //(it's ensured that the IP is valid because connect can not be pressed otherwise)
        GlobalVariables.tcpClient = TCPClient(withHostIP: ipTextField.text!)
    }
    
    @objc func tappedAnywhere() {
        //cause the active textfield to resign first responder
        if ipTextField.isFirstResponder {
            ipTextField.resignFirstResponder()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var ipTextField: UITextField!
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the ipAddress if saved
        let ipAddress = UserDefaults.standard.object(forKey: "ipAddress") as? String ?? ""
        ipTextField.text = ipAddress

        //init the button state
        updateConnectButtonState();
        
        //set the text field's delegate
        ipTextField.delegate = self
        
        //dismiss the keyboard when the view is tapped anywhere
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedAnywhere))
        view.addGestureRecognizer(tap)
        
        //set text field to first responder if the textfield is empty
        if ipTextField.text!.isEmpty {
            ipTextField.becomeFirstResponder()
        }
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
    
    //MARK: Notification listeners
    @objc func onConnectionStateReady(_ notification: Notification) {
        DispatchQueue.main.async {
            //dismiss the view because connecting was successfull
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onConnectionStateFailed(_ notification: Notification) {
        DispatchQueue.main.async {
            //do nothing
        }
    }
    
    @objc func onConnectionStateWaiting(_ notification: Notification) {
        DispatchQueue.main.async {
            //create alert to tell user that a conneciton could not be established
            let alert = UIAlertController(title: "Crap!",
                                          message: "Could not establish a connection.",
                                          preferredStyle: .alert)
            
            //add an action
            alert.addAction(UIAlertAction(title: "Got it", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            })
            
            //present alert controller
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Methods
    func updateConnectButtonState() {
        let ipOK = GlobalVariables.checkIPAddress(ipTextField.text)
        connectButton.isEnabled = ipOK
        connectButton.alpha = ipOK ? LayoutMetrics.isConnectedAlpha : LayoutMetrics.isNotConnectedAlpha
    }
    
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //done was pressed -> hide the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //textField dissapeared -> update the connect button
        updateConnectButtonState()
        
        //also save the content of the textfield
        let ipAddress = textField.text ?? ""
        UserDefaults.standard.set(ipAddress, forKey: "ipAddress")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //disable the connect button
        connectButton.isEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //restrict number of chars in the textfields to 15 (max 3 dots and 4x3 numbers)
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 15
    }
}
