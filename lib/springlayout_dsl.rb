require 'java'

java_import javax.swing.SpringLayout
java_import javax.swing.Spring
java_import java.awt.Component

class Spring
  
  def + o
    Spring::sum(self, SpringLayoutDSL::make_spring_proxy(o))
  end
  
  def * n
    raise '#{n} must be numeric' unless n.kind_of? Numeric
    Spring::scale(self, n)
  end
  
  def / n
    raise '#{n} must be numeric' unless n.kind_of? Numeric
    self * (1/n)
  end
  
  def maximum spring
    Spring::maximum self, spring
  end
  
  def self.maximum(spring1, spring2)
    Spring::max(SpringLayoutDSL::make_spring_proxy(spring1), SpringLayoutDSL::make_spring_proxy(spring2))
  end
  
  def -@
    #    p 'called: -@'
    Spring::minus self
  end
  
  def - o
    #    p 'called: - o'
    self + (-(SpringLayoutDSL::make_spring_proxy(o)))
  end
  
end

class Fixnum
  alias :original_plus :+
  def +(x)
    return x+self if x.kind_of? Spring
    original_plus(x)
  end
  
  alias :original_minus :-
  def -(x)
    return x-self if x.kind_of? Spring
    original_minus(x)
  end
  
  alias :original_minus :*
  def *(x)
    return x*self if x.kind_of? Spring
    original_minus(x)
  end
end

class Float
  alias :original_plus :+
  def +(x)
    return x+self if x.kind_of? Spring
    original_plus(x)
  end
  
  alias :original_minus :-
  def -(x)
    return x-self if x.kind_of? Spring
    original_minus(x)
  end
  
  alias :original_minus :*
  def *(x)
    return x*self if x.kind_of? Spring
    original_minus(x)
  end
end

class SpringLayoutDSL
  
  @@directions = [:west,:east,:south,:north, :height, :width] #:width and :height only work with jdk1.6
  
  @@new_constraints = [:vertical_center, :horizontal_center, :baseline] #works only since jdk1.6
  
  #TODO: implement Spring.min which does not even exist in Java! :)
  
  def max(*args)
    raise 'require at least one argument' unless args and args.size>1
    last_spring = nil
    args.each do |value|
      spring = SpringLayoutDSL::make_spring_proxy(value)
      if !!last_spring
        last_spring = Spring::max(last_spring, spring)
      else
        last_spring = spring
      end
    end
    last_spring
  end
  
  def initialize(layout, &block)
    @@layout_stack ||= []
    @@layout_stack.push(layout)
    define_constraint_methods
    begin
      self.instance_eval(&block)
    ensure
      @@layout_stack.pop
      define_constraint_methods
    end
  end
  
   def define_constraint_methods
      layout = @@layout_stack.last
      if layout
        #        p 'define_constraint_methods' << layout.to_s
        @@directions.each do |edge|
          if SpringLayout.constants.include?(edge.to_s.upcase) # included since jdk1.6 
            constraint = SpringLayout.const_get(edge.to_s.upcase)
            constraint_writer(edge, layout, constraint)
            constraint_reader(edge, layout, constraint)
          else 
            p "skipping definition of #{edge}="
            p "skipping definition of #{edge}"
          end
        end
        @@new_constraints.each do |edge|
          if SpringLayout.constants.include?(edge.to_s.upcase) # included since jdk1.6 
            constraint = SpringLayout.const_get(edge.to_s.upcase)
            constraint_reader(edge, layout, constraint)
          else 
            p "skipping definition of #{edge}"
          end
        end
      else
        #p 'undefine_constraint_methods'
        (@@directions|@@new_constraints).each do |edge|
          Component.class_eval {undef_method edge}
        end
      end
    end
    
    def constraint_reader(edge, layout, constraint)
      Component.class_eval do
        define_method edge do
          layout.get_constraint(constraint, self)
        end
      end
    end
    
    def constraint_writer(edge, layout, constraint)
      Component.class_eval do
        define_method((edge.to_s+"=").to_sym) do |arg| #Argh, under jruby 1.8.7 (called directly) the additional, outer brackets are required due to operator precedence. 
          spring = SpringLayoutDSL::make_spring_proxy arg
          layout.get_constraints(self).setConstraint(constraint, spring)
        end
      end
    end
  
  class << self
    
    def layout(layout, &block)
      slh = SpringLayoutDSL.new(layout, &block)
    end
    
    def make_spring_proxy o
      return o if o.kind_of? Spring
      if o.kind_of? Numeric#Integer
        return Spring::constant(o)
      end
      nil
    end
    
  end
  
end
