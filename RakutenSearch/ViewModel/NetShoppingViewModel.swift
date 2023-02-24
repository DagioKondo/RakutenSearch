//
//  NetShoppingViewModel.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/02/21.
//

import Foundation
import Combine


protocol NetShoppingViewModelable {
    var showWebViewPublisher: AnyPublisher<URL, Never> { get }
    func fetch(query: String?) async
    func handleDidSelectRowAt(_ indexPath: IndexPath)
}

final class NetShoppingViewModel {
    private var showWebViewSubject = PassthroughSubject<URL, Never>()
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        showWebViewSubject.eraseToAnyPublisher()
    }
}

extension NetShoppingViewModel: NetShoppingViewModelable {
    func fetch(query: String?) async {
        
    }
    
    func handleDidSelectRowAt(_ indexPath: IndexPath) {
//        let item = listSubject.value[indexPath.row]
//        guard let url = URL(string: item.htmlUrl) else { return }
        guard let url = URL(string: "https://www.google.com/?hl=ja") else {return} // ダミーURL
        showWebViewSubject.send(url)
    }
}
