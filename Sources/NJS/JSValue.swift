import CNJS
import JavaScript

public class JSValue: JavaScript.JSValue {
    let pointer: OpaquePointer
    let vm: OpaquePointer

    init(_ pointer: OpaquePointer, in vm: OpaquePointer) {
        self.pointer = pointer
        self.vm = vm
    }

    public subscript(_ key: String) -> JSValue? {
        key.withCString { keyPointer in
            let start = UnsafeMutablePointer<UInt8>(keyPointer)
            var s = njs_str_t(length: key.count, start: start)
            var op = njs_opaque_value_t()
            guard let p = njs_vm_object_prop(vm, pointer, &s, &op) else {
                return nil
            }
            return JSValue(p, in: vm)
        }
    }

    public func toString() throws -> String {
        var s = njs_str_t()
        guard njs_vm_value_to_string(vm, &s, pointer) == NJS_OK else {
            throw Error(from: "njs_vm_value_to_string", in: vm)
        }
        return String(s)
    }

    public func toInt() throws -> Int {
        return Int(numberValue)
    }

    // is `Type`

    public var isNull: Bool {
        return njs_value_is_null(pointer) == 1
    }

    public var isUndefined: Bool {
        return njs_value_is_undefined(pointer) == 1
    }

    public var isBool: Bool {
        return njs_value_is_boolean(pointer) == 1
    }

    public var isNumber: Bool {
        return njs_value_is_number(pointer) == 1
    }

    public var isString: Bool {
        return njs_value_is_string(pointer) == 1
    }

    public var isObject: Bool {
        return njs_value_is_object(pointer) == 1
    }

    // TODO: add to JavaScript

    var boolValue: Bool {
        get { return njs_value_bool(pointer) == 1 }
        set { njs_value_boolean_set(pointer, newValue ? 1 : 0) }
    }

    var numberValue: Double {
        get { return njs_value_number(pointer) }
        set { njs_value_number_set(pointer, newValue)}
    }

    public var isNullOrUndefined: Bool {
        return njs_value_is_null_or_undefined(pointer) == 1
    }

    public var isFunction: Bool {
        return njs_value_is_function(pointer) == 1
    }
}
