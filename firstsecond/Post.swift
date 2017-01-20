//
//  Post.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/18/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import Foundation

struct Post {
    private var _pid: String
    private var _uid: String
    private var _caption: String
    private var _type: String
    private var _mediaUrl: String
    private var _mediaStorageId: String
    private var _group: String
    private var _recipients: [String]
    
    var pid: String {
        return _pid
    }

    var uid: String {
        return _uid
    }
    
    var caption: String {
        return _caption
    }
    
    var type: String {
        return _type
    }
    
    var mediaUrl: String {
        return _mediaUrl
    }

    var mediaStorageId: String {
        return _mediaStorageId
    }
    
    var group: String {
        return _group
    }
    
    var recipients: [String] {
        return _recipients
    }
    
    init(pid: String, uid: String, caption: String, type: String, mediaUrl: String, mediaStorageId: String, group: String, recipients: [String]) {
        _pid = pid
        _uid = uid
        _caption = caption
        _type = type
        _mediaUrl = mediaUrl
        _mediaStorageId = mediaStorageId
        _group = group
        _recipients = recipients
    }
}
