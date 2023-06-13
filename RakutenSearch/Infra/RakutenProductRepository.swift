//
//  RakutenAPIProductRepository.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/05.
//

import Foundation
import Network

// 楽天市場APIから商品を取得するリポジトリ実装クラス
struct RakutenProductRepository: ProductRepository {
    private let apiClient = RakutenAPIClient()
    
    // 楽天市場APIから商品検索
    func fetchProducts(query: RakutenAPIQuery) async throws -> [Product] {
//        httpリクエスト作成
        let urlQueryItems = [
            URLQueryItem(name: "keyword", value: query.keyword),
            URLQueryItem(name: "page", value: query.page),
            URLQueryItem(name: "sort", value: query.sort)
        ]
        let rakutenProductAPIRequest: RakutenAPIRequest<Products> = try RakutenAPIRequest(path: RakutenAPIUrl.rakutenProductSearchAPI.rawValue, method: .get, queryItems: urlQueryItems)
        let products = try await apiClient.fetch(request: rakutenProductAPIRequest).items
        return products
    }
    
    func fetchCoupons() async throws -> [Coupon] {
        let coupons = CouponStub().data
        return coupons
    }
}

