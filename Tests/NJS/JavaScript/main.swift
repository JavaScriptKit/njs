import Test
@testable import NJS

test("evaluate") {
    let context = try JSContext()
    _ = try context.evaluate("40 + 2")
}

test("ReferenceError exception") {
    let context = try JSContext()

    let message = """
        ReferenceError: "x" is not defined
            at main (:1)

        """

    expect(throws: Error(message: message)) {
        try context.evaluate("x()")
    }
}

test("SyntaxError exception") {
    let context = try JSContext()

    let message = "SyntaxError: Unexpected end of input in 1"
    expect(throws: Error(message: message)) {
        try context.evaluate("{")
    }
}

await run()
