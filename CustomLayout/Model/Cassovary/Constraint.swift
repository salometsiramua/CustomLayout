//
//  Constraint.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import Foundation

class Constraint {
    var components: [ConstraintComponent]
    var axis: Axis
    
    init(components: [ConstraintComponent] = [], axis: Axis) {
        self.components = components
        self.axis = axis
    }
    
    func insert(_ component: ConstraintComponent, at index: Int) {
        if components.count == index {
            components.append(component)
            return
        }
        
        guard components.count > index else {
            return
        }
        
        components.insert(component, at: index)
    }
    
    func concatenate(with constraint: Constraint) {
        if constraint.components.first?.id == components.last?.id {
            components.removeLast()
            components.append(contentsOf: constraint.components)
        } else if constraint.components.last?.id == components.first?.id {
            components.removeFirst()
            components.insert(contentsOf: constraint.components, at: 0)
        }
    }
}

enum Axis {
    case horizontal
    case vertical
}

enum ConstraintComponent {
    case parent
    case variable(withId: String)
    
    var isParent: Bool {
        self == .parent
    }
    
    var id: String? {
        switch self {
        case .parent:
            return nil
        case .variable(let id):
            return id
        }
    }
}

extension ConstraintComponent: Equatable {
    
}
