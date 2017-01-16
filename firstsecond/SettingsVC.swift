//
//  SettingsVC.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/12/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit

func pretty_function(file:String = #file, function:String = #function, line:Int = #line) {
    print("file:\(file) function:\(function) line:\(line)")
}

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    private var _uid: String?
    
    var uid: String? {
        set {
            _uid = newValue
        } get {
            return _uid
        }
    }

    @IBOutlet weak var avatarBtn: RoundedButton!
    @IBOutlet weak var firstnameTF: RoundTextField!
    @IBOutlet weak var lastnameTF: RoundTextField!
    @IBOutlet weak var nicknameTF: RoundTextField!
    
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
                    //self.delegate?.launchVC(vcName: self.menu[indexPath.row])
                    let user = User(uid: self.uid!, nickname: nickname, firstName: firstname, lastName: lastname)
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
        }
        else {
            print("JESS: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pretty_function()

        // Do any additional setup after loading the view.
        imagePicker = UIImagePickerController()
        //imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
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
