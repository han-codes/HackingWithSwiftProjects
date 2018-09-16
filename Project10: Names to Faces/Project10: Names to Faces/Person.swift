//
//  Person.swift
//  Project10: Names to Faces
//
//  Created by Hannie Kim on 8/30/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
