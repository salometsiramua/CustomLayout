//
//  ConstraintTests.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 25.02.21.
//

import XCTest
@testable import CustomLayout

class ConstraintTests: XCTestCase {

    func testInsertComponent() {
        let constraint1 = Constraint(components: [ConstraintComponent.parent, ConstraintComponent.variable(withId: "id123")], axis: .horizontal)
        constraint1.insert(ConstraintComponent.variable(withId: "id321"), at: 1)
        XCTAssertEqual(constraint1.components.count, 3)
        XCTAssertEqual(constraint1.components[1].id, "id321")
    }
    
    func testInsertComponentOutOfBounds() {
        let constraint1 = Constraint(components: [ConstraintComponent.parent, ConstraintComponent.variable(withId: "id123")], axis: .horizontal)
        constraint1.insert(ConstraintComponent.variable(withId: "id321"), at: 89)
        XCTAssertEqual(constraint1.components.count, 2)
        XCTAssertEqual(constraint1.components[1].id, "id123")
    }
    
    func testInsertComponentAtTheEnd() {
        let constraint1 = Constraint(components: [ConstraintComponent.parent, ConstraintComponent.variable(withId: "id123")], axis: .horizontal)
        constraint1.insert(ConstraintComponent.variable(withId: "id321"), at: 2)
        XCTAssertEqual(constraint1.components.count, 3)
        XCTAssertEqual(constraint1.components[2].id, "id321")
    }
    
    func testConstraintConcatenate() {
        let constraint1 = Constraint(components: [ConstraintComponent.parent, ConstraintComponent.variable(withId: "id123")], axis: .horizontal)
        let constraint2 = Constraint(components: [ConstraintComponent.variable(withId: "id123"), ConstraintComponent.variable(withId: "id124")], axis: .horizontal)
        XCTAssertEqual(constraint1.components.count, 2)
        constraint1.concatenate(with: constraint2)
        XCTAssertEqual(constraint1.components.count, 3)
    }
    
    func testConstraintsNotConcatenate() {
        let constraint1 = Constraint(components: [ConstraintComponent.parent, ConstraintComponent.variable(withId: "id123")], axis: .horizontal)
        let constraint2 = Constraint(components: [ConstraintComponent.variable(withId: "id125"), ConstraintComponent.variable(withId: "id124")], axis: .horizontal)
        XCTAssertEqual(constraint1.components.count, 2)
        constraint1.concatenate(with: constraint2)
        XCTAssertEqual(constraint1.components.count, 2)
    }
    
    func testConstraintsConcatenateFromStart() {
        let constraint1 = Constraint(components: [ConstraintComponent.variable(withId: "1"), ConstraintComponent.variable(withId: "2")], axis: .horizontal)
        let constraint2 = Constraint(components: [ConstraintComponent.variable(withId: "3"), ConstraintComponent.variable(withId: "1")], axis: .horizontal)
        XCTAssertEqual(constraint1.components.count, 2)
        constraint1.concatenate(with: constraint2)
        XCTAssertEqual(constraint1.components.count, 3)
    }
    
    func testConstraintsConcatenateVertical() {
        let constraint1 = Constraint(components: [ConstraintComponent.variable(withId: "1"), ConstraintComponent.variable(withId: "2")], axis: .vertical)
        let constraint2 = Constraint(components: [ConstraintComponent.variable(withId: "3"), ConstraintComponent.variable(withId: "1")], axis: .vertical)
        XCTAssertEqual(constraint1.components.count, 2)
        constraint1.concatenate(with: constraint2)
        XCTAssertEqual(constraint1.components.count, 3)
    }
    
    func testIsParent() {
        XCTAssertTrue(ConstraintComponent.parent.isParent)
        XCTAssertFalse(ConstraintComponent.variable(withId: "image").isParent)
    }
    
    func testId() {
        XCTAssertEqual(ConstraintComponent.variable(withId: "id123").id, "id123")
        XCTAssertNil(ConstraintComponent.parent.id)
    }

}
