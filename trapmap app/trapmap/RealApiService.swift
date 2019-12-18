import Siesta
//import SwiftyXMLParser

class RealApiService: NSObject, Api, XMLParserDelegate {
//     To obtain oauth_nonce, oauth_timestamp, and oauth_signature go to "http://bettiolo.github.io/oauth-reference-page/"
    
    // Enter oauth_consumer_key, app_key, consumer_secret to obtain the token with POST method "https://eventful.com/oauth/request_token"
    
//    Then, perform a GET call to "https://eventful.com/oauth/authorize" using the oauth_token provided by the previous call
    
//    You will be redirected to a webpage. Use the oauth_verifier in the link along with the consumer_key, oauth_token, oauth_token_secret to create a new signature at "http://bettiolo.github.io/oauth-reference-page/"
    
//    The access_token obtained from completing the previous step along with the oauth_token can then be used to produce a new signature at "http://bettiolo.github.io/oauth-reference-page/" and the GET method for publishEvent can be called
    
//    Full Documentation: "http://api.eventful.com/docs/auth"
    
    
    let APP_KEY = "kP9qz9zBpgZBR3XW"
    let oauth_consumer_key = "d60b4ccc918b61967d16"
    let oauth_nonce = "996385760"
    let oauth_signature_method = "HMAC-SHA1"
    let oauth_timestamp = "1568851280"
    let oauth_token = "2b471d7b5e96bf0bd395"
    let oauth_version = "1.0"
    let oauth_signature = "7l75lh3pm1KUW3XKPMJDZEZn4kQ="
    
    private var service = Service(
        baseURL: "https://api.eventful.com",
        standardTransformers: [.text])
    
    override init() {
        SiestaLog.Category.enabled = [.network]
    }
    
    func api(host: String) {
        service = Service(baseURL: host, standardTransformers: [.text])
    }
    
    func searchEvents(with params: SearchParams,
                      then: ((SearchResult) -> Void)?,
                      fail: ((Error) -> Void)?) {
        service.resource("json/events/search")
            .withParam("app_key", APP_KEY)
            .withParam("location", params.location)
            .withParam("date", "Future")
            .request(.get).onSuccess { result in
                if let searchResult: String = result.typedContent(),
                    let callback = then {
                    if let data = searchResult.data(using: .utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            let jsonDecoder = JSONDecoder()
                            let searchResult: SearchResult = try jsonDecoder.decode(SearchResult.self, from: JSONSerialization.data(withJSONObject: json))
                            callback(searchResult)
                        } catch {
                            if let errorCallback = fail {
                                errorCallback(error)
                            }
                        }
                    }
                }
        }.onFailure { error in
            if let callback = fail {
                callback(error)
            }
        }
    }
    
    func publishEvent(with params: PublishParams,
                      then: ((PublishResult) -> Void)?,
                      fail: ((Error) -> Void)?) {
        service.resource("/rest/events/new")
            .withParam("app_key", APP_KEY)
            .withParam("title", params.title)
            .withParam("start_time", params.start_time)
            .withParam("venue_id", params.venue_id)
            .withParam("category1", "music")
            .withParam("oauth_consumer_key", oauth_consumer_key)
            .withParam("oauth_nonce", oauth_nonce)
            .withParam("oauth_signature_method", oauth_signature_method)
            .withParam("oauth_timestamp", oauth_timestamp)
            .withParam("oauth_token", oauth_token)
            .withParam("oauth_version", oauth_version)
            .withParam("oauth_signature", oauth_signature)
            .withParam("description", params.description)
            .request(.get).onSuccess { result in
                if let publishResult: NSString = result.typedContent(),
                    let callback = then {
                    var parser:XMLParser?
                    let str: NSString = publishResult
                    var xml: XML.Accessor?
                    var parsedPublishResult: PublishResult!
                    if let data = str.data(using: String.Encoding.utf8.rawValue) {
                        parser = XMLParser.init(data: data)
                        parser!.delegate = (self as XMLParserDelegate)
                        parser!.parse()
                        xml = XML.parse(data)
                        if String(xml!.response.error.debugDescription) == "Optional(trapmap.XMLError.accessError(description: \"response not found.\"))" {
                            callback(PublishResult(id: "Post not successful"))
                            return
                        }
                        parsedPublishResult = PublishResult(id: xml!.response.id.text!)
                    }
                    callback(parsedPublishResult)
                }
        }.onFailure { error in
            if let callback = fail {
                callback(error)
            }
        }
    }
    
    func searchVenues(with params: SearchVenueParams,
                      then: ((SearchVenueResult) -> Void)?,
                      fail: ((Error) -> Void)?) {
        service.resource("/rest/venues/search")
            .withParam("app_key", APP_KEY)
            .withParam("keywords", params.keywords)
            .request(.get).onSuccess { result in
                if let searchVenueResult: NSString = result.typedContent(),
                    let callback = then {
                    var parser:XMLParser?
                    let str: NSString = searchVenueResult
                    var xml: XML.Accessor?
                    var venuesArray: [Venue] = []
                    var parsedSearchVenueResult: SearchVenueResult!
                    if let data = str.data(using: String.Encoding.utf8.rawValue) {
                        parser = XMLParser.init(data: data)
                        parser!.delegate = (self as XMLParserDelegate)
                        parser!.parse()
                        xml = XML.parse(data)
                        var venueIndex = 0
                        if xml!.search.venues.venue.all?.count == nil {
                            callback(SearchVenueResult(data: [Venue(venue_name: "No Search Results", id: "", city_name: "")]))
                            return
                        }
                        let numberOfVenues = xml!.search.venues.venue.all?.count
                        while venueIndex < numberOfVenues! {
                            venuesArray.append(Venue(venue_name: xml!.search.venues.venue[venueIndex].venue_name.text!, id: xml!.search.venues.venue[venueIndex].attributes["id"]!, city_name: xml!.search.venues.venue[venueIndex].city_name.text!))
                            venueIndex += 1
                        }
                        parsedSearchVenueResult = SearchVenueResult(data: venuesArray)
                    }
                    callback(parsedSearchVenueResult)
                }
        }.onFailure { error in
            if let callback = fail {
                callback(error)
            }
        }
    }
}
