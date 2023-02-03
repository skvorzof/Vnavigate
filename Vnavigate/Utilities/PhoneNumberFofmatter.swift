//
//  PhoneNumberFofmatter.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import Foundation

final class PhoneNumberFofmatter {
    static let shared = PhoneNumberFofmatter()

    private init() {}

    func formatter(mask: String, phoneNumber: String) -> String {
        let number = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex

        for char in mask where index < number.endIndex {
            if char == "#" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
}
