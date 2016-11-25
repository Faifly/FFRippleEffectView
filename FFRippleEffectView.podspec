Pod::Spec.new do |spec|
spec.name = "FFRippleEffectView"
spec.version = "1.0.2"
spec.summary = "Ripple effect view"
spec.homepage = "https://github.com/Faifly/FFRippleEffectView"
spec.license = { type: 'MIT', file: 'LICENSE' }
spec.authors = { "Artem Kalmykov" => 'ar.kalmykov@gmail.com' }

spec.platform = :ios, "8.0"
spec.requires_arc = true
spec.source = { git: "https://github.com/Faifly/FFRippleEffectView"}
spec.source_files = "FFRippleEffectView/FFRippleEffectView/*.{h,swift}"

end
