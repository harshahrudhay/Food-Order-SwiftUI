//
//  Order+CoreDataProperties.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var userEmail: String?
    @NSManaged public var items: Data?
    @NSManaged public var total: Double
    @NSManaged public var status: String?

}

extension Order : Identifiable {

}
