//
//  AppError.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 22.02.21.
//

import Foundation

enum AppError: Error, Equatable {
    case couldNotDecodeJson
    case fileResouceNotFound
    case invalidUrl
    case generalError
    case dataIsNil
    case couldNotParseImage
}
