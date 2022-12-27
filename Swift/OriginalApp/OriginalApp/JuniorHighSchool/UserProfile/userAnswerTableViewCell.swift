//
//  userAnswerTableViewCell.swift
//  OriginalApp
//
//  Created by 富永開陽 on 2021/09/30.
//

import UIKit



class userAnswerTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var answerTextView: UITextView!
    @IBOutlet var createDateLabel: UILabel!
    
   


    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        createDateLabel.textColor = UIColor(hex: "586365")
        
        answerTextView.isEditable = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
}
