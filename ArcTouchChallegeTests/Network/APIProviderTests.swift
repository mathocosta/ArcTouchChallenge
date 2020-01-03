//
//  APIProviderTests.swift
//  ArcTouchChallegeTests
//
//  Created by Matheus Oliveira Costa on 03/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import XCTest
@testable import ArcTouchChallege

class APIProviderTests: XCTestCase {
    var provider: APIProvider!
    var sessionMock: DataTaskResultMock!

    override func setUp() {
        self.sessionMock = DataTaskResultMock()
        self.provider = APIProvider(session: sessionMock)
    }

    func testRequest_ShouldDecodeModel() {
        let expectation = XCTestExpectation(description: "Waiting \(#function) ends")
        provider.request(type: Question.self, endpoint: Endpoint(path: "/test")) { (result) in
            switch result {
            case .success(let question):
                XCTAssertEqual(question.title, "Example question?", "Wrong value on question title")
                expectation.fulfill()
            case .failure:
                XCTFail("Fail on provider request")
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }
}
