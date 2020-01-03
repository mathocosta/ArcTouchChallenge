//
//  CustomTextField.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 03/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }

    private func initialSetup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        borderStyle = .none
        layer.masksToBounds = true
        layer.cornerRadius = 10
        addPadding()
    }

    private func addPadding() {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: bounds.size.height))
        rightView = padding
        rightViewMode = .always
        leftView = padding
        leftViewMode = .always
    }
}
