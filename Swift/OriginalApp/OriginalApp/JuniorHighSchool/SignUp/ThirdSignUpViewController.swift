//
//  ThirdSignUpViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/02.
//

import UIKit
import NCMB

class ThirdSignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let gradePosition: [String] = ["中学１年生", "中学2年生", "中学3年生", "中学生の保護者"]
    var positiom = ""
    var position: String!
    var userName: String!
    var mailAddress: String!
    var password: String!
   
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var gradePickerView: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        gradePickerView.dataSource = self
        gradePickerView.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fourth = segue.destination as! FourthSignUpViewController
        fourth.gradePosition = positiom
        fourth.position = position
        fourth.userName = userName
        fourth.mailAddress = mailAddress
        fourth.password = password
    }
    
    @IBAction func nextButton() {
        self.performSegue(withIdentifier: "toFourth", sender: nil)
    }
    
    
}
