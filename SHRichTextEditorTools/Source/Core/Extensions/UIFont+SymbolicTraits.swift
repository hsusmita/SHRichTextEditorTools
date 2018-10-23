//
//  UIFont+SymbolicTraits.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

//source http://stackoverflow.com/questions/38533323/ios-swift-making-font-toggle-bold-italic-bolditalic-normal-without-change-oth/38536097#38536097

import Foundation
import UIKit

public extension UIFont {
	
	var isBold: Bool {
		return fontDescriptor.symbolicTraits.contains(.traitBold)
	}
	
	var isItalic: Bool {
		return fontDescriptor.symbolicTraits.contains(.traitItalic)
	}
	
	func setBold() -> UIFont {
		if isBold {
			return self
		} else {
			var fontAttributes = fontDescriptor.symbolicTraits
			fontAttributes.insert([.traitBold])
			let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAttributes)
			return UIFont(descriptor: fontAtrDetails!, size: 0)
		}
	}
	
	func setItalic() -> UIFont {
		if isItalic {
			return self
		} else {
			var fontAttributes = fontDescriptor.symbolicTraits
			fontAttributes.insert([.traitItalic])
			let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAttributes)
			return UIFont(descriptor: fontAtrDetails!, size: 0)
		}
	}
	
	func setBoldItalic() -> UIFont {
		return setBold().setItalic()
	}
	
	func resetBoldItalic() -> UIFont {
		return resetBold().resetItalic()
	}
	
	func resetBold() -> UIFont {
		if !isBold {
			return self
		} else {
			var fontAttributes = fontDescriptor.symbolicTraits
			fontAttributes.remove([.traitBold])
			let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAttributes)
			return UIFont(descriptor: fontAtrDetails!, size: 0)
		}
	}
	
	func resetItalic() -> UIFont {
		if !isItalic {
			return self
		} else {
			var fontAttributes = fontDescriptor.symbolicTraits
			fontAttributes.remove([.traitItalic])
			let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAttributes)
			return UIFont(descriptor: fontAtrDetails!, size: 0)
		}
	}
	
	func toggleBold() -> UIFont {
		if isBold {
			return resetBold()
		} else {
			return setBold()
		}
	}
	
	func toggleItalic() -> UIFont {
		if isItalic {
			return resetItalic()
		}
		else {
			return setItalic()
		}
	}
}
