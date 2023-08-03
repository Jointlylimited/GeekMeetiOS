//
//  BaseModel.swift
//
//  Created by SOTSYS203 on 20/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class BaseModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let responseMessage = "responseMessage"
    static let responseData = "responseData"
    static let responseCode = "responseCode"
  }

  // MARK: Properties
  public var responseMessage: String?
  public var responseData: ResponseData?
  public var responseCode: Int?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    responseMessage = json[SerializationKeys.responseMessage].string
    responseData = ResponseData(json: json[SerializationKeys.responseData])
    responseCode = json[SerializationKeys.responseCode].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = responseMessage { dictionary[SerializationKeys.responseMessage] = value }
    if let value = responseData { dictionary[SerializationKeys.responseData] = value.dictionaryRepresentation() }
    if let value = responseCode { dictionary[SerializationKeys.responseCode] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.responseMessage = aDecoder.decodeObject(forKey: SerializationKeys.responseMessage) as? String
    self.responseData = aDecoder.decodeObject(forKey: SerializationKeys.responseData) as? ResponseData
    self.responseCode = aDecoder.decodeObject(forKey: SerializationKeys.responseCode) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(responseMessage, forKey: SerializationKeys.responseMessage)
    aCoder.encode(responseData, forKey: SerializationKeys.responseData)
    aCoder.encode(responseCode, forKey: SerializationKeys.responseCode)
  }

}
