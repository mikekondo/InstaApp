//
//  SendDB.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SendDB{
    let db = Firestore.firestore()

    // MARK: ユーザ情報の登録
    func createUser(userName: String,profileImage: UIImage){
        signIn()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        guard let profileImageData = profileImage.jpegData(compressionQuality: 0.01) else{
            return
        }
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString)")
        imageRef.putData(profileImageData, metadata: nil) { metadata, error in
            if let error = error {
                print("putDataのエラー",error)
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("downloadURLのエラー",error)
                }
                guard let profileImageString = url?.absoluteString else{
                    return
                }
                UserDefaults.standard.removeObject(forKey: "profileImageStringKey")
                UserDefaults.standard.removeObject(forKey: "userNameKey")
                UserDefaults.standard.setValue(profileImageString, forKey: "profileImageStringKey")
                UserDefaults.standard.setValue(userName, forKey: "userNameKey")
                self.sendUserData(userName: userName, profileImageString: profileImageString, uid: uid)
            }
        }
    }// func createUserはここまで

    // MARK: サインアウト
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch let error as NSError{
            print("error",error)
            return
        }
        let user = Auth.auth().currentUser
        user?.delete{ error in
            if let error = error{
                print("error",error)
            }
        }
    }

    func sendPostData(comment: String, postImage: UIImage){
        guard let userName = UserDefaults.standard.object(forKey: "userNameKey") as? String, let profileImageString = UserDefaults.standard.object(forKey: "profileImageStringKey") as? String else{
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        guard let postImageData = postImage.jpegData(compressionQuality: 0.01) else{
            return
        }
        let imageRef = Storage.storage().reference().child("postImage").child("\(UUID().uuidString)")
                imageRef.putData(postImageData, metadata: nil) { metadata, error in
                    if let error = error{
                        print("error",error)
                        return
                    }
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            print("error",error)
                            return
                        }
                        // メソッド化する
                        self.sendPostData(userName: userName, comment: comment, profileImageString: profileImageString, uid: uid, postDataImageString: url!.absoluteString)
                    }
                }

    }

    // MARK: createUserのみ使用するメソッド
    private func signIn(){
        Auth.auth().signInAnonymously { result, error in
            if let error = error{
                print("signInAnoymouslyのerror",error)
                return
            }
        }
    }

    private func sendUserData(userName: String,profileImageString: String,uid: String){
        let userDB = db.collection("users").document("\(uid)")
        userDB.setData(["userName": userName,"profileImageString": profileImageString,"createTime": Timestamp(),"uid": uid,"postData": Date().timeIntervalSince1970]) { error in
            if let error = error {
                print("setDataのエラー",error)
            }
            print("Firestoreへのユーザ情報の保存完了")
        }
    }

    private func sendPostData(userName: String,comment: String,profileImageString: String,uid: String,postDataImageString: String){
        let postDB = self.db.collection("post").document()
        postDB.setData(["userRef": "/userRef/\(uid)","comment": comment,"postDataImageString": postDataImageString,"userName": userName,"userImageString": profileImageString,"createTime": Timestamp(),"postData": Date().timeIntervalSince1970]) { error in
            if let error = error {
                print("error",error)
                return
            }
            print("Firestoreに投稿データの保存完了")
        }
    }
}
