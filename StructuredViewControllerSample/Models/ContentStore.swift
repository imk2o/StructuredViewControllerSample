//
//  ContentStore.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/17.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

class ContentStore {
    static let shared = ContentStore()

    private var contents: [Content]
//        = [
//        Content(
//            id: 0,
//            title: "薔薇(バラ)",
//            image: UIImage(named: "rose")!,
//            summary: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//            comment: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//            relations: [
//                ContentDigest(id: 1, title: "空", image: UIImage(named: "rose")!),
//                ContentDigest(id: 2, title: "蒸気機関車", image: UIImage(named: "rose")!)
//            ]
//        ),
//        Content(
//            id: 1,
//            title: "空",
//            image: UIImage(named: "rose")!,
//            summary: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//            comment: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//            relations: [
//                ContentDigest(id: 0, title: "薔薇(バラ)", image: UIImage(named: "rose")!),
//                ContentDigest(id: 2, title: "蒸気機関車", image: UIImage(named: "rose")!)
//            ]
//        ),
//        Content(
//            id: 2,
//            title: "蒸気機関車",
//            image: UIImage(named: "rose")!,
//            summary: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//            comment: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//            relations: [
//                ContentDigest(id: 0, title: "薔薇(バラ)", image: UIImage(named: "rose")!),
//                ContentDigest(id: 1, title: "空", image: UIImage(named: "rose")!)
//            ]
//        )
//    ]
    
    private lazy var indexedContents: [Int: Content] = {
        // [Content] -> [(id: Int, Content)] -> [Int: Content]
        return .init(
            self.contents.map { ($0.id, $0) }
        ) { (id, _) in
            return id
        }
    }()
    
    private init() {
        if let url = Bundle.main.url(forResource: "contents", withExtension: "json") {
            do {
                self.contents = try JSONDecoder().decode(
                    [Content].self,
                    from: try Data(contentsOf: url)
                )
            } catch {
                print(error)
                self.contents = []
            }
        } else {
            self.contents = []
        }
    }
    
    func contentDigests(completion: @escaping ([ContentDigest]) -> Void) {
        completion(self.contents.map { (content) in
            return content.digest
        })
    }
    
    func content(for id: Int, completion: @escaping (Content?) -> Void) {
        // 少しウェイトを入れてレスポンス
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [unowned self] in
            completion(self.indexedContents[id])
        }
    }
}

private extension Content {
    var digest: ContentDigest {
        return .init(
            id: self.id,
            title: self.title,
            imageID: self.imageID,
            summary: self.summary
        )
    }
}
