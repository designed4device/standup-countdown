//
//  URLSessionExtension.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 9/28/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

extension URLSession {
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        print("request started")
        return dataTask(with: request) { (data, response, error) in
            print("request complete")
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
