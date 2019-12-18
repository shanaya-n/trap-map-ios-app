import Foundation

public enum XMLError: Error {
    case failToEncodeString
    case interruptedParseError(rawError: Error)
    case accessError(description: String)
}
