//
//  Validators.swift
//  SwiftValidators
//
//  Created by Γιώργος Καϊμακάς on 7/22/15.
//  Copyright (c) 2015 Γιώργος Καϊμακάς. All rights reserved.
//

import Foundation

public protocol ValueProvider {
    var value: String { get }
}

public protocol StringConvertible {
    var string: String? { get }
}

public func ==(lhs: StringConvertible, rhs: StringConvertible) -> Bool{
    return lhs.string == rhs.string
}

public func !=(lhs: StringConvertible, rhs: StringConvertible) -> Bool {
    return lhs.string != rhs.string
}

public func || (lhs: Validator, rhs: Validator) -> Validator {
	return Validator { (value: StringConvertible?) -> Bool in
		return lhs.apply(value) || rhs.apply(value)
	}
}

public func && (lhs: Validator, rhs: Validator) -> Validator {
	return Validator { (value: StringConvertible?) -> Bool in
		return lhs.apply(value) && rhs.apply(value)
	}
}

public prefix func ! (rhs: Validator) -> Validator {
	return Validator{ (value: StringConvertible?) -> Bool in
		return !rhs.apply(value)
	}
}

public class Validator {

    /**
    Checks if the seed contains the value

    - parameter seed:
    - returns: Validator
    */
	public static func contains(_ string: String, nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
			
            return value.range(of: string) != nil
        }
    }

    /**
    Checks if the seed is equal to the value

    - parameter seed:
    - returns: Validator
    */
	public static func equals(_ string: String, nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
            return value == string
        }
    }

    /**
    Checks if it has the exact length

    - parameter length:
    - returns: Validator
    */
	public static func exactLength(_ length: Int, nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
            return value.count == length ? true : false
        }
    }
    
    /**
    Checks if it is a valid ascii string
    
    - returns: Validator
    */
	public static func isASCII(nilResponse:Bool = false) -> Validator {
		return self.regex(Regex.ASCIIRegex, nilResponse: nilResponse)
    }

    /**
    Checks if it is after the date

    - parameter date: The date to check
	- parameter format: The format of the date. Defaults to `dd/MM/yyyy`
	
    - returns: Validator
    */
	public static func isAfter(_ date: String, format: String = "dd/MM/yyyy", nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = format
			let startDate: Date? = dateFormatter.date(from: date)
			
            let date: Date? = dateFormatter.date(from: value)
            if let _date = date {
                let comparison = _date.compare(startDate!)
                switch (comparison) {
                case ComparisonResult.orderedAscending:
                    return false
                case ComparisonResult.orderedSame:
                    return true
                case ComparisonResult.orderedDescending:
                    return true
                }
            } else {
                return false
            }

        }
    }
    
    /**
    Checks if it has only letters
    
    - returns: Validator
    */
    public static func isAlpha(nilResponse:Bool = false) -> Validator {
		return regex(Regex.AlphaRegex, nilResponse: nilResponse)
    }
    
    /**
    Checks if it has letters and numbers only
    
    - returns: Validator
    */
    public static func isAlphanumeric(nilResponse:Bool = false) -> Validator {
		return regex(Regex.AlphanumericRegex, nilResponse: nilResponse)
    }
    
    /**
    Checks if it a valid base64 string
    
    - returns: Validator
    */
    public static func isBase64(nilResponse:Bool = false) -> Validator {
		return self.regex(Regex.Base64Regex, nilResponse: nilResponse)
    }

    /**
    Checks if it is before the date

    - parameter date: A date as a string
    - returns: Validator
    */
	public static func isBefore(_ date: String, format: String = "dd/MM/yyyy", nilResponse:Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = format
			let startDate: Date? = dateFormatter.date(from: date)
            let date: Date? = dateFormatter.date(from: value)
            if let _date = date {
                let comparison = _date.compare(startDate!)
                switch (comparison) {
                case ComparisonResult.orderedAscending:
                    return true
                case ComparisonResult.orderedSame:
                    return true
                case ComparisonResult.orderedDescending:
                    return false
                }
            } else {
                return false
            }

        }
    }
    
    /**
    Checks if it is boolean
    
    - returns: Validator
    */
    public static func isBool(nilResponse:Bool = false) -> Validator {
		return self.isTrue(nilResponse: nilResponse) || self.isFalse(nilResponse: nilResponse)
    }

    /**
    Checks if it is a credit card number
    
    - returns: Validator
    */
	public static func isCreditCard(nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) in
			
			guard let value = value?.string else { return nilResponse }

            let test = NSPredicate(format: "SELF MATCHES %@", Regex.CreditCardRegex)
            var clearValue = self.removeDashes(value)
            clearValue = self.removeSpaces(clearValue)
            return test.evaluate(with: clearValue)
        }
    }

    /**
    Checks if it is a valid date
	
    - parameter format: The expected format of the date. Defaults to `dd/MM/yyyy`
	
    - returns: Validator
	
    */
	public static func isDate(_ format: String = "dd/MM/yyyy", nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			
			guard let value = value?.string else { return nilResponse }
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = format
            let date: Date? = dateFormatter.date(from: value)
            if let _ = date {
                return true
            } else {
                return false
            }

        }
    }
    
    /**
    Checks if it is an email
    
    - returns: Validator
    */
    public static func isEmail(nilResponse: Bool = false) -> Validator {
		return self.regex(Regex.EmailRegex, nilResponse: nilResponse)
    }

    /**
    Checks if it is an empty string
    
    - returns: Validator
    */
    public static func isEmpty(nilResponse: Bool = false) -> Validator {
		return equals("", nilResponse: nilResponse)
    }

    /**
    Checks if it is fully qualified domain name

    - parameter options: An instance of FDQNOptions
    - returns: Validator
    */
	public static func isFQDN(_ options: FQDNOptions = FQDNOptions.defaultOptions, nilResponse: Bool = false) -> Validator {
		return Validator{ (value: StringConvertible?) in
			
			guard let value = value?.string else { return nilResponse }

            var string = value
            if options.allowTrailingDot && string.last == Character(".") {
//				string = string.substring(with: string.characters.index(string.startIndex, offsetBy: 0) ..< string.characters.index(string.startIndex, offsetBy: string.length))

				let _subscript = string[string.startIndex..<string.index(string.startIndex, offsetBy: string.count)]
				string = String(_subscript)
            }

            var parts = string.split(omittingEmptySubsequences: false) {
                $0 == "."
            }.map { String($0) }

            if (options.requireTLD) {
                let tld = parts.removeLast()
                if (parts.count == 0 || !self.regex("([a-z\u{00a1}-\u{ffff}]{2,}|xn[a-z0-9-]{2,})").apply(tld) ){
                    return false
                }
            }

            for part in parts {
                var _part = part
                if options.allowUnderscores {
                    _part = self.removeUnderscores(_part)
                }

                if !self.regex("[a-z\u{00a1}-\u{ffff0}0-9-]+").apply(_part) {
                    return false
                }

                if _part[0] == "-" || _part.last == Character("-")  {
                    return false
                }
            }

            return true
        }
    }
    
    /**
    Checks if it is false
    
    - returns: Validator
    */
	public static func isFalse(nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) in
			guard let value = value?.string else { return nilResponse }
			
            return value.lowercased() == "false"
        }
    }

    /**
    Checks if it is a float number
    
    - returns: Validator
    */
    public static func isFloat(nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) in
			guard let value = value?.string else { return nilResponse }
            return self.regex(Regex.FloatRegex).apply(value)
        }
    }
	
	/**
	Checks if it is a hexadecimal value
	
	- returns: Validator
	*/
	public static func isHexadecimal(nilResponse: Bool = false) -> Validator {
		return Validator { (value: StringConvertible?) in
			guard let value = value?.string else { return nilResponse }
			let newValue = value.uppercased()
			return self.regex(Regex.HexadecimalRegex, nilResponse: nilResponse).apply(newValue)
		}
	}
	
    /**
    Checks if it is a valid hex color
    
    - returns: Validator
    */
    public static func isHexColor(nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) in
			guard let value = value?.string else { return nilResponse }
			
            let test = NSPredicate(format: "SELF MATCHES %@", Regex.HexColorRegex)
            let newValue = value.uppercased()
            let result = test.evaluate(with: newValue)
            return result
        }
    }
    
    /**
    Checks if it is a valid IP (v4 or v6)
    
    - returns: Validator
    */
    public static func isIP(nilResponse: Bool = false) -> Validator {
		return isIPv4(nilResponse: nilResponse) || isIPv6(nilResponse: nilResponse)
    }

    
    /**
    Checks if it is a valid IPv4
    
    - returns: Validator
    */
	
	public static func isIPv4(nilResponse: Bool = false) -> Validator {
		return regex(Regex.IPRegex["4"]!, nilResponse: nilResponse)
    }
    
    /**
    Checks if it is a valid IPv6
    
    - returns: Validator
    */
    public static func isIPv6(nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) in
			guard let value = value?.string else { return nilResponse }
            let string: String = self.removeDashes(self.removeSpaces(value))
            var blocks = string.split(omittingEmptySubsequences: false) {
                $0 == ":"
            }.map { String($0) }

            var foundOmissionBlock = false // marker to indicate ::

            // At least some OS accept the last 32 bits of an IPv6 address
            // (i.e. 2 of the blocks) in IPv4 notation, and RFC 3493 says
            // that '::ffff:a.b.c.d' is valid for IPv4-mapped IPv6 addresses,
            // and '::a.b.c.d' is deprecated, but also valid.
			
            let foundIPv4TransitionBlock = (blocks.count > 0 ? Validator.isIPv4(nilResponse: nilResponse).apply(blocks[blocks.count - 1]) : false)
            let expectedNumberOfBlocks = (foundIPv4TransitionBlock ? 7 : 8)

            if (blocks.count > expectedNumberOfBlocks) {
                return false
            }


            if (string == "::") {
                return true
            } else if (String(string[string.startIndex..<string.index(string.startIndex, offsetBy: 2)]) == "::") {
                blocks.remove(at: 0)
                blocks.remove(at: 0)
                foundOmissionBlock = true
            } else if (String(String(string.reversed())[string.startIndex..<string.index(string.startIndex, offsetBy: 2)]) == "::") {
                blocks.removeLast()
                blocks.removeLast()
                foundOmissionBlock = true
            }

            for i in 0 ..< blocks.count {
                if (blocks[i] == "" && i > 0 && i < blocks.count - 1) {
                    if (foundOmissionBlock) {
                        return false
                    }
                    foundOmissionBlock = true
                } else if (foundIPv4TransitionBlock && i == blocks.count - 1) {

                } else if (!self.regex(Regex.IPRegex["6"]!, nilResponse: nilResponse).apply(blocks[i])) {
                    return false
                }
            }

            if (foundOmissionBlock) {
                return blocks.count >= 1
            } else {
                return blocks.count == expectedNumberOfBlocks
            }
        }
    }
    
    /**
    Checks if it is a valid ISBN

    - parameter version: ISBN version "10" or "13"
    - returns: Validator
    */
    /*
	public static func isISBN(_ version: ISBN, nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) in
			guard let value = value?.string else { return nilResponse }
			
            var sanitized = self.removeDashes(value)
            sanitized = self.removeSpaces(sanitized)
            let regexTest: Bool = self.regex(Regex.ISBNRegex[version.rawValue]!).apply(sanitized)
            if (regexTest == false) {
                return false
            }

            var checkSum: Int = 0
            if (version.rawValue == "10") {

                for i in 0 ..< 9 {
                    checkSum += (i + 1) * Int("\(sanitized[sanitized.index(sanitized.startIndex, offsetBy: i)])")!
                }

                if ("\(sanitized[sanitized.index(sanitized.startIndex, offsetBy: 9)])".lowercased() == "x") {
                    checkSum += 10 * 10
                } else {
                    checkSum += 10 * Int("\(sanitized[sanitized.index(sanitized.startIndex, offsetBy: 9)])")!
                }

                if (checkSum % 11 == 0) {
                    return true
                }

            } else if (version.rawValue == "13") {
                var factor = [1, 3]
                for i in 0 ..< 12 {
                    let charAt: Int = Int("\(sanitized[sanitized.index(sanitized.startIndex, offsetBy: i)])")!
                    checkSum += factor[i % 2] * charAt
                }

                let charAt12 = Int("\(sanitized[sanitized.index(sanitized.startIndex, offsetBy: 12)])")!
                if ((charAt12 - ((10 - (checkSum % 10)) % 10)) == 0) {
                    return true
                }
            }

            return false
        }
    }*/
    
    /**
    Checks if the value exists in the supplied array

    - parameter array: An array of strings
    - returns: Validator
    */
	public static func isIn(_ array: Array<String>, nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			
			guard let value = value?.string else { return nilResponse }
			
			return array
				.firstIndex(of: value) != nil
        }
    }

    /**
    Checks if it is a valid integer
    
    - returns: Validator
    */
    public static func isInt(nilResponse: Bool = false) -> Validator {
		return isNumeric(nilResponse: nilResponse)
    }

    /**
    Checks if it only has lowercase characters
    
    - returns: Validator
    */
    public static func isLowercase(nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			
			guard let value = value?.string else { return nilResponse }
			
            return value == value.lowercased()
        }
    }

    /**
    Checks if it is a hexadecimal mongo id
    
    - returns: Validator
    */
    public static func isMongoId(nilResponse: Bool = false) -> Validator {
		return isHexadecimal(nilResponse: nilResponse) && exactLength(24, nilResponse: nilResponse)
	}
	
	/**
	Checks if it is nil
	
	- returns: Validator
	*/
	
	public static func isNil() -> Validator {
		return Validator { (value: StringConvertible?) -> Bool in
			return value?.string == nil
		}
	}
	
    /**
    Checks if it is numeric
    
    - returns: Validator
    */
    public static func isNumeric(nilResponse: Bool = false) -> Validator {
		return regex(Regex.NumericRegex, nilResponse: nilResponse)
    }
    
    /**
    Checks if is is a valid phone

    - parameter locale: The locale as a String. Available locales are 'zh-CN', 'en-ZA', 'en-AU', 'en-HK', 'pt-PT', 'fr-FR', 'el-GR', 'en-GB', 'en-US', 'en-ZM', 'ru-RU
    - returns: (String)->Bool
    */
    public static func isPhone(_ locale: Phone, nilResponse: Bool = false) -> Validator {
      return regex(locale.rawValue, nilResponse: nilResponse)
    }

    /**
    Checks if postal code is valid

    - parameter country code:
    - returns (String)->Bool
    */
    public static func isPostalCode(_ countryCode: PostalCode, nilResponse: Bool = false) -> Validator {
      return regex(countryCode.rawValue, nilResponse: nilResponse)
    }

    /**
    Checks if it is true
    
    - returns: Validator
    */
    public static func isTrue(nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) in
			guard let value = value?.string else { return nilResponse }
			
            return value.lowercased() == String(true)
        }
    }

    /**
    Checks if it is a valid UUID
    
    - returns: Validator
    */
	public static func isUUID(nilResponse: Bool = false) -> Validator {
		return Validator { (value: StringConvertible?) in
			
			guard let value = value?.string else { return nilResponse }

            let uuid = UUID(uuidString: value)
            if let _ = uuid {
                return true
            }

            return false

        }
    }

    /**
    Checks if it has only uppercase letters
    
    - returns: Validator
    */
	public static func isUppercase(nilResponse: Bool = false) -> Validator {
		return Validator { (value: StringConvertible?) -> Bool in
			
			guard let value = value?.string else { return nilResponse }
            return value == value.uppercased()
        }
    }
    
    /**
    Checks if the length does not exceed the max length

    - parameter length: The max length
    - returns: Validator
    */
    public static func maxLength(_ length: Int, nilResponse: Bool = false) -> Validator {
        return Validator {(value: StringConvertible?) -> Bool in
	
			guard let value = value?.string else { return nilResponse }
            return value.count <= length ? true : false
        }
    }
    
    /**
    Checks if the length isn't lower than

    - parameter length: The min length
    - returns: Validator
    */
	public static func minLength(_ length: Int, nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			
			guard let value = value?.string else { return nilResponse }
            return value.count >= length ? true : false
        }
    }
	
	/**
	check if the value fullfils the pattern. The value is matched from start to finish with the regex.
	
	- parameter pattern: The regex to check
	- returns: (StringConvertible) -> Bool
	*/
	public static func regex(_ pattern: String, nilResponse: Bool = false) -> Validator {
		return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
			let regexText = NSPredicate(format: "SELF MATCHES %@", pattern)
			return regexText.evaluate(with: value)
		}
	}

	
    /**
    Checks if it is not an empty string

    - returns: Validator
    */
	
	public static func required(nilResponse: Bool = false) -> Validator {
		return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
			return value != ""
			
		}
    }
    
    /**
     watch the validator protocol implementor for changes
     
     -parameter delegate: The validator protocol implementor
     - returns: Validator
     */
	
	public static func watch(_ delegate: ValueProvider, nilResponse: Bool = false) -> Validator {
        return Validator { (value: StringConvertible?) -> Bool in
			guard let value = value?.string else { return nilResponse }
            return value.string == delegate.value
        }
    }
	
    fileprivate static func removeSpaces(_ value: String) -> String {
        return self.removeCharacter(value, char: " ")
    }

    fileprivate static func removeDashes(_ value: String) -> String {
        return self.removeCharacter(value, char: "-")
    }

    fileprivate static func removeUnderscores(_ value: String) -> String {
        return self.removeCharacter(value, char: "_")
    }

    fileprivate static func removeCharacter(_ value: String, char: String) -> String {
        return value.replacingOccurrences(of: char, with: "")
    }
    
    private let validator: (StringConvertible?) -> Bool
    
    public init(_ validator: @escaping (StringConvertible?) -> Bool) {
        self.validator = validator
    }
    
    public func apply(_ value: StringConvertible?) -> Bool {
        return self.validator(value)
    }
}

