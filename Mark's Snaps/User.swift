//
//  User.swift
//  Mark's Snaps
//
//  Created by Mark Rassamni on 9/21/16.
//  Copyright © 2016 markrassamni. All rights reserved.
//

import UIKit

struct User {
    private var _firstName: String
    private var _uid: String
    
    var firstName: String {
        return _firstName
    }
    
    var uid: String {
        return _uid
    }
    
    init(firstName: String, uid: String) {
        _firstName = firstName
        _uid = uid
    }
}
