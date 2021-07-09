//
//  NetworkServise.swift
//  kingbirdTestWork
//
//  Created by Oleg on 7/8/21.
//

import UIKit

enum NetworkError: Error {
    case noConnection
    case decodingError
}

protocol NetworkServiceProtocol {
    func fetchPhoto(completion: @escaping (Result<[Photo], NetworkError>) -> ())
}

struct NetworkService: NetworkServiceProtocol {
    
    // MARK: Network
    func fetchPhoto(completion: @escaping (Result<[Photo], NetworkError>) -> ()) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=20") else { return }
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try decoder.decode([Photo].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(jsonData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.noConnection))
                }
            }
        }.resume()
    }
    
    static func fetchImageWithResize(imageUrl: String, completion: @escaping (Data?) -> ()){
        guard let imageUrl = URL(string: imageUrl) else { return }
        let session = URLSession.shared
        session.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                }
            } else {
                guard let image = UIImage(systemName: "arrow.triangle.2.circlepath.camera") else { return
                }
                DispatchQueue.main.async {
                    completion(image.pngData())
                }
            }
        }.resume()
    }
}

