import Test
@testable import NJS

test.case("evaluate") {
    let context = try JSContext()
    _ = try context.evaluate("40 + 2")
}

test.case("ReferenceError exception") {
    let context = try JSContext()

    let message = """
        ReferenceError: \"x\" is not defined in 1
            at main (native)

        """

    expect(throws: Error(message: message)) {
        try context.evaluate("x()")
    }
}

test.case("SyntaxError exception") {
    let context = try JSContext()

    let message = "SyntaxError: Unexpected end of input in 1"
    expect(throws: Error(message: message)) {
        try context.evaluate("{")
    }
}

test.run()