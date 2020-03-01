//
//  PowerPointViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 22.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

class PowerPointViewController: RemoteViewController {

    //MARK: Outlets
    @IBOutlet weak var startPresentationView: UIView! {
        didSet { setupRecognizer(for: startPresentationView, withID: "startPresentation") }
    }
    @IBOutlet weak var endPresentationView: UIView! {
        didSet { setupRecognizer(for: endPresentationView, withID: "endPresentation") }
    }
    @IBOutlet weak var previousSlideView: UIView! {
        didSet { setupRecognizer(for: previousSlideView, withID: "previousSlide") }
    }
    @IBOutlet weak var nextSlideView: UIView! {
        didSet { setupRecognizer(for: nextSlideView, withID: "nextSlide") }
    }
    
    //MARK: Actions
    @objc func leftSwipe(recognizedBy recognizer: UISwipeGestureRecognizer) {
        afterSwipeSend(message: "previousSlide", recognizedBy: recognizer)
    }
    
    @objc func rightSwipe(recognizedBy recognizer: UISwipeGestureRecognizer) {
        afterSwipeSend(message: "nextSlide", recognizedBy: recognizer)
    }
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //append all the views
        remoteButtonViews.append(startPresentationView)
        remoteButtonViews.append(endPresentationView)
        remoteButtonViews.append(previousSlideView)
        remoteButtonViews.append(nextSlideView)
        
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
