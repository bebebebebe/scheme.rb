module Tree

  def self.structure(root)
    { id: root.id,
      frame: process_frame(root.frame, root.label), 
      children: root.children.map{ |i| structure(i) } }
  end

  def self.process_frame(frame, label)
    frame2 = frame.dup
    string = frame2.each { |k,v| frame2[k] = schemify(label[k]) if v.class == Proc }.to_s
    #string.gsub('"', '').gsub(":", "").gsub("=>", ": ")
    string.delete('":').gsub("=>", ": ")
  end

  def self.schemify(exp)
    if exp.is_a? Array
      '(' + exp.map{ |x| schemify(x) }.join(' ') + ')'
    else exp.to_s
    end
  end

end