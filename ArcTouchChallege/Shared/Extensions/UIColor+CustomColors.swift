//
//  UIColor+CustomColors.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import UIKit

// NOTE: I use force unwrapping here because these colors are needed in the app, so if any
// are removed by mistake, there will be an error when testing the app to remember that
// color is needed. Not the best solution, but for me it's effective
extension UIColor {
    static var customOrange: UIColor {
        return UIColor(named: "orange")!
    }

    static var timerBackground: UIColor {
        return UIColor(named: "timer-background")!
    }
}
