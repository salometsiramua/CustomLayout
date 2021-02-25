//
//  ViewController.swift
//  CustomLayout
//
//  Created by Salome Tsiramua on 22.02.21.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: ViewModelable?
    
    var viewInsideSafeArea: UIView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
        view.addSubview(viewInsideSafeArea)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewInsideSafeArea.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: view.frame.width - view.safeAreaInsets.left - view.safeAreaInsets.right, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)

        viewModel?.align(for: viewInsideSafeArea.frame, { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let layoutItems):
                self.displayLayout(layoutItems)
            case .failure(let error):
                self.showAlert(with: error)
            }
        })
    }
    
    private func showAlert(with error: Error) {
        
    }
    
    private func displayLayout(_ layoutItems: [LayoutDisplayItem]) {
        
        viewInsideSafeArea.subviews.forEach({ (subview) in
            subview.removeFromSuperview()
        })
        
        layoutItems.forEach { (item) in
            viewInsideSafeArea.addSubview(item.view)
            item.configure()
        }
    }
}

