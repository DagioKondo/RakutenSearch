//
//  APIUrl.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/05.
//

import Foundation

// これなんで構造体なの？
struct APIUrl {
    static let apikey = "1072027207911802205"
    static func RakutenProductAPI(query: String) -> URL {
        let encordeUrlString:String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?format=json&keyword=\(encordeUrlString)&applicationId=\(apikey)") else {return URL(fileURLWithPath: "")}
        return url
    }
}
