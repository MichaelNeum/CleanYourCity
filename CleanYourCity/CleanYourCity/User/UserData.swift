//
//  UserData.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 09.01.24.
//

import Foundation

class UserData {
    private static let key = "userId"
    
    static func getUserId() -> String {
        return UserDefaults.standard.object(forKey: key) as? String ?? ""
    }
    
    static func setUserId(id: String) {
        UserDefaults.standard.set(id, forKey: key)
    }
}
