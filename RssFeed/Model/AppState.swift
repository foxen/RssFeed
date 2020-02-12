import SwiftUI

let defaultFeedUrl = "http://static.feed.rbc.ru/rbc/logical/footer/news.rss"
let defaultFeedTitle = "РБК"

let data = AppState()

let ny  = "https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml"
let al = "https://www.aljazeera.com/xml/rss/all.xml"

final class AppState: ObservableObject {
    
    @Published private(set) var feeds: [String: Feed] = [:]
    @Published var titles: [String: String] = [:]
    @Published var pubDates: [String: Date] = [:]
    @Published var images: [String: CGImage] = [:]
    
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
            let defaultFeed = Feed(for: defaultFeedUrl)
            defaultFeed.title = defaultFeedTitle
            feeds = [defaultFeedUrl: defaultFeed]
            save()
        }
        
//        feeds[ny] = Feed(for: ny)
//        feeds[al] = Feed(for: al)
        
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
        titles[url] = nil
        pubDates[url] = nil
        images[url] = nil
    
        save()
        
        mx.signal()
    }
    
    func update(_ url: String) {
        mx.wait()
        
        titles[url] = feeds[url]?.title
        pubDates[url] = feeds[url]?.pubDate
        images[url] = feeds[url]?.image
        
        save()
        
        print("updated")
        
        mx.signal()
    }
    
}


