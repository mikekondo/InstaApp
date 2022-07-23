//
//  ViewController.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/23.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameTextField: UITextField!

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = userImageView.frame.width*0.5
        let checkModel = CheckModel()
        checkModel.showCheckPermission()

    }

    @IBAction func didTapSetImageView(_ sender: Any) {
        showAlert()
    }

    @IBAction func didTapCreateUser(_ sender: Any) {
        let userName = userNameTextField.text ?? ""
        var profileImageString = ""
        Auth.auth().signInAnonymously { result, error in
            if let error = error{
                print("signInAnoymouslyのerror",error)
                return
            }
        }
        // Firestoreにユーザ情報を保存
        let uid = Auth.auth().currentUser?.uid
        guard let uid = uid else{
            return
        }
        let usersDB = db.collection("users").document("\(uid)")
        let profileImageData = userImageView.image?.jpegData(compressionQuality: 0.01)
        guard let profileImageData = profileImageData else {
            return
        }

        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString)")
        imageRef.putData(profileImageData, metadata: nil) { metadata, error in
            if let error = error {
                print("putDataのエラー",error)
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("downloadURLのエラー",error)
                }
                profileImageString = url!.absoluteString
                // プロフィール画像と名前を保存
                UserDefaults.standard.setValue(userName, forKey: "userNameKey")
                UserDefaults.standard.setValue(profileImageString, forKey: "profileImageKey")
                usersDB.setData(["userName" : userName,"profileImageString" : profileImageString,"createTime": Timestamp(),"uid":uid,"postData":Date().timeIntervalSince1970]) { error in
                    if let error = error{
                        print("setDataのエラー",error)
                    }
                    print("Firestoreへのユーザ情報の保存完了")
                }
            }
        }
        // 画面遷移
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        self.present(homeVC, animated: true, completion: nil)

    }

    func doCamera(){
        let sourceType: UIImagePickerController.SourceType = .camera
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }

    func showAlert(){
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.doAlbum()
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }

    func doAlbum(){
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] as? UIImage != nil{
            let selectedImage = info[.originalImage] as! UIImage
            // アルバムで選択したImageをuserImageViewに反映する
            userImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }

}
