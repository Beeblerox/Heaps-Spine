# Heaps-Spine
Spine player for Heaps framework. It is based on h2d.Graphics class.

You will need https://github.com/jeremyfa/spine-hx to make it work (see example).

Currently it requires that all images of animation should be packed in one atlas (since each player can work only with one tile at a time)

Added binary data loader which is faster and have less memory footprint.
Actually this data loader can be used with any Haxe framework.