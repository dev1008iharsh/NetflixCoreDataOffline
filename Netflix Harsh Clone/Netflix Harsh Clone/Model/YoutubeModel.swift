//
//  YoutubeSearch.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 20/12/23.
//

import Foundation

struct YoutubeModel: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}


