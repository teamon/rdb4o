# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jrodb}
  s.version = "0.0.2"
  s.platform = %q{jruby}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kacper Cie\305\233la, Tymon Tobolski"]
  s.date = %q{2009-06-14}
  s.default_executable = %q{jrodb}
  s.description = %q{Small library for accessing db4o from jruby}
  s.email = %q{kacper.ciesla@gmail.com}
  s.executables = ["jrodb"]
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "bin/jrodb", "lib/java", "lib/java/com", "lib/java/com/jrodb", "lib/java/com/jrodb/JrodbModel.class", "lib/java/com/jrodb/JrodbModel.java", "lib/java/com/jrodb/RubyPredicate.class", "lib/java/com/jrodb/RubyPredicate.java", "lib/java/db4o.jar", "lib/java/jrodb.jar", "lib/jrodb", "lib/jrodb/collection", "lib/jrodb/collection/basic.rb", "lib/jrodb/collection/one_to_many.rb", "lib/jrodb/database.rb", "lib/jrodb/finder.rb", "lib/jrodb/model", "lib/jrodb/model/field.rb", "lib/jrodb/model/generator.rb", "lib/jrodb/model/model.rb", "lib/jrodb/model/relations.rb", "lib/jrodb/type.rb", "lib/jrodb/types", "lib/jrodb/types/primitives.rb", "lib/jrodb.rb", "spec/app", "spec/app/models", "spec/app/models/cat.rb", "spec/app/models/dog.rb", "spec/app/models/java", "spec/app/models/java/Cat.class", "spec/app/models/java/Cat.java", "spec/app/models/java/Dog.class", "spec/app/models/java/Dog.java", "spec/app/models/java/Person.class", "spec/app/models/java/Person.java", "spec/app/models/person.rb", "spec/collection", "spec/collection/basic_spec.rb", "spec/collection/one_to_many_spec.rb", "spec/collection/scope_spec.rb", "spec/console.rb", "spec/database_spec.rb", "spec/fields_spec.rb", "spec/generator_spec.rb", "spec/model_spec.rb", "spec/original_attributes_spec.rb", "spec/relations_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/types_spec.rb"]
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
