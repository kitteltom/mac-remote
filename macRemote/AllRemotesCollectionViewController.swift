//
//  macRemoteCollectionViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 22.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

class AllRemotesCollectionViewController: UICollectionViewController {

    //MARK: Properties
    var connectionStateButton: UIBarButtonItem!
    let cellIDs = ["netflixCell", "photosCell", "powerPointCell", "spotifyCell", "desktopCell"]
    
    //MARK: Outlets
    @IBOutlet weak var ipAddressButton: UIBarButtonItem!
    
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
        
        //update the connect button
        updateButtonStates()
        
        //reload the collection view cells
        collectionView.reloadData()
        
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
            self.updateButtonStates()
        }
    }
    
    @objc func onConnectionStateFailed(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateButtonStates()
        }
    }
    
    @objc func onConnectionStateWaiting(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateButtonStates()
        }
    }
    
    //MARK: Methods
    func updateButtonStates() {
        connectionStateButton.title = GlobalVariables.isConnected ? LayoutMetrics.connectedText : LayoutMetrics.notConnectedText
    }

    //MARK: CollectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellIDs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get the cell and adjust it
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: getIdentifier(for: indexPath),
            for: indexPath)
        cell.layer.cornerRadius = LayoutMetrics.cornerRadius
        cell.layer.borderWidth = LayoutMetrics.borderWidth
        cell.layer.borderColor = LayoutMetrics.borderColor
        cell.tintColorDidChange()
        cell.alpha = 1
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = LayoutMetrics.isTouchedAlpha
    }
    
    func getIdentifier(for indexPath: IndexPath) -> String {
        return cellIDs[indexPath.item]
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let connectVC = segue.destination as? ConnectViewController {
            connectVC.modalPresentationStyle = .overCurrentContext
        }
    }
}
