//
//  Variable.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import UIKit

class Variable {
    var widthType: Width
    var name: String
    var width: CGFloat? {
        didSet {
            guard dataType != .image else {
                return
            }
            height = size(of: content, with: width ?? 0, style: style).height
        }
    }
    var height: CGFloat?
    var x: CGFloat?
    var y: CGFloat?
    var dataType: DataType
    var content: String
    var style: UIFont
    
    init(dataType: DataType, content: String, widthType: Width, name: String, width: CGFloat? = nil, height: CGFloat? = nil, x: CGFloat? = nil, y: CGFloat? = nil, style: UIFont = .systemFont(ofSize: 16)) {
        self.dataType = dataType
        self.content = content
        self.widthType = widthType
        self.name = name
        self.width = width
        self.height = height
        self.x = x
        self.y = y
        self.style = style
        switch widthType {
        case .fixed(let value):
            self.width = CGFloat(value)
        default:
            break
        }
    }
    
    func size(of label: String, with width: CGFloat, style: UIFont) -> CGSize {
        
        let string: NSMutableAttributedString = NSMutableAttributedString(string: label, attributes: [NSAttributedString.Key.font: style])
        
        var boundingRect = string.boundingRect(with: CGSize(width: width , height: 9999), options: .usesLineFragmentOrigin, context: nil)
        
        if (boundingRect.size.width > width) {
            boundingRect = CGRect(x: 0, y: 0, width: width, height: boundingRect.size.height);
        }
        
        return boundingRect.size
    }
}
