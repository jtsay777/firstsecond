//
//  ScoreCell.swift
//  firstsecond
//
//  Created by Johnson Tsay on 1/22/17.
//  Copyright © 2017 Johnson Tsay. All rights reserved.
//

import UIKit

class ScoreCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: CircleImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(dict:Dictionary<String, String>) {
        nicknameLabel.text = dict["nickname"]
        captionLabel.text = dict["caption"]
        scoreLabel.text = dict["score"]
        commentLabel.text = dict["comment"]
    }

}
