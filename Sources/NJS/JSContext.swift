import CNJS
import JavaScript

public class JSContext {
    let vm: OpaquePointer
    let options: njs_vm_opt_t

    public convenience init() throws {
        var options = njs_vm_opt_t()
        options.`init` = 1
        options.log_level = NJS_LOG_LEVEL_INFO
        options.max_stack_size = 64 * 1024
        options.backtrace = 1
        try self.init(options: options)
    }

    public init(options: njs_vm_opt_t) throws {
        var options = options
        guard let vm = njs_vm_create(&options) else {
            throw Error(
                message: "njs_vm_create() failed",
                source: "njs_vm_create")
        }
        self.vm = vm
        self.options = options
    }

    private init(vm: OpaquePointer, options: njs_vm_opt_t) {
        self.vm = vm
        self.options = options
    }

    deinit {
        njs_vm_destroy(vm)
    }

    // 1.
    private func compile(_ script: String) throws {
        try script.withCString { start in
            var start = UnsafeMutablePointer<UInt8>(start)
            let end = start?.advanced(by: script.count)
            guard njs_vm_compile(vm, &start, end) == NJS_OK else {
                throw try Error(in: vm, source: "njs_vm_compile")
            }
        }
    }

    // 2.
    private func start() throws -> JSValue {
        try .init(in: vm) { pointer in
            guard njs_vm_start(vm, .init(pointer)) == NJS_OK else {
                throw try Error(in: vm, source: "njs_vm_start")
            }
        }
    }

    public func evaluate(_ script: String) throws -> JSValue {
        try compile(script)
        return try start()
    }

    public func clone() throws -> JSContext {
        guard let pointer = njs_vm_clone(vm, nil) else {
            throw try Error(in: vm, source: "njs_vm_clone")
        }
        return JSContext(vm: pointer, options: options)
    }
}

extension UnsafeMutablePointer where Pointee == UInt8 {
    init?(_ pointer: UnsafePointer<Int8>) {
        self = UnsafeMutableRawPointer(mutating: pointer)
            .assumingMemoryBound(to: UInt8.self)
    }
}
