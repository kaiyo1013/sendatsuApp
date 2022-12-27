//
//  EditHInfoViewController.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/12.
//

import UIKit
import NCMB
import SkyFloatingLabelTextField

class EditHInfoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate{
    
    var position = ["高校1年生", "高校2年生", "高校３年生", "高校生の保護者"]
    var positiom = ""
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userDisplayNameTextField: SkyFloatingLabelTextField!
    @IBOutlet var userIDTextField: SkyFloatingLabelTextField!
    @IBOutlet var schoolButton: UIButton!
    @IBOutlet var positionPickerView: UIPickerView!
    @IBOutlet var introductionTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        userDisplayNameTextField.delegate = self
        userIDTextField.delegate = self
        positionPickerView.delegate = self
        positionPickerView.dataSource = self
        introductionTextView.delegate = self
        
        
        // ユーザーがnilでないとき
        if let user = NCMBUser.current() {
            userDisplayNameTextField.text = user.object(forKey: "displayName") as? String
            userIDTextField.text = user.userName
            introductionTextView.text = user.object(forKey: "introduction") as? String
            schoolButton.setTitle(user.object(forKey: "school") as! String, for: .normal)
            self.navigationItem.title = user.userName
        } else {
            // nilであるならサインイン画面に戻る
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(identifier: "rootnavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //ログアウト状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
        
        let file = NCMBFile.file(withName:  NCMBUser.current().objectId, data: nil) as! NCMBFile
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
        
    }
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return position.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return position[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        positiom = position[row]
    }
    
    //画像が選択された時に呼ばれる関数
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       //画像の取り出し
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let cgImage = selectedImage.cgImage
        let uiImage2 = UIImage(cgImage: cgImage!, scale: 0, orientation: selectedImage.imageOrientation)
        let resizedImage = uiImage2.scale(byFactor: 0.4)
        
        picker.dismiss(animated: true, completion: nil)
        
        let data = UIImage.pngData(resizedImage!)
        let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: data()) as! NCMBFile
        file.saveInBackground { error in
            if error != nil {
                print(error)
            } else {
                //画像が保存できたら表示
                self.userImageView.image = resizedImage
                
            }
        } progressBlock: { progress in
            print(progress)
        }

        
        
    }
    
    //画像を選択するボタン
    @IBAction func selectImage() {
        let actionController =  UIAlertController(title: "画像の選択", message: "画像を選択してください", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                
            } else{
                print("カメラは使用できません")
            }
            
        }
        let albumAction = UIAlertAction(title: "アルバム", style: .default) { (action) in
            //アルバム
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            } else {
                print("アルバムは使用できません")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
       
    }
    
    
    //保存ボタン
    @IBAction func save() {
        
        let user = NCMBUser.current()
        user?.setObject(userDisplayNameTextField.text, forKey: "displayName")
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.setObject(userIDTextField.text, forKey: "userName")
        user?.setObject(positiom, forKey: "gradePostion")
        user?.setObject(schoolButton.currentTitle, forKey: "school")
        user?.saveInBackground({ error in
            if error != nil {
                print(error)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
        }
    
    @IBAction func school() {
        performSegue(withIdentifier: "toschool", sender: nil)
    }
    
}
