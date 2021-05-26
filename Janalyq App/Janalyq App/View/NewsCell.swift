//
//  NewsCell.swift
//  Janalyq App
//
//  Created by Nurlybek Amanzhol on 26.05.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "NewsCell"
    
    private let newsTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .semibold)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let publishedAtLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17, weight: .light)
        return lbl
    }()
    
    private let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 6
        iv.layer.masksToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    //MARK: - Helpers

    func configureUI(){
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(publishedAtLbl)
        contentView.addSubview(newsImageView)

        newsTitleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 5, width: 270)
        publishedAtLbl.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 10, paddingBottom: 10, width: 100)
        newsImageView.anchor(top: topAnchor, left: newsTitleLabel.rightAnchor , bottom: bottomAnchor, right: rightAnchor, paddingTop: 3, paddingLeft: 3, paddingBottom: 3, paddingRight: 3, width: 140)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        publishedAtLbl.text = nil
        newsImageView.image = nil
    }
    
    
    func configure(with viewModel: NewsCellViewModel) {
        newsTitleLabel.text = viewModel.title
        publishedAtLbl.text = viewModel.publishedAt.getTimeAgo()
        
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL{
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
                
            } .resume()

        }
    }
    
}
