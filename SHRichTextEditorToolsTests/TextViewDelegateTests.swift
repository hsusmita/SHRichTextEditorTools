//
//  TextViewDelegateTests.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 22/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import XCTest
@testable import SHRichTextEditorTools

class TextViewDelegateTests: XCTestCase {
	
	var delegate: TextViewDelegate!
	var textView: UITextView!
	
    override func setUp() {
        super.setUp()
		delegate = TextViewDelegate()
		textView = UITextView()
		textView.delegate = delegate
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	// MARK: Test for open func registerShouldBeginEditing(with handler: (UITextView) -> Bool)
	
	func testRegisterShouldBeginEditingFalse() {
		//Given
		delegate?.registerShouldBeginEditing(with: { textView -> Bool in
			return false
		})
		
		//When
		let result = textView.delegate?.textViewShouldBeginEditing!(textView)
		
		//Assertion
		XCTAssert(result == false)
	}
	
	func testRegisterShouldBeginEditingTrue() {
		//Given
		delegate?.registerShouldBeginEditing(with: { textView -> Bool in
			return true
		})
		
		//When
		let result = textView.delegate?.textViewShouldBeginEditing!(textView)
		
		//Assertion
		XCTAssert(result == true)
	}
	
	func testNoRegisterForShouldBeginEditing() {
		//When
		let result = textView.delegate?.textViewShouldBeginEditing!(textView)
		
		//Assertion
		XCTAssert(result == true)

	}
	
	// MARK: Test for func registerDidBeginEditing(with handler: (UITextView) -> ())
	
	func testRegisterDidBeginEditing() {
		//Given
		var registerDidBeginEditingCalled = false
		delegate.registerDidBeginEditing { textView in
			registerDidBeginEditingCalled = true
		}

		//When
		textView.delegate?.textViewDidBeginEditing!(textView)

		//Assertion
		XCTAssertTrue(registerDidBeginEditingCalled)
	}
	
	// MARK: Test for open func registerShouldEndEditing(with handler: (UITextView) -> Bool)

	func testRegisterShouldEndEditingTrue() {
		//Given
		delegate?.registerShouldEndEditing { testView in
			return true
		}
		
		//When
		let result = textView.delegate?.textViewShouldEndEditing!(textView)
		
		//Assetion
		XCTAssert(result == true)
	}
	
	func testRegisterShouldEndEditingFalse() {
		//Given
		delegate?.registerShouldEndEditing { textView in
			return false
		}
		
		//When
		let result = textView.delegate?.textViewShouldEndEditing!(textView)
		
		//Assetion
		XCTAssert(result == false)
	}
	
	func testNoRegisterShouldEndEditing() {
		//When
		let result = textView.delegate?.textViewShouldEndEditing!(textView)
		
		//Assetion
		XCTAssert(result == true)
	}
	
	// MARK: Test for open func registerDidEndEditing(with handler: (UITextView) -> ())
	
	func testRegisterDidEndEditing() {
		//Given
		var registerDidEndEditingCalled = false
		delegate.registerDidEndEditing { textView in
			registerDidEndEditingCalled = true
		}
		
		//When
		textView.delegate?.textViewDidEndEditing!(textView)
		
		//Assertion
		XCTAssert(registerDidEndEditingCalled)
	}
	
	// MARK: Test for open func registerShouldChangeText(with handler: (UITextView, NSRange, String) -> (Bool))
	
	func testRegisterShouldChangeTextTrue() {
		//Given
		delegate?.registerShouldChangeText { _, _, _ in
			return true
		}
		
		//When
		let result = textView.delegate?.textView!(textView, shouldChangeTextIn: NSRange(location: 0, length: 1), replacementText: "")
		
		//Assertion
		XCTAssert(result == true)
	}
	
	func testRegisterShouldChangeTextFalse() {
		//Given
		delegate?.registerShouldChangeText { _, _, _ in
			return false
		}
		
		//When
		let result = textView.delegate?.textView!(textView,
		                                          shouldChangeTextIn: NSRange(location: 0, length: 1),
		                                          replacementText: "")
		
		//Assertion
		XCTAssert(result == false)
	}
	
	// MARK: Test for func registerDidChangeText(with handler: (UITextView) -> ())
	
	func testRegisterDidChangeText() {
		//Given
		var registerDidChangeTextCalled = false
		delegate?.registerDidChangeText { _ in
			registerDidChangeTextCalled = true
		}
		
		//When
		textView.delegate?.textViewDidChange!(textView)
		
		//Assertion
		XCTAssert(registerDidChangeTextCalled)
	}
	
	// MARK: Test for func registerDidChangeSelection(with handler: (UITextView) -> ())
	
	func testRegisterDidChangeSelection() {
		//Given
		var registerDidChangeSelectionCalled = false
		delegate?.registerDidChangeSelection { _ in
			registerDidChangeSelectionCalled = true
		}
		
		//When
		textView.delegate?.textViewDidChangeSelection!(textView)
		
		//Assertion
		XCTAssert(registerDidChangeSelectionCalled)
	}
	
	// MARK: Test for func registerShouldInteractURL(with handler: (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)
	
	func testNoRegisterShouldInteractURL() {
		//When
		let result = textView.delegate?.textView!(textView, shouldInteractWith: URL(string: "www.google.com")!,
		                                          in: NSRange(location: 0, length: 1),
		                                          interaction: UITextItemInteraction.preview)
		
		//Assertion
		XCTAssert(result == true)
	}
	
	func testRegisterShouldInteractURLTrue() {
		//Given 
		delegate?.registerShouldInteractURL { (textView, URL, range, interaction) -> Bool in
			return true
		}
		
		//When
		let result = textView.delegate?.textView!(textView, shouldInteractWith: URL(string: "www.google.com")!,
		                            in: NSRange(location: 0, length: 1),
		                            interaction: UITextItemInteraction.preview)
		
		//Assertion
		XCTAssert(result == true)
	}
	
	func testRegisterShouldInteractURLFalse() {
		//Given
		delegate?.registerShouldInteractURL { (textView, URL, range, interaction) -> Bool in
			return false
		}
		
		//When
		let result = textView.delegate?.textView!(textView, shouldInteractWith: URL(string: "www.google.com")!,
		                                          in: NSRange(location: 0, length: 1),
		                                          interaction: UITextItemInteraction.preview)
		
		//Assertion
		XCTAssert(result == false)
	}

	// MARK: Test for func registerShouldInteractTextAttachment(with handler: (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)
	
	func testNoRegisterShouldInteractTextAttachment() {
		//When
		let result = textView?.delegate?.textView!(textView, shouldInteractWith: NSTextAttachment(), in: NSRange(location: 0, length: 1), interaction: .preview)
		
		
		//Assertion
		XCTAssert(result == true)		
	}

	func testRegisterShouldInteractTextAttachmentTrue() {
		//Given
		delegate?.registerShouldInteractTextAttachment { _, _, _, _ -> Bool in
			return true
		}
		
		//When
		let result = textView?.delegate?.textView!(textView, shouldInteractWith: NSTextAttachment(), in: NSRange(location: 0, length: 1), interaction: .preview)
		
		
		//Assertion
		XCTAssert(result == true)
	}
	
	func testRegisterShouldInteractTextAttachmentFalse() {
		//Given
		delegate?.registerShouldInteractTextAttachment { _, _, _, _ -> Bool in
			return false
		}
		
		//When
		let result = textView?.delegate?.textView!(textView, shouldInteractWith: NSTextAttachment(), in: NSRange(location: 0, length: 1), interaction: .preview)
		
		//Assertion
		XCTAssert(result == false)
	}
	
	func testMultipleRegisterShouldInteractTextAttachment() {
		//Given 
		delegate?.registerShouldInteractTextAttachment { _, _, _, _ -> Bool in
			return false
		}
		delegate?.registerShouldInteractTextAttachment { _, _, _, _ -> Bool in
			return true
		}
		
		//When
		let result = textView?.delegate?.textView!(textView, shouldInteractWith: NSTextAttachment(), in: NSRange(location: 0, length: 1), interaction: .preview)
		
		//Assertion
		XCTAssert(result == false)
	}
	
	// MARK: Test for func registerDidTapChange(with handler: (UITextView) -> ()) 
	
	func testRegisterDidTapChange() {
		//Given
		var registerDidTapChangeCalled = false
		delegate?.registerDidTapChange { textView in
			registerDidTapChangeCalled = true
		}
		
		//When
		let notification: Notification = Notification(name: UITextView.UITextViewTextDidChangeTap, object: textView, userInfo: nil)
		NotificationCenter.default.post(notification)
		
		//Assertion
		XCTAssertTrue(registerDidTapChangeCalled)
	}
	
	// MARK: Test deinit
	
	func testDeinit() {
		//Given
		var delegate: TextViewDelegate? = TextViewDelegate()
		var registerDidTapChangeCalled = false
		delegate?.registerDidTapChange { _ in
			registerDidTapChangeCalled = true
		}
		
		delegate = nil
		//When
		let notification: Notification = Notification(name: UITextView.UITextViewTextDidChangeTap, object: textView, userInfo: nil)
		NotificationCenter.default.post(notification)
		
		XCTAssertFalse(registerDidTapChangeCalled)
	}
}
