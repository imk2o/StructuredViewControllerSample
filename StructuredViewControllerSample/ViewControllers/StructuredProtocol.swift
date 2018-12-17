//
//  StructuredProtocol.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/17.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

protocol StructuredProtocol: class {
    func configureSelf()
}
typealias StructuredViewController = UIViewController & StructuredProtocol

extension StructuredProtocol where Self: UIViewController {
    func configure() {
        self.configureSelf()
       
        self.children
            .compactMap { $0 as? StructuredViewController }
            .forEach { $0.configure() }
    }
    
    func configureSelf() {}
}

protocol StructuredChildProtocol: StructuredProtocol {
    associatedtype OwnerViewController: UIViewController
}

extension StructuredChildProtocol where Self: UIViewController {
    var ownerViewController: OwnerViewController? {
        return self.parent(of: OwnerViewController.self)
    }
    
    private func parent<VC: UIViewController>(of type: VC.Type) -> VC? {
        var parent = self.parent
        while parent != nil {
            if let typedParent = parent as? VC {
                return typedParent
            }
            parent = parent?.parent
        }
        
        return nil
    }
}
