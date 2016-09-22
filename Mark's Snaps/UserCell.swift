//
//  UserCell.swift
//  Mark's Snaps
//
//  Created by Mark Rassamni on 9/21/16.
//  Copyright © 2016 markrassamni. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setCheckmark(selected: false)
    }

    func updateUI(user: User) {
        firstNameLbl.text = user.firstName
    }
    
    func setCheckmark(selected: Bool) {
        let imageStr = selected ? "messageindicatorchecked1" : "messageindicator1"
        accessoryView = UIImageView(image: UIImage(named: imageStr))
    }

}
