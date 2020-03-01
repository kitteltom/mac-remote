//
//  PhotosViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 22.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

class PhotosViewController: RemoteViewController {

    //MARK: Outlets
    @IBOutlet weak var fullScreenView: UIView! {
        didSet { setupRecognizer(for: fullScreenView, withID: "fullScreen") }
    }
    @IBOutlet weak var selectPicView: UIView! {
        didSet { setupRecognizer(for: selectPicView, withID: "selectPic") }
    }
    @IBOutlet weak var previousPicView: UIView! {
        didSet { setupRecognizer(for: previousPicView, withID: "previousPic") }
    }
    @IBOutlet weak var nextPicView: UIView! {
        didSet { setupRecognizer(for: nextPicView, withID: "nextPic") }
    }
    
    //MARK: Actions
    @objc func leftSwipe(recognizedBy recognizer: UISwipeGestureRecognizer) {
        afterSwipeSend(message: "previousPic", recognizedBy: recognizer)
    }
    
    @objc func rightSwipe(recognizedBy recognizer: UISwipeGestureRecognizer) {
        afterSwipeSend(message: "nextPic", recognizedBy: recognizer)
    }
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //append all the views
        remoteButtonViews.append(fullScreenView)
        remoteButtonViews.append(selectPicView)
        remoteButtonViews.append(previousPicView)
        remoteButtonViews.append(nextPicView)
        
        //init and update
        initRemoteButtonViews()
        updateRemoteButtonViews()
        
        /*//add swipe gesture recognizers
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(recognizedBy:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(recognizedBy:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)*/
    }
}
