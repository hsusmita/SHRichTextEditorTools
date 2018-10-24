//
//  BundleExtension.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 24/10/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import Foundation

extension Bundle {
	static func getResourcesBundle(for aClass: AnyClass) -> Bundle? {
		let bundle = Bundle(for: aClass.self)
		guard let resourcesBundleUrl = bundle.url(forResource: "Resources", withExtension: "bundle") else {
			return nil
		}
		return Bundle(url: resourcesBundleUrl)
	}
}
