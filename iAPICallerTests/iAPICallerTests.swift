//
//  iAPICallerTests.swift
//  iAPICallerTests
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import XCTest
@testable import iAPICaller

class iAPICallerTests: XCTestCase {
    func testCorrectCallAPIs() {
        guard let url = URL(string: "https://www.apple.com") else {
            fatalError("Could not transform string https://www.apple.com to URL")
        }
        
        let request = URLRequest(url: url)
        let expecation = expectation(description: "API Caller testing to see if it gives a positive result")
        
        APICaller().callAPI(with: request, responseParser: nil)
        .done { response in
            expecation.fulfill()
        }
        .catch { error in
            XCTAssertNil(error)
        }
        
        wait(for: [expecation], timeout: 2)
    }
    
    func testServerFilter() {
        let serverBrain = ServerBrain()
        var servers = [Server(name: "Lithuania", distance: 4),
                       Server(name: "USA", distance: 5),
                       Server(name: "Lithuania", distance: 6)]
        serverBrain.servers = servers
        servers = serverBrain.filterServers(filter: "Lithuan")
        XCTAssertEqual(servers.count, 2)
    }
    
    func testTokenFetching() {
        let expecation = expectation(description: "Server testing to see if it returns a token")
        let serverBrain = ServerBrain()
        
        serverBrain.userName = "tesonet"
        serverBrain.password = "partyanimal"
        serverBrain.tokenURL = K.requests.tokenURL
        
        _ = serverBrain.fetchToken()
        .done { token in
            XCTAssertNotNil(token)
            expecation.fulfill()
        }.catch({ error in
            XCTAssertNil(error)
            expecation.fulfill()
        })
        
        wait(for: [expecation], timeout: 2)
    }
    
    
}
