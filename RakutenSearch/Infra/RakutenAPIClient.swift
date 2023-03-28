//
//  APIClient.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/09.
//

import Foundation
import Network

protocol RakutenAPIClientable {
    func fetch<Request: RakutenAPIBaseRequest>(request: Request) async throws -> Request.Response
}

final class RakutenAPIClient: RakutenAPIClientable {
    static var networkStatus: NWPath.Status = .satisfied
    
    func fetch<Request: RakutenAPIBaseRequest>(request: Request) async throws -> Request.Response {
        guard RakutenAPIClient.networkStatus == .satisfied else {
            throw RakutenAPIError.networkError
        }
        let (data, response) = try await URLSession.shared.data(for: request.buildURLRequest())
        try responseErrorHandling(response: response as! HTTPURLResponse)
        print("RakutenAPIClient.fetch")
        print(try JSONDecoder().decode(Request.Response.self, from: data))
        return try JSONDecoder().decode(Request.Response.self, from: data)
    }
    
    private func responseErrorHandling(response: HTTPURLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RakutenAPIError.unknownError
        }
        switch httpResponse.statusCode {
        case 200:
            return
        case 400:
            throw RakutenAPIError.parameterError
        case 404:
            throw RakutenAPIError.notFoundError
        case 429:
            throw RakutenAPIError.tooManyRequestsError
        case 500:
            throw RakutenAPIError.sistemError
        case 503:
            throw RakutenAPIError.maintenanceError
        default:
            throw RakutenAPIError.unknownError
        }
    }
}

