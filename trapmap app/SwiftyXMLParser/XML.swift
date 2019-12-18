import Foundation

public protocol XMLSubscriptType {}
extension Int: XMLSubscriptType {}
extension String: XMLSubscriptType {}

infix operator ?= // Failable Assignment
/**
 assign value if rhs is not optonal. When rhs is optional, nothing to do.
*/
public func ?=<T>(lhs: inout T, rhs: T?) {
    if let unwrappedRhs = rhs {
        lhs = unwrappedRhs
    }
}

infix operator ?<< // Failable Push
/**
 push value to array if rhs is not optonal. When rhs is optional, nothing to do.
*/
public func ?<< <T>(lhs: inout [T], rhs: T?) {
    if let unwrappedRhs = rhs {
        lhs.append(unwrappedRhs)
    }
}


/**
 Director class to parse and access XML document.
 
 You can parse XML docuemnts with parse() method and get the accessor.
 
 ### Example
 ```
    let string = "<ResultSet><Result><Hit index="1"><Name>ほげ</Name></Hit><Hit index="2"><Name>ふが</Name></Hit></Result></ResultSet>"
    xml = XML.parse(string)
    let text = xml["ResultSet"]["Result"]["Hit"][0]["Name"].text {
        println("exsists path & text")
    }
    let text = xml["ResultSet", "Result", "Hit", 0, "Name"].text {
        println("exsists path & text")
    }
    let attributes = xml["ResultSet", "Result", "Hit", 0, "Name"].attributes {
        println("exsists path & attributes")
    }
    for hit in xml["ResultSet", "Result", "Hit"] {
        println("enumarate existing element")
    }
    switch xml["ResultSet", "Result", "TypoKey"] {
    case .Failure(let error):
        println(error)
    case .SingleElement(_), .Sequence(_):
        println("success parse")
    }
 ```
*/
open class XML {
    /**
    Interface to parse NSData
    
    - parameter data:NSData XML document
    - returns:Accessor object to access XML document
    */
    open class func parse(_ data: Data) -> Accessor {
        return Parser().parse(data)
    }
    
    /**
     Interface to parse String
     
     - Parameter str:String XML document
     - Returns:Accessor object to access XML document
     */
    open class func parse(_ str: String) throws -> Accessor {
        guard let data = str.data(using: String.Encoding.utf8) else {
            throw XMLError.failToEncodeString
        }
        
        return Parser().parse(data)
    }
    
    /**
     Interface to parse NSData
     
     - parameter data:NSData XML document
     - parameter manner:NSCharacterSet If you wannna trim Text, assign this arg
     - returns:Accessor object to access XML document
     */
    open class func parse(_ data: Data, trimming manner: CharacterSet) -> Accessor {
        return Parser(trimming: manner).parse(data)
    }
    
    /**
     Interface to parse String
     
     - Parameter str:String XML document
     - parameter manner:NSCharacterSet If you wannna trim Text, assign this arg
     - Returns:Accessor object to access XML document
     */
    open class func parse(_ str: String, trimming manner: CharacterSet) throws -> Accessor {
        guard let data = str.data(using: String.Encoding.utf8) else {
            throw XMLError.failToEncodeString
        }
        
        return Parser(trimming: manner).parse(data)
    }
    
    open class func document(_ accessor: Accessor) throws -> String {
        return try Converter(accessor).makeDocument()
    }
}
