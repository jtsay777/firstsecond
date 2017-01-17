//
//  DataService.swift
//  DevChat
//
//  Created by Mark Price on 7/13/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

let FIR_CHILD_USERS = "users"

import Foundation
import FirebaseDatabase
import FirebaseStorage


class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    var mainStorageRef: FIRStorageReference {
 
        return FIRStorage.storage().reference(forURL: "gs://first-second-1be39.appspot.com")
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    var videoStorageRef: FIRStorageReference {
        return mainStorageRef.child("videos")
    }
    
    var avatarsStorageRef: FIRStorageReference {
        return mainStorageRef.child("avatars")
    }
    
    func doesUrerProfileExist(uid: String, onComplete: @escaping (_ existing: Bool) -> Void) {
        //return mainRef.child(FIR_CHILD_USERS).child(uid).value(forKey: "profile") != nil //crash
        
        usersRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            print("snapshot = \(snapshot)")
            if snapshot.hasChild(uid){
                
                print("users exist")
                if let users = snapshot.value as? Dictionary<String, AnyObject> {
                    if let user = users[uid] as? Dictionary<String, AnyObject> {
                        if let _ = user["profile"] as? Dictionary<String, AnyObject> {
                            print("profile exists!")
                            onComplete(true)
                        }
                    }
                    else {
                        print("users doesn't exist 001")
                        onComplete(false)
                    }
                }
                else {
                    print("users doesn't exist 002")
                    onComplete(false)
                }
                
            }else{
                
                print("users doesn't exist 003")
                onComplete(false)
            }
            
            
        })
        
    }
        
    func sendMediaPullRequest(senderUID: String, sendingTo:Dictionary<String, User>, mediaURL: URL, textSnippet: String? = nil) {
        
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }

        let pr: Dictionary<String, AnyObject> = ["mediaURL":mediaURL.absoluteString as AnyObject, "userID":senderUID as AnyObject,"openCount": 0 as AnyObject, "recipients":uids as AnyObject]
        
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
        
    }
    
    
    func updateProfile(user: User) {
        let uid = user.uid
        let nickname = user.nickname
        let firstName = user.firstName
        let lastName = user.lastName
        let avatarUrl = user.avatarUrl
        let avatarStorageId = user.avatarStorageId
        
        print("updateProfile, avatarUrl = \(avatarUrl)")
        
        let profile: Dictionary<String, AnyObject> = ["nickname": nickname as AnyObject, "firstName": firstName as AnyObject, "lastName": lastName as AnyObject, "avatarUrl": avatarUrl as AnyObject, "avatarStorageId": avatarStorageId as AnyObject]
        
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
    }
    
    func getProfile(uid: String, onComplete: @escaping (_ data: Dictionary<String, String>? ) -> Void) {
        print("getProfile, uid = \(uid)")
        
        usersRef.child(uid).observe(.value, with: { (snapshot) in
        if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for snap in snapshot {
                print("SNAP: \(snap)")
                if snap.key == "profile" {
                    if let profile = snap.value as! Dictionary<String, String>? {
                        print("getProfile, profile = \(profile)")
                        onComplete(profile)
                    }
                }
                
            }
        }
        else {
           print("no profile yet!")
           onComplete(nil)
        }

        })
    }
    
}
