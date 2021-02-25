//
//  ImageDownloader.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 25.02.21.
//

import UIKit

protocol ImageDownloader {
    func download(from url: String, completion: @escaping ((Result<UIImage, Error>) -> Void))
}

class ImageDownloaderService: ImageDownloader {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func download(from url: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let url = URL(string: url) else {
            completion(.failure(AppError.invalidUrl))
            return
        }
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error ?? AppError.generalError))
                return
            }
            
            guard let data = data else {
                completion(.failure(AppError.dataIsNil))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(AppError.couldNotParseImage))
                return
            }
            completion(.success(image))
        }.resume()
    }
    
}
