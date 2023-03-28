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
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var products:[Product] { get }
    func fetch(query: String?) async
    func handleDidSelectRowAt(_ indexPath: IndexPath)
}

final class NetShoppingViewModel {
    private let showWebViewSubject = PassthroughSubject<URL, Never>()
    private let onSearchButtonClickedSubject = PassthroughSubject<Void, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    var products:[Product] = []
    
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        return showWebViewSubject.eraseToAnyPublisher()
    }
    
    var onSearchButtonClickedPublisher: AnyPublisher<Void, Never> {
        return onSearchButtonClickedSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
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
        isLoadingSubject.send(false)
    }
}

extension NetShoppingViewModel: NetShoppingViewModelable {
    func fetch(query: String?) async {
        do {
            isLoadingSubject.send(true)
            guard let query = query else { return }
            async let list = productRepository.fetchProduct(query: query).items
            setupList(try await list)
        } catch {
            guard let error = error as? RakutenAPIError else { return }
            print(error) // アラート出す予定
        }
    }
    
    func handleDidSelectRowAt(_ indexPath: IndexPath) {
        let itemUrl = products[indexPath.row].item.urlString
        guard let url = URL(string: itemUrl) else { return }
        showWebViewSubject.send(url)
    }
}
