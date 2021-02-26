//
//  FileReaderMock.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 26.02.21.
//

import Foundation
@testable import CustomLayout

class FileReaderMock: FileReader {
    
    let success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    func read(from resource: String, ofType: String, _ callback: @escaping JsonCallBack) {
        if success {
            callback(.success(Data()))
        } else {
            callback(.failure(AppError.generalError))
        }
    }
    
}
