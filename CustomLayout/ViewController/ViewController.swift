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

        viewModel?.align({ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let successfyllyAligned):
                guard successfyllyAligned == true, let layoutItems = self.viewModel?.fit(to: self.viewInsideSafeArea.frame) else {
                    self.showAlert(with: AppError.generalError)
                    return
                }
                
                self.displayLayout(layoutItems)
            case .failure(let error):
                self.showAlert(with: error)
            }
        })
    }
    
    private func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
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

