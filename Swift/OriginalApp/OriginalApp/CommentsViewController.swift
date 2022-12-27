//
//  CommentsViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/16.
//

import UIKit
import NCMB
import KRProgressHUD
import SwiftData

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postId: String!
    
    var comments = [Comment]()
    
    var blockUserIdArray = [String]()
    
    @IBOutlet var commentsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        
        let nib = UINib(nibName: "AnswerTableViewCell", bundle: Bundle.main)
        commentsTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        commentsTableView.rowHeight = 272
        
        commentsTableView.tableFooterView = UIView()
        
        

        loadComments()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AnswerTableViewCell
        let userImageView = cell.viewWithTag(1) as! UIImageView
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        let answerTextView = cell.viewWithTag(3) as! UITextView
        let createDateLabel = cell.viewWithTag(4) as! UILabel

        // ユーザー画像を丸く
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true

        let user = comments[indexPath.row].user
        let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
        file.getDataInBackground { data, error in
            if error != nil {
                print(error)
            } else {
                if data != nil {
                    let image = UIImage(data: data!)
                    userImageView.image = image
                }
            }
            
        }
        userNameLabel.text = user.displayName
        answerTextView.text = comments[indexPath.row].text
        createDateLabel.text = DateUtils2.stringFromDate(date: comments[indexPath.row].createDate, format: "yyyy年MM月dd日 HH時mm分")
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func loadComments() {
        comments = [Comment]()
        let query = NCMBQuery(className: "Comment")
        query?.whereKey("postId", equalTo: postId)
        query?.includeKey("user")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                KRProgressHUD.showError(withMessage: error!.localizedDescription)
            } else {
                for commentObject in result as! [NCMBObject] {
                    // コメントをしたユーザーの情報を取得
                    let user = commentObject.object(forKey: "user") as! NCMBUser
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String

                    // コメントの文字を取得
                    let text = commentObject.object(forKey: "text") as! String
                    
                    let objectId = commentObject.object(forKey: "objectId") as! String

                    // Commentクラスに格納
                    let comment = Comment(postId: self.postId, user: userModel, text: text, createDate: commentObject.createDate, objectId: objectId)
                    self.comments.append(comment)
                    
                    // テーブルをリロード
                    self.commentsTableView.reloadData()
                }

            }
        })
    }
    
    @IBAction func addComment() {
        let alert = UIAlertController(title: "コメント", message: "コメントを入力して下さい", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            KRProgressHUD.show()
            let object = NCMBObject(className: "Comment")
            object?.setObject(self.postId, forKey: "postId")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.setObject(alert.textFields?.first?.text, forKey: "text")
            object?.saveInBackground({ (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: error!.localizedDescription)
                } else {
                    KRProgressHUD.dismiss()
                    self.loadComments()
                }
            })
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField) in
            textField.placeholder = "ここにコメントを入力"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //自分以外＝>報告・ブロックする
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if comments[indexPath.row].user.objectId != NCMBUser.current()?.objectId {
            let reportButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "報告") { (action, index) -> Void in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let reportAction = UIAlertAction(title: "報告する", style: .destructive ){ (action) in
                    KRProgressHUD.showSuccess(withMessage: "この投稿を報告しました。ご協力ありがとうございました。")
                    let object = NCMBObject(className: "Report") //新たにクラス作る
                    object?.setObject(self.comments[indexPath.row].objectId, forKey: "reportId")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.saveInBackground({ (error) in
                        if error != nil {
                            KRProgressHUD.showError(withMessage: "エラーです")
                        } else {
                            
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    })
                }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(reportAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                tableView.isEditing = false
                
            }
            reportButton.backgroundColor = UIColor.red
            let blockButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "ブロック") { (action, index) -> Void in
                //self.comments.remove(at: indexPath.row)
                //tableView.deleteRows(at: [indexPath], with: .fade)
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let blockAction = UIAlertAction(title: "ブロックする", style: .destructive) { (action) in
                    KRProgressHUD.showSuccess(withMessage: "このユーザーをブロックしました。")
                    
                    let object = NCMBObject(className: "Block") //新たにクラス作る
                    object?.setObject(self.comments[indexPath.row].user.objectId, forKey: "blockUserID")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.saveInBackground({ (error) in
                        if error != nil {
                            KRProgressHUD.showError(withMessage: "エラーです")
                        } else {
                            KRProgressHUD.dismiss()
                            tableView.deselectRow(at: indexPath, animated: true)
                            self.getBlockUser()
                        }
                    })
                    
                }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(blockAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                tableView.isEditing = false
            }
            blockButton.backgroundColor = UIColor.blue
            return[blockButton,reportButton]
        } else {
            let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
                let query = NCMBQuery(className: "Comment")
                query?.getObjectInBackground(withId: self.comments[indexPath.row].objectId, block: { (post, error) in
                    if error != nil {
                        KRProgressHUD.showError(withMessage: "エラーです")
                        KRProgressHUD.dismiss()
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "投稿を削除しますか？", message: "削除します", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                                alertController.dismiss(animated: true, completion: nil)
                            }
                            let deleteAction = UIAlertAction(title: "OK", style: .default) { (acrion) in
                                post?.deleteInBackground({ (error) in
                                    if error != nil {
                                        KRProgressHUD.showError(withMessage: "エラーです")
                                        KRProgressHUD.dismiss()
                                    } else {
                                        tableView.deselectRow(at: indexPath, animated: true)
                                        self.loadComments()
                                        self.commentsTableView.reloadData()
                                    }
                                })
                            }
                            alertController.addAction(cancelAction)
                            alertController.addAction(deleteAction)
                            self.present(alertController,animated: true,completion: nil)
                            tableView.isEditing = false
                        }
                        
                    }
                })
            }
            deleteButton.backgroundColor = UIColor.red //色変更
            return [deleteButton]
        }
    }
    
    func getBlockUser() {
        
        let query = NCMBQuery(className: "Block")
        
        //includeKeyでBlockの子クラスである会員情報を持ってきている
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //エラーの処理
            } else {
                //ブロックされたユーザーのIDが含まれる + removeall()は初期化していて、データの重複を防いでいる
                self.blockUserIdArray.removeAll()
                for blockObject in result as! [NCMBObject] {
                    //この部分で①の配列にブロックユーザー情報が格納
                    self.blockUserIdArray.append(blockObject.object(forKey: "blockUserID") as! String)
                    
                }
                
            }
        })
        loadComments()
    }
    
   
    
}

class DateUtils2 {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}


