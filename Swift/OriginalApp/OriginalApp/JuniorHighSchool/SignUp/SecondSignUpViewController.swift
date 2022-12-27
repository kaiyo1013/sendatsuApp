//
//  SecondSignUpViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/02.
//

import UIKit
import NCMB


class SecondSignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var positionPickerView: UIPickerView!
    
    let position: [String] = ["中学生、中学生の保護者", "高校生、高校生の保護者" ]
    var positiom = ""
    var userName: String!
    var mailAddress: String!
    var password: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        positionPickerView.dataSource = self
        positionPickerView.delegate = self
    }
    
    // PickerViewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerViewの行数
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return position[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return position.count
    }
    
    //pickerViewで選択したものを取り出す
    //positiomは選択したものを入れる変数
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        positiom = position[row]
    }
    
    
    
    @IBAction func nextButton() {
        print(positiom)
        if positiom == "中学生、中学生の保護者" {
            self.performSegue(withIdentifier: "toThird", sender: nil)
        } else {
            self.performSegue(withIdentifier: "toFifth", sender: nil)
        }
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toThird" {
            let third = segue.destination as! ThirdSignUpViewController
            third.position = positiom
            third.userName = userName
            third.mailAddress = mailAddress
            third.password = password
        } else {
            let fifth = segue.destination as! FifthSignUpViewController
            fifth.position = positiom
            fifth.userName = userName
            fifth.mailAddress = mailAddress
            fifth.password = password
        }
    }
    
    
    
}
