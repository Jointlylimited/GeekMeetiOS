/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class QuestionnaireModel {
	public var udid : String?
	public var title : String?
	public var description : String?
	public var sort_order : Int?
	public var field_code : Int?
	public var is_mandatory : Bool?
	public var is_reportable : Bool?
	public var status : Int?
	public var response_set : Response_set?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [QuestionnaireModel]
    {
        var models:[QuestionnaireModel] = []
        for item in array
        {
            models.append(QuestionnaireModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		udid = dictionary["udid"] as? String
		title = dictionary["title"] as? String
		description = dictionary["description"] as? String
		sort_order = dictionary["sort_order"] as? Int
		field_code = dictionary["field_code"] as? Int
		is_mandatory = dictionary["is_mandatory"] as? Bool
		is_reportable = dictionary["is_reportable"] as? Bool
		status = dictionary["status"] as? Int
		if (dictionary["response_set"] != nil) { response_set = Response_set(dictionary: dictionary["response_set"] as! NSDictionary) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.udid, forKey: "udid")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.sort_order, forKey: "sort_order")
		dictionary.setValue(self.field_code, forKey: "field_code")
		dictionary.setValue(self.is_mandatory, forKey: "is_mandatory")
		dictionary.setValue(self.is_reportable, forKey: "is_reportable")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.response_set?.dictionaryRepresentation(), forKey: "response_set")

		return dictionary
	}

}

 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Response_set {
  public var udid : String?
  public var response_option : Array<Response_option>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let response_set_list = Response_set.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Response_set Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Response_set]
    {
        var models:[Response_set] = []
        for item in array
        {
            models.append(Response_set(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let response_set = Response_set(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Response_set Instance.
*/
  required public init?(dictionary: NSDictionary) {

    udid = dictionary["udid"] as? String
    if (dictionary["response_option"] != nil) { response_option = Response_option.modelsFromDictionaryArray(array: dictionary["response_option"] as! NSArray) }
  }

    
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
  public func dictionaryRepresentation() -> NSDictionary {

    let dictionary = NSMutableDictionary()

    dictionary.setValue(self.udid, forKey: "udid")

    return dictionary
  }

}

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Response_option {
  public var udid : String?
  public var name : String?
  public var sort_order : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let response_option_list = Response_option.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Response_option Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Response_option]
    {
        var models:[Response_option] = []
        for item in array
        {
            models.append(Response_option(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let response_option = Response_option(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Response_option Instance.
*/
  required public init?(dictionary: NSDictionary) {

    udid = dictionary["udid"] as? String
    name = dictionary["name"] as? String
    sort_order = dictionary["sort_order"] as? Int
  }

    
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
  public func dictionaryRepresentation() -> NSDictionary {

    let dictionary = NSMutableDictionary()

    dictionary.setValue(self.udid, forKey: "udid")
    dictionary.setValue(self.name, forKey: "name")
    dictionary.setValue(self.sort_order, forKey: "sort_order")

    return dictionary
  }

}
