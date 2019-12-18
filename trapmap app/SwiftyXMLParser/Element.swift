import Foundation

extension XML {
    open class Element {
        open var name: String
        open var text: String?
        open var attributes = [String: String]()
        open var childElements = [Element]()
        
        // for println
        open weak var parentElement: Element?
        
        public init(name: String) {
            self.name = name
        }
    }
}
