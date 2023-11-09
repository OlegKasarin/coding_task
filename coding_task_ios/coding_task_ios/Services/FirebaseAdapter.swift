//
//  FirebaseAdapter.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import Foundation
import FirebaseRemoteConfig

protocol FirebaseAdapterProtocol {
    func configure()
    func startListenChanges(_ listener: FirebaseAdapterDelegateProtocol)
}

protocol FirebaseAdapterDelegateProtocol: AnyObject {
    func configIsUpdated(cards: [CardItem])
}

private enum RemoteConfigKeys {
    static let cardsKey = "cards"
}

final class FirebaseAdapter {
    static var shared = FirebaseAdapter()
    
    private let remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()
    
    weak var delegate: FirebaseAdapterDelegateProtocol?
    
    private init() {}
    
    // MARK: - Private
    
    private func fetchAndActivate() {
        remoteConfig.fetchAndActivate { status, error in
            guard error == nil else {
                return
            }

            self.notifyDelegate()
        }
    }
    
    private func notifyDelegate() {
        guard let delegate = delegate else {
            debugPrint("FirebaseAdapter: no delegate error")
            return
        }
        
        let data = remoteConfig.configValue(forKey: RemoteConfigKeys.cardsKey).dataValue
        
        do {
            let items = try JSONDecoder().decode([CardItemResponse].self, from: data)
            let cards = items.compactMap { CardItem(response: $0) }
            delegate.configIsUpdated(cards: cards)
        } catch let error {
            debugPrint("FirebaseAdapter: JSONDecoder fail: \(error)")
        }
    }
}

// MARK: - FirebaseAdapterProtocol

extension FirebaseAdapter: FirebaseAdapterProtocol {
    func configure() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = .zero
        remoteConfig.configSettings = settings
        
        // set defaults
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
    }
    
    func startListenChanges(_ listener: FirebaseAdapterDelegateProtocol) {
        delegate = listener
        
        fetchAndActivate()
        
        // start listen updates
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard
                error == nil,
                let configUpdate = configUpdate
            else {
                debugPrint("FirebaseAdapter: configUpdate error")
                return
            }
            
            debugPrint("FirebaseAdapter updatedKeys: \(configUpdate.updatedKeys)")
            
            self.remoteConfig.activate { changed, error in
                guard error == nil else {
                    debugPrint("FirebaseAdapter: activate error")
                    return
                }
                
                self.notifyDelegate()
            }
        }
    }
}
