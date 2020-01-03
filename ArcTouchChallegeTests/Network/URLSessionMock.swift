//
//  URLSessionMock.swift
//  ArcTouchChallegeTests
//
//  Created by Matheus Oliveira Costa on 03/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation
@testable import ArcTouchChallege

func mockResponseBuilder() -> Data {
    let keywords = Array(repeating: "\"do\"", count: 50)
    let jsonString = """
        {
            "question": "Example question?",
            "answer": [\(keywords.joined(separator: ", "))]
        }
    """

    print(jsonString)

    return jsonString.data(using: .utf8)!
}

class DataTaskResultMock: DataTaskResult {
    func dataTask(
        with url: URL,
        result: @escaping (Result<(HTTPURLResponse, Data), Error>) -> Void
    ) -> URLSessionDataTask {
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let validData = mockResponseBuilder()

        result(.success((urlResponse, validData)))

        return URLSessionDataTaskMock()
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    override init() {
    }

    override func resume() {
    }
}
