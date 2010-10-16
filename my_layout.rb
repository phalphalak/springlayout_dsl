#if input
#  input.entry_set.each do |entry|
#    
#    p entry.key
#    p entry.value
#    p "#{entry.key}=entry.value"
##    p some_number
#p local_variables
#  eval("x=3",binding)
#  p x
##  instance_variable_set(:@x,1)
##    instance_eval("#{entry.key}=entry.value")
#p local_variables
#    p "<"
#    eval("p entry")
#    p ">"
#  end
#end
#def layout

$:.unshift File.expand_path(File.dirname(__FILE__))

print "working dir: \n" << ($:.join("\n"))
print "Ruby version: " << RUBY_VERSION << "\n\n"

# sigh, another workaround, so this will work for jruby called diretly and from java respectively
require 'spring_layout_helper'

require 'java'

java_import javax.swing.JFrame
java_import javax.swing.JLabel
java_import javax.swing.JButton
java_import javax.swing.SpringLayout
java_import javax.swing.Spring
java_import java.awt.Color
java_import javax.swing.JTextField
java_import java.util.HashMap

frame = JFrame.new 'Test Frame'
frame.default_close_operation=JFrame::EXIT_ON_CLOSE

content = frame.content_pane
layout=SpringLayout.new
content.layout = layout

#layout.put_constraint(SpringLayout::SOUTH, content, 5, SpringLayout::SOUTH, button1)
#layout.put_constraint(SpringLayout::NORTH, button1, 5, SpringLayout::NORTH, content)
#layout.put_constraint(SpringLayout::NORTH, button2, 5, SpringLayout::NORTH, content)
#
#layout.put_constraint(SpringLayout::EAST, button2, -5, SpringLayout::EAST, content)
#layout.put_constraint(SpringLayout::WEST, button2, 5, SpringLayout::EAST, button1)
##layout.put_constraint(SpringLayout::EAST, content, 5, SpringLayout::EAST, button2)

label1 = JLabel.new(" foo")
label2 = JLabel.new(" bar")
label3 = JLabel.new(" yeah!")

text1 = JTextField.new()
text2 = JTextField.new()
text3 = JTextField.new()

[label1,label2,label3,text1,text2,text3].each {|component| content.add(component)}

SpringLayoutHelper::layout(layout) do
    label1.north = content.north+5
    label2.north = label1.south+5
    label3.north = label2.south+5
    
    m = max(label1.width,label2.width,label3.width) + 5
#    m=30
    label1.east = m
    label2.east = m
    label3.east = m
#    label3.width=30
#    label3.east = label2.west+label2.width
    
    content.south = label3.south+7
    content.east = 300
    
    text1.north = label1.north
    text1.east = content.east-5 #! text1.east must come before text1.west otherwise this won't work under jdk1.5
    text1.west = label1.east+5
    
    text2.north = label2.north
    text2.east = content.east-5
    text2.west = label2.east+5
    
    text3.north = label3.north
    text3.east = content.east-5
    text3.west = label3.east+5
#eval("p local_variables", binding)
end
#eval("p local_variables", binding)
#local_variables.each do |v|
#  p "#{v}=#{eval(v<<".class",binding)}"
#end

#button1=JButton.new("Test1111")
#button2=JButton.new("Hallo222222")
#
#content.add(button1)
#content.add(button2)
#
#SpringLayoutHelper::layout(layout) do
#  content.south = button1.south + 5
##  button2.south = button1.baseline
##  button2.south = (button1.vertical_center-2.5)*2
##  button2.south = 0.5 * button1.south + 2.5
#  button1.north = content.north + 5
#  button2.north = content.north + 5
##  SpringLayoutHelper::layout(layout2) do
##    p :foo
##    p 1/0
##  end
#  button2.east = content.east - 5
#  button2.west = button1.east + 5
##  content.east = button2.east + 5
#end

frame.pack
frame.visible=true

#values = {}
#local_variables.each do |v|
#  values[v]=eval(v)
#end
#values

map = HashMap.new
local_variables.each do |v|
  map.put(v,eval(v))
end
map

#end
