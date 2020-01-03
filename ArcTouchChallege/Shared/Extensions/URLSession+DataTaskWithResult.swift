//
//  URLSession+DataTaskWithResult.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation

protocol DataTaskResult {
    func dataTask(
        with url: URL,
        result: @escaping (Result<(HTTPURLResponse, Data), Error>) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: DataTaskResult {
    func dataTask(
        with url: URL,
        result: @escaping (Result<(HTTPURLResponse, Data), Error>) -> Void
    ) -> URLSessionDataTask {

        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }

            guard let validData = data else {
                let error = NSError(domain: "invalid data", code: 0, userInfo: nil)
                return result(.failure(error))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "response is not http response", code: 0, userInfo: nil)
                return result(.failure(error))
            }

            result(.success((httpResponse, validData)))
        }
    }
}