public class FQDNOptions {
    public static let defaultOptions: FQDNOptions = FQDNOptions(requireTLD: true, allowUnderscores: false, allowTrailingDot: false)
    
    public let requireTLD: Bool
    public let allowUnderscores: Bool
    public let allowTrailingDot: Bool
    
    public init(requireTLD: Bool, allowUnderscores: Bool, allowTrailingDot: Bool) {
        self.requireTLD = requireTLD
        self.allowUnderscores = allowUnderscores
        self.allowTrailingDot = allowTrailingDot
    }
}

public enum Phone: String {
    case ar_DZ = "(\\+?213|0)(5|6|7)\\d{8}"
    case ar_SY = "(!?(\\+?963)|0)?9\\d{8}"
    case ar_SA = "(!?(\\+?966)|0)?5\\d{8}"
    case cs_CZ = "(\\+?420)? ?[1-9][0-9]{2} ?[0-9]{3} ?[0-9]{3}"
    case de_DE = "(\\+?49[ \\.\\-])?([\\(]{1}[0-9]{1,6}[\\)])?([0-9 \\.\\-\\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?"
    case da_DK = "(\\+?45)?(\\d{8})"
    case en_US = "(\\+?1)?[2-9]\\d{2}[2-9](?!11)\\d{6}"
    case en_AU = "(\\+?61|0)4\\d{8}"
    case en_GB = "(\\+?44|0)7\\d{9}"
    case en_HK = "(\\+?852\\-?)?[569]\\d{3}\\-?\\d{4}"
    case en_IN = "(\\+?91|0)?[789]\\d{9}"
    case en_NZ = "(\\+?64|0)2\\d{7,9}"
    case en_ZA = "(\\+?27|0)\\d{9}"
    case en_ZM = "(\\+26)?09[567]\\d{7}"
    case es_ES = "(\\+?34)?(6\\d{1}|7[1234])\\d{7}"
    case fi_FI = "(\\+?358|0)\\s?(4(0|1|2|4|5)?|50)\\s?(\\d\\s?){4,8}\\d"
    case fr_FR = "(\\+?33|0)[67]\\d{8}"
    case hu_HU = "(\\+?36)(20|30|70)\\d{7}"
    case ms_MY = "(\\+?6?01){1}(([145]{1}(\\-|\\s)?\\d{7,8})|([236789]{1}(\\s|\\-)?\\d{7}))"
    case nb_NO = "(\\+?47)?[49]\\d{7}"
    case nl_BE_mobile = "(\\+324|00324|04)(\\d{9})"
    case nl_BE = "(\\+32|0032|0)([0-3,5-9]\\d{8})"
    case nl_NL = "(\\+31|0031|0)(\\d{9})"
    case pl_PL = "(\\+?48)? ?[5-8]\\d ?\\d{3} ?\\d{2} ?\\d{2}"
    case pt_BR = "(\\+?55|0)\\-?[1-9]{2}\\-?[2-9]{1}\\d{3,4}\\-?\\d{4}"
    case pt_PT = "(\\+351)?9[1236]\\d{7}"
    case ru_RU = "(\\+?7|8)?9\\d{9}"
    case tr_TR = "(\\+?90|0)?5\\d{9}"
    case vi_VN = "(\\+?84|0)?((1(2([0-9])|6([2-9])|88|99))|(9((?!5)[0-9])))([0-9]{7})"
    case zh_CN = "(\\+?0?86\\-?)?1[345789]\\d{9}"
    case zh_TW = "(\\+?886\\-?|0)?9\\d{8}"
    case el_GR = "(\\+30)?((2\\d{9})|(69\\d{8}))"
    
}

