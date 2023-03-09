//
//  RakutenAPIProductRepository.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/05.
//

import Foundation
import Network

// これなんで構造体なの？
struct RakutenProductRepository: ProductRepository {
    let apiClient = APIClient<Products>()
    
    func fetchProduct(query: String) async throws -> Products {
        let products = try await apiClient.fetch(query: query)
        return products
    }
}
