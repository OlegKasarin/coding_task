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

protocol FirebaseAdapterDelegateProtocol {
    func configIsUpdated(cards: [CardItem])
}

final class FirebaseAdapter {
    static var shared = FirebaseAdapter()
    
    private let remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()
    
    var delegate: FirebaseAdapterDelegateProtocol?
    
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
        
        let data = remoteConfig.configValue(forKey: "cards").dataValue
//        else {
//            debugPrint("FirebaseAdapter: json value error")
//            return
//        }
        
        do {
            let cards = try JSONDecoder().decode([CardItem].self, from: data)
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
        settings.minimumFetchInterval = 0
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
            
            debugPrint("FirebaseAdapter: \(configUpdate.updatedKeys)")
            
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
