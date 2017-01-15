//
//  LoginVC.swift
//  DevChat
//
//  Created by Mark Price on 7/13/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginPressed(_ sender: AnyObject) {
        
        if let email = emailField.text, let password = passwordField.text {
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            let password = password.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            
            if email.characters.count > 0 && password.characters.count > 0 {
                print("loginPressed: email = \(email), password = \(password)")
                
                AuthService.instance.login(email: email, password: password, onComplete: { (errMsg, data) in
                    guard errMsg == nil else {
                        let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if let firUser = data as? FIRUser {
                        let uid = firUser.uid 
                        print("!!!uid = \(uid)")
                       
   
                        DataService.instance.doesUrerProfileExist(uid: uid, onComplete: { (existing) in
                            
                            if !existing {
                                //launch Settings to do updateProfile
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                                settingsVC.uid = uid
                                self.present(settingsVC, animated:true, completion:{
                                    self.dismiss(animated: true, completion: nil)
                                })
                                //self.dismiss(animated: true, completion: nil)
                            }
                            else {
                                print("User Profile already exists.")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
 
                        
                    }
                    
                    //self.dismiss(animated: true, completion: nil)
                })
            }
            else {
                let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both a username and a password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both a username and a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }

}
