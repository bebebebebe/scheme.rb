module Tree

  def self.structure(root)
    hash = structure1(root)
    hash[:name] = "Global Environment.<br>"
    hash
  end

  def self.structure1(root)
    { id: root.id,
      frame: process_frame(root.frame, root.label), 
      children: root.children.map{ |i| structure1(i) }}
  end

  # def self.process_frame(frame, label)
  #   frame2 = frame.dup
  #   string = frame2.each { |k,v| frame2[k] = schemify(label[k]) if v.class == Proc }.to_s
  #   #string.gsub('"', '').gsub(":", "").gsub("=>", ": ")
  #   string = string.delete('":{}').gsub("=>", ": ").gsub(", ", "<br>")
  # end

  def self.process_frame(frame, label)
    frame2 = frame.dup
    frame2 = frame2.each { |k,v| frame2[k] = schemify(label[k]) if v.class == Proc }
    #frame2 = frame2.each { |k,v|  }
    string = frame2.to_s.delete('":{}').gsub("=>", ": ").gsub(", ", "<br>")
    #string.gsub(/:\s<br>(?!<)/, ", ")
  end

  def self.schemify(exp)
    if exp.is_a? Array
      '(' + exp.map{ |x| schemify(x) }.join(' ') + ')'
    else exp.to_s
    end
  end

end