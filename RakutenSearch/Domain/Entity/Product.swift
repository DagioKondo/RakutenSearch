//
//  Product.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/02.
//

import Foundation

struct Products: Codable {
    let Items: [Product]?
}

struct Product: Codable {
    let Item: ProductInfo?
}

struct ProductInfo: Codable {
    let itemUrl:String?
    let itemName:String?
    let itemPrice:Int?
    let mediumImageUrls:[ImageUrl]?
    let reviewAverage:Double?
}

struct ImageUrl: Codable{
    let imageUrl: String?
}
