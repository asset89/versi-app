//
//  SearchViewController.swift
//  versi-app
//
//  Created by Asset Ryskul on 16.07.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class SearchViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchTextField: RoundedTextField!
    @IBOutlet weak var tableView: UITableView!

    let group = DispatchGroup()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        bindSearchField()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func bindSearchField() {
        let searchTextObservable = searchTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map {
                $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            }
            .flatMap { (query) -> Observable<[Repo]> in
                if query == "" {
                    return Observable<[Repo]>.just([])
                } else {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    let url = searchUrl + query + starsDescendingSegment
                    var searchRepos = [Repo]()
                    return URLSession.shared.rx.json(url: URL(string: url)!).map { [self] in
                        let results = $0 as AnyObject
                        let items = results.object(forKey: "items") as? [Dictionary<String, Any>] ?? []
                        for item in items {
                            guard let ownerDict = item["owner"] as? Dictionary<String, Any>,
                                  let avatar_url = ownerDict["avatar_url"] as? String,
                                  let name = item["name"] as? String,
                                  let description = item["description"] as? String,
                                  let language = item["language"] as? String,
                                  let numberOfForks = item["forks_count"] as? Int,
                                  let repoUrl = item["html_url"] as? String
                            else { break }
                            DownloadService.instance.downloadAvatarImage(avatarUrl: avatar_url)
                            
                            sleep(1)
                            let image = DownloadService.instance.returnedImage
                            let repo = Repo(image: image, name: name, description: description,numberOfForks: numberOfForks, language: language ?? "Swift", numberOfContributors: 0, repoUrl: repoUrl)
                            searchRepos.append(repo)
                        }
                        return searchRepos
                    }
                }
            }
            .observe(on: MainScheduler.instance)
        
        searchTextObservable.bind(to: self.tableView.rx.items(cellIdentifier: "searchCell")) {
            (row, repo: Repo, cell: SearchTableViewCell) in
            cell.configureCell(repo: repo)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }.disposed(by: self.disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell else {return}
        self.presentSFSafariVCFor(url: cell.repoUrl!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
