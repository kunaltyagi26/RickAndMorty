//
//  SettingsView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 27/10/23.
//

import SwiftUI

struct SettingsView: View {
    var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { model in
            HStack {
                if let image = model.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.white))
                        .padding(6)
                        .background(Color(model.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(model.title)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding([.top, .bottom], 3)
            .onTapGesture {
                model.tapHandler(model.type)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            viewModel: SettingsViewModel(
                cellViewModels: SettingsOption.allCases.compactMap {
                    SettingsCellViewModel(type: $0) { _ in
                        
                    }
                }
            )
        )
    }
}
