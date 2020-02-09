import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.eugenepolyakov.RssFeed.feedupdate",
            using: DispatchQueue.global()
        ) { task in

            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1

            queue.addOperation {
                task.setTaskCompleted(success: true)
            }

            task.expirationHandler = {
                queue.cancelAllOperations()
            }

            data.load(Completor(onComplete: { print("from back") }))

            let lastOperation = queue.operations.last
            lastOperation?.completionBlock = {
                task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
            }

            task.setTaskCompleted(success: true)

            self.nextFeedUpdateTask()
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BGTaskScheduler.shared.cancelAllTaskRequests()
        nextFeedUpdateTask()
    }
    
    func nextFeedUpdateTask() {
        let request = BGAppRefreshTaskRequest(
            identifier: "com.eugenepolyakov.RssFeed.feedupdate"
        )
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 5)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            // тыц
            print(error)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

