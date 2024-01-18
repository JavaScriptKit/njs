import CNJS
import JavaScript

public class JSValue: JavaScript.JSValue {
    let vm: OpaquePointer
    let pointer: UnsafeMutablePointer<njs_opaque_value_t>

    init(
        in vm: OpaquePointer,
        initialize: (UnsafeMutablePointer<njs_opaque_value_t>) throws -> Void?
    ) rethrows {
        self.vm = vm
        self.pointer = .allocate(capacity: 1)
        try initialize(pointer)
    }

    deinit {
        pointer.deallocate()
    }

    public subscript(_ key: String) -> JSValue? {
        key.withCString { start in
            JSValue(in: vm) { retval in
                var s = njs_str_t(length: key.count, start: .init(start))
                guard
                    njs_vm_object_prop(
                        vm, .init(pointer), &s, .init(retval)
                    ) != nil
                else {
                    return nil
                }
            }
        }
    }

    public func toString() throws -> String {
        var s = njs_str_t()
        guard njs_vm_value_to_string(vm, &s, .init(pointer)) == NJS_OK else {
            throw try Error(in: vm, source: "njs_vm_value_to_string")
        }
        return String(s)
    }

    public func toInt() throws -> Int {
        Int(numberValue)
    }

    // is `Type`

    public var isNull: Bool {
        njs_value_is_null(.init(pointer)) == 1
    }

    public var isUndefined: Bool {
        njs_value_is_undefined(.init(pointer)) == 1
    }

    public var isBool: Bool {
        njs_value_is_boolean(.init(pointer)) == 1
    }

    public var isNumber: Bool {
        njs_value_is_number(.init(pointer)) == 1
    }

    public var isString: Bool {
        njs_value_is_string(.init(pointer)) == 1
    }

    public var isObject: Bool {
        njs_value_is_object(.init(pointer)) == 1
    }

    // TODO: add to JavaScript

    var boolValue: Bool {
        get { njs_value_bool(.init(pointer)) == 1 }
        set { njs_value_boolean_set(.init(pointer), newValue ? 1 : 0) }
    }

    var numberValue: Double {
        get { njs_value_number(.init(pointer)) }
        set { njs_value_number_set(.init(pointer), newValue)}
    }

    public var isNullOrUndefined: Bool {
        njs_value_is_null_or_undefined(.init(pointer)) == 1
    }

    public var isFunction: Bool {
        njs_value_is_function(.init(pointer)) == 1
    }
}
