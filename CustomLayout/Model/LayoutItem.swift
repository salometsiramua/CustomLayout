//
//  LayoutItem.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 23.02.21.
//

import UIKit

class LayoutDisplayItem {
    let dataType: DataType
    let content: String
    let frame: CGRect
    let view: UIView
    let style: UIFont
    
    private let imageDownloader: ImageDownloader
    
    init(dataType: DataType, content: String, rect: CGRect, imageDownloader: ImageDownloader = ImageDownloaderService(), style: UIFont = .systemFont(ofSize: 16)) {
        self.dataType = dataType
        self.content = content
        self.frame = rect
        self.imageDownloader = imageDownloader
        self.style = style
        
        switch dataType {
        case .image:
            view = UIImageView(frame: rect)
        default:
            view = UILabel(frame: rect)
        }
        
    }
    
    func configure() {
        switch dataType {
        case .image:
            imageDownloader.download(from: content) { [weak self] (result) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        (self?.view as? UIImageView)?.image = image
                        self?.view.layoutSubviews()
                    }
                case .failure:
                    break
                }
                
            }
        default:
            (view as? UILabel)?.text = content
        }
    }
    
}

protocol LayoutDisplayable {
    associatedtype ViewComponent: UIView
    
    var view: ViewComponent { get }
    func add(to superView: UIView)
    func configure(with content: String)
}

extension LayoutDisplayable {
    func add(to superView: UIView) {
        superView.addSubview(view)
    }
}

class LayoutDisplayableImage: LayoutDisplayable {
    typealias ViewComponent = UIImageView
    var view: UIImageView = UIImageView()
    
    private let imageDownloader: ImageDownloader
    
    init(downloader: ImageDownloader) {
        self.imageDownloader = downloader
    }
    
    func configure(with content: String) {
        imageDownloader.download(from: content) { [weak self] (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.view.image = image
                }
            case .failure:
                break
            }
        }
    }
}

class LayoutDisplayableTextView: LayoutDisplayable {
    typealias ViewComponent = UILabel
    var view: UILabel = UILabel()
    
    func configure(with content: String) {
        view.text = content
    }
}
