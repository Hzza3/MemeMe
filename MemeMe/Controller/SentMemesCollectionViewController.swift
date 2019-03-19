//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Epic Systems on 1/20/19.
//  Copyright © 2019 AhmedHazzaa. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController {

   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        return SavedMemes.shared.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sent Memes"

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        self.navigationItem.rightBarButtonItem = addButton
        
        setupCollectionViewFlowLayout(flowLayout: self.flowLayout, space: 3.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }
    
    
    @objc func addMeme() {
        let dvc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(dvc, animated: true, completion: nil)
    }

    func setupCollectionViewFlowLayout(flowLayout: UICollectionViewFlowLayout, space: CGFloat) {
        
        let dimension = (view.frame.size.width - (2.0 * space)) / space
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

}

extension SentMemesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.memedImage = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }

}
