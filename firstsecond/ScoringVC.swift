//
//  ScoringVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/20/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit

class ScoringVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
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
