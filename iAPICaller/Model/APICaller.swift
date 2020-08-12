//
//  APICaller.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation

struct APICaller {
    
    //MARK: - API Request functions
    func callAPI(with request: URLRequest, sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default, responseParser:  ((Data) -> (Any))?,callback: @escaping (Any?,String?) ->()) {
        let session = URLSession(configuration: sessionConfiguration)
        
        let task = session.dataTask(with: request) { data, response, error in
            if (error != nil) {
                print(error?.localizedDescription ?? "No data")
                callback(nil, error?.localizedDescription)
                return
            }
            
            if let safeResponse = response, self.isError(response: safeResponse) {
                callback(nil, "Something went wrong, try again :(")
                return
            }
            
            if data != nil {
                if responseParser != nil {
                    let parsedResponse = responseParser!(data!)
                    callback(parsedResponse, nil)
                }
            }
            callback(nil,nil)
        }
        task.resume()
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
