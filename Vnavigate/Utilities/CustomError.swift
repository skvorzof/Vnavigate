//
//  CustomError.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 07.02.2023.
//

import Foundation

enum CustomError {
    case fileNotFound
    case decodeError
    case unownedError
    case coreDataSaveError
    case coreDataFetchError
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return NSLocalizedString("Json файл не найден", comment: "")
        case .decodeError:
            return NSLocalizedString("Ошибка декодирования", comment: "")
        case .unownedError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .coreDataSaveError:
            return NSLocalizedString("Ошибка сохранения в базе", comment: "")
        case .coreDataFetchError:
            return NSLocalizedString("Ошибка запроса из базы", comment: "")
        }
    }
}
