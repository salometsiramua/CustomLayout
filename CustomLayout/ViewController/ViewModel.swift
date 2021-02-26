//
//  ViewModel.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import UIKit

protocol ViewModelable {
    var dataTranslator: DataTranslator { get }
    func align(_ callback: @escaping (Result<Bool, Error>) -> Void)
    func fit(to rect: CGRect) -> [LayoutDisplayItem]
}

extension ViewModelable {
    
    func translate(data: [LayoutObject]) {
        dataTranslator.translate(data: data)
    }
    
    func fit(to rect: CGRect) -> [LayoutDisplayItem] {
        return dataTranslator.fit(to: rect)
    }
}

final class ViewModel: ViewModelable {
    
    private let fileReader: FileReader
    private let elementsDecoder: ElementsDecoder
    private let filePath: String
    private let type: String
    let dataTranslator: DataTranslator
    
    typealias JsonCallBack = (Result<Data, Error>) -> Void
    typealias MappedResult = ((Result<Array<LayoutObject>, Error>) -> Void)
    
    init(fileReader: FileReader = FileReaderService(),
         elementsDecoder: ElementsDecoder = ElementsDecoder(),
         dataTranslator: DataTranslator = DataTranslatorService(),
         filePath: String = "example",
         type: String = "json") {
        self.fileReader = fileReader
        self.elementsDecoder = elementsDecoder
        self.dataTranslator = dataTranslator
        self.filePath = filePath
        self.type = type
    }
    
    func align(_ callback: @escaping ((Result<Bool, Error>) -> Void)) {
        readFile(from: filePath, of: type) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.decode(data: data, { decodedResult in
                    switch decodedResult {
                    case .success(let layout):
                        self?.translate(data: layout)
                        callback(.success(true))
                    case .failure(let error):
                        callback(.failure(error))
                    }
                })
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    private func readFile(from path: String, of type: String, _ callback: @escaping JsonCallBack) {
        fileReader.read(from: path, ofType: type) { (result) in
            callback(result)
        }
    }
    
    private func decode(data: Data?, _ callback: @escaping MappedResult) {
        elementsDecoder.decode(jsonData: data) { (result) in
            switch result {
            case .success(let response):
                callback(.success(response.elements.map{LayoutObject(content: $0)}))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
