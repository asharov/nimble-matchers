import Foundation
import Nimble

public func roundTripFromJson<T: Codable>(throughType type: T.Type) -> Matcher<Data> {
  return Matcher { (actualExpression: Nimble.Expression<Data>) throws -> MatcherResult in
    guard let initialData = try actualExpression.evaluate() else {
      return MatcherResult(status: .fail, message: .fail("expected a non-<nil> Data"))
    }
    let object = try JSONDecoder().decode(type, from: initialData)
    let encodedData = try JSONEncoder().encode(object)
    let initialJson =
      try JSONSerialization.jsonObject(with: initialData, options: .allowFragments) as! NSObject
    let encodedJson =
      try JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as! NSObject
    let message = ExpectationMessage.expectedCustomValueTo(
      "equal as JSON <\(String(data: initialData, encoding: .utf8)!)>",
      actual: String(data: encodedData, encoding: .utf8)!)
    return MatcherResult(bool: initialJson.isEqual(encodedJson), message: message)
  }
}

public func roundTripThroughJson<T: Codable & Equatable>() -> Matcher<T> {
  return Matcher { (actualExpression: Nimble.Expression<T>) throws -> MatcherResult in
    guard let object = try actualExpression.evaluate() else {
      return MatcherResult(status: .fail, message: .fail("expected a non-<nil> object"))
    }
    let json = try JSONEncoder().encode(object)
    let decodedObject = try JSONDecoder().decode(T.self, from: json)
    let message = ExpectationMessage.expectedCustomValueTo(
      "equal <\(String(describing: object))>", actual: String(describing: decodedObject))
    return MatcherResult(bool: decodedObject == object, message: message)
  }
}
