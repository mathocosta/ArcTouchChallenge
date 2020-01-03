//
//  QuestionViewModelTests.swift
//  ArcTouchChallegeTests
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import XCTest
@testable import ArcTouchChallege

class QuestionViewModelTests: XCTestCase {

    var viewModel: QuestionViewModel!
    var viewModelDelegateMock: QuestionViewModelDelegateMock!

    override func setUp() {
        let provider = APIProvider()
        self.viewModelDelegateMock = QuestionViewModelDelegateMock()
        self.viewModel = QuestionViewModel(delegate: viewModelDelegateMock, provider: provider)
    }

    func testInit_ShouldSetDelegate() {
        XCTAssertNotNil(viewModel.delegate, "View model delegate can't be nil")
    }

    func testTitleText_InitialValue() {
        XCTAssertEqual(viewModel.titleText, "", "Wrong initial value for titleText")
    }

    func testResetButtonTitleText_InitialValue() {
        XCTAssertEqual(viewModel.resetButtonTitleText, "Reset", "Wrong initial value for resetButtonTitleText")
    }

    func testTimerText_InitialValue() {
        XCTAssertEqual(viewModel.timerText, "05:00", "Wrong initial value for timerText")
    }

    func testAnswersCounterText_InitialValue() {
        XCTAssertEqual(viewModel.answersCounterText, "00/00", "Wrong initial value for answersCounterText")
    }

    func testTextFieldPlaceholder_InitialValue() {
        XCTAssertEqual(viewModel.textFieldPlaceholder, "Insert Word", "Wrong initial value for textFieldPlaceholder")
    }

    func testCorrectAnswersCounter_Initially_ShouldBeZero() {
        XCTAssertEqual(viewModel.correctAnswersCounter, 0, "Initially correctAnswersCounter")
    }

    func testFireTimer_CallDelegate_UpdateTimer() {
        let expectation = XCTestExpectation(description: "Call delegate to update timer text")
        viewModelDelegateMock.onUpdateTimer = { _ in
            expectation.fulfill()
        }

        viewModel.fireTimer()

        wait(for: [expectation], timeout: 3.0)
    }

    func testTimeIsOver_ShouldCallDelegate_ToPresentEndingAlert() {
        let expectation = XCTestExpectation(description: "Call delegate to present ending alert")
        viewModelDelegateMock.onPresentEndingAlert = { (title, message, buttonTitle) in
            XCTAssertEqual(title, "Time finished", "Wrong text in ending alert title")
            XCTAssertEqual(message, "Sorry, time is up! You got 0 of 50 answers", "Wrong text in ending alert message")
            XCTAssertEqual(buttonTitle, "Try again", "Wrong text in ending alert title")
            expectation.fulfill()
        }

        viewModel.timeIsOver()

        wait(for: [expectation], timeout: 3.0)
    }

    func testReset_ShouldCallDelegate_ToReloadContent() {
        let expectation = XCTestExpectation(description: "Call delegate to reload content")
        viewModelDelegateMock.onShouldReloadContent = { expectation.fulfill() }
        viewModel.reset()
        wait(for: [expectation], timeout: 5.0)
    }
}
