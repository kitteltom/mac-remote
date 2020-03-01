//
//  DesktopViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 25.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

class DesktopViewController: RemoteViewController {

    //MARK: Actions
    @objc func leftSwipe(recognizedBy recognizer: UISwipeGestureRecognizer) {
        afterSwipeSend(message: "leftDesktop", recognizedBy: recognizer)
    }
    
    @objc func rightSwipe(recognizedBy recognizer: UISwipeGestureRecognizer) {
        afterSwipeSend(message: "rightDesktop", recognizedBy: recognizer)
    }
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init and update
        initRemoteButtonViews()
        updateRemoteButtonViews()
        
        //add swipe gesture recognizers
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(recognizedBy:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(recognizedBy:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
}
