//
//  Data.swift
//  MemeMe
//
//  Created by Matthias Buehl on 9/15/20.
//  Copyright © 2020 Matthias Buehl. All rights reserved.
//

import Foundation

class Data {
    static let shared: Data = {
        let instance = Data()
        return instance
    }()

    var memes = [Meme]()
    var sentMemes: [Meme] {
        memes
    }

    func saveMeme(meme: Meme) {
        memes.append(meme)
    }
}
