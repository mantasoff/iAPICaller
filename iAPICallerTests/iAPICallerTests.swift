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
        let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)
        let expecation = expectation(description: "API Caller testing to see if it gives a positive result")
        
        APICaller().callAPI(with: request, responseParser: nil) { (data, errorText) in
            XCTAssertNil(errorText)
            expecation.fulfill()
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
        serverBrain.fetchToken { (token) in
            XCTAssertNotNil(token)
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 2)
    }
    
    
}
