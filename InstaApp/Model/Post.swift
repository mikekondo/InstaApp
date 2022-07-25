//
//  Post.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/25.
//

import UIKit

class Post{
    var userName: String
    var userImageString: String
    var postDataImageString: String
    var comment: String

    init(userName: String,userImageString: String,postDataImageString: String,comment: String){
        self.userName = userName
        self.userImageString = userImageString
        self.postDataImageString = postDataImageString
        self.comment = comment
    }
}
