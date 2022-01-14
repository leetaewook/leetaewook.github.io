# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "my-theme-name"
  spec.version       = "0.1.0"
  spec.authors       = ["leetaewook"]
  spec.email         = ["twleev@gmail.com"]

  spec.summary       = "My new Jekyll theme!"
  spec.homepage      = "https://github.com/leetaewook/leetaewook.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_runtime_dependency "jekyll-paginate-v2", "~> 3.0"
  spec.add_runtime_dependency "jekyll-sitemap"
  spec.add_runtime_dependency "jekyll-gist"
end
