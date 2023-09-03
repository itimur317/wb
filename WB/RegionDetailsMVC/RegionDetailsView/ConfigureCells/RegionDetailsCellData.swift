//
//  RegionDetailsCellData.swift
//  WB
//
//  Created by Галимов Тимур on 03.09.2023.
//

import Foundation

enum RegionDetailsCellData {
    case images([Image])
    case details(RegionDetails, RegionDetailsCellDelegate)
}

extension RegionDetailsCellData {
    var reuseIdentifier: String {
        switch self {
        case .images:
            return RegionDetailsImagesCarouselCell.reuseIdentifier
        case .details:
            return RegionDetailsCell.reuseIdentifier
        }
    }
}
