//
//  QuestionTableViewCell.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/11.
//

import UIKit

protocol QuestionTableViewCellDelegate {
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton)
    //func didTapImageViewButton(tableViewCell: UITableViewCell, button: UITapGestureRecognizer)
    }


class QuestionTableViewCell: UITableViewCell //UIGestureRecognizerDelegate
{
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userDisplayNameLabel: UILabel!
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var timeStampLabel: UILabel!
    
    var delegate: QuestionTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        timeStampLabel.textColor = UIColor(hex: "586365")
        
        questionTextView.isEditable = false
        
//        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
//                       target: self,
//                       action: #selector(QuestionTableViewCell.showUserInfo(_:)))
//
//        tapGesture.delegate = self
//
//               self.userImageView.addGestureRecognizer(tapGesture)
//
       
        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

    @IBAction func showComments(button: UIButton) {
        self.delegate?.didTapCommentsButton(tableViewCell: self, button: button)
    }
    

//    @IBAction func showUserInfo(_ sender: UITapGestureRecognizer) {
//        self.delegate?.didTapCommentsButton(tableViewCell: self, button: sender)
//    }
    
}
