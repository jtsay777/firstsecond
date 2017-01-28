//
//  PlayPhotoVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/24/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"
let Timeout = 3.0

class PlayPhotoVC: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    private var _photoUrl: String?
    private var _caption: String?
    private var timer: Timer?
    private var _timerNeeded: Bool?
    
    var photoUrl: String? {
        set {
            _photoUrl = newValue
            print("PlayPhotoVC photoUrl set as \(newValue)")
        } get {
            return _photoUrl
        }
    }
    
    var caption: String? {
        set {
            _caption = newValue
            print("PlayPhotoVC caption set as \(newValue)")
        } get {
            return _caption
        }
    }
    
    var timerNeeded: Bool? {
        set {
            _timerNeeded = newValue
        } get {
            return _timerNeeded
        }
    }



    @IBAction func donePressed(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.topItem?.title = caption!
        
        playPhoto()
    }
    
    func timeout() {
        dismiss(animated: true, completion: nil)
    }
    
    func playPhoto() {
        //_photoUrl = "https://firebasestorage.googleapis.com/v0/b/first-second-1be39.appspot.com/o/photos%2F33A4A266-3584-462E-BA89-0EBC9C6A3574?alt=media&token=2b7fc336-bafc-486f-af49-99d28efa489e"
        
        if let url = NSURL(string: photoUrl!) {
            if let img = NSData(contentsOf: url as URL) {
                photoImageView.image = UIImage(data: img as Data)
                if let needTimer = timerNeeded {
                    if needTimer {
                        timer = Timer.scheduledTimer(timeInterval: Timeout, target: self, selector: #selector(self.timeout), userInfo: nil, repeats: false);
                    }
                
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
