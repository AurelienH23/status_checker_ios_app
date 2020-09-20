//
//  Service+CoreDataProperties.swift
//  StatusChecker
//
//  Created by Aurélien Haie on 24/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var lastTimeChecked: String?
    @NSManaged public var status: Int16
    @NSManaged public var url: String?
    @NSManaged public var name: String?

}
