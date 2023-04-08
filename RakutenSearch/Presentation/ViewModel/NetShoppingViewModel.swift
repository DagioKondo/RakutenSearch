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
    var addToFavoritePublisher: AnyPublisher<Bool, Never> { get }
    var products:[Product] { get }
    func handleSearchButtonClicked(query: String?) async
    func handleDidSelectRowAt(_ indexPath: IndexPath)
    func addToFavorites(_ indexPath: IndexPath) async
}

final class NetShoppingViewModel {
    private let showWebViewSubject = PassthroughSubject<URL, Never>()
    private let onSearchButtonClickedSubject = PassthroughSubject<Void, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let addToFavoriteSubject = PassthroughSubject<Bool, Never>()
    private let productRepository: ProductRepository = RakutenProductRepository()
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
    
    var addToFavoritePublisher: AnyPublisher<Bool, Never> {
        return addToFavoriteSubject.eraseToAnyPublisher()
    }
    
//    convenience init() {
//        self.init(repository: RakutenProductRepository())
//    }
//
//    private init(repository: ProductRepository) {
//        productRepository = repository
//    }
}

extension NetShoppingViewModel: NetShoppingViewModelable {
    func handleSearchButtonClicked(query: String?) async {
        do {
            isLoadingSubject.send(true)
            guard let query = query else { return isLoadingSubject.send(false) }
            // ランキングAPIを叩く想定で並列処理にしている
            async let products = productRepository.fetchProduct(query: query).items
            self.products = try await products
            onSearchButtonClickedSubject.send()
            isLoadingSubject.send(false)
        } catch {
            guard let error = error as? RakutenAPIError else { return }
            isLoadingSubject.send(false)
            print(error) // アラート出す予定
        }
    }
    
    func handleDidSelectRowAt(_ indexPath: IndexPath) {
        let itemUrl = products[indexPath.row].item.urlString
        guard let url = URL(string: itemUrl) else { return }
        showWebViewSubject.send(url)
    }
    
    func addToFavorites(_ indexPath: IndexPath) async {
        do {
            if products[indexPath.row].item.favorite == true {
                let favoriteProduct = products[indexPath.row].item
                try await CoreDataFavoriteProductRepository.shared.delete(id: favoriteProduct.itemCode)
                products[indexPath.row].item.favorite = false
                addToFavoriteSubject.send(false)
            } else {
                products[indexPath.row].item.favorite = true
                let favoriteProduct = products[indexPath.row].item
                try await CoreDataFavoriteProductRepository.shared.insertFavoriteProduct(into: favoriteProduct)
                addToFavoriteSubject.send(true)
            }
        } catch {
            fatalError()
        }
        
    }
}
