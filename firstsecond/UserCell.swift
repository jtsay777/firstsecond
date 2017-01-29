//
//  UserCell.swift
//  DevChat
//
//  Created by Mark Price on 7/15/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setCheckmark(selected: false)
    }
    
    func updateUI(user: User) {
        //firstNameLbl.text = user.firstName
        firstNameLbl.text = user.nickname
    }

    func setCheckmark(selected: Bool) {
        let imageStr = selected ? "messageindicatorchecked2" : "messageindicator2"
        self.accessoryView = UIImageView(image: UIImage(named: imageStr))
    }

}
