//
//  RegEx.swift
//  DRone
//
//  Created by Mihai Ocnaru on 29.08.2023.
//

import SwiftUI

func onlyStringValidation(string: String) -> Bool {
    return !string.isEmpty && containsOnlyLetters(string)
}

func containsOnlyNumbers(_ input: String) -> Bool {
    let regexPattern = "^[0-9]*$"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    let range = NSRange(location: 0, length: input.utf16.count)
    return regex.firstMatch(in: input, options: [], range: range) != nil
}

func containsOnlyLettersAndNumbers(_ input: String) -> Bool {
    let regexPattern = "^[a-zA-Z0-9]*$"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    let range = NSRange(location: 0, length: input.utf16.count)
    return regex.firstMatch(in: input, options: [], range: range) != nil
}

func containsOnlyLetters(_ input: String) -> Bool {
    let regexPattern = "^[a-zA-Z]*$"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    let range = NSRange(location: 0, length: input.utf16.count)
    return regex.firstMatch(in: input, options: [], range: range) != nil
}

func isValidEmail(_ email: String) -> Bool {
    let regexPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    let range = NSRange(location: 0, length: email.utf16.count)
    return regex.firstMatch(in: email, options: [], range: range) != nil
}

func containsSpecialCharacter(_ input: String) -> Bool {
    let regexPattern = "[!@#$%^&*()_+\\-=\\[\\]{};':\",.<>?/~\\\\]"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    let range = NSRange(location: 0, length: input.utf16.count)
    return regex.firstMatch(in: input, options: [], range: range) != nil
}

func containsNumbers(_ input: String) -> Bool {
    let regexPattern = "[0-9]*"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    let range = NSRange(location: 0, length: input.utf16.count)
    return regex.firstMatch(in: input, options: [], range: range) != nil
}

func containsLetters(_ input: String) -> Bool {
    let regexPattern = "[a-zA-Z]*"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    let range = NSRange(location: 0, length: input.utf16.count)
    return regex.firstMatch(in: input, options: [], range: range) != nil
}

func containsOnlyAlphanumericsAndSpecialChars(_ input: String) -> Bool {
    let alphanumericRegexPattern = "^[a-zA-Z0-9]*$"
    let specialCharRegexPattern = "^[!@#$%^&*()_+\\-=\\[\\]{};':\",.<>?/~\\\\]*$"
    
    let alphanumericRegex = try! NSRegularExpression(pattern: alphanumericRegexPattern)
    let specialCharRegex = try! NSRegularExpression(pattern: specialCharRegexPattern)
    
    for char in input {
        let charString = String(char)
        if alphanumericRegex.firstMatch(in: charString, options: [], range: NSRange(location: 0, length: charString.utf16.count)) == nil
            && specialCharRegex.firstMatch(in: charString, options: [], range: NSRange(location: 0, length: charString.utf16.count)) == nil {
            return false
        }
    }
    
    return true
}
