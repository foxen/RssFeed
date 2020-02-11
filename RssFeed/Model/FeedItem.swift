import Foundation

struct FeedItem: Identifiable, Codable {
    
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