public enum PostalCode: String {
    case AR = "((?:[A-HJ-NP-Z])?\\d{4})([A-Z]{3})?"
    case BE = "[1-9]{1}[0-9]{3}"
    case CH, DK, HU, MD, NO, ZA = "([0-9]{4})"
    case BR = "\\d{5}-?\\d{3}"
    case CA = "[ABCEGHJKLMNPRSTVXY]\\d[ABCEGHJ-NPRSTV-Z] ?\\d[ABCEGHJ-NPRSTV-Z]\\d"
    case CN, IN, RO, RU = "\\d{6}"
    case CZ, GR, SK = "\\d{3} ?\\d{2}"
    case DE, EE, ES, FI, IT, KE, LT, MX, SA, UA = "\\d{5}"
    case FR = "\\d{2} ?\\d{3}"
    case GB = "GIR ?0AA|(?:(?:AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|BX|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(?:\\d[\\dA-Z]? ?\\d[ABD-HJLN-UW-Z]{2}))|BFPO ?\\d{1,4}"
    case IE = "[\\dA-Z]{3} ?[\\dA-Z]{4}"
    case JP = "\\d{3}-?\\d{4}"
    case LV = "LV-\\d{4}"
    case NL = "(\\d{4} ?[A-Z]{2})"
    case PL = "\\d{2}-\\d{3}"
    case PT = "\\d{4}-\\d{3}"
    case US = "(\\d{5})(?:[ \\-](\\d{4}))?"
}

