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
    var onSearchButtonClickedPublisher: AnyPublisher<Void, Never> { get }
    var products:[Product] { get }
    func fetch(query: String?) async
    func handleDidSelectRowAt(_ indexPath: IndexPath)
}

final class NetShoppingViewModel {
    private var showWebViewSubject = PassthroughSubject<URL, Never>()
    private var onSearchButtonClickedSubject = PassthroughSubject<Void, Never>()
    var products:[Product] = []
    
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        return showWebViewSubject.eraseToAnyPublisher()
    }
    
    var onSearchButtonClickedPublisher: AnyPublisher<Void, Never> {
        return onSearchButtonClickedSubject.eraseToAnyPublisher()
    }
    
    private let productRepository: ProductRepository
    
    convenience init() {
        self.init(repository: RakutenProductRepository())
    }
    
    private init(repository: ProductRepository) {
        productRepository = repository
    }

    private func setupList(_ list: [Product]) {
        products = list
        onSearchButtonClickedSubject.send()
    }
}

extension NetShoppingViewModel: NetShoppingViewModelable {
    func fetch(query: String?) async {
        do {
            guard let query = query else { return }
            async let list = productRepository.fetchProduct(query: query).Items
            self.setupList(try await list!)
        } catch let error {
            guard let error = error as? APIError else { return }
            print(error) // アラート出す予定
        }
    }
    
    func handleDidSelectRowAt(_ indexPath: IndexPath) {
        guard let itemUrl = products[indexPath.row].Item?.itemUrl else { return }
        guard let url = URL(string: itemUrl) else { return }
        showWebViewSubject.send(url)
    }
}
