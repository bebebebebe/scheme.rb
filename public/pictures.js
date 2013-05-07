;(function(exports) {
  exports.makePicture = function(treeData){

      d3.select("svg")
       .remove();

      var vis = d3.select("#viz").append("svg:svg")
                .attr("width", 400)
                .attr("height", 300)
                .append("svg:g")
                .attr("transform", "translate(40, 0)");

      //tooltips
      var div = d3.select("body").append("div")
                .attr("class", "tooltip")
                .style("opacity", 1e-6);

      var tree = d3.layout.tree()
                .size([300,150]);

      var diagonal = d3.svg.diagonal()
                .projection(function(d) { return [d.y, d.x]; });

      var nodes = tree.nodes(treeData);

      var link = vis.selectAll("pathlink")
                .data(tree.links(nodes))
                .enter().append("svg:path")
                .attr("class", "link")
                .attr("d", diagonal);

      var node = vis.selectAll("g.node")
                .data(nodes)
                .enter().append("svg:g")
                .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })

      node.append("svg:circle")
            .on("mouseover", mouseover)
            .on("mousemove", function(d){mousemove(d);})
            .on("mouseout", mouseout)
            .attr("fill", "red")
            .style("opacity", function(d) { return d.access? 1 : 0.3; })

            //.style("fill", function(d) { return d.access ? "lightsteelblue": "red"; })




            //.style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });
            //.attr("fill","red")
            .attr("r", 4.5);
 
            function mouseover() {
                div.transition()
                .duration(300)
                .style("opacity", 0.9);
            }
 
            function mousemove(d) {
                div
                //.text(d.frame)
                //.html("Bindings" + "<br>" + d.frame)
                .html(d.frame)
                .style("color", "darkblue")
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY) + "px");      
            }

            function mouseout() {
                div.transition()
                .duration(300)
                .style("opacity", 1e-6);
            };



      //node.append("svg:circle")
      //           .attr("r", 4)
      //           .style("fill", "red")
      //           .on("click", function(d) {      // added click event to print node name to console
      //               console.log("you clicked " + d.name)
      //             })
      // .append("title")
      // .text(function(d) {
      //         return d.frame;
      //       });

};
})(this);