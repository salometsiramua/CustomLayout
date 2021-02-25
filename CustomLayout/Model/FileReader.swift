//
//  FileReader.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import Foundation

protocol FileReader {
    typealias JsonCallBack = (Result<Data, Error>) -> Void
    func read(from resource: String, ofType: String, _ callback: @escaping JsonCallBack)
}

class FileReaderService: FileReader {
    
    func read(from resource: String, ofType: String, _ callback: @escaping JsonCallBack) {
        guard let path = Bundle.main.path(forResource: resource, ofType: ofType) else {
            callback(.failure(AppError.fileResouceNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            callback(.success(data))
        } catch(let error) {
            callback(.failure(error))
        }
    }
}

