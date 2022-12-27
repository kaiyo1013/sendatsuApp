//
//  FirstSignUpViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/02.
//

import UIKit
import NCMB
import SkyFloatingLabelTextField

class FirstSignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var mailAddressLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var confirmPasswordLabel: UILabel!
    @IBOutlet var userIDTextField: SkyFloatingLabelTextField!
    @IBOutlet var mailAddressTextField: SkyFloatingLabelTextField!
    @IBOutlet var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet var confirmPasswordTextField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        userIDTextField.delegate = self
        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func next() {
        let user = NCMBUser()
        if userIDTextField.text!.count >= 8  {
           
            if passwordTextField.text == confirmPasswordTextField.text {
                user.password = passwordTextField.text
            } else {
                let alertController = UIAlertController(title: "パスワードの不一致", message: "パスワードが一致していません", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)}
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                return
            }
        } else {
            let alertController = UIAlertController(title: "字数不足", message: "ユーザーIDの字数が不足しています", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)}
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            return
                }
        self.performSegue(withIdentifier: "toSecond", sender: nil)
       
    }
    
        //ここでサインアップではなくて,一番最後のサインアップ画面に値渡しする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecond" {
            let second = segue.destination as! SecondSignUpViewController
            second.userName = userIDTextField.text
            second.mailAddress = mailAddressTextField.text
            second.password = passwordTextField.text
        }
        
    }
    
        
            
        
        
    }
    


