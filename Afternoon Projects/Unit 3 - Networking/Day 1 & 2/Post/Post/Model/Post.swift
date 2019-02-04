//
//  Post.swift
//  Post
//
//  Created by Deniz Tutuncu on 2/4/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct Post: Codable {
    let text: String
    let timestamp: Date
    let username: String
}

let postOne = Post(text: "A post", timestamp: Date(), username: "Deniz")
