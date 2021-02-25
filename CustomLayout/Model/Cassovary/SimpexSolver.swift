//
//  SimpexSolver.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import UIKit

protocol SimpexSolver {
    func addVariable(_ variable: Variable)
    func addConstraintComponents(componentOne: ConstraintComponent, componentTwo: ConstraintComponent, axis: Axis)
    func resolve(for frame: CGRect) -> [Variable]
}

class SimpexSolverService: SimpexSolver {
    
    private var variables: [Variable] = []
    private var constraints: [Constraint] = []
    
    init() {
    }
    
    func addVariable(_ variable: Variable) {
        variables.append(variable)
    }
    
    func addConstraintComponents(componentOne: ConstraintComponent, componentTwo: ConstraintComponent, axis: Axis) {
        
        var addedToConstraint: Constraint?
        
        constraints.forEach { (constraint) in
            guard constraint.axis == axis else { return }
            
            constraint.components.enumerated().forEach { (component) in
                switch component.element {
                case .parent:
                    break
                case .variable(let id):
                    if id == componentOne.id {
                        constraint.insert(componentTwo, at: component.offset + 1)
                        guard let updatedConstraint = addedToConstraint else {
                            addedToConstraint = constraint
                            return
                        }
                        constraint.concatenate(with: updatedConstraint)
                    } else if id == componentTwo.id {
                        constraint.insert(componentOne, at: component.offset)
                        guard let updatedConstraint = addedToConstraint else {
                            addedToConstraint = constraint
                            return
                        }
                        constraint.concatenate(with: updatedConstraint)
                    }
                }
            }
        }
        
        guard addedToConstraint == nil else {
            return
        }
        
        constraints.append(Constraint(components: [componentOne, componentTwo], axis: axis))
    }
    
    func resolve(for frame: CGRect) -> [Variable] {
        constraints.forEach { (constraint) in
            if constraint.axis == .horizontal {
                var totalWidth: CGFloat = 0
                let frameWidth: CGFloat = frame.width
                var variablesWithoutValue: [Variable] = []
                constraint.components.forEach { (component) in
                    guard !component.isParent else {
                        return
                    }
            
                    guard let variable = (variables.first { $0.name == component.id }) else {
                        return
                    }
                    if let width = variable.width {
                        totalWidth += width
                    } else {
                        variablesWithoutValue.append(variable)
                    }
                }
                
                guard frameWidth > totalWidth, !variablesWithoutValue.isEmpty else {
                    return
                }
                
                let newWidth = (frameWidth - totalWidth) / CGFloat(variablesWithoutValue.count)
                
                variablesWithoutValue.forEach { (variable) in
                    variable.width = newWidth
                }
                
                var accumulatedX: CGFloat = 0
                
                variables.forEach { (variable) in
                    if variable.width == nil && variable.widthType == .fill {
                        variable.width = frame.width
                    }
                }
                
                constraint.components.forEach { (component) in
                    guard let variable = (variables.first { $0.name == component.id }) else {
                        return
                    }
                    
                    variable.x = accumulatedX
                    accumulatedX += variable.width ?? 0
                }
            } else {
                var accumulatedY: CGFloat = 0
                
                constraint.components.forEach { (component) in
                    guard let variable = (variables.first { $0.name == component.id }) else {
                        return
                    }
                    
                    variable.y = accumulatedY
                    accumulatedY += variable.height ?? 0
                }
            }
        }
        
        return variables
    }
}
