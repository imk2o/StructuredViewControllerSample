//
//  ContentTextViewController.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/14.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

/// コンテンツ詳細・テキストビュー。
class ContentTextViewController: UIViewController, StructuredChildProtocol {
    enum ReferenceProperty {
        case summary
        case comment
    }
    var referenceProperty: ReferenceProperty!	// 親VCから与えること！
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var moreButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func readMore(_ sender: Any) {
        // Text Viewの高さ制約を解き、全文を表示
        self.textViewHeightContraint.isActive = false
        self.moreButton.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    // MARK: Confirm to StructuredChildProtocol
    typealias OwnerViewController = ContentViewController
    
    func configureSelf() {
        guard let context = self.ownerViewController?.context else {
            return
        }

        self.textView.text = {
            switch self.referenceProperty as ReferenceProperty {
            case .summary:
                switch context {
                case .digest(let digest):
                    return digest.summary
                case .content(let content):
                    return content.summary
                }
            case .comment:
                if case .content(let content) = context {
                    return content.comment
                } else {
                    return ""
                }
            }
        }()
    }
}
