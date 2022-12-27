//
//  FifthViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/02.
//

import UIKit
import NCMB
import SkyFloatingLabelTextField

class FifthSignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    
    
    let gradePosition: [String] = ["高校1年生", "高校2年生", "高校3年生", "高校生の保護者"]
    var positiom = ""
    var userName: String!
    var mailAddress: String!
    var password: String!
    var position: String!
    
    @IBOutlet var belongingSchoolLabel: UILabel!
    @IBOutlet var schoolButton: UIButton!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var gradePickerView: UIPickerView!
    @IBOutlet var clubLabel: UILabel!
    @IBOutlet var clubTextField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        gradePickerView.dataSource = self
        gradePickerView.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradePosition.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePosition[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        positiom = gradePosition[row]
    }
    
    @IBAction func doneButton() {
        let user = NCMBUser()
        user.setObject(positiom, forKey: "gradePosition")
        user.setObject(schoolButton.currentTitle, forKey: "school")
        user.setObject(clubTextField.text, forKey: "club")
        user.setObject(position, forKey: "position")
        user.userName = userName
        print(userName)
        user.password = password
        user.mailAddress = mailAddress
        user.setObject("", forKey: "introduction")
        user.setObject("", forKey: "displayName")
        user.signUpInBackground { error in
            if error != nil {
                print(error)
            } else {
                let storyboard = UIStoryboard(name: "Main02", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabbarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
        }
    }
    
    @IBAction func school() {
        performSegue(withIdentifier: "toschool", sender: nil)
    }
    
    
    

}
