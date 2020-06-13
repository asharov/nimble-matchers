# Miscellaneous Nimble Matchers

[![Build Status](https://travis-ci.com/asharov/nimble-matchers.svg?branch=master)](https://travis-ci.com/asharov/nimble-matchers)
[![codecov](https://codecov.io/gh/asharov/nimble-matchers/branch/master/graph/badge.svg)](https://codecov.io/gh/asharov/nimble-matchers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

I prefer to use [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) for
testing in my Swift projects. And sometimes I write my own matchers for Nimble when there is nothing
suitable in the predefined matchers. This library collects some generally useful matchers I've written.

## Codable Round-Trip Verification

When implementing a custom conformance to `Codable`, it's useful to verify that there are no mistakes in
the implementation. A simple check that helps a lot is to verify that a decode-encode cycle and an
encode-decode cycle produce output equivalent to the input. The two matchers `roundTripFromJson` and
`roundTripThroughJson` perform these checks.

`roundTripFromJson(throughType:)` is used on `Data` values that represent an encoded JSON form. It will
decode the `Data` into a value of the type given as a parameter, encode this value into JSON, and
verify that the initial `Data` and the encoded result are equal as JSON.

`roundTripThroughJson()` is used on values of your own type. It will encode the value into JSON, decode
the JSON into a value of the original type, and verify that the initial value and decoded value are
equal. This requires the custom type to also conform to `Equatable`, so that the equality check can be
performed.

As an example, the following code shows how to verify the `Codable` implementation for `MyType`.
```swift
struct MyType: Codable, Equatable { // Equatable conformance not needed for roundTripFromJson
	...
}

let value: MyType = ...
let encodedJson = "...".data(using: .utf8)!

expect(encodedJson).to(roundTripFromJson(throughType: MyType.self))
expect(value).to(roundTripThroughJson())
```
