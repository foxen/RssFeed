import Foundation

let rbcUrl = "http://static.feed.rbc.ru/rbc/logical/footer/news.rss"

let data = AppData()

final class AppData: ObservableObject {
    
    @Published private(set) var feeds: [String: Feed] = [:]
    
    var defaults = UserDefaults.standard
    
    private let key = "com.eugenepolyakov.RssFeed.feeds"
    
    private let mx = DispatchSemaphore(value: 1)
    
    init() {

        if
            let json = UserDefaults.standard.value(forKey: key) as? Data,
            let feeds = try? JSONDecoder().decode([String:Feed].self, from: json)
        {
            self.feeds = feeds
        }
        
        if feeds.count == 0 {
            let defaultFeed = Feed(for: rbcUrl)
            defaultFeed.localTitle = "РБК - Все материалы"
            feeds = [rbcUrl: defaultFeed]
            save()
        }
        
        for (_, feed) in feeds {
            feed.store = self
        }
    }
    
    private func save() {
        guard let data = try? JSONEncoder().encode(feeds) else {
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func add(_ url: String) {
        mx.wait()
        
        self.feeds[url] = Feed(for: url)
        save()
        
        mx.signal()
    }
    
    func remove(_ url: String) {
        mx.wait()
        
        self.feeds[url] = nil
        save()
        
        mx.signal()
    }
    
    func update(_ url: String) {
        mx.wait()
        mx.signal()
        mx.wait()
    }
}


