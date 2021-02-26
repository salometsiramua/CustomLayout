//
//  SimpexSolverMock.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 25.02.21.
//

import UIKit
@testable import CustomLayout

class SimpexSolverMock: SimpexSolver {
    
    var variables: [Variable] = []
    var constrainst: [ConstraintComponent] = []
    
    var variableAdded: Bool = false
    var constraintsAdded: Bool = false
    var allRemoved: Bool = false
    
    init() {
        
    }
    
    func addVariable(_ variable: Variable) {
        variableAdded = true
    }
    
    func addConstraintComponents(componentOne: ConstraintComponent, componentTwo: ConstraintComponent, axis: Axis) {
        constraintsAdded = true
    }
    
    func resolve(for frame: CGRect) -> [Variable] {
        return []
    }
    
    func removeAll() {
        allRemoved = true
    }
}
