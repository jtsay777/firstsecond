//
//  SettingsVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/12/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit
import Firebase

func pretty_function(file:String = #file, function:String = #function, line:Int = #line) {
    print("file:\(file) function:\(function) line:\(line)")
}

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    private var _uid: String?
    private var _isFirsttime: Bool?
    //private var _avatarUrl: String?
    private var avatarUrl: String?
    private var avatarStorageId: String?
    
    
    var uid: String? {
        set {
            _uid = newValue
        } get {
            return _uid
        }
    }
    
    var isFirsttime: Bool? {
        set {
            _isFirsttime = newValue
        } get {
        return _isFirsttime
        }
    }
    
//    var avatarUrl: String? {
//        set {
//            _avatarUrl = newValue
//        } get {
//            return _avatarUrl
//        }
//    }

    @IBOutlet weak var avatarBtn: RoundedButton!
    @IBOutlet weak var firstnameTF: RoundTextField!
    @IBOutlet weak var lastnameTF: RoundTextField!
    @IBOutlet weak var nicknameTF: RoundTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func avatarUpload(_ sender: RoundedButton) {
        print("avatarUpload pressed!")
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        print("Done pressed")
        
        if let firstname = firstnameTF.text, let lastname = lastnameTF.text, let nickname = nicknameTF.text {
            let firstname = firstname.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            let lastname = lastname.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            let nickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if firstname.characters.count > 0 && lastname.characters.count > 0 && nickname.characters.count > 0 {
                print("firstname = \(firstname), lastname = \(lastname), nickname = \(nickname)")
                
                print("before dismiss SettingsVC")
                dismiss(animated: true, completion: {
                    var user: User
                    if let avatarUrl = self.avatarUrl, let avatarStorageId = self.avatarStorageId {
                        user = User(uid: self.uid!, nickname: nickname, firstName: firstname, lastName: lastname, avatarUrl: avatarUrl, avatarStorageId: avatarStorageId)
                    }
                    else {
                       user = User(uid: self.uid!, nickname: nickname, firstName: firstname, lastName: lastname)
                    }
                    
                    print("Before updateProfile")
                    DataService.instance.updateProfile(user: user)
                    print("After updateProfile")
                })

            }
            else {
                let alert = UIAlertController(title: "All Names Required", message: "You must enter all first name, last name and nickname", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "All Names Required", message: "You must enter all first name, last name and nickname", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarBtn.setImage(image, for: UIControlState.normal)
            imageSelected = true
            
            guard let img = avatarBtn.imageView?.image else {
                print("JESS: can't get avatarBtn image")
                return
            }
            
            if let imgData = UIImageJPEGRepresentation(img, 0.2) {
                var imgUid: String
                if self.avatarStorageId != nil {
                    imgUid = self.avatarStorageId!
                }
                else {
                    imgUid = NSUUID().uuidString
                    self.avatarStorageId = imgUid
                }
                
                print("imgUid = \(imgUid)")
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.instance.avatarsStorageRef.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("Johnson: Unable to upload image to Firebasee avatars storage")
                    } else {
                        print("Johnson: Successfully uploaded image to Firebase avatars storage")
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            self.avatarUrl = url
                        }
                        
                    }
                }

            }
            
        }
        else {
            print("Johnson: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pretty_function()
        print("isFirsttime = \(self.isFirsttime)")
        if self.isFirsttime == true {
            cancelBtn.isHidden = true
        }

        // Do any additional setup after loading the view.
        imagePicker = UIImagePickerController()
        //imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        avatarBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        
        //testing
        DataService.instance.getProfile(uid: self.uid!) { (data) in
            if let data = data {
            print("data = \(data)")
            let url = data["avatarUrl"]!
            print("avatarUrl = \(url)")
      
            //the following not work?
//            if let img = SettingsVC.imageCache.object(forKey: url as NSString) {
//                print("cache avatar image")
//                self.avatarBtn.setImage(img, for: .normal)
//            }
            
            if let url = NSURL(string: url) {
                if let img = NSData(contentsOf: url as URL) {
                    self.avatarBtn.setImage(UIImage(data: img as Data), for: .normal)
                }        
            }

            self.firstnameTF.text = data["firstName"]
            self.lastnameTF.text = data["lastName"]
            self.nicknameTF.text = data["nickname"]
            
            self.avatarStorageId = data["avatarStorageId"]
            }
            
         }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        pretty_function()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
