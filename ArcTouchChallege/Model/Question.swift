//
//  Question.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation

struct Question: Decodable {
    var title: String
    var answers: [String]

    enum CodingKeys: String, CodingKey {
        case title = "question"
        case answers = "answer"
    }
}
