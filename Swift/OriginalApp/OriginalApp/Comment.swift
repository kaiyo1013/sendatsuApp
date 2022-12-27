//
//  Comment.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/18.
//コメントのモデル

import UIKit

class Comment: NSObject {
    
        var postId: String
        var user: User
        var text: String
        var createDate: Date
        var objectId: String
        

    init(postId: String, user: User, text: String, createDate: Date, objectId: String) {
            self.postId = postId
            self.user = user
            self.text = text
            self.createDate = createDate
            self.objectId = objectId
            
        }
}
