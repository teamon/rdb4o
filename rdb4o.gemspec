# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rdb4o}
  s.version = "0.0.1"
  s.platform = %q{jruby}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kacper Cie\305\233la"]
  s.autorequire = %q{rdb4o}
  s.date = %q{2009-04-10}
  s.description = %q{Small library for accessing db4o from jruby}
  s.email = %q{kacper.ciesla@gmail.com}
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/java", "lib/java/com", "lib/java/com/rdb4o", "lib/java/com/rdb4o/Rdb4oModel.class", "lib/java/com/rdb4o/Rdb4oModel.java", "lib/java/com/rdb4o/RubyPredicate.class", "lib/java/com/rdb4o/RubyPredicate.java", "lib/java/db4o.jar", "lib/rdb4o", "lib/rdb4o/database.rb", "lib/rdb4o/model.rb", "lib/rdb4o.rb", "spec/app", "spec/app/models", "spec/app/models/java", "spec/app/models/java/Person.class", "spec/app/models/java/Person.java", "spec/database_spec.rb", "spec/model_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Small library for accessing db4o from jruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
