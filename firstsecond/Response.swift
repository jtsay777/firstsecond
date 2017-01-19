//
//  Response.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/18/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import Foundation

struct Response {
    private var _rid: String
    private var _uid: String
    private var _pid: String
    private var _comment: String
    private var _score: Int8
    
    var rid: String {
        return _rid
    }
    
    var uid: String {
        return _uid
    }
    
    var pid: String {
        return _pid
    }
    
    var comment: String {
        return _comment
    }
    
    var score: Int8 {
        return _score
    }
    
    init(rid: String, uid: String, pid: String, comment: String, score: Int8) {
        _rid = rid
        _uid = uid
        _pid = pid
        _comment = comment
        _score = score
    }

}
