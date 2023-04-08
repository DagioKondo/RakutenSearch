//
//  NSPersistentCloudKitContainer.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/04/02.
//

import CoreData

extension NSPersistentContainer {
    // viewContextで保存
    func saveContext() {
        saveContext(context: viewContext)
    }
    
    // 指定したcontextで保存
    // マルチスレッド環境でのバックグラウンドコンテキストを使う場合など
    func saveContext(context: NSManagedObjectContext) {
        // 変更がなければ何もしない
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
