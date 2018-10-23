Pod:: Spec.new do |spec|
  spec.platform     = 'ios', '10.0'
  spec.name         = 'SHRichTextEditorTools'
  spec.version      = '2.0.8'
  spec.summary      = 'This is a collection of extensions which are helpful in configuring UIBarButtonItem to build a rich text editor'
  spec.author = {
    'Susmita Horrow' => 'susmita.horrow@gmail.com'
  }
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/hsusmita/SHRichTextEditorTools'
  spec.source = {
    :git => 'https://github.com/hsusmita/SHRichTextEditorTools.git',
    :tag => '2.0.8'
  }
  spec.ios.deployment_target = '10.0'
  spec.source_files = 'SHRichTextEditorTools/Source/**/*.{swift, xib}'
  spec.preserve_paths = 'SHRichTextEditorTools/Source/**'
  spec.resources = 'SHRichTextEditorTools/*.xcassets'
  spec.requires_arc = true
  spec.swift_version = '4.2'
end
