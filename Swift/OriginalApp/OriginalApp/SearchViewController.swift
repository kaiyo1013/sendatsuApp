//
//  QuestionViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/03.
//

import UIKit
import NCMB
import KRProgressHUD
import SwiftData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, QuestionTableViewCellDelegate{
    
    var selectedPost: Post?
    
    var posts = [Post]()
    
    var currentPost = [Post]()
    
    var allPost = [Post]()
    
    var allComment = [String]()
    
    var userObjectID: User!
    
    var allusers = [NCMBUser]()
    
    var selectedUser: User!
    
    var blockUserIdArray = [String]()
    
    
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        
        let nib = UINib(nibName: "QuestionTableViewCell", bundle: Bundle.main)
        searchTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        searchTableView.tableFooterView = UIView()
        
        searchTableView.rowHeight = 272
        
        setRefreshControl()
        loadSearchQuestion()
        
        searchBar.delegate = self
        
        
        
        
        searchBar.placeholder = "高校名を検索"
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        
        currentPost = posts
        
        searchTableView.reloadData()
        
        setupSearchBar()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allloadUser()
        setRefreshControl()
        getBlockUser()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            let commentViewController = segue.destination as! CommentsViewController
            commentViewController.postId = selectedPost?.objectId
        } else if segue.identifier == "toJHUserInfo" {
            let JHUserInfoViewController = segue.destination as! JHUserInfoViewController
            JHUserInfoViewController.userObjectID = userObjectID
        } else {
            let HUserInfoViewController = segue.destination as! HUserInfoViewController
            HUserInfoViewController.userObjectID = userObjectID
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! QuestionTableViewCell
        
        let userImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let questionTextView = cell.contentView.viewWithTag(3) as! UITextView
        let createDateLabel = cell.contentView.viewWithTag(4) as! UILabel
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        let user = posts[indexPath.row].user
        userNameLabel.text = user.displayName
        
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
        //                let userImageUrl = "https://mb.api.cloud.nifty.com/2013-09-01/applications/rcsyyu9UuijtnCy5/publicFiles/" + userObjectId
        //                userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "human-placeholder@2x.png"), options: nil, progressBlock: nil, completionHandler: nil)
        
        questionTextView.text = posts[indexPath.row].text
        // let imageUrl = posts[indexPath.row].imageUrl
        //cell.photoImageView.kf.setImage(with: URL(string: imageUrl))
        
        // Likeによってハートの表示を変える
        /* if posts[indexPath.row].isLiked == true {
         cell.likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
         } else {
         cell.likeButton.setImage(UIImage(named: "heart-outline"), for: .normal)
         }
         
         // Likeの数
         cell.likeCountLabel.text = "\(posts[indexPath.row].likeCount)件"*/
        
        // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
        createDateLabel.text = DateUtils.stringFromDate(date: posts[indexPath.row].createDate, format: "yyyy年MM月dd日 HH時mm分")
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = posts[indexPath.row].user
        userObjectID = selectedUser
        if selectedUser.position == "中学生、中学生の保護者" {
            performSegue(withIdentifier: "toJHUserInfo", sender: nil)
        } else if selectedUser.position == "高校生、高校生の保護者" {
            performSegue(withIdentifier: "toHUserInfo", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //自分以外＝>報告・ブロックする
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if posts[indexPath.row].user.objectId != NCMBUser.current()?.objectId {
            let reportButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "報告") { (action, index) -> Void in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let reportAction = UIAlertAction(title: "報告する", style: .destructive ){ (action) in
                    KRProgressHUD.showSuccess(withMessage: "この投稿を報告しました。ご協力ありがとうございました。")
                    let object = NCMBObject(className: "Report") //新たにクラス作る
                    object?.setObject(self.posts[indexPath.row].objectId, forKey: "reportId")
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
                    object?.setObject(self.posts[indexPath.row].user.objectId, forKey: "blockUserID")
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
                query?.getObjectInBackground(withId: self.posts[indexPath.row].objectId, block: { (post, error) in
                    if error != nil {
                        KRProgressHUD.showError(withMessage: "エラーです")
                        KRProgressHUD.dismiss()
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "投稿を削除しますか？", message: "削除します", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                                alertController.dismiss(animated: true, completion: nil)
                            }
                            let deleteAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                post?.deleteInBackground({ (error) in
                                    if error != nil {
                                        print(error)
                                        KRProgressHUD.showError(withMessage: "エラーです")
                                        KRProgressHUD.dismiss()
                                        
                                    } else {
                                        tableView.deselectRow(at: indexPath, animated: true)
                                        self.loadSearchQuestion()
                                        self.searchTableView.reloadData()
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
    
    func allloadUser(){
        let query = NCMBUser.query()
        // 新着ユーザー50人だけ拾う
        //query?.order(byDescending: “createDate”)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                
            } else {
                self.allusers = result as! [NCMBUser]
                
                self.searchTableView.reloadData()
            }
        })
        searchTableView.reloadData()
    }
    
    
    
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton) {
        // 選ばれた投稿を一時的に格納
        selectedPost = posts[tableViewCell.tag]
        
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toComments", sender: nil)    }
    
    
    
    //    func didTapImageViewButton(tableViewCell: UITableViewCell, button: UIButton) {
    //        if selectedUser.position == "中学生、中学生の保護者" {
    //            performSegue(withIdentifier: "toJHUserInfo", sender: nil)
    //        } else {
    //            performSegue(withIdentifier: "toHUserInfo", sender: nil)
    //        }
    //
    //    }
    
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
        
        
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                KRProgressHUD.showError(withMessage: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [Post]()
                self.allComment = [String]()
                
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        // 投稿したユーザーの情報をUserモデルにまとめる
                        
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        userModel.displayName = user.object(forKey: "displayName") as? String
                        
                        userModel.position = user.object(forKey: "position") as? String
                        
                        userModel.gradePosition = user.object(forKey: "gradePosition") as? String
                        
                        userModel.introduction = user.object(forKey: "introduction") as? String
                        
                        userModel.school = user.object(forKey: "school") as? String
                        
                        userModel.firstSchool = user.object(forKey: "firstSchool") as? String
                        
                        userModel.secondSchool = user.object(forKey: "secondSchool") as? String
                        
                        userModel.thirdSchool = user.object(forKey: "thirdSchool") as? String
                        
                        userModel.fourthSchool = user.object(forKey: "fourthSchool") as? String
                        
                        userModel.fifthSchool = user.object(forKey: "fifthSchool") as? String
                        
                        
                        
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
                        if self.blockUserIdArray.firstIndex(of: post.user.objectId) == nil{
                            self.posts.append(post)
                            self.allComment.append(text)
                        }
                        // 配列に加える
                       
                    }
                }
                self.allPost = self.posts
                // 投稿のデータが揃ったらTableViewをリロード
                self.searchTableView.reloadData()
            }
        })
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
    
    
    //③
   
    
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        searchTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        //self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    func setupSearchBar() {
        
        searchBar.delegate = self
        searchBar.placeholder = "キーワード検索"
        searchBar.tintColor = UIColor.gray
        searchBar.keyboardType = UIKeyboardType.default
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
        searchBar.showsCancelButton = true
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        posts = allPost
        searchBar.text = nil
        searchBar.showsCancelButton = true
        searchBar.resignFirstResponder()
        searchTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            guard let self = self else { return }
            if let keyword = searchBar.text, !keyword.isEmpty {
                
                self.posts = []
                var textArray = [String]()
                var postArray = [String]()
                self.currentPost = []
                //検索かける
                let charArray = Array(keyword)
                
                postArray = self.allComment
                for ichimoji in charArray{
                    postArray = postArray.filter { (str) -> Bool in
                        return str.contains(ichimoji)
                    }
                    
                }
                for i in self.allPost {
                    for h in postArray {
                        if i.text == h {
                            self.posts.append(i)
                        }
                    }
                }
                self.posts =  NSOrderedSet(array: self.posts).array as! [Post]
                
                self.searchTableView.reloadData()
                
                
            } else {
                //別に検索結果無しにするし
                self.posts = self.allPost
                self.searchTableView.reloadData()
            }
        }
        return true
    }
    
    
}

class DateUtils {
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
