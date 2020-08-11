//
//  Constants.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation

struct K {
    struct cellNames {
        static let CountryTableViewCell = "CountryTableViewCell"
    }
    struct requests {
        static let tokenURL = "https://playground.tesonet.lt/v1/tokens"
        static let locationURL = "https://playground.tesonet.lt/v1/servers"
    }
    
    struct jsonIdentifiers {
        static let usernameIdentifier = "username"
        static let passwordIdentifier = "password"
        static let tokenIdentifier = "token"
        static let messageIdentifier = "message"
    }
    
    struct jsonValues {
        static let unauthorized = "Unauthorized"
    }
    
    struct segues {
        static let loginToServers = "LoginToServers"
    }
    
    struct responses {
        
    }
}
