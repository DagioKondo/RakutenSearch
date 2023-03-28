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
    func fetchProduct(query: String) async throws -> Products {
//        httpリクエスト作成
        let urlQueryItems = [
//            URLQueryItem(name: "format", value: "json"),
//            URLQueryItem(name: "applicationId", value: "1072027207911802205"),
            URLQueryItem(name: "keyword", value: query),
            
            // 付け足すかも
        ]
        let rakutenProductAPIRequest: RakutenAPIRequest<Products> = try RakutenAPIRequest(path: RakutenAPIUrl.rakutenProductSearchAPI.rawValue, method: .get, queryItems: urlQueryItems)
        let products = try await apiClient.fetch(request: rakutenProductAPIRequest)
        return products
    }
}


