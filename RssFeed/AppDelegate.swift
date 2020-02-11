import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.eugenepolyakov.RssFeed.update",
            using: nil
        ) { task in
            self.bgFeedUpdateTaskHandler(task as! BGAppRefreshTask)
        }
        
        return true
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
    
    func bgFeedUpdateTaskHandler(_ task: BGAppRefreshTask) {
        
        self.nextBgFeedUpdateTask()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        let lastOperation = queue.operations.last
        
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }
        
        queue.addOperation({
            data.load(Completor(onComplete: {
                task.setTaskCompleted(success: true)
                print("updated in background")
            }))
        })
    }
    
    // for test in debugger
    //e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"rssfeed.update"]
    func nextBgFeedUpdateTask() {
        let request = BGAppRefreshTaskRequest(
            identifier: "com.eugenepolyakov.RssFeed.update"
        )
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)

        do {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("bg sch-r error: \(error)")
        }
    }

}
