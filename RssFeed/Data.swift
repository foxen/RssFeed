import Foundation
import FeedKit

import Combine
import SwiftUI


struct feedItem: Identifiable {
    var id: String
    var title: String?
    var link: String?
    var description: String?
    var author: String?
    var pubDate: Date?
    var imageUrl: String?
    var image: CGImage?
    
    func isSufficient() -> Bool {
        return
            self.title != nil &&
            self.description != nil &&
            self.author != nil &&
            self.link != nil &&
            self.imageUrl != nil &&
            self.pubDate != nil
    }
}



final class Data: ObservableObject {
    @Published var updeted: Date?
    @Published var isSample = false
    @Published var isLoadedAtLeastOnce = false
    @Published var isLoading = false
    @Published var feed: [String: feedItem] = [:]
    @Published var breakings: [String: feedItem] = [:]
}

func loadData(to data: Data){

    if data.isLoading {
        return
    }

    data.isLoading = true
    
    let feedURL = URL(
        string: "http://static.feed.rbc.ru/rbc/logical/footer/news.rss"
    )!

    let parser = FeedParser(URL: feedURL)
    
    parser.parseAsync { (result) in
        
        print("finish loading feed")
        
        switch result {
        
        case .success(let feed):
            
            var _breakingItems: [String: feedItem] = [:]
            
            var imageUrls: [String: (String, Bool)] = [:]
            
            if let updated = feed.rssFeed?.pubDate {
                DispatchQueue.main.async {
                    data.updeted = updated
                }
            }
            
            var stub = 0
            feed.rssFeed?.items?.forEach { rssItem in
                
                // fufufu
                guard stub < 50 else {
                    return
                }
                
                guard
                    let uuid = rssItem.guid?.value,
                    let pubDate = rssItem.pubDate
                else {
                    return
                }
                //data.feed.
                let item = feedItem(
                    id: uuid,
                    title: rssItem.title,
                    link: rssItem.link,
                    description:
                    rssItem.description,
                    author: rssItem.author,
                    pubDate: pubDate,
                    imageUrl: rssItem.enclosure?.attributes?.url
                )
                
                
                let key = "\(Int(pubDate.timeIntervalSince1970))" + uuid
                
                if item.isSufficient() && _breakingItems.count < 10 {
                    _breakingItems[key] = item
                    imageUrls[key] = (item.imageUrl!, true)
                    return
                }
                
                guard data.feed[key] == nil else {
                    return
                    
                }
                
                if let imageUrl = item.imageUrl {
                    imageUrls[key] = (imageUrl, false)
                }
                
                
                DispatchQueue.main.async {
                    data.feed[key] = item
                }
                
                stub += 1
            }
            
            if _breakingItems.count > 0 {
                DispatchQueue.main.async {
                    data.breakings = _breakingItems
                }
            }
            
            // fetch image one by one
            // we are stil in the background thread
            print("start image load")
            for (k, v) in imageUrls {
                let link = v.0.replacingOccurrences(of: "http:/", with: "https:/")
                guard
                    let url = NSURL(string: link),
                    let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
                    let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
                else {
                    continue
                }
                DispatchQueue.main.async {
                    if v.1 {
                        data.breakings[k]?.image = image
                        return
                    }
                    data.feed[k]?.image = image
                }
                
            }
            print("end image load")
        
        case .failure(let error):
            // try next time
            print(error)
        }
        DispatchQueue.main.async {
            data.isLoading = false
        }
    }
}
