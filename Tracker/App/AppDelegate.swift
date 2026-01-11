import UIKit
import YandexMobileMetrica

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // ✅ доступ к стеку (одиночка)
    let coreDataStack = CoreDataStack.shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if let configuration = YMMYandexMetricaConfiguration(apiKey: "5afc96f8-ab58-4d42-948a-3c6685bbb788") {
            YMMYandexMetrica.activate(with: configuration)
        } else {}
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        // 🔄 Проверим, что контейнер поднялся
        _ = coreDataStack.context
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // 💾 сохраним изменения перед завершением
        coreDataStack.saveContext()
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
