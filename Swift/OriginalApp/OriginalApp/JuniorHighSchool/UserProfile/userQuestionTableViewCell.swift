//
//  userQuestionTableViewCell.swift
//  OriginalApp
//
//  Created by 富永開陽 on 2021/09/26.
//

import UIKit

protocol userQuestionTableViewCellDelegate {
    
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton)
}

class userQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet var userPostTextView: UITextView!
    @IBOutlet var userPostTimeLineLabel: UILabel!
    
    var delegate: userQuestionTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        userPostTextView.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showComments(button: UIButton) {
        self.delegate?.didTapCommentsButton(tableViewCell: self, button: button)
    
}
}
