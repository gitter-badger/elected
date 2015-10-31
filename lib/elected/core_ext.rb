# Try taken from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/object/try.rb

class Object
  # Return a list of methods defined locally for a particular object.  Useful
  # for seeing what it does whilst losing all the guff that's implemented
  # by its parents (eg Object).
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end unless Object.respond_to?(:local_methods)

  def try(*a, &b)
    try!(*a, &b) if a.empty? || respond_to?(a.first)
  end unless Object.respond_to?(:try)

  def try!(*a, &b)
    if a.empty? && block_given?
      if b.arity.zero?
        instance_eval(&b)
      else
        yield self
      end
    else
      public_send(*a, &b)
    end
  end unless Object.respond_to?(:try!)
end

class NilClass
  def try(*args)
    nil
  end unless NilClass.respond_to?(:try)

  def try!(*args)
    nil
  end unless NilClass.respond_to?(:try!)
end

class String
  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr('-', '_').
      downcase
  end unless ''.respond_to?(:underscore)
end