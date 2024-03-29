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
    func fetchProducts(query: RakutenAPIQuery) async throws -> [Product]
    func fetchCoupons() async throws -> [Coupon]
}
