//
//  QuestionViewController.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var loadingView: LoadingView!

    // Main content
    @IBOutlet weak var contentWrapperView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answersTableView: UITableView!

    // Bottom view
    @IBOutlet weak var bottomWrapperView: UIView!
    @IBOutlet weak var answersCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!

    private lazy var viewModel: QuestionViewModel = {
        return QuestionViewModel(delegate: self)
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContent()
    }

    // MARK: - Methods
    private func setupUI() {
        resetButton.backgroundColor = .customOrange
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10.0

        loadingView.isHidden = true
    }

    private func setupContent() {
        titleLabel.text = viewModel.titleText
        answerTextField.placeholder = viewModel.textFieldPlaceholder
        answersCounterLabel.text = viewModel.answersCounterText
        timerLabel.text = viewModel.timerText
        resetButton.setTitle(viewModel.resetButtonTitleText, for: .normal)
    }

    private func refreshView() {
        setupContent()
        viewModel.fireTimer()
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        viewModel.reset()
    }

}

// MARK: - QuestionViewModelDelegate
extension QuestionViewController: QuestionViewModelDelegate {
    func shouldReloadContent() {
        refreshView()
    }

    func update(timerText: String) {
        timerLabel.text = timerText
    }

    func presentEndingAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel) { [weak self] _ in
            self?.viewModel.reset()
            alert.dismiss(animated: true, completion: nil)
        })

        present(alert, animated: true, completion: nil)
    }

    func viewStateChanged(to newState: QuestionViewModel.State) {
        if newState == .loading {
            loadingView.isHidden = false
        } else {
            contentWrapperView.isHidden = false
        }
    }
}
