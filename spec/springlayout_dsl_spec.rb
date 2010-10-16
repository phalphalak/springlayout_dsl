require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

java_import javax.swing.SpringLayout
java_import javax.swing.Spring
java_import javax.swing.JLabel
java_import javax.swing.JButton

describe "SpringlayoutDsl" do
    #print javax.swing.Spring.instance_methods.sort.join("\n").to_s 

  it "should respond to accessors for width and height before layout" do
    label = JLabel.new("label");
    label.should respond_to('width', 'height')
  end

# it-scope is possibly overriden in the block as this test results in a undefined method "respoint_to" error
#  it "should respond to accessors for width and height during layout" do
#    layout = SpringLayout.new
#    label = JLabel.new("label");
#    SpringLayoutDSL::layout(layout) do
#      print label.methods.sort.join("\n").to_s
#      label.should respond_to('width', 'height')
#    end
#  end

  # This is the regression test for issue 1 (fix it and comment it back!)
  #it "should respond to accessors for width and height after layout" do
  #  layout = SpringLayout.new
  #  label = JLabel.new("label");
  #  SpringLayoutDSL::layout(layout) do
  #    label.west = 42
  #  end 
  #  label.should respond_to('width', 'height')
  #end

  it "should not respond to constraint accessor methods for components before layout" do
    label = JLabel.new("label");
    label.should_not respond_to(:west,:east,:north,:south,:vertical_center,:horizontal_center,:baseline)
  end
  
#  it "should not respond to constraint accessor methods for components during layout" do
#    layout = SpringLayout.new
#    label = JLabel.new("label");
#    #describe_block = Proc.new {}
#    SpringLayoutDSL::layout(layout) do
#      label.should eval('respond_to(:west,:east,:north,:south,:vertical_center,:horizontal_center,:baseline)',describe_block.binding)
#      #label.should eval('respond_to(:west,:east,:north,:south,:vertical_center,:horizontal_center,:baseline)',describe_block.binding)
#    end 
#  end

  it "should not respond to constraint accessor methods for components after layout" do
    layout = SpringLayout.new
    label = JLabel.new("label");
    SpringLayoutDSL::layout(layout) do
      label.west = 42
    end 
    label.should_not respond_to(:west,:east,:north,:south,:vertical_center,:horizontal_center,:baseline)
  end

  it "should define helper methods for javax.swing.Spring" do
    spring_methods = javax.swing.Spring.instance_methods
    spring_methods.should include('+','*','/','maximum','-@','-')
  end


#  it "fails" do
#    fail "hey buddy, you should probably rename this file and start specing for real"
#  end
end

