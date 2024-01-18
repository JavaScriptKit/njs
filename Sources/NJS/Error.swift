import CNJS

struct Error: Swift.Error {
    let message: String
    let source: String

    init(message: String, source: String = "") {
        self.message = message
        self.source = source
    }

    init(from source: String, in vm: OpaquePointer) {
        self.message = String(retvalIn: vm)
        self.source = source
    }
}

extension Error: CustomStringConvertible {
    var description: String {
        return message
    }
}

extension Error: Equatable {
    static func == (lhs: Error, rhs: Error) -> Bool {
        return lhs.message == rhs.message
    }
}
