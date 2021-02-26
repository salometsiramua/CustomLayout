//
//  ViewModelTests.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 26.02.21.
//

import XCTest
@testable import CustomLayout

class ViewModelTests: XCTestCase {

    func testViewModelTranslatorCanLayour() {
        let viewModel: ViewModelable = ViewModel(fileReader: FileReaderMock(success: false), elementsDecoder: ElementsDecoder(), dataTranslator: DataTranslatorMock(), filePath: "example", type: "json")
        XCTAssertFalse(viewModel.dataTranslator.canLayout)
        viewModel.dataTranslator.translate(data: [])
        XCTAssertTrue(viewModel.dataTranslator.canLayout)
    }
    
    func testViewModelDataTranslatorMockResponse() {
        let viewModel: ViewModelable = ViewModel(fileReader: FileReaderMock(success: false), elementsDecoder: ElementsDecoder(), dataTranslator: DataTranslatorMock(), filePath: "example", type: "json")
        
        let response = viewModel.fit(to: CGRect(x: 23, y: 43, width: 10, height: 20))
        
        let layoutItem = LayoutDisplayItem(id: "2", dataType: .date, content: "24.12.09", rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(response.count, 1)
        XCTAssertEqual(response[0].frame, layoutItem.frame)
        XCTAssertEqual(response[0].content, "24.12.09")
        XCTAssertEqual(response[0].id, "2")
    }
    
    func testViewModelFileReaderMockResponse() {
        let fileReaderMock = FileReaderMock(success: false)
        let viewModel: ViewModelable = ViewModel(fileReader: fileReaderMock, elementsDecoder: ElementsDecoder(), dataTranslator: DataTranslatorMock(), filePath: "example", type: "json")
        
        let exp = expectation(description: "Pokemons details fetcher fails")
        
        viewModel.align { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                exp.fulfill()
                XCTAssertEqual((error as? AppError), .generalError)
            }
        }
        
        wait(for: [exp], timeout: 0.4)
    }
    
    func testViewModelFileReaderMockSuccessfulResponse() {
        let fileReaderMock = FileReaderMock(success: true)
        let viewModel: ViewModelable = ViewModel(fileReader: fileReaderMock, elementsDecoder: ElementsDecoder(), dataTranslator: DataTranslatorMock(), filePath: "example", type: "json")
        
        let exp = expectation(description: "Pokemons details fetcher succeed")
        
        viewModel.align { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.4)
    }
}
