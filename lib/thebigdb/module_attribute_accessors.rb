# Heavily inspired by "core_ext/module/attribute_accessors" from activesupport (4.0.0.beta)
module TheBigDB
  def self.mattr_reader(*syms)
    syms.each do |sym|
      raise NameError.new('invalid attribute name') unless sym =~ /^[_A-Za-z]\w*$/
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        @@#{sym} = nil unless defined? @@#{sym}

        def self.#{sym}
          @@#{sym}
        end
      EOS

      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def #{sym}
          @@#{sym}
        end
      EOS
    end
  end

  def self.mattr_writer(*syms)
    syms.each do |sym|
      raise NameError.new('invalid attribute name') unless sym =~ /^[_A-Za-z]\w*$/
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def self.#{sym}=(obj)
          @@#{sym} = obj
        end
      EOS

      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def #{sym}=(obj)
          @@#{sym} = obj
        end
      EOS
    end
  end

  def self.mattr_accessor(*syms)
    mattr_reader(*syms)
    mattr_writer(*syms)
  end
end