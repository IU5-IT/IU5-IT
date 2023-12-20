//
//  Network.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 18.09.2023.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private func createRequest(
        router: Router,
        method: Method,
        parameters: [String: Any]?
    ) throws -> URLRequest {
        let urlString = router.endpoint
        guard let url = urlString.toURL else { 
            throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let params = parameters {
            switch method {
            case .get:
                guard var urlComponents = URLComponents(string: urlString) else { 
                    throw APIError.badParameters }
                urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                request.url = urlComponents.url
            case .post:
                do {
                    let bodyData = try JSONSerialization.data(withJSONObject: params)
                    request.httpBody = bodyData
                } catch {
                    throw error
                }
            }
        }
        
        return request
    }
    
    func request<T: Decodable>(
        router: Router,
        method: Method = .get,
        type: T.Type,
        parameters: [String: Any]?,
        resultQueue: DispatchQueue = .main,
        completion: @escaping MKRResultBlock<T>
    ) {
        var request: URLRequest?
        do {
            request = try createRequest(router: router, method: method, parameters: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        guard let request = request else {
            completion(.failure(URLError(.unknown)))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                resultQueue.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                resultQueue.async {
                    completion(.failure(APIError.dataIsNil))
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                resultQueue.async {
                    completion(.failure(URLError(.unknown)))
                }
                return
            }
            guard (200..<300).contains(response.statusCode) else {
                resultQueue.async {
                    completion(.failure(APIError.badStatusCode(response.statusCode)))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type.self, from: data)
                resultQueue.async {
                    completion(.success(decodedData))
                }
                return
            } catch {
                resultQueue.async {
                    completion(.failure(error))
                }
                return
            }
        }.resume()
    }
}
