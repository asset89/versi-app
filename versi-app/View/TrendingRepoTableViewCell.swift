//
//  TrendingRepoTableViewCell.swift
//  versi-app
//
//  Created by Asset Ryskul on 21.07.2022.
//

import UIKit
import RxSwift
import RxCocoa

class TrendingRepoTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var numberOfForksLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var contributorsLabel: UILabel!
    
    @IBOutlet weak var viewReadmeButton: UIButton!
    
    private var repoUrl: String?
    
    var disposeBag = DisposeBag()
    
    
    func configureCell(repo: Repo) {
        repoImageView.image = repo.image
        nameLabel.text = repo.name
        descriptionLabel.text = repo.description
        numberOfForksLabel.text = String(describing: repo.numberOfForks)
        languageLabel.text = repo.language
        contributorsLabel.text = String(describing: repo.numberOfContributors)
        repoUrl = repo.repoUrl
        
        viewReadmeButton.rx.tap
            .subscribe(onNext: {
                self.window!.rootViewController?.presentSFSafariVCFor(url: self.repoUrl!)
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        backView.layer.cornerRadius = 5.0
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowRadius = 5.0
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    


}
