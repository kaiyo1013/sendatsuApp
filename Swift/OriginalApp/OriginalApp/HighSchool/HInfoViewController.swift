//
//  HInfoViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/12.
//

import UIKit
import NCMB
import KRProgressHUD

class HInfoViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,
                           HUserQuestionTableViewCellDelegate{
   
    var userPosts = [Post]()
    
    var selectedPost: Post?
    
    var posts = [Post]()
    
    var blockUserIdArray = [String]()
    
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userDisplayNameLabel: UILabel!
    @IBOutlet var schoolNameLabel: UILabel!
    @IBOutlet var positionLabel : UILabel!
    @IBOutlet var introductionTextView: UITextView!
    @IBOutlet var questionHistoryLabel: UILabel!
    @IBOutlet var questionHistoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        introductionTextView.delegate = self
        questionHistoryTableView.delegate = self
        questionHistoryTableView.dataSource = self
        
        //ImageViewを丸くするコード
         userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
         userImageView.layer.masksToBounds = true
        
        let nib = UINib(nibName: "HUserQuestionTableViewCell", bundle: Bundle.main)
        questionHistoryTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        questionHistoryTableView.rowHeight = 148
        
        questionHistoryTableView.tableFooterView = UIView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = NCMBUser.current() {
            userDisplayNameLabel.text = user.object(forKey: "displayName")  as? String
            introductionTextView.text = user.object(forKey: "introduction")  as? String
            schoolNameLabel.text = user.object(forKey: "school") as? String
            positionLabel.text = user.object(forKey: "gradePosition") as? String
            self.navigationItem.title = user.userName
            
            let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
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
        loadSearchQuestion()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toComments" {
               let userCommentViewController = segue.destination as! UserCommentsViewController
               userCommentViewController.postId = selectedPost?.objectId
           }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HUserQuestionTableViewCell
        cell.delegate = self
        
        
        
        let userPostTextView = cell.contentView.viewWithTag(1) as! UITextView
        let userPostTimeLineLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        let user = userPosts[indexPath.row].user
        
        //cell.userDisplayNameLabel.text = user.displayName
       // let userImageUrl = "https://mb.api.cloud.nifty.com/2013-09-01/applications/rcsyyu9UuijtnCy5/publicFiles/" + user.objectId
        //cell.userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil, completionHandler: nil)

        userPostTextView.text = userPosts[indexPath.row].text
        //let imageUrl = userPosts[indexPath.row].imageUrl
        
        
        userPostTimeLineLabel.text = DateUtils.stringFromDate(date: userPosts[indexPath.row].createDate, format: "yyyy年MM月dd日 HH時mm分")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //自分以外＝>報告・ブロックする
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if userPosts[indexPath.row].user.objectId != NCMBUser.current()?.objectId {
            let reportButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "報告") { (action, index) -> Void in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let reportAction = UIAlertAction(title: "報告する", style: .destructive ){ (action) in
                    KRProgressHUD.showSuccess(withMessage: "この投稿を報告しました。ご協力ありがとうございました。")
                    let object = NCMBObject(className: "Report") //新たにクラス作る
                    object?.setObject(self.userPosts[indexPath.row].objectId, forKey: "reportId")
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
                    object?.setObject(self.userPosts[indexPath.row].user.objectId, forKey: "blockUserID")
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
                let query = NCMBQuery(className: "Post")
                query?.getObjectInBackground(withId: self.userPosts[indexPath.row].objectId, block: { (post, error) in
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
                                        self.loadSearchQuestion()
                                        self.questionHistoryTableView.reloadData()
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
        loadSearchQuestion()
    }
    
   
    
    @IBAction func showMenu() {
        
        let actionController = UIAlertController(title: "メニュー", message: "メニュ-を選択して下さい", preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "サインアウト", style: .default) { (action) in
            //ログイン画面に戻る
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(identifier: "rootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            //ログアウト状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        let deletaAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ error in
                if error != nil {
                    print(error)
                } else {
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "rootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }        }
           
            )
   }
        actionController.addAction(signOutAction)
        actionController.addAction(cancelAction)
        actionController.addAction(deletaAction)
        self.present(actionController, animated: true, completion: nil)
        
   }
    
    func loadSearchQuestion() {
        
        guard let currentUser = NCMBUser.current() else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(identifier: "rootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            return
        }
       
        let query = NCMBQuery(className: "Post")
        
        
        query?.includeKey("user")
                // 降順に表示する
                query?.order(byDescending: "createDate")

                // 投稿したユーザーの情報も同時取得
                query?.includeKey("user")

                // フォロー中の人 + 自分の投稿だけ持ってくる
        query?.whereKey("user", equalTo: NCMBUser.current())

                // オブジェクトの取得
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
                        KRProgressHUD.showError(withMessage: error!.localizedDescription)
                    } else {
                        // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                   self.userPosts = [Post]()

                        for postObject in result as! [NCMBObject] {
                            // ユーザー情報をUserクラスにセット
                            let user = postObject.object(forKey: "user") as! NCMBUser

                            // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                            if user.object(forKey: "active") as? Bool != false {
                                // 投稿したユーザーの情報をUserモデルにまとめる
                                let userModel = User(objectId: user.objectId, userName: user.userName)
                                userModel.displayName = user.object(forKey: "displayName") as? String

                                // 投稿の情報を取得
                                let imageUrl = postObject.object(forKey: "imageUrl") as! String
                                let text = postObject.object(forKey: "post") as! String

                                // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                                let post = Post(objectId: postObject.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate)

                                // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                                let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                                if likeUsers?.contains(currentUser.objectId) == true {
                                    post.isLiked = true
                                } else {
                                    post.isLiked = false
                                }

                                // いいねの件数
                                if let likes = likeUsers {
                                    post.likeCount = likes.count
                                }

                                // 配列に加える
                                self.userPosts.append(post)
                            }
                        }

                        // 投稿のデータが揃ったらTableViewをリロード
                        self.questionHistoryTableView.reloadData()
                    }
                })
    }

    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton) {
        // 選ばれた投稿を一時的に格納
               selectedPost = userPosts[tableViewCell.tag]

               // 遷移させる(このとき、prepareForSegue関数で値を渡す)
               self.performSegue(withIdentifier: "toComments", sender: nil)    }
    
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
                    KRProgressHUD.show()
                    let query = NCMBQuery(className: "Post")
                    query?.getObjectInBackground(withId: self.posts[tableViewCell.tag].objectId, block: { (post, error) in
                        if error != nil {
                            KRProgressHUD.showError(withMessage: error!.localizedDescription)
                        } else {
                            // 取得した投稿オブジェクトを削除
                            post?.deleteInBackground({ (error) in
                                if error != nil {
                                    KRProgressHUD.showError(withMessage: error!.localizedDescription)
                                } else {
                                    // 再読込
                                    self.loadSearchQuestion()
                                    KRProgressHUD.dismiss()
                                }
                            })
                        }
                    })
                }
                let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
                    KRProgressHUD.showSuccess(withMessage: "この投稿を報告しました。ご協力ありがとうございました。")
                }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }
                if posts[tableViewCell.tag].user.objectId == NCMBUser.current().objectId {
                    // 自分の投稿なので、削除ボタンを出す
                    alertController.addAction(deleteAction)
                } else {
                    // 他人の投稿なので、報告ボタンを出す
                    alertController.addAction(reportAction)
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)    }
    
}
            
        

