//
//  Users.swift
//  iOS-task
//
//  Created by Toya on 2022/05/24.
//

import Foundation

struct SearchUsers: Codable {
    
    let items: [items]
    
    struct items: Codable {
        
        let avatar_url: String
        let login: String
        let type: String
        let html_url: String
        
    }
}

struct AllUsers: Codable {

        let avatar_url: String
        let login: String
        let type: String
        let html_url: String
    
}
