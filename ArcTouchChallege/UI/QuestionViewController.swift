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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answersCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var answersTableView: UITableView!

    private lazy var viewModel: QuestionViewModel = {
        return QuestionViewModel(delegate: self)
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // MARK: - Methods
    private func setupUI() {
        resetButton.backgroundColor = .customOrange
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 5.0
    }

    private func bindViewModel() {
        titleLabel.text = viewModel.titleText
        answerTextField.placeholder = viewModel.textFieldPlaceholder
        answersCounterLabel.text = viewModel.answersCounterText
        timerLabel.text = viewModel.timerText
        resetButton.setTitle(viewModel.resetButtonTitleText, for: .normal)
    }

}

// MARK: - QuestionViewModelDelegate
extension QuestionViewController: QuestionViewModelDelegate {

}
