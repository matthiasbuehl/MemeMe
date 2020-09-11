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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sent Memes Grid"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addMeme))
    }

    @objc func addMeme() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        
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

extension SentItemsCollectionViewController: Sharing {
    func afterSharing() {
        self.collectionView.reloadData()
    }
}
