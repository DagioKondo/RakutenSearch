//
//  FavoritesViewModel.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/04/13.
//

import Foundation
import Combine


protocol FavoritesViewModelable {
    var showWebViewPublisher: AnyPublisher<URL, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var favoriteProductsPublisher: AnyPublisher<Void, Never> { get }
    var favoriteProducts: [FavProduct] { get }
    func willAppear() async
    func didSelectRowAt(_ indexPath: IndexPath)
    func deleteProduct(_ indexPath: IndexPath) async
}

final class FavoritesViewModel {
    private let showWebViewSubject = PassthroughSubject<URL, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let favoriteProductsSubject = PassthroughSubject<Void, Never>()
    var favoriteProducts: [FavProduct] = []
    
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        return showWebViewSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
    }
    
    var favoriteProductsPublisher: AnyPublisher<Void, Never> {
        return favoriteProductsSubject.eraseToAnyPublisher()
    }
}

extension FavoritesViewModel: FavoritesViewModelable {
    func willAppear() async {
        do {
            isLoadingSubject.send(true)
            favoriteProducts = try await CoreDataFavoriteProductRepository.shared.getFavProducts()
            favoriteProductsSubject.send()
            isLoadingSubject.send(false)
        } catch {
            guard let error = error as? RakutenAPIError else { return }
            isLoadingSubject.send(false)
            print(error) // アラート出す予定
        }
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        guard let itemUrl = favoriteProducts[indexPath.row].urlString,
        let url = URL(string: itemUrl) else { return }
        showWebViewSubject.send(url)
    }
    
    func deleteProduct(_ indexPath: IndexPath) async {
        do {
            guard let itemCode = favoriteProducts[indexPath.row].itemCode else { return }
            favoriteProducts.remove(at: indexPath.row)
            try await CoreDataFavoriteProductRepository.shared.delete(id: itemCode)
            favoriteProductsSubject.send()
        } catch {
            print(error)
        }
    }
}
