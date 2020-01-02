//
//  LoadingView.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    private let alertContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layer.cornerRadius = 10.0
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.text = "Loading..."
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }

    func initialSetup() {
        activityIndicator.startAnimating()
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        buildViewHierarchy()
        buildConstraints()
    }

    func buildViewHierarchy() {
        addSubview(alertContainerView)
        alertContainerView.addSubview(activityIndicator)
        alertContainerView.addSubview(label)
    }

    func buildConstraints() {
        NSLayoutConstraint.activate([
            alertContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            alertContainerView.heightAnchor.constraint(equalToConstant: 150),
            alertContainerView.widthAnchor.constraint(equalToConstant: 150)
        ])

        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: alertContainerView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -20)
        ])
    }
}
