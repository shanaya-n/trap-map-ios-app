import Foundation

extension XML {
    class Parser: NSObject, XMLParserDelegate {
        /// If it has value, Parser is interuppted by error. (e.g. using invalid character)
        /// So the result of parsing is missing.
        /// See https://developer.apple.com/documentation/foundation/xmlparser/errorcode
        private(set) var error: XMLError?
        
        func parse(_ data: Data) -> Accessor {
            stack = [Element]()
            stack.append(documentRoot)
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            if let error = error {
                return Accessor(error)
            } else {
                return Accessor(documentRoot)
            }
        }
        
        override init() {
            trimmingManner = nil
        }
        
        init(trimming manner: CharacterSet) {
            trimmingManner = manner
        }
        
        // MARK:- private
        fileprivate var documentRoot = Element(name: "XML.Parser.AbstructedDocumentRoot")
        fileprivate var stack = [Element]()
        fileprivate let trimmingManner: CharacterSet?
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            let node = Element(name: elementName)
            if !attributeDict.isEmpty {
                node.attributes = attributeDict
            }
            
            let parentNode = stack.last
            
            node.parentElement = parentNode
            parentNode?.childElements.append(node)
            stack.append(node)
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            if let text = stack.last?.text {
                stack.last?.text = text + string
            } else {
                stack.last?.text = "" + string
            }
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if let trimmingManner = self.trimmingManner {
                stack.last?.text = stack.last?.text?.trimmingCharacters(in: trimmingManner)
            }
            stack.removeLast()
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            error = .interruptedParseError(rawError: parseError)
        }
    }
}
