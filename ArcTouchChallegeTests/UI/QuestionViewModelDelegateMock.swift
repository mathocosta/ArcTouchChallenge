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
    var onShouldReloadContent: (() -> Void)?
    var onPresentEndingAlert: ((String, String, String) -> Void)?

    func shouldReloadContent() {
        onShouldReloadContent?()
    }

    func update(timerText: String) {
        onUpdateTimer?(timerText)
    }

    func presentEndingAlert(title: String, message: String, buttonTitle: String) {
        onPresentEndingAlert?(title, message, buttonTitle)
    }
}
