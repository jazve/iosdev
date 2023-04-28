import SwiftUI
import RealmSwift

class Article: Object, Identifiable, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var publishDate: Date = Date()
    @objc dynamic var imageURL: String? = nil
    @objc dynamic var author: String = ""
    @objc dynamic var isRead: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, title: String, content: String, publishDate: Date, imageURL: URL?, author: String) {
        self.init()
        self.id = id
        self.title = title
        self.content = content
        self.publishDate = publishDate
        self.author = author
        self.imageURL = imageURL?.absoluteString
    }
    
    // Codable conformance for the @Published property
    enum CodingKeys: String, CodingKey {
        case id, title, content, publishDate, imageURL, author, isRead
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(publishDate, forKey: .publishDate)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(author, forKey: .author)
        try container.encode(isRead, forKey: .isRead)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let content = try container.decode(String.self, forKey: .content)
        let publishDate = try container.decode(Date.self, forKey: .publishDate)
        let imageURL = try container.decode(URL?.self, forKey: .imageURL)
        let author = try container.decode(String.self, forKey: .author)
        let isRead = try container.decode(Bool.self, forKey: .isRead)
        
        self.init(id: id, title: title, content: content, publishDate: publishDate, imageURL: imageURL, author: author)
        self.isRead = isRead
    }
}
