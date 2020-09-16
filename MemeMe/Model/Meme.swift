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
        Data.shared.sentMemes
    }

    func save() {
        Data.shared.saveMeme(meme: self)
    }
}
