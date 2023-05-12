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
//    var addToFavoritePublisher: AnyPublisher<Bool, Never> { get }
    var favoriteProductsPublisher: AnyPublisher<[FavProduct], Never> { get }
    func willAppear() async
    func didSelectRowAt(_ indexPath: IndexPath)
    func deleteProduct(_ indexPath: IndexPath) async
}

final class FavoritesViewModel {
    private let showWebViewSubject = PassthroughSubject<URL, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
//    private let addToFavoriteSubject = PassthroughSubject<Bool, Never>()
    private let favoriteProductsSubject: CurrentValueSubject<[FavProduct], Never> = .init([])
    
    var showWebViewPublisher: AnyPublisher<URL, Never> {
        return showWebViewSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
    }
    
//    var addToFavoritePublisher: AnyPublisher<Bool, Never> {
//        return addToFavoriteSubject.eraseToAnyPublisher()
//    }
//
    
    var favoriteProductsPublisher: AnyPublisher<[FavProduct], Never> {
        return favoriteProductsSubject.eraseToAnyPublisher()
    }
}

extension FavoritesViewModel: FavoritesViewModelable {
    func willAppear() async {
        do {
            isLoadingSubject.send(true)
            favoriteProductsSubject.value = try await CoreDataFavoriteProductRepository.shared.getFavProducts()
            print(favoriteProductsSubject.value.forEach({ FavProduct in
                print(FavProduct.name)
                print(FavProduct.itemCode)
            }))
            isLoadingSubject.send(false)
        } catch {
            guard let error = error as? RakutenAPIError else { return }
            isLoadingSubject.send(false)
            print(error) // アラート出す予定
        }
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        guard let itemUrl = favoriteProductsSubject.value[indexPath.row].urlString,
        let url = URL(string: itemUrl) else { return }
        showWebViewSubject.send(url)
    }
    
    func deleteProduct(_ indexPath: IndexPath) async {
        print(favoriteProductsSubject.value[indexPath.row].itemCode)
        do {
            guard let itemCode = favoriteProductsSubject.value[indexPath.row].itemCode else { return }
            favoriteProductsSubject.value.remove(at: indexPath.row)
            try await CoreDataFavoriteProductRepository.shared.delete(id: itemCode)
        } catch {
            print(error)
        }
    }
}
