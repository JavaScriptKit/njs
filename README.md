# NJS

[njs](https://nginx.org/en/docs/njs/) is a subset of the JavaScript language that allows extending nginx functionality. njs is created in compliance with ECMAScript 5.1 (strict mode) with some ECMAScript 6 and later extensions. The compliance is still evolving.

## Usage

```swift
let context = try JSContext()

let result = try context.evaluate("40 + 2")
assertEqual(try result.toString(), "42")

let sef = """
    (function(){
      return { property: 'test' }
    })()
    """
let object = try context.evaluate(sef)
assertEqual(try object["property"]?.toString(), "test")
```

### Building njs from source

```
git clone https://github.com/nginx/njs
cd njs
./configure
make -j8
```

### Useful commands

```bash
export NJS=/path/to/cloned/njs

./run_tests
```
