# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rdb4o}
  s.version = "0.0.2"
  s.platform = %q{jruby}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kacper Cie\305\233la, Tymon Tobolski"]
  s.date = %q{2009-06-14}
  s.default_executable = %q{rdb4o}
  s.description = %q{Small library for accessing db4o from jruby}
  s.email = %q{kacper.ciesla@gmail.com}
  s.executables = ["rdb4o"]
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "bin/rdb4o", "lib/java", "lib/java/com", "lib/java/com/rdb4o", "lib/java/com/rdb4o/Rdb4oModel.class", "lib/java/com/rdb4o/Rdb4oModel.java", "lib/java/com/rdb4o/RubyPredicate.class", "lib/java/com/rdb4o/RubyPredicate.java", "lib/java/db4o.jar", "lib/java/rdb4o.jar", "lib/rdb4o", "lib/rdb4o/collection", "lib/rdb4o/collection/basic.rb", "lib/rdb4o/collection/one_to_many.rb", "lib/rdb4o/database.rb", "lib/rdb4o/finder.rb", "lib/rdb4o/model", "lib/rdb4o/model/field.rb", "lib/rdb4o/model/generator.rb", "lib/rdb4o/model/model.rb", "lib/rdb4o/model/relations.rb", "lib/rdb4o/type.rb", "lib/rdb4o/types", "lib/rdb4o/types/primitives.rb", "lib/rdb4o.rb", "spec/app", "spec/app/models", "spec/app/models/cat.rb", "spec/app/models/dog.rb", "spec/app/models/java", "spec/app/models/java/Cat.class", "spec/app/models/java/Cat.java", "spec/app/models/java/Dog.class", "spec/app/models/java/Dog.java", "spec/app/models/java/Person.class", "spec/app/models/java/Person.java", "spec/app/models/person.rb", "spec/collection", "spec/collection/basic_spec.rb", "spec/collection/one_to_many_spec.rb", "spec/collection/scope_spec.rb", "spec/console.rb", "spec/database_spec.rb", "spec/fields_spec.rb", "spec/generator_spec.rb", "spec/model_spec.rb", "spec/original_attributes_spec.rb", "spec/relations_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/types_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://blog.teamon.eu/projekty/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Small library for accessing db4o from jruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<extlib>, [">= 0.9"])
    else
      s.add_dependency(%q<extlib>, [">= 0.9"])
    end
  else
    s.add_dependency(%q<extlib>, [">= 0.9"])
  end
end
