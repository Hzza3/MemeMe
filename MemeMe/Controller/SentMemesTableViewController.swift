//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Epic Systems on 1/20/19.
//  Copyright © 2019 AhmedHazzaa. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController {
    
    @IBOutlet weak var memesTableView: UITableView!
    
    var memes: [Meme]! {
        return SavedMemes.shared.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sent Memes"
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        self.navigationItem.leftBarButtonItem = editButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        self.navigationItem.rightBarButtonItem = addButton
        
        memesTableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memesTableView.reloadData()
    }
    
    
    @objc func editTapped() {
        
    }
    
    @objc func addMeme() {
        let dvc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(dvc, animated: true, completion: nil)
    }
}

extension SentMemesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = memesTableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        
        cell.memeImageView.image = memes[indexPath.row].memedImage
        let title = memes[indexPath.row].topText + " .. " + memes[indexPath.row].buttomText
        cell.memeLabel.text = title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.memedImage = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
}
