//
//  ContentSectionViewController.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/14.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

/// コンテンツ詳細・セクションビュー。
class ContentSectionViewController: UIViewController, StructuredChildProtocol {
    
    var sectionTitle: String!        // 親VCから与えること！
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Confirm to StructuredChildProtocol
    typealias OwnerViewController = ContentViewController
    
    func configureSelf() {
        self.titleLabel.text = sectionTitle
    }
}

