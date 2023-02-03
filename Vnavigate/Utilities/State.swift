//
//  State.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import Foundation

enum State {
    case initial
    case loading
    case loaded
    case error(String)
}

enum Action {
    case initial
}
