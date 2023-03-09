//
//  APIClient.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/09.
//

import Foundation
import Network

protocol APIClientable {
    associatedtype ResponseData
    func fetch(query: String) async throws -> ResponseData
}

final class APIClient<ResponseDataType: Codable>: APIClientable {
    typealias ResponseData = ResponseDataType
        
    func fetch(query: String) async throws -> ResponseData {
        guard NetworkStatus.status == .satisfied else {
                    throw APIError.networkError
                }
        let url = APIUrl.RakutenProductAPI(query: query)
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknownError
                }
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(ResponseData.self, from: data)
        case 401:
            throw APIError.unauthorizedError
        case 503:
            throw APIError.maintenanceError
        default:
            throw APIError.unknownError
        }
    }
}

final class NetworkStatus {
    public static var status: NWPath.Status = .satisfied
}
