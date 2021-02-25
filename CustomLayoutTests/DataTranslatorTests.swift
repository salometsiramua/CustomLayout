//
//  DataTranslatorTests.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 25.02.21.
//

import XCTest
@testable import CustomLayout

class DataTranslatorTests: XCTestCase {

    func initDataTranslator() -> DataTranslator {
        return DataTranslatorService()
    }

    func testDataTranslatorInit() {
        let dataTranslator = initDataTranslator()
        let layoutObject = LayoutObject(content: LayoutObjectContent(id: "id123", data: .init(type: "image", content: "url.com"), width: .init(mode: "fill", value: nil), position: .init(anchors: ["right"], relativity: .init(type: "parent", referenceIds: nil, alignment: nil))))
        let result = dataTranslator.translate(data: [layoutObject], for: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].dataType, .image)
        XCTAssertEqual(result[0].frame.width, 100)
        XCTAssertEqual(result[0].frame.origin.x, 0)
    }
    
    func testDataTranslatorWithMock() {
        let dataTranslator = DataTranslatorService(simpexSolver: SimpexSolverMock())
        let layoutObject = LayoutObject(content: LayoutObjectContent(id: "id123", data: .init(type: "image", content: "url.com"), width: .init(mode: "fill", value: nil), position: .init(anchors: ["right"], relativity: .init(type: "parent", referenceIds: nil, alignment: nil))))
        let variables = dataTranslator.translate(data: [layoutObject], for: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(variables.count, 0)
    }
}
