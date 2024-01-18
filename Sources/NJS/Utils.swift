import CNJS

extension String {
    init(errorIn vm: OpaquePointer) throws {
        var s = njs_str_t()
        guard njs_vm_value_string(vm, &s, nil) == NJS_OK else {
            throw Error(message: "njs_vm_value_string() failed")
        }
        self = String(s)
    }
}

extension String {
    init(_ s: njs_str_t) {
        let buffer = UnsafeBufferPointer(start: s.start, count: s.length)
        self.init(decoding: buffer, as: UTF8.self)
    }
}
