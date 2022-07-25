//
//  ProfileViewController.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/23.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postCountLabel: UILabel!
    var loadDB = LoadDB()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        postCountLabel.text = "投稿 \(loadDB.postDataSets.count)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserView()
        loadDB.fetchMyPostData()
    }

    private func setupDelegate(){
        collectionView.dataSource = self
        collectionView.delegate = self
        loadDB.delegate = self
    }

    private func setupUserView(){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        loadDB.fetchUserFromFirestore(uid: uid) { user in
            guard let user = user else {
                print("ユーザの情報が取得できませんでした")
                return
            }
            print("ユーザの情報を取得しました")
            self.userNameLabel.text = user.userName
            self.userImageView.sd_setImage(with: URL(string: user.profileImageString))
            self.userImageView.circleTrim()
        }
    }

    func doAlbum(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary

        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }

    @IBAction func didTapPostButton(_ sender: Any) {
        doAlbum()
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if info[.originalImage] as? UIImage != nil{

            let selectedImage = info[.originalImage] as! UIImage
            //値を渡しながら画面遷移
            let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
            postVC.selectedImage = selectedImage
            picker.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(postVC, animated: true)
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadDB.postDataSets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)

        let contentImageView = cell.contentView.viewWithTag(1) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: loadDB.postDataSets[indexPath.row].postDataImageString))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/3.2
        let height = width
        return CGSize(width: width, height: height)
    }
}

extension ProfileViewController: loadDoneDelegate{
    func loadOK(judge: Bool) {
        if judge == true{
            collectionView.reloadData()
            postCountLabel.text = "投稿 \(loadDB.postDataSets.count)"
        }
    }
}
