//
//  UserDefaults+Helper.swift
//  SHRichTextEditorTools
//
//  Created by Ajay Bhanushali on 10/07/20.
//  Copyright © 2020 hsusmita. All rights reserved.
//

import LinkPresentation

@available(iOS 13.0, *)
extension UserDefaults {
    func store(_ metadata: LPLinkMetadata) {
        let storage = UserDefaults.standard
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            var metadatas = storage.dictionary(forKey: "Metadata") as? [String: Data] ?? [String: Data]()
            while metadatas.count > 10 {
                guard let key = metadatas.randomElement()?.key else { return }
                metadatas.removeValue(forKey: key)
            }
            guard let absString = metadata.originalURL?.absoluteString else { return }
            metadatas[absString] = data
            storage.set(metadatas, forKey: "Metadata")
        }
        catch {
            print("Failed storing metadata with error \(error as NSError)")
        }
    }
    
    func metadata(for url: URL) -> LPLinkMetadata? {
        let storage = UserDefaults.standard
        guard let metadatas = storage.dictionary(forKey: "Metadata") as? [String: Data] else { return nil }
        guard let data = metadatas[url.absoluteString] else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data)
        }
        catch {
            print("Failed to unarchive metadata with error \(error as NSError)")
            return nil
        }
    }
}
