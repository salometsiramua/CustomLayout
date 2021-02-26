//
//  SimpexSolverTests.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 24.02.21.
//

import XCTest
@testable import CustomLayout

class SimpexSolverTests: XCTestCase {

    func initSimpexSolver() -> SimpexSolver {
        let simpexSolver: SimpexSolver = SimpexSolverService()
        simpexSolver.addVariable(Variable(dataType: .date, content: "23.34.12", widthType: .fixed(value: 100), name: "id123"))
        return simpexSolver
    }
    
    func testSimpexSolverWidthWithOneVariable() {
        let simpexSolver = initSimpexSolver()
        let variables = simpexSolver.resolve(for: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(variables.count, 1)
        XCTAssertEqual(variables[0].width, 100)
        XCTAssertNil(variables[0].x)
    }
    
    func testSimplexSolverWithSomeConstraints() {
        let simpexSolver = initSimpexSolver()
        simpexSolver.addConstraintComponents(componentOne: ConstraintComponent.parent, componentTwo: ConstraintComponent.variable(withId: "id123"), axis: .horizontal)
        let variables = simpexSolver.resolve(for: CGRect(x: 0, y: 0, width: 200, height: 100))
        XCTAssertEqual(variables.count, 1)
        XCTAssertEqual(variables[0].width, 100)
        XCTAssertNil(variables[0].x)
    }
    
    func testSimplexSolverWithComplexConstraints() {
        let simpexSolver = initSimpexSolver()
        simpexSolver.addVariable(Variable(dataType: .text, content: "some text", widthType: .fixed(value: 23), name: "1"))
        simpexSolver.addVariable(Variable(dataType: .text, content: "some text", widthType: .fixed(value: 23), name: "2"))
        simpexSolver.addVariable(Variable(dataType: .text, content: "some text", widthType: .fill, name: "3"))
        simpexSolver.addVariable(Variable(dataType: .text, content: "some text", widthType: .fixed(value: 23), name: "4"))
        simpexSolver.addConstraintComponents(componentOne: ConstraintComponent.parent, componentTwo: ConstraintComponent.variable(withId: "1"), axis: .horizontal)
        simpexSolver.addConstraintComponents(componentOne: ConstraintComponent.variable(withId: "3"), componentTwo: ConstraintComponent.variable(withId: "4"), axis: .horizontal)
        simpexSolver.addConstraintComponents(componentOne: ConstraintComponent.variable(withId: "2"), componentTwo: ConstraintComponent.variable(withId: "3"), axis: .horizontal)
        simpexSolver.addConstraintComponents(componentOne: ConstraintComponent.variable(withId: "1"), componentTwo: ConstraintComponent.variable(withId: "2"), axis: .horizontal)
        let variables = simpexSolver.resolve(for: CGRect(x: 0, y: 0, width: 200, height: 100))
        XCTAssertEqual(variables.count, 5)
        XCTAssertEqual(variables[3].width, 131)
    }
}
