//
//  NewsTitleTableViewCell.swift
//  weather
//
//  Created by mac on 31.03.22.
//

import UIKit

class NewsTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageViewNews: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupNews(with news: Article) {
        newsLabel.text = news.title
        authorLabel.text = news.source.name
        
        DispatchQueue.global().async { [weak self] in
            if let urlToImage = URL(string: news.urlToImage ?? ""),
               let data = try? Data(contentsOf: urlToImage, options: .alwaysMapped) {
                DispatchQueue.main.async {
                    self?.imageViewNews.image = UIImage(data: data)
                }
            }
        }
    }
}
