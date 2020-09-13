//
//  SentItemsTableViewController.swift
//  MemeMe
//
//  Created by Matthias Buehl on 9/7/20.
//  Copyright © 2020 Matthias Buehl. All rights reserved.
//

import UIKit

class SentItemsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sent Memes Table"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("table view will appear")
        navigationController?.navigationBar.isHidden = false
        tableView.reloadData()
    }

    @objc func addMeme() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.sentMemes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentItemsTableViewCell") as! SentItemsTableViewCell
        let meme = Meme.sentMemes[indexPath.row]
        cell.memeLabel?.textAlignment = .center
        cell.memeLabel?.text = meme.topText
        cell.memeImage?.image = meme.memedImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = Meme.sentMemes[indexPath.row]
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
