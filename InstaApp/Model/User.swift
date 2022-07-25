//
//  User.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/25.
//

import UIKit

class User{
    var userName: String
    var profileImageString: String
    init(dic: [String: Any]){
        self.userName = dic["userName"] as? String ?? ""
        self.profileImageString = dic["profileImageString"] as? String ?? ""
    }
}
