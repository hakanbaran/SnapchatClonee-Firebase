//
//  File.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 7.11.2022.
//

import Foundation

class UserSingleton {
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
    
}
