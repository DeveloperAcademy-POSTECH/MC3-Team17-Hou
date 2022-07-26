//
//  XMLManger.swift
//  Ninano
//
//  Created by Yoonjae on 2022/07/23.
//

import Foundation

final class APICaller {
    static let shared = APICaller()

    struct Constants {
        static let topHeadlinesURL = URL(string: "http://openapi.seoul.go.kr:8088/51476b414763686534346b53557a4a/json/culturalEventInfo/1/1/%EA%B5%AD%EC%95%85")
    }

    private init() {}

    public func getTopStories(completion: @escaping (Result<APIResponse, Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

