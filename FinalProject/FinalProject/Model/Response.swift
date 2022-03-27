//
//  Response.swift
//  FinalProject
//
//  Created by Maria Andreea on 14.03.2022.
//

import Foundation

struct Response : Codable {
    let status : String
    var products : [Product]
}
