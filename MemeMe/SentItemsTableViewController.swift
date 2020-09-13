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
        self.navigationItem.title = "Sent Memes Grid"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("table view will appear")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let meme = Meme.sentMemes[indexPath.row]
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage

        return cell
    }
}
