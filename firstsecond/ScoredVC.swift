//
//  ScoringViewerVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/22/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import AVFoundation
import AVKit

class ScoredVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var _uid: String?
    private var scoreDictArr = [Dictionary<String, String>]()
    private var scoredBoardCount = 0
    
    var uid: String? {
        set {
            _uid = newValue
            print("ScoredVC uid set as \(newValue)")
        } get {
            return _uid
        }
    }

    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        print("playPressed, tag = \(sender.tag)")
      
        let dict = self.scoreDictArr[sender.tag]
        if let mediaUrl = dict["mediaUrl"] {
            let type = dict["type"]
            if type == "video" {
                playVideo(urlString: mediaUrl)
            } else if type == "photo" {
                playPhoto(urlString: mediaUrl, caption: dict["caption"]!)
            }
            
        }
    }
    
    func playPhoto(urlString: String, caption: String){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayPhotoVC") as! PlayPhotoVC
        vc.photoUrl = urlString
        vc.caption = caption
        self.present(vc, animated:true, completion:nil)
    }

    
    func playVideo(urlString: String){
        
        let videoURL = NSURL(string: urlString)
        let player = AVPlayer(url: videoURL! as URL)
        
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func countOfMyScoredPosts(onComplete:@escaping ()->Void) {
        DataService.instance.postsRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let posts = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in posts {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        let posterId = dict["uid"] as! String
                        if (posterId == self.uid) {
                            let recipients = dict["recipients"] as! Dictionary<String, String>
                            for (key, value) in recipients {
                                print("key = \(key), value = \(value)")
                                if value == "read" {
                                    print("caption = \(dict["caption"])")
                                    self.scoredBoardCount += 1
                                }
                            }
                        }

                    }
                }
                onComplete()
            }
        }
    }

    
    func collectScoredBoard(onComplete:@escaping (_ count:Int)->Void) {
        
        DataService.instance.responsesRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            //var scoreDict = Dictionary<String, String>()
            print("snapshot: \(snapshot.debugDescription)")
            if let responses = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in responses {
                    var scoreDict = Dictionary<String, String>()
                    if let response = value as? Dictionary<String, AnyObject> {
                        if let uid = response["uid"] as? String, let pid = response["pid"] as? String, let score = response["score"] as? Int8, let comment = response["comment"] as? String {
                            print("uid = \(uid), pid = \(pid)")
                            if true {
                                scoreDict["score"] = "\(score)"
                                scoreDict["comment"] = comment
                                
                                // try to fetch caption from pid
                                DataService.instance.postsRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                                    if let posts = snapshot.value as? Dictionary<String, AnyObject> {
                                        for (key, value) in posts {
                                            if let dict = value as? Dictionary<String, AnyObject> {
                                                let postid = key as String
                                                if postid == pid {
                                                    let caption = dict["caption"] as! String
                                                    let type = dict["type"] as! String
                                                    let mediaUrl = dict["mediaURL"] as! String
                                                    let posterId = dict["uid"] as! String
                                                      if (posterId == self.uid) {
                                                        print("caption = \(caption)")
                                                        scoreDict["caption"] = caption
                                                        scoreDict["type"] = type
                                                        scoreDict["mediaUrl"] = mediaUrl
                                                        //self.scoreDictArr.append(scoreDict)
                                                        //print("scoreDictArr: \(self.scoreDictArr)")
                                                        
                                                        // try to fetch nickname, avatarUrl from uid's profile
                                                        DataService.instance.getProfile(uid: uid) { (data) in
                                                            if let data = data {
                                                                print("data = \(data)")
                                                                print("nickname = \(data["nickname"])")
                                                                scoreDict["nickname"] = data["nickname"]
                                                                if let url = data["avatarUrl"] {
                                                                    print("avatarUrl = \(url)")
                                                                    scoreDict["avatarUrl"] = url
                                                                }
                                                                
                                                                self.scoreDictArr.append(scoreDict)
                                                                //print("scoreDictArr: \(self.scoreDictArr)")
                                                                let count = self.scoreDictArr.count
                                                        
                                                                onComplete(count)
                                                                
                                                            }
                                                        }
                                                        
                                                        
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
               
            }
            
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
       
        countOfMyScoredPosts {
            print("After countOfMyScoredPosts, scoreDictArr: \(self.scoreDictArr)")
            self.collectScoredBoard(onComplete: { (count) in
                print("***COUNT*** = \(count)")
                if count == self.scoredBoardCount {
                    print("!!!!!!!I got you!!!!!!!")
                    print("scoreDictArr: \(self.scoreDictArr)")
                    
                    self.tableView.reloadData()
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as PostCell? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell") as? ScoreCell {
            
            cell.playButton.tag = indexPath.row
            let dict = self.scoreDictArr[indexPath.row]
            cell.updateUI(dict:dict)
            
            if let avatarUrl = dict["avatarUrl"] {
                if let url = URL(string: avatarUrl) {
                    cell.avatarImageView.contentMode = .scaleAspectFill
                    print("Download Started")
                    self.getDataFromUrl(url: url) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                        print(response?.suggestedFilename ?? url.lastPathComponent)
                        print("Download Finished")
                        DispatchQueue.main.async() { () -> Void in
                            cell.avatarImageView.image = UIImage(data: data)
                        }
                    }
                }

            }
            
            return cell
        }
        else {
            return ScoreCell()
        }
        
        //return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreDictArr.count
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
