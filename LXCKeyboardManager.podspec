Pod::Spec.new do |s|
  s.name         = "LXCKeyboardManager"
  s.version      = "1.0.0"
  s.summary      = "身份键盘和自动处理Scroll上的输入框"
 
  s.homepage     = "https://github.com/nablxc/KeyboardManager.git"
  s.license      = "MIT"
  s.author             = { "刘星辰" => "liuxc@ngarihealth.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/nablxc/KeyboardManager.git", :tag => "1.0" }

  s.source_files  = "KeyboardManager/KeyboardManager/**/*.{h,m}"

  s.requires_arc = true
  s.framework = 'UIKit'


end
