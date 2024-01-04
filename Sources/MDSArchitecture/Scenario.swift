//
//  Scenario.swift
//
//
//  Created by Ilya Bondarenko on 05.01.2024.
//

import Foundation
#if os(iOS)
import UIKit
#endif

public protocol ScenarioDelegate: AnyObject {
    
    func didFinish(scenario: Scenario)
}

open class Scenario {
    
    // MARK: - Variables
    
    let id = UUID()
    
    open private(set) weak var delegate: ScenarioDelegate?
    
    open private(set) var rootVC: UIViewController?
    
    open private(set) var childScenarios: [Scenario] = [Scenario]()
    
    // MARK: - Init Method
    
    public init(delegate: ScenarioDelegate?, rootVC: UIViewController) {
        self.delegate = delegate
        self.rootVC = rootVC
    }
    
    // MARK: - Open Methods
    
    open func start() {
        /// This method should be override in subclass
    }
    
    open func stop() {
        finishAllChildScenarios()
    }
    
    open func finish() {
        delegate?.didFinish(scenario: self)
    }
    
    open func finishAllChildScenarios() {
        for childScenario in childScenarios {
            didFinish(scenario: childScenario)
        }
    }
}

extension Scenario: Equatable {
    
    public static func == (lhs: Scenario, rhs: Scenario) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Scenario {
    
    public func start(scenario: Scenario) {
        do {
            try add(childScenario: scenario)
            scenario.start()
        } catch ScenarioError.canNotAddScenarioAsChild {
            assertionFailure("The scenario can't be a child for itself")
        } catch ScenarioError.alreadyExist {
            assertionFailure("This scenario (\(scenario)) is already in the list of child scenarios")
        } catch {
            assertionFailure("Unknown error")
        }
    }
    
    public func start(scenarios: [Scenario]) {
        for scenario in scenarios {
            start(scenario: scenario)
        }
    }
}

private extension Scenario {
    
    func add(childScenario: Scenario) throws {
        guard childScenario != self else {
            throw ScenarioError.canNotAddScenarioAsChild
        }
        
        guard !childScenarios.contains(childScenario) else {
            throw ScenarioError.alreadyExist
        }
        
        childScenarios.append(childScenario)
    }
}

extension Scenario: ScenarioDelegate {
    
    public func didFinish(scenario: Scenario) {
        scenario.stop()
        childScenarios.removeAll { $0 == scenario }
    }
}
