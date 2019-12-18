import Foundation

protocol Api {
    func api(host: String)
    func searchEvents(with params: SearchParams,
                      then: ((SearchResult) -> Void)?,
                      fail: ((Error) -> Void)?)
    func publishEvent(with params: PublishParams,
                      then: ((PublishResult) -> Void)?,
                      fail: ((Error) -> Void)?)
    func searchVenues(with params: SearchVenueParams,
                      then: ((SearchVenueResult) -> Void)?,
                      fail: ((Error) -> Void)?)
}

class ApiService: Api {
    func api(host: String) {
    }
    
    func searchEvents(with params: SearchParams,
                      then: ((SearchResult) -> Void)?,
                      fail: ((Error) -> Void)?) {
        if let callback = then {
            callback(SearchResult(events: EventContainer(event: [
                Event(id: "E0-001-130550278-8", title: "Book Club", start_time: "Dec 11, 2019, 7:00 PM", venue_id: "V0-001-000104270-1", venue_name: "5943 Balboa Avenue, Suite #100", description: "Book club meeting for book lovers"),
                
                Event(id: "E0-001-128591811-5", title: "Book Discussion Group", start_time: "Nov 19, 2019, 4:00 PM", venue_id: "V0-001-000264062-5", venue_name: "239 South Kalmia Street", description: "Read the selected book, chat about what you thought, and eat some food inspired by the book. NOV 2019: Orphan Monster Spy by Matt Killeen"),
                
                Event(id: "E0-001-128591884-1", title: "Deathling Book Club", start_time: "Oct 30, 2019, 7:00 PM", venue_id: "V0-001-000402425-6", venue_name: "810 West Valley Parkway", description: "Join us as we kick off our first ever Deathling Book Club")
            ])))
        }
    }
    
    func publishEvent(with params: PublishParams, then: ((PublishResult) -> Void)?,
                      fail: ((Error) -> Void)?) {
        if let callback = then {
            callback(PublishResult(id: "E0-001-130550278-8"))
        }
    }
    
    func searchVenues(with params: SearchVenueParams,
                      then: ((SearchVenueResult) -> Void)?,
                      fail: ((Error) -> Void)?) {
        if let callback = then {
            callback(SearchVenueResult(data: [
            Venue(venue_name: "Mysterious Galaxy Books", id: "V0-001-000104270-1", city_name: "San Diego"),
            Venue(venue_name: "Escondido Public Library", id: "V0-001-000264062-5", city_name: "San Diego"),
            Venue(venue_name: "The Lyceum Stage", id: "V0-001-000402425-6", city_name: "San Diego")]))
        }
    }
}
