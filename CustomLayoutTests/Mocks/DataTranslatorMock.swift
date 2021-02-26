//
//  DataTranslatorMock.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 26.02.21.
//

import UIKit
@testable import CustomLayout

class DataTranslatorMock: DataTranslator {
    
    var canLayout: Bool = false
    
    func translate(data: [LayoutObject]) {
        canLayout = true
    }
    
    func fit(to rect: CGRect) -> [LayoutDisplayItem] {
        [LayoutDisplayItem(id: "2", dataType: .date, content: "24.12.09", rect: CGRect(x: 0, y: 0, width: 100, height: 100))]
    }
}
