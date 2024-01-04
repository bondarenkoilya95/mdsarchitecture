//
//  InitialScenario.swift
//  
//
//  Created by Ilya Bondarenko on 05.01.2024.
//

import UIKit

open class InitialScenario: Scenario {
    
    open private(set) var window: UIWindow
    
    // MARK: - Init Method
    
    public init(window: UIWindow, delegate: ScenarioDelegate?, rootVC: UIViewController) {
        self.window = window
        super.init(delegate: delegate, rootVC: rootVC)
    }
    
    // MARK: - Open Methods
    
    open func installRootViewController(viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
