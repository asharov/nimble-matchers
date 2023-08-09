import Nimble
import Quick
@testable import AsharovNimbleMatchers

struct CustomType: Equatable {
  let outerValue: String
  let innerValue: String
}

extension CustomType: Codable {
  private enum OuterCodingKeys: CodingKey {
    case outer
    case nested
  }
  private enum InnerCodingKeys: CodingKey {
    case inner
  }

  init(from decoder: Decoder) throws {
    let outerContainer = try decoder.container(keyedBy: OuterCodingKeys.self)
    outerValue = try outerContainer.decode(String.self, forKey: .outer)
    let innerContainer = try outerContainer.nestedContainer(keyedBy: InnerCodingKeys.self, forKey: .nested)
    innerValue = try innerContainer.decode(String.self, forKey: .inner)
  }

  func encode(to encoder: Encoder) throws {
    var outerContainer = encoder.container(keyedBy: OuterCodingKeys.self)
    try outerContainer.encode(outerValue, forKey: .outer)
    var innerContainer = outerContainer.nestedContainer(keyedBy: InnerCodingKeys.self, forKey: .nested)
    try innerContainer.encode(innerValue, forKey: .inner)
  }
}

struct BrokenCustomType: Equatable {
  let value: String
}

extension BrokenCustomType: Codable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    value = String(try container.decode(String.self).reversed())
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

let testString = "String"
let testStringJson = "\"String\"".data(using: .utf8)!
let testInt = 12345
let testIntJson = "12345".data(using: .utf8)!
let testArray = [1, 2, 3, 4, 5]
let testArrayJson = "[1, 2, 3, 4, 5]".data(using: .utf8)!
let testDictionary = [
  "key1": 1, "key2": 2, "keyNil": nil
]
let testDictionaryJson = """
{
  "key1": 1,
  "key2": 2,
  "key3": null
}
""".data(using: .utf8)!
let customValue = CustomType(outerValue: "Outer", innerValue: "Inner")
let customValueJson = """
{
  "outer": "Outer",
  "nested": {
    "inner": "Inner"
  }
}
""".data(using: .utf8)!
let brokenCustomValue = BrokenCustomType(value: "Broken")
let brokenCustomValueJson = "\"Broken\"".data(using: .utf8)!

final class AsharovNimbleMatchersTests: QuickSpec {
  override class func spec() {
    describe("Encode-decode cycle") {
      it("should round-trip string") {
        expect(testString).to(roundTripThroughJson())
      }
      it("should round-trip int") {
        expect(testInt).to(roundTripThroughJson())
      }
      it("should round-trip array") {
        expect(testArray).to(roundTripThroughJson())
      }
      it("should round-trip dictionary") {
        expect(testDictionary).to(roundTripThroughJson())
      }
      it("should round-trip custom type") {
        expect(customValue).to(roundTripThroughJson())
      }
      it("should not round-trip when Codable implementation is incorrect") {
        expect(brokenCustomValue).toNot(roundTripThroughJson())
      }
    }
    describe("Decode-encode cycle") {
      it("should round-trip string") {
        expect(testStringJson).to(roundTripFromJson(throughType: String.self))
      }
      it("should round-trip int") {
        expect(testIntJson).to(roundTripFromJson(throughType: Int.self))
      }
      it("should round-trip array") {
        expect(testArrayJson).to(roundTripFromJson(throughType: Array<Int>.self))
      }
      it("should round-trip dictionary") {
        expect(testDictionaryJson).to(roundTripFromJson(throughType: Dictionary<String, Int?>.self))
      }
      it("should round-trip custom type") {
        expect(customValueJson).to(roundTripFromJson(throughType: CustomType.self))
      }
      it("should not round-trip when Codable implementation is incorrect") {
        expect(brokenCustomValueJson).toNot(roundTripFromJson(throughType: BrokenCustomType.self))
      }
    }
  }
}
