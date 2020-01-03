//
//  APIProvider.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation

final class APIProvider {

    private let session: DataTaskResult

    init(session: DataTaskResult = URLSession.shared) {
        self.session = session
    }

    func request<T: Decodable>(type: T.Type, endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: endpoint.url) { (result) in
            switch result {
            case .success((_, let validData)):
                do {
                    let model = try JSONDecoder().decode(T.self, from: validData)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

        DispatchQueue.global(qos: .background).async {
            task.resume()
        }
    }
}
