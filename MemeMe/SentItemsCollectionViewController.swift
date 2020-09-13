//
//  SentItemsCollectionViewController.swift
//  MemeMe
//
//  Created by Matthias Buehl on 9/7/20.
//  Copyright © 2020 Matthias Buehl. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class SentItemsCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupFlowLayout()
    }
    
    func setupNav() {
        self.navigationItem.title = "Sent Memes Grid"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addMeme))
    }
    
    func setupFlowLayout() {
        let space:CGFloat = 2.0
        let width = (view.frame.size.width - (2 * space)) / 5.0
        let height = (view.frame.size.height - (2 * space)) / 5.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: 10.0, height: 10.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("collection view will appear")
        collectionView.reloadData()
    }
    
    @objc func addMeme() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        vc.hidesBottomBarWhenPushed = true
//        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.sentMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentItemsCollectionViewCell
        
        let meme = Meme.sentMemes[indexPath.row]
        cell.imageView.image = meme.memedImage
        
        return cell
    }
}

//extension SentItemsCollectionViewController: Sharing {
//    func afterSharing() {
//        self.collectionView.reloadData()
//    }
//}
