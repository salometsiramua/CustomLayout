//
//  DataTranslator.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import UIKit

protocol DataTranslator {
    var canLayout: Bool { get }
    func translate(data: [LayoutObject])
    func fit(to rect: CGRect) -> [LayoutDisplayItem]
}

class DataTranslatorService: DataTranslator {
    
    var canLayout: Bool = false
    
    private let simpexSolver: SimpexSolver
    
    init(simpexSolver: SimpexSolver = SimpexSolverService()) {
        self.simpexSolver = simpexSolver
    }
    
    func translate(data: [LayoutObject]) {
        simpexSolver.removeAll()
        data.forEach { (object) in
            var variable: Variable
            switch object.width {
            case .fill:
                variable = Variable(dataType: object.dataType, content: object.content, widthType: .fill, name: object.id)
            case .fixed(let value):
                variable = Variable(dataType: object.dataType, content: object.content, widthType: .fixed(value: value), name: object.id)
            }
            
            switch object.relativity {
            case .parent(let anchors, _ ):
                anchors?.forEach({ (anchor) in
                    switch anchor {
                    case .bottom:
                        simpexSolver.addConstraintComponents(componentOne: .variable(withId: variable.name), componentTwo: .parent, axis: .vertical)
                    case .left:
                        simpexSolver.addConstraintComponents(componentOne: .parent, componentTwo: .variable(withId: variable.name), axis: .horizontal)
                    case .top:
                        simpexSolver.addConstraintComponents(componentOne: .parent, componentTwo: .variable(withId: variable.name), axis: .vertical)
                    case .right:
                        simpexSolver.addConstraintComponents(componentOne: .variable(withId: variable.name), componentTwo: .parent, axis: .horizontal)
                    }
                })
            case .layout(let referenceIds, let anchors, _ ):
                anchors?.forEach({ (anchor) in
                    referenceIds?.forEach({ (referenceId) in
                        let axis: Axis
                        switch anchor {
                        case .left, .right: axis = .horizontal
                        case .top, .bottom: axis = .vertical
                        }
                        simpexSolver.addConstraintComponents(componentOne: .variable(withId: referenceId), componentTwo: .variable(withId: object.id), axis: axis)
                    })
                })
            }
            
            simpexSolver.addVariable(variable)
        }
        
        canLayout = true
    }
    
    func fit(to rect: CGRect) -> [LayoutDisplayItem] {
        guard canLayout == true else {
            return []
        }
        
        let variables = simpexSolver.resolve(for: rect)
        
        return variables.map { LayoutDisplayItem(dataType: $0.dataType, content: $0.content, rect: CGRect(x: $0.x ?? 0, y: $0.y ?? 0, width: $0.width ?? rect.width, height: $0.height ?? 0
        ))}
    }
}
