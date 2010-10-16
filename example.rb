
$:.unshift File.expand_path(File.dirname(__FILE__))
$:.unshift File.expand_path(File.dirname(__FILE__)<<"/lib")

print "working dir: \n" << ($:.join("\n"))
print "Ruby version: " << RUBY_VERSION << "\n\n"

require 'springlayout_dsl'
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

label1 = JLabel.new(" foo")
label2 = JLabel.new(" bar")
label3 = JLabel.new(" yeah!")

text1 = JTextField.new()
text2 = JTextField.new()
text3 = JTextField.new()

[label1,label2,label3,text1,text2,text3].each {|component| content.add(component)}

SpringLayoutDSL::layout(layout) do
    label1.north = content.north+5
    label2.north = label1.south+5
    label3.north = label2.south+5
    
    m = max(label1.width,label2.width,label3.width) + 5
    label1.east = m
    label2.east = m
    label3.east = m
    
    content.south = label3.south+7
    content.east = 300
    
    text1.north = label1.north
    text1.east = content.east-5 #! text1.east must be assigned before text1.west otherwise this won't work under <=jdk1.5. This is not a bug with SpringLayoutDSL
    text1.west = label1.east+5
    
    text2.north = label2.north
    text2.east = content.east-5
    text2.west = label2.east+5
    
    text3.north = label3.north
    text3.east = content.east-5
    text3.west = label3.east+5
end

frame.pack
frame.visible=true

