//
//  EndpointTests.swift
//  ArcTouchChallegeTests
//
//  Created by Matheus Oliveira Costa on 03/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import XCTest
@testable import ArcTouchChallege

class EndpointTests: XCTestCase {

    func testInit_ShouldSetPath() {
        let endpoint = Endpoint(path: "/test")
        XCTAssertEqual(endpoint.path, "/test", "Endpoint path should be '/test'")
    }

    func testURL_ShouldReturnCorrectURL() {
        let endpoint = Endpoint(path: "/test")
        let expected = URL(string: "https://codechallenge.arctouch.com/test")!
        XCTAssertEqual(endpoint.url, expected, "Endpoit url should create correct url based on path")
    }
}
