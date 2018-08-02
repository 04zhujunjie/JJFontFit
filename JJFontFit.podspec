Pod::Spec.new do |s|
s.name         = 'JJFontFit'
s.version      = '1.0.1'
s.summary      = '功能齐全，自动化的文字适配库'
s.homepage     = 'https://github.com/04zhujunjie/JJFontFit'
s.license      = 'MIT'
s.authors      = {'xiaozhu' => 'xswt04zjj@163.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/04zhujunjie/JJFontFit.git', :tag => s.version}
s.source_files = 'JJFontFit/*.{h,m}'
s.public_header_files = 'JJFontFit/*.h'
s.requires_arc = true
s.frameworks =
"Foundation","UIKit"
end
