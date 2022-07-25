//
//  HomeViewController.swift
//  InstaApp
//
//  Created by 近藤米功 on 2022/07/23.
//

import UIKit
import SDWebImage

class TimeLineViewController: UIViewController {
    var loadDB = LoadDB()
    var postDatas = [Post]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TLCell")
        loadDB.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        loadDB.fetchPostData()
    }
}

extension TimeLineViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadDB.postDataSets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLCell", for: indexPath) as! TimeLineTableViewCell
        cell.userNameLabel.text = loadDB.postDataSets[indexPath.row].userName
        cell.userImageView.sd_setImage(with: URL(string: loadDB.postDataSets[indexPath.row].userImageString))
        cell.postDataImageView.sd_setImage(with: URL(string: loadDB.postDataSets[indexPath.row].postDataImageString))
        cell.commentTextView.text = loadDB.postDataSets[indexPath.row].comment
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}

extension TimeLineViewController: loadDoneDelegate{
    func loadOK(judge: Bool) {
        if judge == true{
            tableView.reloadData()
        }
    }
}
