//
//  ProfileViewController.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/23.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postCountLabel: UILabel!
    var loadDB = LoadDB()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserView()
        loadDB.loadMyPostData()
    }

    private func setupDelegate(){
        collectionView.dataSource = self
        collectionView.delegate = self
        loadDB.delegate = self
    }

    private func setupUserView(){
        userNameLabel.text = UserDefaults.standard.object(forKey: "userNameKey") as! String
        let profileImageString = UserDefaults.standard.object(forKey: "profileImageStringKey") as! String
        userImageView.sd_setImage(with: URL(string: profileImageString))
        userImageView.circleTrim()
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
