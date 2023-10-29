//
//  SettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 26/10/23.
//

import UIKit

final class SettingsCellViewModel: Identifiable {
    let id = UUID()
    let type: SettingsOption
    let tapHandler: (SettingsOption) -> Void
    
    init(type: SettingsOption, onTapHandler: @escaping (SettingsOption) -> Void) {
        self.type = type
        self.tapHandler = onTapHandler
    }
    
    var image: UIImage? {
        return type.iconImage
    }
    
    var title: String {
        return type.displayTitle
    }
    
    var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
