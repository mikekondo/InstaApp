//
//  PostViewController.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/24.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    var selectedImage = UIImage()
    let sendDB = SendDB()

    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.image = selectedImage
    }

    @IBAction func didTapPostButton(_ sender: Any) {
        guard let comment = commentTextView.text, let postImage = postImageView.image else{
            return
        }
        sendDB.sendPostData(comment: comment, postImage: postImage)
        self.navigationController?.popViewController(animated: true)
        
    }

}
