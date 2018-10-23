#SHRichTextEditorTools
This is a collection of extensions which are helpful in building a rich text editor.

#Installation

Add following lines in your pod file  
pod 'SHRichTextEditorTools', '~> 2.0.5'

#Usage

#### Basic 
This library includes a basic editor SHRichTextEditor which includes basic functionalities like `Bold`, `Italic` and `Indentation` features.

```
let textEditor = SHRichTextEditor(textView: self.textView)
textEditor.toolBarItems = [textEditor.boldBarItem(), textEditor.italicBarItem(), textEditor.indentationBarItem()]

```
#### Custom TintColor

```
let textEditor = SHRichTextEditor(textView: self.textView, defaultTintColor: UIColor.gray, selectedTintColor: UIColor.green)

```

#### Customize bar button

```
let boldBarItem = self.textEditor.boldBarItem(type: .title(title: "Button")) { (button, selected) in
	button.barButtonItem.tintColor = selected ? UIColor.gray : UIColor.green
}
self.textEditor.toolBarItems = [boldBarItem]

```

Here type is defined by the following enum 	
```
public enum ButtonType {
	case title(title: String)
	case attributed(title: String, attributes: [UIControlState.RawValue: [NSAttributedStringKey : Any]])
	case image(image: UIImage)
}
```



