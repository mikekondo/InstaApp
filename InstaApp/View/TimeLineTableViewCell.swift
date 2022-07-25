//
//  TimeLineTableViewCell.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/25.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postDataImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.circleTrim()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
