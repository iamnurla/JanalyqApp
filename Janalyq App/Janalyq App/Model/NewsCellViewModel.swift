//
//  NewsCellViewModel.swift
//  Janalyq App
//
//  Created by Nurlybek Amanzhol on 26.05.2021.
//

import Foundation

//MARK: - NewsCellViewModel

class NewsCellViewModel {
    let title: String
    let publishedAt: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String,
         publishedAt: String,
         imageURL: URL?
         ) {
        self.title = title
        self.publishedAt = publishedAt
        self.imageURL = imageURL
    }
}
