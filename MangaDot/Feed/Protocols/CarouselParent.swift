//
//  CarouselParent.swift
//  MangaDot
//
//  Created by Jian Chao Man on 5/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit

protocol CarouselParent {
    var selectedCell: CarouselCell? { get set }
    var currentView: UIView { get }
}
