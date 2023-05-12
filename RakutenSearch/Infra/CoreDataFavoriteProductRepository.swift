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
    
//    func insertFavoriteProduct(into: Product) async throws {
//        guard let managedContext = persistentContainer?.viewContext,
//              entity = NSEntityDescription.entity(forEntityName: "FavProduct", in: managedContext) else { return }
//        let favProduct = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        // 保存する商品情報
//        favProduct.setValue(into.item.itemCode, forKey: "itemCode")
//        favProduct.setValue(into.item.urlString, forKey: "urlString")
//        favProduct.setValue(into.item.reviewAverage, forKey: "reviewAverage")
//        favProduct.setValue(into.item.price, forKey: "price")
//        favProduct.setValue(into.item.name, forKey: "name")
//        favProduct.setValue(into.item.imageUrls[0], forKey: "imageUrl")
//
//        save()
//        await print(try getFavProducts())
//        await print(try getFavProducts().count)
//    }
//
    func insertFavoriteProduct(into: Product) async throws {
        let context = persistentContainer?.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavProduct")
        request.predicate = NSPredicate(format: "itemCode = %@", into.item.itemCode)
        do {
            let results = try context?.fetch(request) as? [NSManagedObject]
            if let object = results?.first as? NSManagedObject { // IDが存在する場合は何もしない
                
            } else { // IDが存在しない場合はオブジェクトを追加する
                let newObject = NSManagedObject(entity: FavProduct.entity(), insertInto: context)
                newObject.setValue(into.item.itemCode, forKey: "itemCode")
                newObject.setValue(into.item.urlString, forKey: "urlString")
                newObject.setValue(into.item.reviewAverage, forKey: "reviewAverage")
                newObject.setValue(into.item.price, forKey: "price")
                newObject.setValue(into.item.name, forKey: "name")
                newObject.setValue(into.item.imageUrls[0], forKey: "imageUrl")
                save()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }

    }
    
    func getFavProducts() async throws -> [FavProduct] {
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
        let favProducts = try context.fetch(favProductFetch) as! [FavProduct]
        for favProduct in favProducts {
            context.delete(favProduct)
        }
        save()
    }
    
    private func save() {
        guard let persistentContainer = self.persistentContainer else { return }
        persistentContainer.saveContext()
    }
}
