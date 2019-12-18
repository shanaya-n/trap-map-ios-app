let TESTING_UI = "UI_TESTING"

struct SearchParams {
    let location: String
}

struct SearchResult: Codable, Equatable {
    let events: EventContainer
}

struct EventContainer: Codable, Equatable {
    let event: [Event]
}

struct Event: Codable, Equatable {
    let id: String?
    let title: String?
    let start_time: String?
    let venue_id: String?
    let venue_name: String?
    let description: String?
}

struct PublishParams {
    let title: String?
    let start_time: String?
    let venue_id: String?
    let venue_name: String?
    let description: String?
}

struct PublishResult: Codable, Equatable {
    let id: String
}

struct SearchVenueParams {
    let keywords: String
}

struct VenueParams {
    let venue_name: String
    let id: String
    let city_name: String?
}

struct SearchVenueResult: Codable, Equatable {
    let data: [Venue]
}

struct Venue: Codable, Equatable {
    let venue_name: String
    let id: String
    let city_name: String?
}
