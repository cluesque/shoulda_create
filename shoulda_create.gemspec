Gem::Specification.new do |s|
  s.name        = "shoulda_create"
  s.version     = "0.0.9"
  s.author      = "Bill Kirtley"
  s.email       = "bill.kirtley@gmail.com"
  s.homepage    = "http://github.com/cluesque/shoulda_create"
  s.summary     = "Restores should_create functionality to shoulda."
  s.description = "I like using should_create and friends to make assertions about records coming and going in the database. Shoulda did, but doesn't any more.  With this, it can again."

  s.files        = Dir["lib/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.require_path = "lib"
end