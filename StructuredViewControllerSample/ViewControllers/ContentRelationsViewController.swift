//
//  ContentRelationsViewController.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/14.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

/// コンテンツ詳細・関連事項ビュー。
class ContentRelationsViewController: UIViewController, StructuredChildProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    private var content: Content? {
        return self.ownerViewController?.content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Confirm to StructuredChildProtocol
    typealias OwnerViewController = ContentViewController
    
    func configureSelf() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "showRelation":
            guard
                let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell),
                let relation = self.relation(at: indexPath)
            else {
                break
            }

            // 表示させるコンテンツの概要を引き渡す
            let contentViewController = segue.destination as! ContentViewController
            contentViewController.context = .digest(relation)
        default:
            break
        }
    }
}

extension ContentRelationsViewController: UITableViewDataSource, UITableViewDelegate {
    private func relation(at indexPath: IndexPath) -> ContentDigest? {
        return self.content?.relations[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content?.relations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let relation = self.relation(at: indexPath) {
            cell.textLabel?.text = relation.title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
