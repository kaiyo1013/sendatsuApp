//
//  PostViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/16.
//

import UIKit
import NYXImagesKit
import NCMB
import UITextView_Placeholder
import PKHUD

class PostViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        postTextView.delegate = self
        postButton.isEnabled = false
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        confirmContent()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @IBAction func shareQuestion() {
        
        HUD.show(.progress)
        
        let postObject = NCMBObject(className: "Post")
        
        if self.postTextView.text.count == 0  {
            print("コメントが入力されていません")
            return
        }
        
        postObject?.setObject(postTextView.text, forKey: "post")
        postObject?.setObject(NCMBUser.current(), forKey: "user")
        let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/FdS8pWgQd14PFHaU/rcsyyu9UuijtnCy5"
        postObject?.setObject(url, forKey: "imageUrl")
        postObject?.saveInBackground({ error in
            if error != nil {
                HUD.hide()
                HUD.show(.labeledError(title: error!.localizedDescription, subtitle: nil))
            } else {
                HUD.hide()
                self.postTextView.text = nil
                self.tabBarController?.selectedIndex = 0
            }
        })
        
    }
    
    func confirmContent() {
        if postTextView.text.count > 0 {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }
    
    @IBAction func cancel() {
        //postTextViewがFirstResponderなら,キーボードを閉じる
        if postTextView.isFirstResponder == true {
            postTextView.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "投稿内容の削除", message: "入力中の投稿内容を削除しますか", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.postTextView.text = nil
            self.confirmContent()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
   
}
