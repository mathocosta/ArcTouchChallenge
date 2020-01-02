//
//  QuestionViewModel.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation

protocol QuestionViewModelDelegate: class {
}

class QuestionViewModel: NSObject {
    // MARK: - Properties
    weak var delegate: QuestionViewModelDelegate?

    var titleText: String {
        return "What are all the Java keywords?"
    }

    var textFieldPlaceholder: String {
        return "Insert Word"
    }

    var answersCounterText: String {
        return "00/50"
    }

    var timerText: String {
        return "05:00"
    }

    var resetButtonTitleText: String {
        return "Reset"
    }

    // MARK: - Initializers
    init(delegate: QuestionViewModelDelegate) {
        super.init()
        self.delegate = delegate
    }

    // MARK: - Methods
    func check(keyword: String) -> Bool {
        return true
    }
}
