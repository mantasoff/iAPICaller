//
//  KeychainManager.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-27.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainManager {
    private let service: String
    
    init(service: String) {
        self.service = service
    }
    
    public func setPassword(_ password: String?, key: String) {
        let keychain = Keychain(service: service)
        keychain[key] = password
    }
    
    public func getPassword(key: String) -> String? {
        let keychain = Keychain(service: service)
        if let password = keychain[key] {
            return password
        }
        print("Password for key: \(key) could not be found!")
        return nil
    }
}
