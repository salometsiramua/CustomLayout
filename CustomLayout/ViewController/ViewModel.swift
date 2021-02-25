//
//  ViewModel.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import UIKit

protocol ViewModelable {
    var dataTranslator: DataTranslator { get }
    func align(for rect: CGRect, _ callback: @escaping (Result<[LayoutDisplayItem], Error>) -> Void)
}

extension ViewModelable {
    func translate(data: [LayoutObject], for rect: CGRect) -> [LayoutDisplayItem] {
        return dataTranslator.translate(data: data, for: rect)
    }
}

final class ViewModel: ViewModelable {
    
    private let fileReader: FileReader
    private let elementsDecoder: ElementsDecoder
    let dataTranslator: DataTranslator
    private var rect: CGRect?
    private let filePath: String
    private let type: String
    
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
    
    func align(for rect: CGRect, _ callback: @escaping ((Result<[LayoutDisplayItem], Error>) -> Void)) {
        self.rect = rect
        readFile(from: filePath, of: type) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.decode(data: data, { [weak self] decodedResult in
                    guard let self = self else { return }
                    switch decodedResult {
                    case .success(let array):
                        let result = self.translate(data: array, for: rect)
                        callback(.success(result))
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
