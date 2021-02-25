//
//  SimpexSolverMock.swift
//  CustomLayoutTests
//
//  Created by Salome Tsiramua on 25.02.21.
//

import UIKit
@testable import CustomLayout

class SimpexSolverMock: SimpexSolver {
    
    init() {
        
    }
    
    func addVariable(_ variable: Variable) {
        
    }
    
    func addConstraintComponents(componentOne: ConstraintComponent, componentTwo: ConstraintComponent, axis: Axis) {
        
    }
    
    func resolve(for frame: CGRect) -> [Variable] {
        return []
    }
}
