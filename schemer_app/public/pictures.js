;(function(exports) {
  exports.makePicture = function(treeData){

  // console.log("picture!")


//   .link {
//   fill: none;
//   stroke: blue;/*#ccc;*/
//   stroke-width: 3.5px;
// };

      var vis = d3.select("#viz").append("svg:svg")
.attr("width", 400)
.attr("height", 300)
.append("svg:g")
.attr("transform", "translate(40, 0)");

      var tree = d3.layout.tree()
.size([300,150]);

      var diagonal = d3.svg.diagonal()
.projection(function(d) { return [d.y, d.x]; });

      var nodes = tree.nodes(treeData);
      var link = vis.selectAll("pathlink")
.data(tree.links(nodes))
.enter().append("svg:path")
.attr("class", "link")
.attr("fill", "none")
.attr("stroke", "#ccc")
.attr("stroke-width", "2px")
.attr("d", diagonal);

      var node = vis.selectAll("g.node")
.data(nodes)
.enter().append("svg:g")
.attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })



      node.append("svg:circle")
.attr("r", 4)
// .style("fill", "red");
.style("fill", "red")
.on("click", function(d) {      // added click event to print node name to console
    console.log("you clicked " + d.name)
  })

.append("title")
.text(function(d) {
        return d.frame;
});

// node.append("svg:text")
// .attr("dx", function(d) { return d.children ? -8 : 8; })
// .attr("dy", 3)
// .attr("text-anchor", function(d) { return d.children ? "end" : "start"; })
// .text(function(d) { return d.name; });

};
})(this);