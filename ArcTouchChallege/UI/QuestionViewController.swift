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
    @IBOutlet weak var bottomWrapperViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var viewModel: QuestionViewModel = {
        let apiProvider = APIProvider()
        return QuestionViewModel(delegate: self, provider: apiProvider)
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextField()
        setupTableView()
        viewModel.start()
    }

    // MARK: - Methods
    private func setupUI() {
        resetButton.backgroundColor = .customOrange
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10.0

        bottomWrapperView.layer.shadowColor = UIColor.black.cgColor
        bottomWrapperView.layer.shadowOpacity = 0.3
        bottomWrapperView.layer.shadowOffset = .zero
        bottomWrapperView.layer.shadowRadius = 1

        loadingView.isHidden = false
        contentWrapperView.isHidden = true
    }

    private func setupTextField() {
        answerTextField.delegate = self
        answerTextField.addTarget(self, action: #selector(answerTextFieldDidChange(_:)), for: .editingChanged)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldKeyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldKeyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func setupTableView() {
        answersTableView.allowsSelection = false
        answersTableView.dataSource = self
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
        answersTableView.reloadData()
        viewModel.fireTimer()
    }

    // MARK: - Actions
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        viewModel.reset()
    }

    @objc func answerTextFieldDidChange(_ textField: UITextField) {
        guard let currentText = textField.text, !currentText.isEmpty else { return }
        viewModel.check(keyword: currentText)
    }

    @objc func textFieldKeyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) {
            let keyboardHeight = keyboardSize.cgRectValue.height
            bottomWrapperViewBottomConstraint.constant += (keyboardHeight - view.safeAreaInsets.bottom)

            view.layoutIfNeeded()
        }
    }

    @objc func textFieldKeyboardWillHide(_ notification: NSNotification) {
        bottomWrapperViewBottomConstraint.constant = 16.0
        view.layoutIfNeeded()
    }
}

// MARK: - UITextViewDelegate
extension QuestionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: - UITableViewDataSource
extension QuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.correctAnswersCounter
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.textLabel?.text = viewModel.correctAnswers[indexPath.row]
        return cell
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
        let isLoading = (newState == .loading)
        loadingView.isHidden = !isLoading
        contentWrapperView.isHidden = isLoading

        if newState == .ready {
            refreshView()
        }
    }

    func didFind(answer: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        answersTableView.insertRows(at: [indexPath], with: .automatic)
        answerTextField.text = ""
        answersCounterLabel.text = viewModel.answersCounterText
    }
}
