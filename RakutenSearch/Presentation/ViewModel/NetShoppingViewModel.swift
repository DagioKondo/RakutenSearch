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
    var addToFavoritePublisher: AnyPublisher<Void, Never> { get }
    var productsPublisher: AnyPublisher<[Product], Never> { get }
    func onSearchButtonClicked(keyword: String?) async
    func didSelectRowAt(_ indexPath: IndexPath)
    func onFavoriteButtonClicked(_ indexPath: IndexPath) async
    func didScrollToBottom() async
}

final class NetShoppingViewModel {
    private let showWebViewSubject = PassthroughSubject<URL, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let addToFavoriteSubject = PassthroughSubject<Void, Never>()
    private let productsSubject: CurrentValueSubject<[Product], Never> = .init([])
    private let productRepository: ProductRepository = RakutenProductRepository()
    private var scrollsToBottom = 0 // 一番下までスクロールした回数をカウントするための変数
    private var query = RakutenAPIQuery()
    
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        return showWebViewSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
    }
    
    var addToFavoritePublisher: AnyPublisher<Void, Never> {
        return addToFavoriteSubject.eraseToAnyPublisher()
    }
    
    var productsPublisher: AnyPublisher<[Product], Never> {
        return productsSubject.eraseToAnyPublisher()
    }
}

extension NetShoppingViewModel: NetShoppingViewModelable {
    func onSearchButtonClicked(keyword: String?) async {
        do {
            isLoadingSubject.send(true)
            guard let keyword = keyword else { return isLoadingSubject.send(false) }
            self.productsSubject.value = []
            query.keyword = keyword
            query.page = "1"
            scrollsToBottom = 1
            // ランキングAPIを叩く想定で並列処理にしている
            async let products = productRepository.fetchProduct(query: query)
            self.productsSubject.value = try await products
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
    
    func didScrollToBottom() async {
        do {
            scrollsToBottom += 1
            query.page = String(scrollsToBottom)
            let productsToAdd = try await productRepository.fetchProduct(query: query)
            self.productsSubject.value.append(contentsOf: productsToAdd)
        } catch {
            print(error)
        }
    }
    
    func onFavoriteButtonClicked(_ indexPath: IndexPath) async {
        do {
            let favoriteProduct = productsSubject.value[indexPath.row]
            try await CoreDataFavoriteProductRepository.shared.insertFavoriteProduct(into: favoriteProduct)
            addToFavoriteSubject.send()
        } catch {
            fatalError()
        }
        
    }
}
