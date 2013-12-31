require 'shoulda'
require 'shoulda_create/shoulda_create'

begin
  ActiveSupport::TestCase.extend(ShouldaCreate)
rescue NameError
  require 'shoulda_create/test_unit'
end
