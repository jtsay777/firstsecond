//
//  ScoringViewerVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/22/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit

class ScoringViewerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var _uid: String?
    
    var uid: String? {
        set {
            _uid = newValue
            print("ScoringVC uid set as \(newValue)")
        } get {
            return _uid
        }
    }

    @IBAction func playPressed(_ sender: UIButton) {
        print("playPressed, tag = \(sender.tag)")
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as PostCell? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell") as? ScoreCell {
            
            cell.playButton.tag = indexPath.row
            
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
        return 12
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
