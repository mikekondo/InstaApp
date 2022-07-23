//
//  LoginViewController.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapImage(_ sender: Any) {

    }
    @IBAction func didTapCreateUserButton(_ sender: Any) {

    }
}

extension LoginViewController: UIImagePickerControllerDelegate{
    
}
