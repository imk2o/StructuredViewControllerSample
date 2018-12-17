//
//  Content.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/17.
//  Copyright © 2018 imk2o. All rights reserved.
//

import Foundation

protocol ContentDigestProtocol {
    var id: Int { get }
    var title: String { get }
    var imageID: String { get }
    var summary: String { get }
}

struct ContentDigest: ContentDigestProtocol, Decodable {
    let id: Int
    let title: String
    let imageID: String
    let summary: String
}

struct Content: ContentDigestProtocol, Decodable {
    let id: Int
    let title: String
    let imageID: String
    let summary: String
    let comment: String?
    let relations: [ContentDigest]
}

import UIKit
extension ContentDigestProtocol {
    var image: UIImage {
        return UIImage(named: self.imageID)!
    }
}
