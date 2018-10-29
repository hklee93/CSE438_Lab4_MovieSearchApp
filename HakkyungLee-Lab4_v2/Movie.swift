//
//  Movie.swift
//  HakkyungLee-Lab4_v2
//
//  Created by Hakkyung on 2018. 10. 18..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    
    var vote_count:Int!
    var id: Int!
    var vote_average: Double
    var title: String
    var poster_path: String?
    var overview: String
    var release_date: String
}
