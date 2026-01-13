import CoreData
import Foundation
import Logging

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")

        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("❌ Ошибка загрузки Persistent Store: \(error), \(error.userInfo)")
            } else {
                print("✅ Загружен Store: \(description)")
            }
        }
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    // MARK: - Context
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("💾 Сохранено в Core Data")
            } catch {
                let nserror = error as NSError
                fatalError("❌ Ошибка сохранения: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
