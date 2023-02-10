//
//  UITextFieldDelegate+Extension.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 10.02.2023.
//

import UIKit

// MARK: - Маска для телефонного номера +7(ххх)ххх-хх-хх
extension UITextFieldDelegate {
    func phoneMask(phoneField: UITextField, textField: UITextField, _ range: NSRange, _ string: String) -> (
        result: Bool, phoneNumber: String, maskPhoneNumber: String
    ) {
        let maxCharInPhoneNumber = 11
        let oldString = textField.text ?? ""
        let newString = (oldString as NSString).replacingCharacters(in: range, with: string)
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let numString = components.joined(separator: "")

        let lenght = numString.count

        if newString.count < oldString.count {
            if newString.count <= 2 {
                phoneField.text = ""
            } else {
                return (true, numString, newString)
            }
        }

        if lenght > maxCharInPhoneNumber {
            return (false, numString, newString)
        }

        var indexStart: String.Index
        var indexEnd: String.Index
        var maskString = ""
        var template = ""
        var endOffset = 0

        if newString == "+" {
            maskString += "+"
        }

        if lenght > 0 {
            maskString += "+"
            indexStart = numString.index(numString.startIndex, offsetBy: 0)
            indexEnd = numString.index(numString.startIndex, offsetBy: 1)
            maskString += String(numString[indexStart..<indexEnd]) + "("
        }

        if lenght > 1 {
            endOffset = 4
            template = ")"

            if lenght < 4 {
                endOffset = lenght
                template = ""
            }

            indexStart = numString.index(numString.startIndex, offsetBy: 1)
            indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
            maskString += String(numString[indexStart..<indexEnd]) + template
        }

        if lenght > 4 {
            endOffset = 7
            template = "-"

            if lenght < 7 {
                endOffset = lenght
                template = ""
            }

            indexStart = numString.index(numString.startIndex, offsetBy: 4)
            indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
            maskString += String(numString[indexStart..<indexEnd]) + template
        }

        if lenght > 7 {
            endOffset = 9
            template = "-"

            if lenght < 9 {
                endOffset = lenght
                template = ""
            }

            indexStart = numString.index(numString.startIndex, offsetBy: 7)
            indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
            maskString += String(numString[indexStart..<indexEnd]) + template
        }

        if lenght > 9 {
            indexStart = numString.index(numString.startIndex, offsetBy: 9)
            indexEnd = numString.index(numString.startIndex, offsetBy: lenght)
            maskString += String(numString[indexStart..<indexEnd])
        }

        phoneField.text = maskString

        if lenght == maxCharInPhoneNumber {
            phoneField.endEditing(true)
        }

        return (false, numString, newString)
    }
}