public enum ISBN: String {
    case v10 = "10"
    case v13 = "13"
}

struct Regex {
    static let
    EmailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}",
    AlphaRegex: String = "[a-zA-Z]+",
    Base64Regex: String = "(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?",
    CreditCardRegex: String = "(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})",
    HexColorRegex: String = "#?([0-9A-F]{3}|[0-9A-F]{6})",
    HexadecimalRegex: String = "[0-9A-F]+",
    ASCIIRegex: String = "[\\x00-\\x7F]+",
    NumericRegex: String = "[-+]?[0-9]+",
    FloatRegex: String = "([\\+-]?\\d+)?\\.?\\d*([eE][\\+-]\\d+)?",
    IPRegex: [String:String] = [
        "4": "(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})",
        "6": "[0-9A-Fa-f]{1,4}"
    ],
    ISBNRegex: [String:String] = [
        "10": "(?:[0-9]{9}X|[0-9]{10})",
        "13": "(?:[0-9]{13})"
    ],
    AlphanumericRegex: String = "[\\d[A-Za-z]]+"
    
    private init() {}
}

internal extension String {
    subscript (i: Int) -> String{
        return "\(self[self.index(self.startIndex, offsetBy: i)])"
    }
}

extension Bool: StringConvertible {
    public var string: String? {
        return String(self)
    }
}

extension Double: StringConvertible {
    public var string: String? {
        return String(self)
    }
}

extension Float: StringConvertible {
    public var string: String? {
        return String(self)
    }
}

extension Int: StringConvertible {
    public var string: String? {
        return String(self)
    }
}

extension NSString {
    public var string: String {
        return self as String
    }
}

extension String: StringConvertible {
    public var string: String? {
        return self
    }
}

