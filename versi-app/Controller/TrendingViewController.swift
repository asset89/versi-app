//
//  ViewController.swift
//  versi-app
//
//  Created by Asset Ryskul on 12.07.2022.
//

import UIKit
import RxSwift
import RxCocoa

class TrendingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let group = DispatchGroup()
    let refreshControl = UIRefreshControl()
    
    var trendingRepo = PublishSubject<[Repo]>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor(red: 71/255, green: 118/255, blue: 230/255, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Hot GitHub Repos 🔥", attributes: [.foregroundColor: UIColor(red: 71/255, green: 118/255, blue: 230/255, alpha: 1), .font: UIFont(name: "Avenir", size: 16.0)!])
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        fetchData()
        group.notify(queue: DispatchQueue.main) {
            self.trendingRepo.bind(to: self.tableView.rx.items(cellIdentifier: "trendingRepoCell")) {
                (row, repo: Repo, cell: TrendingRepoTableViewCell) in
                cell.configureCell(repo: repo)
            }.disposed(by: self.disposeBag)
        }
    }
    
    @objc func fetchData() {
        DownloadService.instance.downloadTrendingRepos { repos in
            self.group.enter()
            self.trendingRepo.onNext(repos)
            self.refreshControl.endRefreshing()
            self.group.leave()
        }
    }
}

