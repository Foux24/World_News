//
//  WorldNewsBuilder.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit

// MARK: - SearchPhotoBuilder
class WorldNewsBuilder {
    
    /// Билд контроллера
    static func build() -> (UIViewController & WorldNewsViewModelInput) {

        let viewModel = WorldNewsViewModel()
        let viewController = WorldNewsViewController(viewModel: viewModel)
        viewModel.controller = viewController

        return viewController
    }
}
