//
//  MetadataStorage.swift
//  SHRichTextEditorTools
//
//  Created by D2k on 29/06/20.
//  Copyright © 2020 hsusmita. All rights reserved.
//

import LinkPresentation

@available(iOS 13.0, *)
struct MetadataStorage {
    private let storage = UserDefaults.standard
    
    func store(_ metadata: LPLinkMetadata) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            var metadatas = storage.dictionary(forKey: "Metadata") as? [String: Data] ?? [String: Data]()
            while metadatas.count > 10 {
                metadatas.removeValue(forKey: metadatas.randomElement()!.key)
            }
            metadatas[metadata.originalURL!.absoluteString] = data
            storage.set(metadatas, forKey: "Metadata")
        }
        catch {
            print("Failed storing metadata with error \(error as NSError)")
        }
    }
    
    func metadata(for url: URL) -> LPLinkMetadata? {
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
