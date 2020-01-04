//
//  QuestionViewModelDelegateMock.swift
//  ArcTouchChallegeTests
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation
@testable import ArcTouchChallege

class QuestionViewModelDelegateMock: QuestionViewModelDelegate {
    var onUpdateTimer: ((String) -> Void)?
    var onPresentEndingAlert: ((String, String, String) -> Void)?
    var onViewStateChanged: ((QuestionViewModel.State) -> Void)?
    var onDidFind: ((String) -> Void)?

    func didFind(answer: String) {
        onDidFind?(answer)
    }

    func viewStateChanged(to newState: QuestionViewModel.State) {
        onViewStateChanged?(newState)
    }

    func update(timerText: String) {
        onUpdateTimer?(timerText)
    }

    func presentEndingAlert(title: String, message: String, buttonTitle: String) {
        onPresentEndingAlert?(title, message, buttonTitle)
    }
}
