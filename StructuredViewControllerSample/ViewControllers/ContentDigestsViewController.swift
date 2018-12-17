//
//  ContentDigestsViewController.swift
//  StructuredViewControllerSample
//
//  Created by k2o on 2018/12/17.
//  Copyright © 2018 imk2o. All rights reserved.
//

import UIKit

/// コンテンツ概要一覧ビュー。
class ContentDigestsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var digests: [ContentDigest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.load()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "showDetail":
            guard
                let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell),
                let digest = self.digest(at: indexPath)
            else {
                break
            }
            
            // 表示させるコンテンツの概要を引き渡す
            let contentViewController = segue.destination as! ContentViewController
            contentViewController.context = .digest(digest)
        default:
            break
        }
    }
    
    private func load() {
        ContentStore.shared.contentDigests { [weak self] (digests) in
            
            self?.digests = digests
            self?.tableView.reloadData()
        }
    }
}

extension ContentDigestsViewController: UITableViewDataSource, UITableViewDelegate {
    private func digest(at indexPath: IndexPath) -> ContentDigest? {
        return self.digests[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.digests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let digest = self.digest(at: indexPath) {
            cell.textLabel?.text = digest.title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
