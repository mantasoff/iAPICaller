//
//  APICaller.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation
import PromiseKit
struct APICaller {
    
    //MARK: - API Request functions
    func callAPI(with request: URLRequest,
                 sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default,
                 responseParser:  ((Data) -> (Any))?) -> Promise<Any?> {
        return Promise { seal in
            let session = URLSession(configuration: sessionConfiguration)
        
            let task = session.dataTask(with: request) { data, response, error in
                if (error != nil) {
                    print(error!.localizedDescription)
                    seal.reject(error!)
                    return
                }
            
                if let safeResponse = response, self.isError(response: safeResponse) {
                    let HTTPresponse = safeResponse as? HTTPURLResponse
                    let responseError = NSError(domain: "APICaller", code: HTTPresponse?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                    seal.reject(responseError)
                    return
                }
            
                if data != nil {
                    if responseParser != nil {
                        let parsedResponse = responseParser!(data!)
                        seal.fulfill(parsedResponse)
                        return
                    }
                }
                seal.fulfill(nil)
            }
            task.resume()
        }
    }

    private func isError(response: URLResponse) -> Bool {
        if let httpResponse = response as? HTTPURLResponse {
            
            if (httpResponse.statusCode < 600) && (httpResponse.statusCode >= 400) {
                return true
            }
        }
        return false
    }
}
