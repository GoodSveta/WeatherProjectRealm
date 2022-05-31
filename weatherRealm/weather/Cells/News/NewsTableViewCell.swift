//
//  NewsTableViewCell.swift
//  weather
//
//  Created by mac on 31.03.22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewAllNews: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupNewsAll(with newsAll: Article) {
        titleLabel.text = newsAll.source.name
        dateLabel.text = newsAll.publishedAt
        contentLabel.text = newsAll.content
        authorLabel.text = newsAll.author
        
        DispatchQueue.global().async { [weak self] in
            if let urlToImage = URL(string: newsAll.urlToImage),
               let data = try? Data(contentsOf: urlToImage, options: .alwaysMapped) {
                DispatchQueue.main.async {
                    self?.imageViewAllNews.image = UIImage(data: data)
                }
            }
        }
    }
}
