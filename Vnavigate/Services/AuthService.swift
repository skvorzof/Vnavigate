//
//  AuthService.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 07.02.2023.
//

import FirebaseAuth
import Foundation

enum AuthResult<T> {
    case success(T)
    case failure(Error)
}

final class AuthService {

    static let shared = AuthService()
    private var verificationId: String?

    private init() {}

    func startAuth(phoneNumber: String, completion: @escaping (AuthResult<Bool>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(.failure(error!))
                return
            }

            self?.verificationId = verificationId
            completion(.success(true))
        }
    }

    func verifyCode(smsCode: String, complition: @escaping (AuthResult<Bool>) -> Void) {
        guard let verificationId = verificationId else {
            complition(.failure(CustomError.unownedError))
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)

        Auth.auth().signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                complition(.failure(error!))
                return
            }

            complition(.success(true))
        }
    }
}
