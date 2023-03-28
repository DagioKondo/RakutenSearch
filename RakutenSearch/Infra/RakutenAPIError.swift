//
//  APIError.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/05.
//

import Foundation

enum RakutenAPIError: Error {
    case customError(message: String)
    case parameterError
    case notFoundError
    case tooManyRequestsError
    case sistemError
    case maintenanceError
    case networkError
    case unknownError

    var message: String {
        switch self {
        case .customError(let message):
            return message
        case .parameterError:
            return "入力値が正しくありません。"
        case .notFoundError:
            return "対象のデータが存在しません。"
        case .tooManyRequestsError:
            return "リクエスト数が上限に達しました。しばらく時間を空けてから、ご利用ください。"
        case .sistemError:
            return "不具合が発生しました。お手数ですが時間をおいてもう一度お試しください。"
        case .maintenanceError:
            return "メンテナンス中です。終了までしばらくお待ちください。"
        case .networkError:
            return "通信エラーが発生しました。電波の良い所で再度お試しください。"
        default:
            return "不具合が発生しました。お手数ですが時間をおいてもう一度お試しください。"
        }
    }
}
