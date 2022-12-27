//
//  SignInViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/02.
//

import UIKit
import NCMB
import SkyFloatingLabelTextField


class SignInViewController: UIViewController, UITextFieldDelegate {
    
//    @IBOutlet var userIDLabel: UILabel!
//    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var userIDTextField: SkyFloatingLabelTextField!
    @IBOutlet var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet var makeAccountLabel: UILabel!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signOutButton: UIButton!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        userIDTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        
        signInButton.backgroundColor = UIColor(hex: "37AB9D")
        signOutButton.backgroundColor = UIColor(hex: "FFC042")
        makeAccountLabel.textColor = UIColor(hex: "FFC042")
        
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn() {
        
        if passwordTextField != nil && userIDTextField != nil {
            NCMBUser.logInWithUsername(inBackground: userIDTextField.text, password: passwordTextField.text) { result, error in
                if error != nil {
                    //ログイン失敗
                    print(error)
                    let alertController = UIAlertController(title: "パスワードかユーザーIDが違います", message: "パスワードとユーザーIDを入力し直してください", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let user = NCMBUser.current()
                    if user?.object(forKey: "position") as! String == "高校生、高校生の保護者" {
                        //ログイン成功
                        let storyboard = UIStoryboard(name: "Main02", bundle: Bundle.main)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabbarController")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    } else {
                        //ログイン成功
                        let storyboard = UIStoryboard(name: "Main01", bundle: Bundle.main)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabbarController")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    }
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        } else {
            let alertController = UIAlertController(title: "入力してください", message: "パスワードとユーザーIDを入力してください", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
   
    
    

}
