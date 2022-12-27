//
//  AnswerTableViewCell.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/11.
//

import UIKit


class AnswerTableViewCell: UITableViewCell {
    
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
