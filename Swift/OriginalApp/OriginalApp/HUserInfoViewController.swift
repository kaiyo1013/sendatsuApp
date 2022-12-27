//
//  HUserInfoViewController.swift
//  OriginalApp
//
//  Created by 富永開陽 on 2021/10/19.
//

import UIKit
import NCMB

class HUserInfoViewController: UIViewController, UITextViewDelegate {
    
    var userObjectID: User!
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userDisplayNameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var introductionTextView: UITextView!
    @IBOutlet var schoolLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        introductionTextView.delegate = self
        
        //ImageViewを丸くするコード
         userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
         userImageView.layer.masksToBounds = true
        
        introductionTextView.textColor = UIColor(hex: "586365")
        
        // 枠のカラー
               introductionTextView.layer.borderColor = #colorLiteral(red: 0.3074430227, green: 0.3217163086, blue: 0.3168176711, alpha: 1)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    if let user = NCMBUser.current() {
        let User = userObjectID
        userDisplayNameLabel.text = User!.userName
        introductionTextView.text = User!.introduction
        self.navigationItem.title = User!.userName
        positionLabel.text = User!.gradePosition
        schoolLabel.text = User!.school
        
        let file = NCMBFile.file(withName: User?.objectId, data: nil) as! NCMBFile
        file.getDataInBackground { data, error in
            if error != nil {
                print(error)
            } else {
                if data != nil {
                    let image = UIImage(data: data!)
                    self.userImageView.image = image
                }
            }
            
        }
      
    } else {
        //ログイン画面に戻る
        let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(identifier: "rootNavigationController")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        
        //ログアウト状態の保持
        let ud = UserDefaults.standard
        ud.set(false, forKey: "isLogin")
        ud.synchronize()
        
    }
    
    

   

}
}
