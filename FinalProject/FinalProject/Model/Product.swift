//
//  Product.swift
//  FinalProject
//
//  Created by Maria Andreea on 11.03.2022.
//

import Foundation


struct Product : Codable {
    let tags: [String]
    let title: String
    let image: String
    let description : String
    let date : Int

}
