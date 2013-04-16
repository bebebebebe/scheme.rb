module Tree

  def self.structure(vertex)
    { frame: process_frame(vertex.frame, vertex.label), 
      children: vertex.children.map{ |i| structure(i) } }
  end

  def self.process_frame(frame, label)
    frame2 = frame.dup
    string = frame2.each { |k,v| frame2[k] = schemify(label[k]) if v.class == Proc }.to_s
    string.gsub('"', '').gsub(":", "").gsub("=>", ": ")
  end

  def self.schemify(array)
    string = array.to_s
    string.gsub("[", "(").gsub("]",")").gsub(":", "").gsub(",","")
  end

end