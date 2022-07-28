//
//  SearchTableViewCell.swift
//  versi-app
//
//  Created by Asset Ryskul on 28.07.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contributorsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    public private(set) var repoUrl: String?
    
    func configureCell(repo: Repo) {
        nameLabel.text = repo.name
        descriptionLabel.text = repo.description
        languageLabel.text = repo.language
        contributorsLabel.text = String(describing: repo.numberOfForks)
        repoUrl = repo.repoUrl
        avatarImageView.image = repo.image
    }
    
    override func layoutSubviews() {
        backView.layer.cornerRadius = 5.0
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowRadius = 5.0
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }


}
