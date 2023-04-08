//
//  Product.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/02.
//

import Foundation

struct Products: Codable {
    let items: [Product]
    
    enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}

struct Product: Codable {
    var item: ProductInfo
    
    enum CodingKeys: String, CodingKey {
        case item = "Item"
    }
}

struct ProductInfo: Codable {
    var itemCode: String
    var urlString: String
    var name: String
    var price: Int
    var imageUrls: [String]
    var reviewAverage: Double
    var favorite:Bool = false
    var favProductImage:String{
        switch self.favorite{
        case true: return "bookmark.fill"
        case false: return "bookmark"
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case itemCode = "itemCode"
        case urlString = "itemUrl"
        case name = "itemName"
        case price = "itemPrice"
        case imageUrls = "mediumImageUrls"
        case reviewAverage
    }
    enum AdditionalInfoKeys: String, CodingKey {
        case imageUrl
    }
}

extension ProductInfo {
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        var imageUrlsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .imageUrls)
        var imageUrls: [String] = []
        while !imageUrlsContainer.isAtEnd {
            // ネストした部分のCodingKeys（AdditionalInfoKeys）を指定し配列内のオブジェクト部分のコンテナを取得
            let imageUrlContainer = try imageUrlsContainer.nestedContainer(keyedBy: AdditionalInfoKeys.self)
            // JSONのキー"imageUrl"にあたる部分の値を取得
            let imageUrl = try imageUrlContainer.decode(String.self, forKey: .imageUrl)
            imageUrls.append(imageUrl)
        }
        self.imageUrls = imageUrls
        // 楽天APIはキーが見つからない場合がないのでdecodeIfPresentは使わない
        self.itemCode = try rootContainer.decode(String.self, forKey: .itemCode)
        self.urlString = try rootContainer.decode(String.self, forKey: .urlString)
        self.name = try rootContainer.decode(String.self, forKey: .name)
        self.price = try rootContainer.decode(Int.self, forKey: .price)
        self.reviewAverage = try rootContainer.decode(Double.self, forKey: .reviewAverage)
    }
}

// ↓レスポンスの形　productInfoのinitはmediumImageUrlsの階層をフラットにしてる。
//{
//  "Items": [
//    {
//      "Item": {
//        "itemName": "テスト商品",
//        "itemPrice": 1980,
//        "itemUrl": "https://item.rakuten.co.jp/aaaaaa/",
//        "mediumImageUrls": [
//          {
//            "imageUrl": "https://thumbnail.image.rakuten.co.jp/@0_mall/musashi-sangyo/cabinet/23222/23222-3_img01.jpg?_ex=128x128"
//          },
//          {
//            "imageUrl": "https://thumbnail.image.rakuten.co.jp/@0_mall/musashi-sangyo/cabinet/23222/23222-3_img02.jpg?_ex=128x128"
//          },
//          {
//            "imageUrl": "https://thumbnail.image.rakuten.co.jp/@0_mall/musashi-sangyo/cabinet/23222/23222-3_img03.jpg?_ex=128x128"
//          }
//        ],
//        "reviewAverage": 4.2,
//                                                  ・
//                                                  ・
//                                                  ・
//      },
//    },
//                                                    ・
//                                                    ・
//                                                    ・
//  ],
//    ↓は使ってないけどどれかもしかしたらどれか使うかも
//  "TagInformation": [],
//  "carrier": 0,
//  "count": 38888,
//  "first": 1,
//  "hits": 30,
//  "last": 30,
//  "page": 1,
//  "pageCount": 100
//}
