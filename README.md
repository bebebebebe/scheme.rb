# Visual Schemer

Try it out <a href='https://visual-schemer.herokuapp.com/'>here</a>!

In browser Scheme interpreter with semantic visualizations.

As the user enters Scheme expressions in the REPL via the in-browser console, tree pictures are drawn showing the environment structure. Hovering over a node in the tree reveals the bindings present at that node.

This is a Sinatra app. The Scheme interpreter is written in Ruby. The visualizations are made with D3.

## Future plans

This was my first web app (other than tutorials)! It would be nice to:

- clean up frontend files (HTML, CSS, JS),
- improve UI: smooth transitions in tree pictures,
- improve UI: better tooltips on hovering over nodes,
- improve presentation of example in instructions,
- write up a little interactive thing about scope and closures, using tree pictures from the app.
