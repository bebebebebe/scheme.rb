;(function(exports) {
  exports.makePicture = function(treeData){


      var tree = d3.layout.tree()
          .size([300,150]);

      var root = {};

      //var nodes = tree.nodes(treeData);
      var nodes = tree.nodes(root);

      root.parent = root;
      root.px = root.x;
      root.py = root.y;


      var diagonal = d3.svg.diagonal();
          //.projection(function(d) { return [d.y, d.x]; });


      var vis = d3.select("#viz").append("svg:svg")
          .attr("width", 400)
          .attr("height", 300)
          .append("svg:g")
          .attr("transform", "translate(40, 0)");

      var node = vis.selectAll(".node"),
          link = vis.selectAll(".link");


      
      update();

      function update() {

          console.log("update function called!")

          node = node.data(tree.nodes(treeData), function(d) { return d.id; } );
          link = link.data(tree.links(nodes), function(d) { return d.source.id + "-" + d.target.id; });

          node.enter().append("circle")
              .attr("r", 4)
              .attr("stroke", "#ccc")
              .attr("stroke-width", "2px")
              .style("fill", "red")
              .attr("cx", function(d) { return d.px = d.x; })
              .attr("cy", function(d) { return d.py = d.y; });
              //.attr("cx", function(d) { return d.parent.px; })
              //.attr("cy", function(d) { return d.parent.py; });

  //         link.enter().insert("path", ".node")
  //     .attr("class", "link")
  //     .attr("d", function(d) {
  //       var o = {x: d.source.px, y: d.source.py};
  //       return diagonal({source: o, target: o});
  //     });

  // // Transition nodes and links to their new positions.
  // var t = svg.transition()
  //     .duration(duration);

  // t.selectAll(".link")
  //     .attr("d", diagonal);

  // t.selectAll(".node")
  //     .attr("cx", function(d) { return d.px = d.x; })
  //     .attr("cy", function(d) { return d.py = d.y; });



      };



      

      
      // var link = vis.selectAll("pathlink")
      //     .data(tree.links(nodes))
      //     .enter().append("svg:path")
      //     .attr("class", "link")
      //     .attr("fill", "none")
      //     .attr("stroke", "#ccc")
      //     .attr("stroke-width", "2px")
      //     .attr("d", diagonal);

      // var node = vis.selectAll("g.node")
      //     .data(nodes)
      //     .enter().append("svg:g")
      //     .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })

      // node.append("svg:circle")
      //     .attr("r", 4)
      //     .style("fill", "red")
      //     .on("click", function(d) {      // added click event to print node name to console
      //         console.log("you clicked " + d.name)
      //      })

      //     .append("title")
      //     .text(function(d) {
      //         return d.frame;
      //         });

};
})(this);