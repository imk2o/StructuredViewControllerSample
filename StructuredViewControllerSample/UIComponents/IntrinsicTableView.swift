//
//  IntrinsicTableView.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/15.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

/// 高さがintrinsicなUITableView
/// https://stackoverflow.com/questions/2595118/resizing-uitableview-to-fit-content/48623673#48623673
class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            if !self.isScrollEnabled {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if self.isScrollEnabled {
            return super.intrinsicContentSize
        } else {
            self.layoutIfNeeded()
            return CGSize(
                width: UIView.noIntrinsicMetric,
                height: self.contentSize.height
            )
        }
    }
}
