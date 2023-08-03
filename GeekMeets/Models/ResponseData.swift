//
//  ResponseData.swift
//
//  Created by SOTSYS203 on 20/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ResponseData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let vLastName = "vLastName"
    static let profileUrl = "profileUrl"
    static let imageBaseUrl = "imageBaseUrl"
    static let iUserId = "iUserId"
    static let vAuthKey = "vAuthKey"
    static let vFirstName = "vFirstName"
    static let vEmailId = "vEmailId"
  }

  // MARK: Properties
  public var vLastName: String?
  public var profileUrl: [ProfileUrl]?
  public var imageBaseUrl: String?
  public var iUserId: Int?
  public var vAuthKey: String?
  public var vFirstName: String?
  public var vEmailId: String?

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
    vLastName = json[SerializationKeys.vLastName].string
    if let items = json[SerializationKeys.profileUrl].array { profileUrl = items.map { ProfileUrl(json: $0) } }
    imageBaseUrl = json[SerializationKeys.imageBaseUrl].string
    iUserId = json[SerializationKeys.iUserId].int
    vAuthKey = json[SerializationKeys.vAuthKey].string
    vFirstName = json[SerializationKeys.vFirstName].string
    vEmailId = json[SerializationKeys.vEmailId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = vLastName { dictionary[SerializationKeys.vLastName] = value }
    if let value = profileUrl { dictionary[SerializationKeys.profileUrl] = value.map { $0.dictionaryRepresentation() } }
    if let value = imageBaseUrl { dictionary[SerializationKeys.imageBaseUrl] = value }
    if let value = iUserId { dictionary[SerializationKeys.iUserId] = value }
    if let value = vAuthKey { dictionary[SerializationKeys.vAuthKey] = value }
    if let value = vFirstName { dictionary[SerializationKeys.vFirstName] = value }
    if let value = vEmailId { dictionary[SerializationKeys.vEmailId] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.vLastName = aDecoder.decodeObject(forKey: SerializationKeys.vLastName) as? String
    self.profileUrl = aDecoder.decodeObject(forKey: SerializationKeys.profileUrl) as? [ProfileUrl]
    self.imageBaseUrl = aDecoder.decodeObject(forKey: SerializationKeys.imageBaseUrl) as? String
    self.iUserId = aDecoder.decodeObject(forKey: SerializationKeys.iUserId) as? Int
    self.vAuthKey = aDecoder.decodeObject(forKey: SerializationKeys.vAuthKey) as? String
    self.vFirstName = aDecoder.decodeObject(forKey: SerializationKeys.vFirstName) as? String
    self.vEmailId = aDecoder.decodeObject(forKey: SerializationKeys.vEmailId) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(vLastName, forKey: SerializationKeys.vLastName)
    aCoder.encode(profileUrl, forKey: SerializationKeys.profileUrl)
    aCoder.encode(imageBaseUrl, forKey: SerializationKeys.imageBaseUrl)
    aCoder.encode(iUserId, forKey: SerializationKeys.iUserId)
    aCoder.encode(vAuthKey, forKey: SerializationKeys.vAuthKey)
    aCoder.encode(vFirstName, forKey: SerializationKeys.vFirstName)
    aCoder.encode(vEmailId, forKey: SerializationKeys.vEmailId)
  }

}
