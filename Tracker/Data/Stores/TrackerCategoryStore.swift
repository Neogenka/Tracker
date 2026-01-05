import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories()
}

final class TrackerCategoryStore: NSObject {

    // MARK: - Properties

    weak var delegate: TrackerCategoryStoreDelegate?

    private let context: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>

    // MARK: - Public access

    var categories: [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        return objects.compactMap { mapCategory(from: $0) }
    }

    // MARK: - Init

    init(context: NSManagedObjectContext) {
        self.context = context
        self.fetchedResultsController = TrackerCategoryStore.makeFetchedResultsController(context: context)
        super.init()
        fetchedResultsController.delegate = self
        performFetch()
    }

    // MARK: - Public methods

    func add(_ category: TrackerCategory) {
        let cdCategory = TrackerCategoryCoreData(context: context)
        cdCategory.id = category.id
        cdCategory.title = category.title
        saveContext()
    }

    func delete(_ category: TrackerCategory) {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("❌ Ошибка delete TrackerCategory: \(error)")
        }
    }

    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", categoryTitle)

        do {
            let cdCategory = try context.fetch(request).first ?? createCategory(title: categoryTitle)

            let cdTracker = TrackerCoreData(context: context)
            cdTracker.id = tracker.id
            cdTracker.name = tracker.name
            cdTracker.color = tracker.color
            cdTracker.emoji = tracker.emoji
            cdTracker.schedule = tracker.schedule as NSObject

            var trackers = cdCategory.trackers as? Set<TrackerCoreData> ?? []
            trackers.insert(cdTracker)
            cdCategory.trackers = trackers as NSSet

            saveContext()
        } catch {
            print("❌ Ошибка добавления трекера в категорию: \(error)")
        }
    }

    // MARK: - Private helpers

    private static func makeFetchedResultsController(
        context: NSManagedObjectContext
    ) -> NSFetchedResultsController<TrackerCategoryCoreData> {

        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]

        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("❌ Ошибка performFetch категорий: \(error)")
        }
    }

    private func createCategory(title: String) -> TrackerCategoryCoreData {
        let category = TrackerCategoryCoreData(context: context)
        category.id = UUID()
        category.title = title
        return category
    }

    private func mapCategory(from cdCategory: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let id = cdCategory.id,
              let title = cdCategory.title else {
            print("⚠️ Ошибка маппинга TrackerCategoryCoreData")
            return nil
        }

        return TrackerCategory(id: id, title: title, trackers: [])
    }

    private func saveContext() {
        do {
            if context.hasChanges { try context.save() }
        } catch {
            print("❌ Ошибка сохранения контекста: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.didUpdateCategories()
    }
}
