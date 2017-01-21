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

class ScoringVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private var posts = [Post]()
    
    @IBAction func playPressed(_ sender: UIButton) {
        print("playPressed, tag = \(sender.tag)")
    }
    
    @IBAction func sliderEnd(_ sender: UISlider) {
        print("slider \(sender.tag): End, score = \(Int(sender.value))")
    }

    @IBAction func sliderValueDidChange(sender:UISlider!)
    {
        print("tag \(sender.tag):\(Int(sender.value))")
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
                        let recipients = dict["recipients"] as! [String]
                        let caption = dict["caption"] as! String
                        let mediaUrl = dict["mediaURL"] as! String
                        let mediaStorageId = dict["mediaStorageId"] as! String
                        let type = dict["type"] as! String
                        let group = dict["group"] as! String
                        
                        let post = Post(pid: pid, uid: uid , caption: caption, type: type, mediaUrl: mediaUrl, mediaStorageId: mediaStorageId, group: group, recipients: recipients)
                        
                        self.posts.append(post)
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
            //cell.textLabel?.text = menu[indexPath.row]
            //cell.textLabel?.textColor = UIColor.yellow
            //cell.backgroundColor = UIColor.clear
            
            cell.playButton.tag = indexPath.row
            cell.scoreSlider.tag = indexPath.row
            
            let post = posts[indexPath.row]
            cell.updateUI(post:post)
            
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
