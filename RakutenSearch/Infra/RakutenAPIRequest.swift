//
//  RakutenAPIRequest.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/14.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
}

enum RakutenAPIUrl: String {
    case rakutenProductSearchAPI = "/Search/20170706"
}

protocol RakutenAPIBaseRequest {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
//    var body: String { get }
    var queryItems: [URLQueryItem] { get }
    
    func buildURLRequest() -> URLRequest
}

extension RakutenAPIBaseRequest {
    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        switch method {
        case .get:
            components?.queryItems = queryItems
        default:
            fatalError()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }
}

// 楽天市場APIのリクエスト
struct RakutenAPIRequest<ResponseDataType: Codable>: RakutenAPIBaseRequest {
    typealias Response = ResponseDataType

    private let baseURLString: String = "https://app.rakuten.co.jp/services/api/IchibaItem"
    var baseURL: URL
    var path: String = ""
    var method: HTTPMethod
//    var body: String = ""
    var queryItems: [URLQueryItem]

    init(path: String, method: HTTPMethod, queryItems: [URLQueryItem]) {
        self.baseURL = URL(string: self.baseURLString)!
        self.path += "\(path)"
        self.method = method
        self.queryItems = queryItems
    }
}
