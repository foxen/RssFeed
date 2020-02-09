import FeedKit
import Combine
import SwiftUI


struct feedItem: Identifiable {
    
    var id: String
    
    var isBreaking = false
    
    var key: String {
        guard let pubDate = self.pubDate else {
            return id
        }
        return "\(Int(pubDate.timeIntervalSince1970))" + id
    }
    
    var isSufficient: Bool {
            self.title != nil &&
            self.description != nil &&
            self.author != nil &&
            self.link != nil &&
            self.imageUrl != nil &&
            self.pubDate != nil
    }
    
    var title: String?
    var link: String?
    var description: String?
    var author: String?
    var pubDate: Date?
    var imageUrl: String?

}

let data = Feed(for: "http://static.feed.rbc.ru/rbc/logical/footer/news.rss")

final class Feed: ObservableObject {
    var url: String
    
    var totalLimit = 50
    var breakingsLimit = 10
    
    @Published private(set) var pubDate: Date?
    @Published private(set) var items: [String: feedItem] = [:]
    @Published private(set) var images: [String: CGImage] = [:]

    private let mx = DispatchSemaphore(value: 1)
    
    private var loading = false
   
    private var onceFlag = false
    var atOnce: Bool {
        mx.wait()
        defer {
            self.mx.signal()
        }
        return onceFlag
    }
    
    init(for url: String) {
        self.url = url
    }
}

struct Completor {
   
   var onComplete: (()->Void)?
   var onError: ((Error)->Void)?
   var onSuccess: (()->Void)?
   var onImagesComplete: (()->Void)?
    
    func complete() {
        if let onComplete = self.onComplete {
            onComplete()
        }
    }
    func error(_ e: Error) {
        if let onError = self.onError {
            onError(e)
        }
    }
    func success() {
        if let onSuccess = self.onSuccess {
            onSuccess()
        }
    }
    func imagesComplete() {
        if let onImagesComplete = self.onImagesComplete {
            onImagesComplete()
        }
    }
    func successfullyComplete() {
        success()
        complete()
    }
    func unsuccessfullyComplete(_ e: Error) {
        error(e)
        complete()
    }
}

enum LoadingError: Error {
    case incorrectUrl(_ url: String)
    case loading
}

extension Feed {
    func load(_ completor: Completor) {
        
        guard let url = URL(string: self.url) else {
            completor.unsuccessfullyComplete(LoadingError.incorrectUrl(self.url))
            return
        }
        
        mx.wait()
        
        let isLoading = loading
        loading = loading ? loading : true
        
        mx.signal()
        
        guard !isLoading else {
            completor.unsuccessfullyComplete(LoadingError.loading)
            return
        }
        
        FeedParser(URL: url).parseAsync { (result) in
            
            switch result {
            
            case .success(let feed):
                
                var items: [String: feedItem] = [:]
                
                if let pubDate = feed.rssFeed?.pubDate {
                    DispatchQueue.main.async {
                        self.mx.wait()
                        data.pubDate = pubDate
                        self.mx.signal()
                    }
                }
                var breakingsCnt = 0
                feed.rssFeed?.items?.forEach { rssItem in
                    
                    // fufufu
                    guard items.count < self.totalLimit else {
                        return
                    }
                    
                    guard
                        let uuid = rssItem.guid?.value,
                        let pubDate = rssItem.pubDate
                    else {
                        return
                    }
                    
                    var item = feedItem(
                        id: uuid,
                        title: rssItem.title,
                        link: rssItem.link,
                        description:
                        rssItem.description,
                        author: rssItem.author,
                        pubDate: pubDate,
                        imageUrl: rssItem.enclosure?.attributes?.url
                        
                    )
                                        
                    if item.isSufficient && breakingsCnt < self.breakingsLimit {
                        item.isBreaking = true
                        breakingsCnt += 1
                    }
                    items[item.key] = item
                    
                }
                
                let income = Set(items.keys)
                let presist = Set(self.items.keys)
                
                let toAdd = income.subtracting(presist)
                let toUnset = presist.subtracting(income)
                
                let toUnsetBreakings = Set(
                    self.items.filter{$0.value.isBreaking}.keys
                ).subtracting(
                    Set(items.filter{$0.value.isBreaking}.keys)
                )
                                
                DispatchQueue.main.async {
                    self.mx.wait()
                    
                    for k in toAdd {
                        guard let item = items[k] else {
                            continue
                        }
                        self.items[k] = item
                    }
                    for k in toUnset {
                        self.items[k] = nil
                    }
                    for k in toUnsetBreakings {
                        self.items[k]?.isBreaking = false
                        
                    }
                    
                    self.mx.signal()
                    
                    completor.successfullyComplete()
                }
                
                // fetch image one by one
                // we are stil in the background thread
                var n = 0
                for k in toAdd {
                    n += 1
                    guard
                        let link = items[k]?.imageUrl?.replacingOccurrences(
                            of: "http:/", with: "https:/"
                        ),
                        let url = NSURL(string: link),
                        let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
                        let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
                    else {
                        continue
                    }
                    
                    DispatchQueue.main.async {
                        self.mx.wait()
                        self.images[k] = image
                        self.mx.signal()
                        if n == toAdd.count {
                            completor.imagesComplete()
                        }
                    }
                }
            case .failure(let e):
                // try next time
                DispatchQueue.main.async {
                    completor.unsuccessfullyComplete(e)
                }
            }

            self.mx.wait()
            self.loading = false
            self.mx.signal()
        }
        
    }
}
