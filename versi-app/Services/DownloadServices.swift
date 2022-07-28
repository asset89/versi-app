//
//  DownloadServices.swift
//  versi-app
//
//  Created by Asset Ryskul on 27.07.2022.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

class DownloadService {
    static let instance = DownloadService()
    public private(set) var returnedImage = UIImage()
    
    func downloadTrendingReposDictArray(completion: @escaping (_ reposDictArray: [Dictionary<String, Any>])->()) {
        var trendingRepoArray = [Dictionary<String,Any>]()
        AF.request(trendingRepoUrl).responseJSON { response in
            guard let json = response.value as? Dictionary<String, Any> else { return }
            guard let reposDictionaryArray = json["items"] as? [Dictionary<String, Any>] else { return }
            for repoDict in reposDictionaryArray {
                if trendingRepoArray.count <= 9 {
                    guard let ownerDict = repoDict["owner"] as? Dictionary<String, Any>,
                          let avatar_url = ownerDict["avatar_url"] as? String,
                          let name = repoDict["name"] as? String,
                          let description = repoDict["description"] as? String,
                          let numberOfForks = repoDict["forks_count"] as? Int,
                          let language = repoDict["language"] ?? "Swift" as? String ,
                          let numberOfContributors = repoDict["contributors_url"] as? String,
                          let repoUrl = repoDict["html_url"] as? String
                    else { break }
                    let reposDictionary: Dictionary<String, Any> = [
                        "name": name, "description": description, "avatar_url": avatar_url,
                        "numberOfForks": numberOfForks, "language": language ,
                        "numberOfContributors": numberOfContributors, "repoUrl": repoUrl
                        
                    ]
                    trendingRepoArray.append(reposDictionary)
                } else {
                    break
                }
            }
            completion(trendingRepoArray)
        }
    }
    
    func downloadTrendingRepos(completion: @escaping (_ repos: [Repo]) -> ()) {
        var repos = [Repo]()
        downloadTrendingReposDictArray { reposDictArray in
            for dict in reposDictArray {
                self.downloadTrendingRepo(fromDictionary: dict) { repo in
                    if repos.count < 9 {
                        repos.append(repo)
                    } else {
                        let sortedRepos = repos.sorted { repoA, repoB in
                            if repoA.numberOfContributors > repoB.numberOfContributors {
                                return true
                            }
                            else {
                                return false
                            }
                        }
                        completion(sortedRepos)
                    }
                }
            }
        }
    }
    
    func downloadTrendingRepo(fromDictionary dict: Dictionary<String, Any>, completion: @escaping (_ repo: Repo) -> ()) {
        let image = dict["avatar_url"] as! String
        let name = dict["name"] as! String
        let description = dict["description"] as! String
        let numberOfForks = dict["numberOfForks"] as! Int
        let language = dict["language"] as? String
        let numberOfContributors = dict["numberOfContributors"] as! String
        let repoUrl = dict["repoUrl"] as! String
        downloadImageFor(avatarUrl: image) { returnedImage in
            self.downloadContributorsData(contributorsUrl: numberOfContributors) { contributors in
                let repo = Repo(image: returnedImage, name: name, description: description, numberOfForks: numberOfForks, language: language ?? "Swift", numberOfContributors: contributors, repoUrl: repoUrl)
                completion(repo)
            }
        }
    }
    
    func downloadImageFor(avatarUrl: String, completion: @escaping (_ image: UIImage) -> ()) {
        AF.request(avatarUrl).responseImage { imageResponse in
            guard let image = imageResponse.value else { return }
            completion(image)
        }
    }
    
    func downloadAvatarImage(avatarUrl: String) {
        AF.request(avatarUrl).responseImage { imageResponse in
            guard let image = imageResponse.value else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                self.setImage(image)
            }
        }
    }
    
    private func setImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.returnedImage = image
        }
    }
    
    func downloadContributorsData(contributorsUrl: String, completion: @escaping (_ contributors: Int) -> ()) {
        AF.request(contributorsUrl).responseJSON { response in
            guard let json = response.value as? [Dictionary<String, Any>] else { return }
            if !json.isEmpty {
                completion(json.count)
            }
        }
    }
}
