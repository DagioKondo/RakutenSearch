//
//  CoreDataFavoriteProductRepository.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/28.
//

import Foundation
import CoreData

// ローカルストレージ（CoreData）にお気に入りを追加するリポジトリ実装クラス
final public class CoreDataFavoriteProductRepository: FavoriteProductRepository{
    public static let shared = CoreDataFavoriteProductRepository()
    private var persistentContainer: NSPersistentContainer?
    
    private init() {}
    
    func configure(container: NSPersistentContainer) {
        persistentContainer = container
    }
    
    func insertFavoriteProduct(into: ProductInfo) async throws {
        guard let managedContext = persistentContainer?.viewContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "FavProduct", in: managedContext) else { return }
        let favProduct = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 保存する商品情報
        favProduct.setValue(into.itemCode, forKey: "itemCode")
        favProduct.setValue(into.urlString, forKey: "urlString")
        favProduct.setValue(into.reviewAverage, forKey: "reviewAverage")
        favProduct.setValue(into.price, forKey: "price")
        favProduct.setValue(into.name, forKey: "name")
        favProduct.setValue(into.imageUrls[0], forKey: "imageUrl")
        favProduct.setValue(into.favorite, forKey: "favorite")
        
        save()
        await print(try getFavProduct())
        await print(try getFavProduct().count)
    }
    
    func getFavProduct() async throws -> [FavProduct] {
        guard let context = persistentContainer?.viewContext else { return [] }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavProduct")
        let persons = try context.fetch(request) as! [FavProduct]
        save()
        return persons
    }
    
    func delete(id: String) async throws {
        guard let context = persistentContainer?.viewContext else { return }
        let favProductFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavProduct")
        let predicate = NSPredicate(format: "itemCode = %@", id)
        favProductFetch.predicate = predicate
        do {
            let favProducts = try context.fetch(favProductFetch) as! [FavProduct]
            for favProduct in favProducts {
                context.delete(favProduct)
            }
        } catch let error as NSError {
            print(error)
        }
        save()
    }
    
    private func save() {
        guard let persistentContainer = self.persistentContainer else { return }
        persistentContainer.saveContext()
    }
}
