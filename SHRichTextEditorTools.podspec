Pod:: Spec.new do |spec|
  spec.platform     = 'ios', '10.0'
  spec.name         = 'SHRichTextEditorTools'
  spec.version      = '3.0.2'
  spec.summary      = 'This is a collection of extensions which are helpful in configuring UIBarButtonItem to build a rich text editor'
  spec.author = {
    'Susmita Horrow' => 'susmita.horrow@gmail.com'
  }
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/hsusmita/SHRichTextEditorTools'
  spec.source = {
    :git => 'https://github.com/hsusmita/SHRichTextEditorTools.git',
    :tag => '3.0.2'
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
     editor.resources = 'SHRichTextEditorTools/Source/SHRichTextEditor/*.xcassets'
     editor.resource_bundles = {
      'SHRichTextEditorTools' => ['SHRichTextEditorTools/Source/SHRichTextEditor/**/*.{xib}', 'SHRichTextEditorTools/Source/SHRichTextEditor/*.xcassets']
     } 
     editor.dependency 'SHRichTextEditorTools/Core', '~> 3.0.2'
  end
  
end
