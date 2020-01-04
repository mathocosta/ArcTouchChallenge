//
//  QuestionViewModel.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation

protocol QuestionViewModelDelegate: class {
    func update(timerText: String)
    func presentEndingAlert(title: String, message: String, buttonTitle: String)
    func viewStateChanged(to newState: QuestionViewModel.State)
    func didFind(answer: String)
}

class QuestionViewModel: NSObject {
    enum State {
        case loading, ready, running
    }

    // MARK: - Properties
    weak var delegate: QuestionViewModelDelegate?

    // 5 minutes
    private let defaultTimeInterval: Double = 5 * 60
    private var timeLeft: Double
    private var timer: Timer!

    let apiProvider: APIProvider

    var allAnswers = [String]()
    var correctAnswers = [String]()

    var viewState: State {
        didSet { delegate?.viewStateChanged(to: viewState) }
    }

    var answersCount: Int {
        return allAnswers.count
    }

    var correctAnswersCounter: Int {
        return correctAnswers.count
    }

    var titleText: String = ""

    var textFieldPlaceholder: String {
        return "Insert Word"
    }

    var textFieldIsEnabled: Bool {
        return viewState == .running
    }

    var answersCounterText: String {
        return String(format: "%02d/%02d", correctAnswersCounter, answersCount)
    }

    var timerText: String {
        return "05:00"
    }

    var buttonTitle: String {
        if viewState == .running {
            return "Reset"
        } else {
            return "Start"
        }
    }

    // MARK: - Initializers
    init(delegate: QuestionViewModelDelegate, provider: APIProvider) {
        self.delegate = delegate
        self.apiProvider = provider
        self.viewState = .loading
        self.timeLeft = defaultTimeInterval
        super.init()
    }

    // MARK: - Methods
    func prepare() {
        loadQuestion()
    }

    private func loadQuestion() {
        viewState = .loading
        let endpoint = Endpoint.firstQuestion()
        apiProvider.request(type: Question.self, endpoint: endpoint) { (result) in
            switch result {
            case .success(let question):
                self.titleText = question.title
                self.allAnswers = question.answers
                DispatchQueue.main.async { self.viewState = .ready }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func reset() {
        timeLeft = defaultTimeInterval
        correctAnswers = [String]()
        stopTimer()
        viewState = .ready
    }

    func check(keyword: String) {
        if let findedAnswer = allAnswers.first(where: { keyword.lowercased() == $0 }),
            !correctAnswers.contains(findedAnswer) {
            correctAnswers.insert(findedAnswer, at: 0)
            delegate?.didFind(answer: findedAnswer)
        }

        if correctAnswersCounter == answersCount {
            allAnswersFound()
        }
    }

    func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: timerHasEnded(_:))
        viewState = .running
    }

    func stopTimer() {
        if timer != nil {
            timer.invalidate()
        }
    }

    func timerHasEnded(_ timer: Timer) {
        timeLeft -= 1
        let minutes = Int(timeLeft) / 60 % 60
        let seconds = Int(timeLeft) % 60

        let newText = String(format: "%02i:%02i", minutes, seconds)
        delegate?.update(timerText: newText)

        if timeLeft <= 0 {
            timeIsOver()
        }
    }

    func allAnswersFound() {
        stopTimer()
        let message = "Good job! You found all the answers on time. Keep up with the great work."
        delegate?.presentEndingAlert(title: "Congratulations", message: message, buttonTitle: "Play Again")
    }

    func timeIsOver() {
        stopTimer()
        let message = "Sorry, time is up! You got \(correctAnswersCounter) of 50 answers"
        delegate?.presentEndingAlert(
            title: "Time finished",
            message: message,
            buttonTitle: "Try again"
        )
    }
}
