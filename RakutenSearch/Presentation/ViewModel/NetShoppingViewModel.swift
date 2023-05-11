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
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var addToFavoritePublisher: AnyPublisher<Bool, Never> { get }
    var productsPublisher: AnyPublisher<[Product], Never> { get }
    func onSearchButtonClicked(query: String?) async
    func didSelectRowAt(_ indexPath: IndexPath)
    func onFavoriteButtonClicked(_ indexPath: IndexPath) async
}

final class NetShoppingViewModel {
    private let showWebViewSubject = PassthroughSubject<URL, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let addToFavoriteSubject = PassthroughSubject<Bool, Never>()
    private let productsSubject: CurrentValueSubject<[Product], Never> = .init([])
    private let productRepository: ProductRepository = RakutenProductRepository()
    
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        return showWebViewSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
    }
    
    var addToFavoritePublisher: AnyPublisher<Bool, Never> {
        return addToFavoriteSubject.eraseToAnyPublisher()
    }
    
    var productsPublisher: AnyPublisher<[Product], Never> {
        return productsSubject.eraseToAnyPublisher()
    }
}

extension NetShoppingViewModel: NetShoppingViewModelable {
    func onSearchButtonClicked(query: String?) async {
        do {
            isLoadingSubject.send(true)
            guard let query = query else { return isLoadingSubject.send(false) }
//            let favoriteProducts = try await CoreDataFavoriteProductRepository.shared.getFavProducts()
            // ランキングAPIを叩く想定で並列処理にしている
            async let products = productRepository.fetchProduct(query: query)
            self.productsSubject.value = try await products
            print(self.productsSubject.value)
            isLoadingSubject.send(false)
        } catch {
            guard let error = error as? RakutenAPIError else { return }
            isLoadingSubject.send(false)
            print(error) // アラート出す予定
        }
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        let itemUrl = productsSubject.value[indexPath.row].item.urlString
        guard let url = URL(string: itemUrl) else { return }
        showWebViewSubject.send(url)
    }
    
    func onFavoriteButtonClicked(_ indexPath: IndexPath) async {
        do {
            if productsSubject.value[indexPath.row].item.favorite == true {
                let favoriteProduct = productsSubject.value[indexPath.row]
//                try await CoreDataFavoriteProductRepository.shared.delete(id: favoriteProduct.itemCode)
                productsSubject.value[indexPath.row].item.favorite = false
                addToFavoriteSubject.send(false)
            } else {
                productsSubject.value[indexPath.row].item.favorite = true
                let favoriteProduct = productsSubject.value[indexPath.row]
                try await CoreDataFavoriteProductRepository.shared.insertFavoriteProduct(into: favoriteProduct)
                addToFavoriteSubject.send(true)
            }
        } catch {
            fatalError()
        }
        
    }
}
