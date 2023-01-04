//
//  News.swift
//  weather
//
//  Created by mac on 31.03.22.
//
import Foundation

// MARK: - Welcome
struct WelcomeNews: Codable {
    let status: String
       let totalResults: Int
       let articles: [Article]
   }

   // MARK: - Article
   struct Article: Codable {
       let source: Source
       let author: String?
       let title: String
       let articleDescription: String?
       let url: String
       let urlToImage: String?
       let publishedAt: String
       let content: String?

       enum CodingKeys: String, CodingKey {
           case source, author, title
           case articleDescription = "description"
           case url, urlToImage, publishedAt, content
       }
   }

   // MARK: - Source
   struct Source: Codable {
       let id: String?
       let name: String
   }
