//
//  JsonDecodable.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 22.02.21.
//

import Foundation

protocol MappableResponse {
    init(data: Data) throws
}

protocol JsonDecodable {
    associatedtype Response: MappableResponse
    typealias DecodedResult = ((Result<Response, Error>) -> Void)
    
    func decode(jsonData: Data?, _ callback: @escaping DecodedResult)
}

extension JsonDecodable {
    func decode(jsonData: Data?, _ callback: @escaping DecodedResult) {
        guard let data = jsonData else {
            callback(.failure(AppError.couldNotDecodeJson))
            return
        }
        do {
            let mapped = try Response(data: data)
            callback(.success(mapped))
        } catch (let error) {
            callback(.failure(error))
        }
    }
}

struct ElementsDecoder: JsonDecodable {
    typealias Response = LayoutObjectsContentArray
}
