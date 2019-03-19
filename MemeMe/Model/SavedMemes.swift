//
//  SavedMemes.swift
//  MemeMe
//
//  Created by Epic Systems on 1/30/19.
//  Copyright © 2019 AhmedHazzaa. All rights reserved.
//

import Foundation

class SavedMemes {
    
    private init(){}
    
    static let shared = SavedMemes()
    
    var memes = [Meme]()
    
}
