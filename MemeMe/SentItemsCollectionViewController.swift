//
//  SentItemsCollectionViewController.swift
//  MemeMe
//
//  Created by Matthias Buehl on 9/7/20.
//  Copyright © 2020 Matthias Buehl. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentItemsCollectionViewCell"

class SentItemsCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("collection view will appear")
        navigationController?.navigationBar.isHidden = false
        collectionView.reloadData()
    }

    func setupNav() {
        self.navigationItem.title = "Sent Memes Grid"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addMeme))
    }
    
    func setupFlowLayout() {
        let space:CGFloat = 2.0
        let width = (view.frame.size.width - (2 * space)) / 2.0
        let height = (view.frame.size.height - (2 * space)) / 2.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height:height)
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    @objc func addMeme() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.sentMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentItemsCollectionViewCell
        
        let meme = Meme.sentMemes[indexPath.row]
        cell.imageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = Meme.sentMemes[indexPath.row]
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
