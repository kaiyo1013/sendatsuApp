//
//  FourthSignUpViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/02.
//

import UIKit
import NCMB

class FourthSignUpViewController: UIViewController, UITextFieldDelegate {
    
    var userName: String!
    var mailAddress: String!
    var password: String!
    var position: String!
    var gradePosition: String!
    
    var selectButtonID: Int = 0
    
    
    @IBOutlet var schoolChoiceLabel: UILabel!
    @IBOutlet var firstSchoolButton: UIButton!
    @IBOutlet var secondSchoolButton: UIButton!
    @IBOutlet var thirdSchoolButton: UIButton!
    @IBOutlet var fourthSchoolButton: UIButton!
    @IBOutlet var fifthSchoolButton: UIButton!
   
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    
    @IBAction func doneButton() {
        
        let user = NCMBUser()
        user.userName = userName
        user.mailAddress = mailAddress
        user.password = password
        user.setObject(position, forKey: "position")
        user.setObject(gradePosition, forKey: "gradePosition")
        user.setObject("", forKey: "introduction")
        user.setObject("", forKey: "displayName")
        user.setObject(firstSchoolButton.currentTitle, forKey: "firstSchool")
        user.setObject(secondSchoolButton.currentTitle, forKey: "secondSchool")
        user.setObject(thirdSchoolButton.currentTitle, forKey: "thirdSchool")
        user.setObject(fourthSchoolButton.currentTitle, forKey: "fourthSchool")
        user.setObject(fifthSchoolButton.currentTitle, forKey: "fifthSchool")
        user.signUpInBackground { error in
            if error != nil {
                print(error)
            } else {
                let storyboard = UIStoryboard(name: "Main01", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabbarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
        }
        
        
        
    }
    
    @IBAction func firstSchool() {
        selectButtonID = 1
        performSegue(withIdentifier: "toSchool", sender: nil)
    }
    
    @IBAction func secondSchool() {
        selectButtonID = 2
        performSegue(withIdentifier: "toSchool", sender: nil)
    }
    
    @IBAction func thirdSchool() {
        selectButtonID = 3
        performSegue(withIdentifier: "toSchool", sender: nil)
    }
    
    @IBAction func fourthSchool() {
        selectButtonID = 4
        performSegue(withIdentifier: "toSchool", sender: nil)
    }
    
    @IBAction func fifthSchool() {
        selectButtonID = 5
        performSegue(withIdentifier: "toSchool", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSchool" {
            let searchSchoolViewController = segue.destination as! SignUpJHSearchSchoolViewController
            searchSchoolViewController.searchSchoolID = selectButtonID
        }
    }
   

}
