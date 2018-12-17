//
//  ContentViewController.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/14.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

/// コンテンツ詳細ビュー。
class ContentViewController: UIViewController, StructuredProtocol {
    enum EmbedSegue: String, CaseIterable {
        case headerView
        case commentSectionView
        case commentTextView
        case relationsSectionView
        case relationsView
        
        var identifier: String {
            return self.rawValue
        }
    
        // 詳細データを要するセグエ
        // 対応するVCのロードが遅延される
        static var contentRequiredSegues: [EmbedSegue] {
            return [
                .commentSectionView,
                .commentTextView,
                .relationsSectionView,
                .relationsView
            ]
        }
    }
    
    // 握っている概要または詳細データ
    enum Context {
        case digest(ContentDigest)
        case content(Content)
    }
    var context: Context!			// 遷移元VCから与えること！
    
    var content: Content? {
        if case .content(let content)? = self.context {
            return content
        } else {
            return nil
        }
    }
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var loadedViewControllers: [EmbedSegue: UIViewController] = [:]
    
    // MARK: Confirm to StructuredProtocol
    func configureSelf() {
        // 詳細データが読み込まれていれば、インジケータをOFF
        print(self.content != nil)
        self.indicatorView.isHidden = self.content != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ヘッダの更新用にコール
        self.configure()
        // 詳細データを読み込む
        self.load()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // 詳細データの内容によって、子VCを読み込むかを判断す
        if let embedSegue = EmbedSegue(rawValue: identifier) {
            return embedSegue.shouldLoad(content: self.content)
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if let embedSegue = EmbedSegue(rawValue: identifier) {
            switch embedSegue {
            case .headerView:
                //let headerViewController = segue.destination as? ContentHeaderViewController
                break
            case .commentSectionView:
                if let commentSectionViewController = segue.destination as? ContentSectionViewController {
                    commentSectionViewController.sectionTitle = "詳細"
                }
            case .commentTextView:
                if let commentTextViewController = segue.destination as? ContentTextViewController {
                    commentTextViewController.referenceProperty = .comment
                }
            case .relationsSectionView:
                if let relationsSectionViewController = segue.destination as? ContentSectionViewController {
                    relationsSectionViewController.sectionTitle = "関連事項"
                }
            case .relationsView:
                //let relationsViewController = segue.destination as? ContentRelationsViewController
                break
            }
            
            // 読み込み済みVCとする
            self.loadedViewControllers[embedSegue] = segue.destination
        }
    }
    
    private func load() {
        guard case .digest(let digest)? = self.context else {
            return
        }
        
        // 詳細データの読み込みと画面更新
        ContentStore.shared.content(for: digest.id) { [weak self] (content) in
            guard let content = content else {
                return
            }
            
            self?.context = .content(content)
            self?.loadChildren()
            self?.configure()
        }
    }
    
    // 遅延対象の子VCを読み込む
    private func loadChildren() {
        // 読み込み済、表示不要な子VCを除外して読み込みを実行
        EmbedSegue.allCases
            .filter {
                return (
                    self.loadedViewControllers[$0] == nil &&
                    $0.shouldLoad(content: self.content)
                )
            }
            .forEach {
                self.performSegue(withIdentifier: $0.identifier, sender: self)
            }
    }
}

private extension ContentViewController.EmbedSegue {
    func shouldLoad(content: Content?) -> Bool {
        switch self {
        case .headerView:
            return true
        case .commentSectionView,
             .commentTextView:
            return content?.comment != nil
        case .relationsSectionView,
             .relationsView:
            return (content?.relations.count ?? 0) > 0
        }
    }
}
