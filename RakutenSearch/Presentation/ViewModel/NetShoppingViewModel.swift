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
    var productsPublisher: AnyPublisher<Void, Never> { get }
    var couponsPublisher: AnyPublisher<Void, Never> { get }
    var products: [Product] { get }
    var coupons: [Coupon] { get }
    func onSearchButtonClicked(keyword: String?) async
    func didSelectRowAt(_ indexPath: IndexPath)
    func onFavoriteButtonClicked(_ indexPath: IndexPath) async
    func didScrollToBottom() async
}

final class NetShoppingViewModel {
    private let showWebViewSubject = PassthroughSubject<URL, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let addToFavoriteSubject = PassthroughSubject<Void, Never>()
    private let productsSubject = PassthroughSubject<Void, Never>()
    private let couponsSubject = PassthroughSubject<Void, Never>()
    private let productRepository: ProductRepository = RakutenProductRepository()
    private var scrollsToBottom = 0 // 一番下までスクロールした回数をカウントするための変数
    private var query = RakutenAPIQuery()
    var products: [Product] = []
    var coupons: [Coupon] = []
    
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        return showWebViewSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
    }
    
    var addToFavoritePublisher: AnyPublisher<Void, Never> {
        return addToFavoriteSubject.eraseToAnyPublisher()
    }
    
    var productsPublisher: AnyPublisher<Void, Never> {
        return productsSubject.eraseToAnyPublisher()
    }
    
    var couponsPublisher: AnyPublisher<Void, Never> {
        return couponsSubject.eraseToAnyPublisher()
    }
}

extension NetShoppingViewModel: NetShoppingViewModelable {
    func onSearchButtonClicked(keyword: String?) async {
        do {
            isLoadingSubject.send(true)
            guard let keyword = keyword else { return isLoadingSubject.send(false) }
            async let coupons = fetchCoupons()
            async let products = fetchProducts(keyword: keyword)
            self.coupons = try await coupons
            self.products = try await products
            couponsSubject.send()
            productsSubject.send()
            isLoadingSubject.send(false)
        } catch {
            guard let error = error as? RakutenAPIError else { return }
            isLoadingSubject.send(false)
            print(error) // アラート出す予定
        }
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        let itemUrl = products[indexPath.row].item.urlString
        guard let url = URL(string: itemUrl) else { return }
        showWebViewSubject.send(url)
    }
    
    func didScrollToBottom() async {
        do {
            scrollsToBottom += 1
            query.page = String(scrollsToBottom)
            let productsToAdd = try await productRepository.fetchProducts(query: query)
            products.append(contentsOf: productsToAdd)
            productsSubject.send()
        } catch {
            print(error)
        }
    }
    
    func onFavoriteButtonClicked(_ indexPath: IndexPath) async {
        do {
            let favoriteProduct = products[indexPath.row]
            try await CoreDataFavoriteProductRepository.shared.insertFavoriteProduct(into: favoriteProduct)
            addToFavoriteSubject.send()
        } catch {
            fatalError()
        }
    }
    
    private func fetchProducts(keyword: String) async throws -> [Product] {
        products = []
        query.keyword = keyword
        query.page = "1"
        scrollsToBottom = 1
        return try await productRepository.fetchProducts(query: query)
    }
    
    private func fetchCoupons() async throws -> [Coupon] {
        return try await productRepository.fetchCoupons()
    }
}
