//
//  TaskData.swift
//  Pluto
//
//  Created by Kul on 11/23/2557 BE.
//  Copyright (c) 2557 Kul.com. All rights reserved.
//

import Foundation
import CoreData
@objc (TaskData)

class TaskData: NSManagedObject {

    @NSManaged var identifier: String
    @NSManaged var photoFullURL: String
    @NSManaged var photoThumbURL: String
    @NSManaged var taskDesc: String
    @NSManaged var taskImage: NSData
    @NSManaged var taskName: String

}
