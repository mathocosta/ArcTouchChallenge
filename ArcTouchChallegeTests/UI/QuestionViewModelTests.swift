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
        let mockDataTask = DataTaskResultMock()
        let apiProvider = APIProvider(session: mockDataTask)
        self.viewModelDelegateMock = QuestionViewModelDelegateMock()
        self.viewModel = QuestionViewModel(delegate: viewModelDelegateMock, provider: apiProvider)
    }

    func testInit_ShouldSetDelegate() {
        XCTAssertNotNil(viewModel.delegate, "View model delegate can't be nil")
    }

    func testTitleText_InitialValue() {
        XCTAssertEqual(viewModel.titleText, "", "Wrong initial value for titleText")
    }

    func testResetButtonTitleText_WhenRunningState() {
        viewModel.viewState = .running
        XCTAssertEqual(viewModel.buttonTitle, "Reset", "Wrong initial value for resetButtonTitleText")
    }

    func testResetButtonTitleText_WhenReadyOrLoadingState() {
        viewModel.viewState = .ready
        XCTAssertEqual(viewModel.buttonTitle, "Start", "Wrong initial value for buttonTitle when ready state")

        viewModel.viewState = .loading
        XCTAssertEqual(viewModel.buttonTitle, "Start", "Wrong initial value for buttonTitle when loading state")
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

    func testReset_ShouldCallDelete_ToUpdateState() {
        let expectation = XCTestExpectation(description: "Call delegate with ready state")
        let expected = QuestionViewModel.State.ready
        viewModelDelegateMock.onViewStateChanged = { (newState) in
            XCTAssertEqual(newState, expected)
            expectation.fulfill()
        }

        viewModel.reset()
        wait(for: [expectation], timeout: 3.0)
    }

    func testFireTimer_ShouldCallDelete_ToUpdateState() {
        let expectation = XCTestExpectation(description: "Call delegate with running state")
        let expected = QuestionViewModel.State.running
        viewModelDelegateMock.onViewStateChanged = { (newState) in
            XCTAssertEqual(newState, expected)
            expectation.fulfill()
        }

        viewModel.fireTimer()
        wait(for: [expectation], timeout: 3.0)
    }

    func testPrepare_ShouldCallDelete_ToUpdateState() {
        let expectation = XCTestExpectation(description: "Call delegate after load question")

        var counter = 0
        viewModelDelegateMock.onViewStateChanged = { (newState) in
            counter += 1
            XCTAssert(newState == .loading || newState == .ready)

            if counter == 2 {
                expectation.fulfill()
            }
        }

        viewModel.prepare()
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(counter, 2)
    }

    func testCheckKeyword_ShouldInsertWord_AtCorrectAnswers() {
        viewModel.prepare()
        viewModel.check(keyword: "do")
        XCTAssert(viewModel.correctAnswers.contains("do"))
    }
}
