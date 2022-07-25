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
    let sendDB = SendDB()

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.circleTrim()
        let checkModel = CheckModel()
        checkModel.showCheckPermission()

    }

    @IBAction func didTapSetImageView(_ sender: Any) {
        showAlert()
    }

    @IBAction func didTapCreateUser(_ sender: Any) {
        if let userName = userNameTextField.text,let userImage = userImageView.image{
            sendDB.createUser(userName: userName, profileImage: userImage)
        }
    }

    @IBAction private func didTapLogoutButton(_ sender: Any) {
        sendDB.signOut()
        userNameTextField.text = ""
        userImageView.image = UIImage(named: "noImage")
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
