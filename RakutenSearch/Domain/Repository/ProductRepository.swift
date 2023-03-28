//
//  ProductRepository.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/05.
//

import Foundation
import Combine

// 商品を取得するリポジトリインターフェース
protocol ProductRepository {
    func fetchProduct(query: String) async throws -> Products
}
