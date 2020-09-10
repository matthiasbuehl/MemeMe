//
//  Meme.swift
//  MemeMe
//
//  Created by Matthias Buehl on 8/29/20.
//  Copyright © 2020 Matthias Buehl. All rights reserved.
//

import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
}

extension Meme {
    static var sentMemes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(self)
    }
}
