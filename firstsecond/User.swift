//
//  User.swift
//  DevChat
//
//  Created by Mark Price on 7/15/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

struct User {
    private var _firstName: String
    private var _lastName: String
    private var _nickname: String
    private var _avatarUrl: String?
    private var _avatarStorageId: String?
    private var _uid: String
    
    var uid: String {
        return _uid
    }
    
    var nickname: String {
        return _nickname
    }
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var avatarUrl: String? {
        return _avatarUrl
    }
    
    var avatarStorageId: String? {
        return _avatarStorageId
    }
    
    init(uid: String, nickname: String, firstName: String, lastName: String) {
        _uid = uid
        _nickname = nickname
        _firstName = firstName
        _lastName = lastName
    }
    
    init(uid: String, nickname: String, firstName: String, lastName: String, avatarUrl: String, avatarStorageId: String) {
        _uid = uid
        _nickname = nickname
        _firstName = firstName
        _lastName = lastName
        
        _avatarUrl = avatarUrl
        _avatarStorageId = avatarStorageId
    }
    
}
