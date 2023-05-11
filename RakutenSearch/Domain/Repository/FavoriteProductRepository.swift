//
//  FavoriteProductRepository.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/28.
//

import Foundation
import Combine

// 商品を取得するリポジトリインターフェース
protocol FavoriteProductRepository {
    func insertFavoriteProduct(into: Product) async throws
    func getFavProducts() async throws -> [FavProduct]
    func delete(id: String) async throws
}
