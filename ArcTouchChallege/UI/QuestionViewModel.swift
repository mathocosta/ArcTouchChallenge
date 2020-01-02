//
//  QuestionViewModel.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation

protocol QuestionViewModelDelegate: class {
    func shouldReloadContent()
    func update(timerText: String)
    func presentEndingAlert(title: String, message: String, buttonTitle: String)
    func viewStateChanged(to newState: QuestionViewModel.State)
}

class QuestionViewModel: NSObject {
    enum State {
        case loading, ready
    }

    // MARK: - Properties
    weak var delegate: QuestionViewModelDelegate?

    // 5 minutes
    private let defaultTimeInterval: Double = 5 * 60
    private var timeLeft: Double
    private var timer: Timer!

    var allAnswers = [String]()
    var correctAnswers = [String]()

    var viewState: State

    var correctAnswersCounter: Int {
        return correctAnswers.count
    }

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
        self.delegate = delegate
        self.viewState = .ready
        self.timeLeft = defaultTimeInterval
        super.init()
        fireTimer()
    }

    // MARK: - Methods
    func reset() {
        timeLeft = defaultTimeInterval
        timer.invalidate()
        delegate?.shouldReloadContent()
    }

    func check(keyword: String) -> Bool {
        return true
    }

    func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: timerHasEnded(_:))
    }

    func timerHasEnded(_ timer: Timer) {
        timeLeft -= 1
        let minutes = Int(timeLeft) / 60 % 60
        let seconds = Int(timeLeft) % 60

        let newText = String(format: "%02i:%02i", minutes, seconds)
        delegate?.update(timerText: newText)

        if timeLeft <= 0 {
            timer.invalidate()
            timeIsOver()
        }
    }

    func timeIsOver() {
        let message = "Sorry, time is up! You got \(correctAnswersCounter) of 50 answers"
        delegate?.presentEndingAlert(
            title: "Time finished",
            message: message,
            buttonTitle: "Try again"
        )
    }
}
