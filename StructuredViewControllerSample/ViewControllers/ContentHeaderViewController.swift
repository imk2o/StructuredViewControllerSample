//
//  ContentHeaderViewController.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/14.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

/// コンテンツ詳細・ヘッダビュー。
/// 概要データ(ContentDigest)があれば表示できる。
class ContentHeaderViewController: UIViewController, StructuredChildProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var summaryTextViewController: ContentTextViewController!
    
    override func loadView() {
        super.loadView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Confirm to StructuredChildProtocol
    typealias OwnerViewController = ContentViewController
    
    func configureSelf() {
        guard let context = self.ownerViewController?.context else {
            return
        }

        let digest: ContentDigestProtocol = {
            switch context {
            case .digest(let digest):
                return digest
            case .content(let content):
                return content
            }
        }()
        
        self.imageView.image = digest.image
        self.titleLabel.text = digest.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "summaryTextView":
            // 子VCにはsummaryの内容を表示
            self.summaryTextViewController = segue.destination as? ContentTextViewController
            self.summaryTextViewController.referenceProperty = .summary
        default:
            break
        }
    }
}
