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

// サービス固有の入力パラメーターの構造体
struct RakutenAPIQuery {
    var keyword: String = ""
    var page: String = "1"
    var sort: String = "standard"
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
//        urlRequest.url = URL(string: "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601?format=json&keyword=%E3%82%8A%E3%82%93%E3%81%94&formatVersion=2&applicationId=1072027207911802205")
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

    init (path: String, method: HTTPMethod, queryItems: [URLQueryItem]) throws {
        guard let url = URL(string: self.baseURLString) else { throw RakutenAPIError.unknownError }
        self.baseURL = url
        self.path += "\(path)"
        self.method = method
        self.queryItems = queryItems
        self.queryItems.append(URLQueryItem(name: "format", value: "json"))
//        self.queryItems.append(URLQueryItem(name: "formatVersion", value: "2"))
        self.queryItems.append(URLQueryItem(name: "applicationId", value: "1072027207911802205"))
    }
}
