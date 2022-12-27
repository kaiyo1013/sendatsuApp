//
//  User.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/18.
//投稿するユーザーのモデル

import UIKit

class User: NSObject {
    
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?
    var position: String?
    var gradePosition: String?
    var school: String?
    var firstSchool: String?
    var secondSchool: String?
    var thirdSchool: String?
    var fourthSchool: String?
    var fifthSchool: String?
    
    
        init(objectId: String, userName: String) {
            self.objectId = objectId
            self.userName = userName
//            self.displayName = displayName
//            self.introduction = introduction
//            self.position = position
//            self.gradePosition = gradePosition
//            self.school = school
//            self.firstSchool = firstSchool
//            self.secondSchool = secondSchool
//            self.thirdSchool = thirdSchool
//            self.fourthSchool = fourthSchool
//            self.fifthSchool = fifthSchool
       }

}
