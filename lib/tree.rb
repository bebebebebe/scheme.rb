module Tree

  def self.structure(root)
    hash = structure1(root)
    hash[:name] = "global environment"
    hash
  end

  def self.structure1(root)
    { id: root.id,
      frame: process_frame(root.frame, root.label), 
      children: root.children.map{ |i| structure1(i)},
      access: root.access }
  end

  def self.process_frame(frame, label)
    frame2 = frame.dup
    frame2 = frame2.each { |k,v| frame2[k] = schemify(label[k]) if v.class == Proc }
    string = frame2.to_s.delete('":{}').gsub("=>", ": ").gsub(", ", "<br>")
  end

  def self.structure_simple(root) # this is for simple static pictures (for blog)
    { id: root.id,
      frame: process_frame_simple(root.frame, root.label), 
      children: root.children.map{ |i| structure_simple(i) }}
  end

  def self.process_frame_simple(frame,label)
    process_frame(frame, label).gsub("car: <br>cdr: <br>cons: <br>", "").gsub("/: <br>**: <br>", "").gsub(">: <br>", "")
  end

  def self.schemify(exp)
    if exp.is_a? Array
      '(' + exp.map{ |x| schemify(x) }.join(' ') + ')'
    else exp.to_s
    end
  end

end