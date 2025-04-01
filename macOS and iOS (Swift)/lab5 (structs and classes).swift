/* 7pkt, wszystko zrobione */

import Foundation

enum FeedType: String, Codable {
    case post
    case video
    case photo
}

struct FeedData: Codable {
    var description: String
    var date: Date
    var likesNumber: Int
    var sharesNumber: Int
    var comments: [String]
}

class Feed: Codable {
    var type: FeedType
    var data: FeedData
    
    // Implementacja Codable dla klasy dziedziczącej
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(FeedType.self, forKey: .type)
        data = try container.decode(FeedData.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(data, forKey: .data)
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }
    
    init(type: FeedType, data: FeedData) {
        self.type = type
        self.data = data
    }
    
    func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            let formatted = Double(number) / 1000.0
            return String(format: "%.1fk", formatted)
        }
        return "\(number)"
    }
    
    func printLikesNumber() {
        print("Likes: \(formatNumber(data.likesNumber))")
    }
    
    func printSharesNumber() {
        print("Shares: \(formatNumber(data.sharesNumber))")
    }
    
    func printLast3Comments() {
        let lastComments = data.comments.suffix(3)
        print("Last 3 comments:")
        for comment in lastComments {
            print("- \(comment)")
        }
    }
    
    func printDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        print("Date: \(formatter.string(from: data.date))")
    }
    
    func displayFeed() {
        print("Type: \(type)")
        print("Description: \(data.description)")
        printDate()
        printLikesNumber()
        printSharesNumber()
        printLast3Comments()
    }
}

class XPost: Feed {
    var author: String
    
    private enum CodingKeys: String, CodingKey {
        case author
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(String.self, forKey: .author)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(author, forKey: .author)
        try super.encode(to: encoder)
    }
    
    init(author: String, data: FeedData) {
        self.author = author
        super.init(type: .post, data: data)
    }
}

class YouTubePost: Feed {
    var channelName: String
    
    private enum CodingKeys: String, CodingKey {
        case channelName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        channelName = try container.decode(String.self, forKey: .channelName)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(channelName, forKey: .channelName)
        try super.encode(to: encoder)
    }
    
    init(channelName: String, data: FeedData) {
        self.channelName = channelName
        super.init(type: .video, data: data)
    }
}

/*

let formatter = DateFormatter()
formatter.dateFormat = "dd.MM.yyyy"

let feeds: [Feed] = [
    XPost(author: "FC Barcelona", data: FeedData(
        description: "No mercy. #BarçaGirona",
        date: formatter.date(from: "30.03.2025")!,
        likesNumber: 713400,
        sharesNumber: 1400,
        comments: ["goal machine", "Legend", "25 goals for La Liga already, give Him a ballon d’or"]
    )),
    YouTubePost(channelName: "PRO8L3M", data: FeedData(
        description: "Ground Zero",
        date: formatter.date(from: "06.04.2018")!,
        likesNumber: 341000,
        sharesNumber: 7739,
        comments: ["Prawa autorskie właśnie odebrały duszę tej legendzie [*]",
                   "Pomyślcie jaki piękny będzie moment na koncercie kiedy wszyscy ludzie i tak będą to śpiewać!",
                   "Zostawmy znicz dla tego wspaniałego kawałka którego już nie ma [*]"]
    )),
    Feed(type: .photo, data: FeedData(
        description: "Życzę Ci spokojnych świąt, gdzie radość i szczęście są wszystkim, na co polujesz. ✨",
        date: formatter.date(from: "24.12.2024")!,
        likesNumber: 2700,
        sharesNumber: 151,
        comments: ["Happy Holidays to you 🎁🎄🎀",
                   "Wesołych świąt 🌲🌲",
                   "Wesołych Świąt",
                   "On the occasion of Christmas, I wishes you the very best! 🌟"]
    ))
]

for feed in feeds {
    feed.displayFeed()
    print("--------------")
}

*/

let jsonString = """
  [
    {
      "type": "post",
      "author": "FC Barcelona",
      "data": {
        "description": "No mercy. #BarçaGirona",
        "date": "30.03.2025",
        "likesNumber": 713400,
        "sharesNumber": 1400,
        "comments": ["goal machine", "Legend", "25 goals for La Liga already, give Him a ballon d’or"]
      }
    },
    {
      "type": "video",
      "channelName": "PRO8L3M",
      "data": {
        "description": "Ground Zero",
        "date": "06.04.2018",
        "likesNumber": 341000,
        "sharesNumber": 7739,
        "comments": ["Prawa autorskie właśnie odebrały duszę tej legendzie [*]", "Pomyślcie jaki piękny będzie moment na koncercie kiedy wszyscy ludzie i tak będą to śpiewać!", "Zostawmy znicz dla tego wspaniałego kawałka którego już nie ma [*]"]
      }
    },
    {
      "type": "photo",
      "data": {
        "description": "Życzę Ci spokojnych świąt, gdzie radość i szczęście są wszystkim, na co polujesz. ✨",
        "date": "24.12.2024",
        "likesNumber": 2700,
        "sharesNumber": 151,
        "comments": ["Happy Holidays to you 🎁🎄🎀", "Wesołych świąt 🌲🌲", "Wesołych Świąt", "On the occasion of Christmas, I wishes you the very best! 🌟"]
      }
    }
  ]
"""

let jsonData = jsonString.data(using: .utf8)!
let decoder = JSONDecoder()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd.MM.yyyy"
decoder.dateDecodingStrategy = .formatted(dateFormatter)

do {
    let feeds = try decoder.decode([Feed].self, from: jsonData)
    for feed in feeds {
        feed.displayFeed()
        print("--------------")
    }
} catch {
    print("Błąd dekodowania: \(error)")
}