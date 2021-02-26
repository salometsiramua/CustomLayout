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
    
    init() {
        
    }
    
    func addVariable(_ variable: Variable) {
        variables.append(variable)
    }
    
    func addConstraintComponents(componentOne: ConstraintComponent, componentTwo: ConstraintComponent, axis: Axis) {
        constrainst.append(componentOne)
    }
    
    func resolve(for frame: CGRect) -> [Variable] {
        return []
    }
    
    func removeAll() {
        variables.removeAll()
    }
}
