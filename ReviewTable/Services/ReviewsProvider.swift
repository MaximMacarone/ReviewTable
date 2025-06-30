//
//  ReviewsProvider.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 28.06.2025.
//

import Foundation
import Combine

final class ReviewsProvider {

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

}

// MARK: - Internal

extension ReviewsProvider {

    typealias GetReviewsResult = Result<Data, GetReviewsError>

    enum GetReviewsError: Error {

        case badURL
        case badData(Error)

    }

    func getReviews(offset: Int = 0, completion: @escaping (GetReviewsResult) -> Void) {
        guard let url = bundle.url(forResource: "getReviews.response", withExtension: "json") else {
            return completion(.failure(.badURL))
        }

        // Симулируем сетевой запрос - не менять
        usleep(.random(in: 100_000...1_000_000))

        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(.badData(error)))
        }
    }
    
    func getReviewsPublisher(offset: Int = 0) -> AnyPublisher<Data, GetReviewsError> {
        Deferred {
            Future<Data, GetReviewsError> { promise in
                self.getReviews(offset: offset) { result in
                    switch result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

}
