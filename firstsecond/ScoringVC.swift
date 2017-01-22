//
//  ScoringVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/20/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ScoringVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var posts = [Post]()
    private var _uid: String?
    
    var uid: String? {
        set {
            _uid = newValue
        } get {
            return _uid
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        print("playPressed, tag = \(sender.tag)")
    }
    
    @IBAction func sliderEnd(_ sender: UISlider) {
        print("slider \(sender.tag): End, score = \(Int(sender.value))")
    }

    @IBAction func sliderValueDidChange(sender:UISlider!)
    {
        print("tag \(sender.tag):\(Int(sender.value))")
        let scoreText = "Score: \(Int(sender.value))"
        let parentView = sender.superview
 
        let myViews = (parentView?.subviews)!.filter{$0 is ScoreLabel}
        //print("\(myViews)")
        let myLabel = myViews[0] as! ScoreLabel
        myLabel.text = scoreText
  
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)

        print("tag \(textField.tag), comment = \(newString)")
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //testing
        DataService.instance.postsRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            print("snapshot: \(snapshot.debugDescription)")
            
            if let posts = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in posts {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        let pid = key as String
                        let uid = dict["uid"] as! String
                        let recipients = dict["recipients"] as! Dictionary<String, String>
                        let caption = dict["caption"] as! String
                        let mediaUrl = dict["mediaURL"] as! String
                        let mediaStorageId = dict["mediaStorageId"] as! String
                        let type = dict["type"] as! String
                        let group = dict["group"] as! String
                        
                        let post = Post(pid: pid, uid: uid , caption: caption, type: type, mediaUrl: mediaUrl, mediaStorageId: mediaStorageId, group: group, recipients: recipients)
                        
                        if let status = recipients[uid], status == "unread" {
                            self.posts.append(post)
                        }
                        
                    }
                }
            }
            
            print("posts: \(self.posts)")
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as PostCell? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
                     
            cell.playButton.tag = indexPath.row
            cell.scoreSlider.tag = indexPath.row
            cell.commentTextField.tag = indexPath.row
            cell.commentTextField.delegate = self
            
            let post = posts[indexPath.row]
            cell.updateUI(post:post)
            
            //testing
            getProfileData(uid: post.uid, onComplete: {(nickname, avatarUrl) in
                cell.nicknameLabel.text = nickname
                
                if let avatarUrl = URL(string: avatarUrl) {
                    cell.avatarImageView.contentMode = .scaleAspectFill
                    print("Download Started")
                    self.getDataFromUrl(url: avatarUrl) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                        print(response?.suggestedFilename ?? avatarUrl.lastPathComponent)
                        print("Download Finished")
                        DispatchQueue.main.async() { () -> Void in
                            cell.avatarImageView.image = UIImage(data: data)
                        }
                    }
                }
            })
            
            return cell
        }
        else {
            return PostCell()
        }
        
        //return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    

    func getProfileData(uid:String, onComplete:@escaping (_ nickname:String, _ avatarUrl: String)->Void) {
        
        DataService.instance.usersRef.child(uid).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            print("snapshot: \(snapshot.debugDescription)")
            if let user = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in user {
                    if key == "profile" {
                        if let profile = value as? Dictionary<String, AnyObject> {
                            let nickname = profile["nickname"]
                            let avatarUrl = profile["avatarUrl"]
                            onComplete(nickname as! String, avatarUrl as! String)
                        }
                        
                    }
                }
            }
        }
        
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
