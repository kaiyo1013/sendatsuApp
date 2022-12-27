//
//  HUserQuestionTableViewCell.swift
//  OriginalApp
//
//  Created by 富永開陽 on 2021/10/06.
//

import UIKit

protocol HUserQuestionTableViewCellDelegate {
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton)
}
class HUserQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet var userPostTextView: UITextView!
    @IBOutlet var userPostTimeLineLabel: UILabel!
    
    var delegate: HUserQuestionTableViewCellDelegate?


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
