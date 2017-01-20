//
//  UsersVC.swift
//  DevChat
//
//  Created by Mark Price on 7/15/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class PostVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var captionTF: UITextField!

    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    
    private var _snapData: Data?
    private var _videoURL: URL?
    
    var snapData: Data? {
        set {
            _snapData = newValue
        } get {
            return _snapData
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
        } get {
            return _videoURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            print("snapshot: \(snapshot.debugDescription)")
            
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let nickname = profile["nickname"] as? String, let firstName = profile["firstName"] as? String, let lastName = profile["lastName"] as? String, let avatarUrl = profile["avatarUrl"] as? String, let avatarStorageId = profile["avatarStorageId"] as? String {
                                let uid = key
                                let user = User(uid: uid, nickname: nickname, firstName: firstName, lastName: lastName, avatarUrl: avatarUrl, avatarStorageId: avatarStorageId)
                                self.users.append(user)
                            }
                            else if let nickname = profile["nickname"] as? String, let firstName = profile["firstName"] as? String, let lastName = profile["lastName"] as? String {
                                let uid = key
                                let user = User(uid: uid, nickname: nickname, firstName: firstName, lastName: lastName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            
            print("users: \(self.users)")
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(sender: AnyObject) {
                
        let caption = captionTF.text
        guard caption != nil && (caption?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0 else {
            let alert = UIAlertController(title: "Caption Required", message: "You must enter a caption for this post", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion:nil)
            
            return
        }
        print("caption = \(caption)")
        
        guard self.selectedUsers.count > 0 else {
            let alert = UIAlertController(title: "Recipients Required", message: "You must select at least one recipient", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion:nil)

            return
        }
        
        let mediaUid = NSUUID().uuidString
        if let url = _videoURL {
            //let videoName = "\(NSUUID().uuidString)\(url)"
            
            //let ref = DataService.instance.videoStorageRef.child(videoName)
            let ref = DataService.instance.videoStorageRef.child(mediaUid)
            
            _ = ref.putFile(url, metadata: nil, completion: { (meta:FIRStorageMetadata?, err:Error?) in
                
                if err != nil {
                    print("Error uploading video: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    print("Download URL: \(downloadURL)")
                    
                    var uids = [String]()
                    for uid in self.selectedUsers.keys {
                        uids.append(uid)
                    }
                    print("recipients = \(uids)")
                    let senderUid = FIRAuth.auth()!.currentUser!.uid
                    print("senderUid = \(senderUid)")
                    
                    DataService.instance.postMedia(senderUID: senderUid, recipients: uids, caption: caption!, type: "video", group: "public", mediaURL: downloadURL!, mediaStorageId: mediaUid)
                    
                    
                    //notify the user when the post video has been uploaded.
                    let alert = UIAlertController(title: "Post", message: "The video has uploaded.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    //self.present(alert, animated: true, completion:nil)
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        
                        // topController should now be your topmost view controller
                        topController.present(alert, animated: true, completion:nil)
                    }
                }
                
            })
            self.dismiss(animated: true, completion: nil)
        } else if let snap = _snapData {
            let ref = DataService.instance.photosStorageRef.child("\(NSUUID().uuidString).jpg")
            
            _ = ref.put(snap, metadata: nil, completion: { (meta:FIRStorageMetadata?, err:Error?) in
                if err != nil {
                    print("Error uploading snapshot: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    //self.dismiss(animated: true, completion: nil)
                }
           })

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
