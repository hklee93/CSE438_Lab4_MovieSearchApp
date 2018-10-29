//
//  APIResults.swift
//  HakkyungLee-Lab4_v2
//
//  Created by Hakkyung on 2018. 10. 18..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//

import Foundation

struct APIResults:Decodable {
    
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
