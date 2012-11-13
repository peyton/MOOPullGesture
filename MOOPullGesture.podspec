Pod::Spec.new do |s|
  s.name     = 'MOOPullGesture'
  s.version  = '0.1.0'
  s.license  = 'Public domain / MIT'
  s.summary  = 'Clean, versatile pull gesture for iOS perfectionists. Comes with pull-to-create and pull-to-refresh.'
  s.homepage = 'https://github.com/peyton/MOOPullGesture'
  s.author   = { 'Peyton Randolph' => '_@peytn.com' }
  s.source   = { :git => 'https://github.com/peyton/MOOPullGesture.git', :tag => 'v0.1.0' }
  s.description = 'MOOPullGesture implements pull gestures on table views through a UIGestureRecognizer subclass. Built to be extensible, MOOPullGesture comes with pull-to-create and pull-to-refresh.'
  s.platform = :ios
  s.source_files = 'MOOPullGesture/**/*.{h,m}'
  s.header_mappings_dir = 'MOOPullGesture'
  s.frameworks = 'QuartzCore'
  s.requires_arc = true
end
