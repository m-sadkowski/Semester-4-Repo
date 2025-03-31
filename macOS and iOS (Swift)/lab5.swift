import Foundation

// Enum to define media types
enum MediaType {
    case video
    case photo
    case music
}

// Struct to hold media details
struct Media {
    var type: MediaType
    var date: Date
    var likes: Int
}

// Class to represent a user profile
class Profile {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getProfileName() -> String {
        return name
    }
}

// Feed struct to represent a feed item
struct Feed {
    var profile: Profile
    var media: Media
    
    func formattedLikes() -> String {
        let numberOfLikes = media.likes
        if numberOfLikes >= 1_000_000 {
            return "\(numberOfLikes / 1_000_000)M"
        } else if numberOfLikes >= 1_000 {
            return "\(numberOfLikes / 1_000)k"
        } else {
            return "\(numberOfLikes)"
        }
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: media.date)
    }
    
    func printFeedInfo() {
        print("Profile name: \(profile.getProfileName()) | Media type: \(media.type) | Date: \(formattedDate()) | Number of likes: \(formattedLikes())")
    }
}

// Helper function to create test data
func generateTestData() -> [Feed] {
    let profile1 = Profile(name: "Apple")
    let date1 = Date() // Current date
    let media1 = Media(type: .video, date: date1, likes: 413000)
    let feed1 = Feed(profile: profile1, media: media1)
    
    let profile2 = Profile(name: "Google")
    let date2 = Date().addingTimeInterval(-86400) // 1 day ago
    let media2 = Media(type: .photo, date: date2, likes: 756000)
    let feed2 = Feed(profile: profile2, media: media2)
    
    return [feed1, feed2]
}

// Main code to test the feed
let feeds = generateTestData()
for feed in feeds {
    feed.printFeedInfo()
}

// Sample JSON
let jsonData = """
[
    {
        "profile": {"name": "Apple"},
        "media": {"type": "video", "date": "2025-03-31T00:00:00Z", "likes": 413000}
    },
    {
        "profile": {"name": "Google"},
        "media": {"type": "photo", "date": "2025-03-30T00:00:00Z", "likes": 756000}
    }
]
""".data(using: .utf8)!

// Decoding JSON
struct FeedData: Codable {
    struct ProfileData: Codable {
        var name: String
    }
    
    struct MediaData: Codable {
        var type: String
        var date: String
        var likes: Int
    }
    
    var profile: ProfileData
    var media: MediaData
}

do {
    let decodedData = try JSONDecoder().decode([FeedData].self, from: jsonData)
    // Process decoded data
    for feedData in decodedData {
        let profile = Profile(name: feedData.profile.name)
        let mediaType: MediaType = feedData.media.type == "video" ? .video : .photo // Just an example for simplicity
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: feedData.media.date)!
        let media = Media(type: mediaType, date: date, likes: feedData.media.likes)
        let feed = Feed(profile: profile, media: media)
        feed.printFeedInfo()
    }
} catch {
    print("Error decoding JSON: \(error)")
}
