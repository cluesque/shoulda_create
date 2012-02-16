module ShouldaCreate
  def should_change_record_count_of(class_name, amount, action) # :nodoc:
    klass = class_name.to_s.camelize.constantize
    var_name = "@_before_change_record_count_#{class_name}"
    before = lambda do
      instance_variable_set var_name, klass.count
    end
    human_name = class_name.to_s.humanize.downcase
    count = 'a'
    if amount > 1
      human_name = human_name.pluralize
      count = amount
    end
    should "#{action} #{count} #{human_name}", :before => before do
      assert_equal instance_variable_get(var_name) + amount,
                   klass.count,
                   "Expected to #{action} a #{human_name}"
    end
  end

  def should_not_change_record_count_of(class_name) # :nodoc:
    should_change_record_count_of class_name, 0, 'neither create nor destroy'
  end

  def should_not_create class_name
    should_change_record_count_of(class_name, 0, 'create')
  end

  def should_create(class_name, options = {})
    count = options[:count] || 1
    should_change_record_count_of(class_name, count, 'create')
  end

  def should_destroy(class_name, options = {})
    count = options[:count] || -1
    should_change_record_count_of(class_name, count, 'destroy')
  end

  def should_change(description, options = {}, &block)
    by, from, to = get_options!([options], :by, :from, :to)
    stmt = "change #{description}"
    stmt << " from #{from.inspect}" if from
    stmt << " to #{to.inspect}" if to
    stmt << " by #{by.inspect}" if by

    if block_given?
      code = block
    else
      warn "[DEPRECATION] should_change(expression, options) is deprecated. " <<
           "Use should_change(description, options) { code } instead."
      code = lambda { eval(description) }
    end

    before_var_name = '@_before_should_change_' + description.downcase.gsub(/[^\w]/, '_')
    before = lambda { self.instance_variable_set( before_var_name, code.bind(self).call ) }
    should stmt, :before => before do
      old_value = self.instance_variable_get( before_var_name )
      new_value = code.bind(self).call
      assert_operator from, :===, old_value, "#{description} did not originally match #{from.inspect}" if from
      assert_not_equal old_value, new_value, "#{description} did not change" unless by == 0
      assert_operator to, :===, new_value, "#{description} was not changed to match #{to.inspect}" if to
      assert_equal old_value + by, new_value if by
    end
  end

  def should_not_change(description, &block)

    if block_given?
      code = block
    else
      warn "[DEPRECATION] should_change(expression, options) is deprecated. " <<
           "Use should_change(description, options) { code } instead."
      code = lambda { eval(description) }
    end

    before_var_name = '@_before_should_change_' + description.downcase.gsub(/[^\w]/, '_')
    before = lambda { self.instance_variable_set( before_var_name, code.bind(self).call ) }
    should "not change #{description}", :before => before do
      old_value = self.instance_variable_get( before_var_name )
      new_value = code.bind(self).call
      assert_equal old_value, new_value, "#{description} changed"
    end
  end
end
