Gem::Specification.new do |s|
  s.name          = "kajiki"
  s.version       = "1.1.1"
  s.authors       = ["Ken J."]
  s.email         = ["kenjij@gmail.com"]
  s.description   = %q{A simple gem to build daemons}
  s.summary       = %q{A simple Ruby gem to ease building daemons.}
  s.homepage      = "https://github.com/kenjij/kajiki"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.require_paths = ["lib"]
end
