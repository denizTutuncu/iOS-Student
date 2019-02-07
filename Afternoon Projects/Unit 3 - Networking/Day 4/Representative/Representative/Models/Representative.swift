//
//  Representative.swift
//  Representative
//
//  Created by Deniz Tutuncu on 2/7/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct TopLevelJSON: Codable {
    let results: [Representative]
}

struct Representative: Codable {
    var name: String
    var party: String
    var state: String?
    var district: String
    var phone: String
    var office: String
    var link: String
}
