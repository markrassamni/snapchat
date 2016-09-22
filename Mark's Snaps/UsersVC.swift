//
//  UsersVC.swift
//  Mark's Snaps
//
//  Created by Mark Rassamni on 9/21/16.
//  Copyright © 2016 markrassamni. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    
    private var _snapData: Data?
    private var _videoURL: URL?
    
    var snapData: Data? {
        get {
            return _snapData
        }
        set {
            _snapData = newValue
        }
    }
    
    var videoURL: URL? {
        get {
            return _videoURL
        }
        set {
            _videoURL = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(firstName: firstName, uid: uid)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
            //print("Users: \(self._users)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectedUsers.count < 1 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    
    @IBAction func sendSnapPressed(sender: AnyObject) {
        if let url = _videoURL {
            let videoName = "\(NSUUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            _ = ref.putFile(url, metadata: nil, completion: { (meta: FIRStorageMetadata?, err: Error?) in
                if err != nil {
                    //error handling
                    print("error uploading video: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta?.downloadURL()
                    print("Download URL: \(downloadURL)")
                    DataService.instance.sendMediaPullRequest(senderUID: (FIRAuth.auth()?.currentUser?.uid)!, recipients: self.selectedUsers, mediaURL: downloadURL!, textSnippet: "Coding today was legit")
                    //save somewhere
                    
                }
            })
            self.dismiss(animated: true, completion: nil)
        } else if let snap = _snapData {
            let reference = DataService.instance.imagesStorageRef.child("\(NSUUID().uuidString).jpg")
            _ = reference.put(snap, metadata: nil, completion: { (meta: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    print("Error updloading snapchat: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta?.downloadURL()
                }
            })
            self.dismiss(animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }

}










