//
//  DataService.swift
//  Mark's Snaps
//
//  Created by Mark Rassamni on 9/21/16.
//  Copyright © 2016 markrassamni. All rights reserved.
//

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
        return mainRef.child("users")
    }
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://marks-snaps.appspot.com")
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    var videoStorageRef: FIRStorageReference {
        return mainStorageRef.child("videos")
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName" : "" as AnyObject, "lastName" : "" as AnyObject]
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(senderUID: String, recipients: Dictionary<String,User>, mediaURL: URL, textSnippet: String? = nil) {
        
        var uids = [String]()
        for uid in recipients.keys{
            uids.append(uid)
        }
        
        let pr: Dictionary<String, AnyObject> = ["mediaURL" : mediaURL.absoluteString as AnyObject, "userID":senderUID as AnyObject,"openCount":0 as AnyObject, "recipients":uids as AnyObject]
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
    }
    
}
