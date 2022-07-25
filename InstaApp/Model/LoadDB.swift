//
//  LoadDB.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol loadDoneDelegate{
    func loadOK(judge: Bool)
}

class LoadDB{
    let db = Firestore.firestore()
    var postDataSets = [Post]()
    var delegate: loadDoneDelegate?

    func loadPostData(){
        let postDB = db.collection("post")
        postDB.order(by: "postData").addSnapshotListener { snapShot, error in
            self.postDataSets = [] // ここで空にしないとバグる
            if let error = error{
                print("投稿データが取得できませんでした",error)
            }
            if let snapshotDoc = snapShot?.documents{
                for doc in snapshotDoc{
                    let data = doc.data()
                    guard let userName = data["userName"] as? String,let userImageString = data["userImageString"] as? String,let postDataImageString = data["postDataImageString"] as? String,let comment = data["comment"] as? String else{
                        return
                    }
                    let postData = Post(userName: userName, userImageString: userImageString, postDataImageString: postDataImageString, comment: comment)
                    self.postDataSets.append(postData)
                    self.postDataSets.reverse()
                }
                self.delegate?.loadOK(judge: true)
            }
        }
    }

    func loadMyPostData(){
        let postDB = db.collection("post")
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        postDB.order(by: "postData").whereField("userRef", isEqualTo: "/userRef/\(uid)").addSnapshotListener { snapShot, error in
            self.postDataSets = [] // ここで空にしないとバグる
            if let error = error{
                print("投稿データが取得できませんでした",error)
            }
            if let snapshotDoc = snapShot?.documents{
                for doc in snapshotDoc{
                    let data = doc.data()
                    guard let userName = data["userName"] as? String,let userImageString = data["userImageString"] as? String,let postDataImageString = data["postDataImageString"] as? String,let comment = data["comment"] as? String else{
                        return
                    }
                    let postData = Post(userName: userName, userImageString: userImageString, postDataImageString: postDataImageString, comment: comment)
                    self.postDataSets.append(postData)
                    self.postDataSets.reverse()
                }
                self.delegate?.loadOK(judge: true)
            }
        }
    }
}
