//
//  LayoutElement.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 22.02.21.
//

import Foundation

struct LayoutObjectsContentArray: Decodable {
    let elements: [LayoutObjectContent]
}

struct LayoutObjectContent: Decodable {
    let id: String
    let data: Data
    let width: Width
    let position: Position
    
    struct Data: Decodable {
        let type: String
        let content: String
    }
    
    struct Width: Decodable {
        let mode: String
        let value: Double?
    }
    
    struct Position: Decodable {
        let anchors: [String]
        let relativity: Relativity
        
        struct Relativity: Decodable {
            let type: String
            let referenceIds: [String]?
            let alignment: String?
        }
    }
}

extension LayoutObjectsContentArray: MappableResponse {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(LayoutObjectsContentArray.self, from: data)
    }
}

class LayoutObject {
    let id: String
    let dataType: DataType
    let content: String
    let width: Width
    let anchors: [Anchor]
    let relativity: Relativity
    
    init(content: LayoutObjectContent) {
        self.id = content.id
        self.dataType = DataType(rawValue: content.data.type) ?? .text
        self.content = content.data.content
        self.width = Width(mode: content.width.mode, value: content.width.value)
        self.anchors = content.position.anchors.compactMap { Anchor(rawValue: $0) }
        self.relativity = Relativity(type: content.position.relativity.type, anchors: content.position.anchors, referenceIds: content.position.relativity.referenceIds, alignment: content.position.relativity.alignment)
    }
}

enum Anchor: String {
    case left
    case right
    case top
    case bottom
}

enum DataType: String {
    case image
    case text
    case date
}

enum Width {
    case fixed(value: Double)
    case fill
    
    init(mode: String, value: Double? = nil) {
        switch mode {
        case "pixel":
            self = .fixed(value: value ?? 0)
        default:
            self = .fill
        }
    }
}

extension Width: Equatable { }

enum Relativity {
    case layout(referenceIds: [String]?, anchors: [Anchor]?, alignment: Alignment? = nil)
    case parent(anchors: [Anchor]?, alignment: Alignment? = nil)
    
    init(type: String, anchors: [String], referenceIds: [String]? = nil, alignment: String?) {
        let alignment = Alignment(rawValue: alignment ?? "")
        let anchors = anchors.compactMap {Anchor(rawValue: $0)}
        switch type {
        case "layout":
            self = .layout(referenceIds: referenceIds, anchors: anchors, alignment: alignment)
        default:
            self = .parent(anchors: anchors, alignment: alignment)
        }
    }
}

enum Alignment: String {
    case left
    case top
    case right
    case bottom
}
