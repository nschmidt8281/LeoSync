//
//  User.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/2/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let key: String
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let company: String
    let admin: Bool
    let ref: DatabaseReference?
    
    init(uid: String, email: String, firstName: String, lastName: String, company: String, admin: Bool, key: String = "") {
        self.key = key
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.admin = admin
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        email = snapshotValue["email"] as! String
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        company = snapshotValue["company"] as! String
        admin = snapshotValue["admin"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "uid" : uid,
            "email" : email,
            "firstName" : firstName,
            "lastName" : lastName,
            "company" : company,
            "admin" : admin
        ]
    }
}
