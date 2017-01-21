//
//  PostCell.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/20/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var scoreSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(post: Post) {
          
        captionLabel.text = post.caption
    }

}
