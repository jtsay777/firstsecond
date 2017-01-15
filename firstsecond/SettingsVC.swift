//
//  SettingsVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/12/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let menu = ["Capturing", "Scoring", "Logout"]
    var imagePicker: UIImagePickerController!
    
    private var _uid: String?
    
    var uid: String? {
        set {
            _uid = newValue
        } get {
            return _uid
        }
    }


    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var avatarBtn: RoundedButton!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var firstnameTF: RoundTextField!
    @IBOutlet weak var lastnameTF: RoundTextField!
    @IBOutlet weak var nicknameTF: RoundTextField!
    
    @IBAction func avatarUpload(_ sender: RoundedButton) {
        print("avatarUpload pressed!")
        
        present(imagePicker, animated: true, completion: nil)
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
                    //self.delegate?.launchVC(vcName: self.menu[indexPath.row])
                    let user = User(uid: self.uid!, nickname: nickname, firstName: firstname, lastName: lastname)
                    DataService.instance.updateProfile(user: user)
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
    
    @IBAction func menuPressed(_ sender: UIButton) {
        print("menu pressed")
         menuTableView.isHidden = !menuTableView.isHidden
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsMenuCell", for: indexPath) as UITableViewCell? {
            cell.textLabel?.text = menu[indexPath.row]
            cell.textLabel?.textColor = UIColor.blue
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you click \(menu[indexPath.row])")
        
        if menu[indexPath.row] == "SecondVC" {
            //dismiss(animated: true, completion: nil)
            
            print("before dismiss ThirdVC")
            dismiss(animated: true, completion: {
                //let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
                //self.present(secondVC, animated:true, completion:nil)
                //self.delegate?.launchVC(vcName: self.menu[indexPath.row])
            })
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarBtn.setImage(image, for: UIControlState.normal)
        }
        else {
            print("JESS: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker = UIImagePickerController()
        //imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.separatorStyle = .none
        menuTableView.backgroundColor = UIColor.clear
        menuTableView.isHidden = true
        
        menuBtn.isHidden = true
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
