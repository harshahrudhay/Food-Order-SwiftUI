//
//  User+CoreDataProperties.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//
//

import Foundation
import CoreData



extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var newFollower: Bool

}

extension User : Identifiable {

}
