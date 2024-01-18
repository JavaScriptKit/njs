import Test
@testable import NJS

test("isUndefined") {
    let context = try JSContext()

    let result = try context.evaluate("undefined")
    expect(result.isUndefined == true)
    expect(result.isNull == false)
    expect(result.isBool == false)
    expect(result.isNumber == false)
    expect(result.isString == false)
    expect(try result.toString() == "undefined")
}

test("isNull") {
    let context = try JSContext()
    let result = try context.evaluate("null")
    expect(result.isUndefined == false)
    expect(result.isNull == true)
    expect(result.isBool == false)
    expect(result.isNumber == false)
    expect(result.isString == false)
    expect(try result.toString() == "null")
}

test("isBool") {
    let context = try JSContext()
    let result = try context.evaluate("true")
    expect(result.isUndefined == false)
    expect(result.isNull == false)
    expect(result.isBool == true)
    expect(result.isNumber == false)
    expect(result.isString == false)
    expect(try result.toString() == "true")
    // expect(result.toBool(), true)
}

test("isNumber") {
    let context = try JSContext()
    let result = try context.evaluate("3.14")
    expect(result.isUndefined == false)
    expect(result.isNull == false)
    expect(result.isBool == false)
    expect(result.isNumber == true)
    expect(result.isString == false)
    expect(try result.toString() == "3.14")
    // expect(try result.toDouble(), 3.14)
}

test("isString") {
    let context = try JSContext()
    let result = try context.evaluate("'success'")
    expect(result.isUndefined == false)
    expect(result.isNull == false)
    expect(result.isBool == false)
    expect(result.isNumber == false)
    expect(result.isString == true)
    expect(try result.toString() == "success")
}

test("toInt") {
    let context = try JSContext()
    let result = try context.evaluate("40 + 2")
    expect(try result.toInt() == 42)
}

test("toString") {
    let context = try JSContext()
    let result = try context.evaluate("40 + 2")
    expect(try result.toString() == "42")
}

test("property") {
    let context = try JSContext()
    let result = try context.evaluate("""
    (function(){
        return { property: 'test' }
    })()
    """)

    expect(try result["property"]?.toString() == "test")
}

await run()
