Pod:: Spec.new do |spec|
  spec.platform     = 'ios', '10.0'
  spec.name         = 'SHRichTextEditorTools'
  spec.version      = '5.1.5'
  spec.summary      = 'This is a collection of extensions which are helpful in configuring UIBarButtonItem to build a rich text editor'
  spec.author = {
    'Susmita Horrow' => 'susmita.horrow@gmail.com'
  }
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/hsusmita/SHRichTextEditorTools'
  spec.source = {
    :git => 'https://github.com/hsusmita/SHRichTextEditorTools.git',
    :tag => '5.1.5'
  }
  spec.ios.deployment_target = '10.0'
  spec.requires_arc = true
  spec.swift_version = '4.2'
  
  spec.subspec 'Core' do |core|
     core.source_files = 'SHRichTextEditorTools/Source/Core/**/*.{swift}'
     core.preserve_paths = 'SHRichTextEditorTools/Source/Core/**'
  end

  spec.subspec 'SHRichTextEditor' do |editor|
     editor.source_files = 'SHRichTextEditorTools/Source/SHRichTextEditor/**/*.{swift}'
     editor.resources = 'SHRichTextEditorTools/Source/SHRichTextEditor/*.xcassets','SHRichTextEditorTools/Source/SHRichTextEditor/**/*.{xib}'
     editor.dependency 'SHRichTextEditorTools/Core', '~> 5.1.5'
  end
  
end
