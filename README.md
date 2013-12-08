DTiled
======

A Dart package that renders Tiled maps and integrates with TiledStack services

0.0.x only supports the JSON map format and currently only renders Isometric maps. TMX and Orthogonal support coming.

Basics.

Setup TilesetProvider and DTiledLoader. A 'TiledsetProvider' is a class which providers logic to get a tileset image.
A DTiledLoader converts from a simple Dto to the main data structure used for renderering. This is based on 'XTiled' by ViNull.

```
...
  gameLoop.start();
  query('#canvas').nodes.add(canvas);
  context2d = canvas.getContext('2d');
  // TiledStack tileset provider is for use with TiledStack API. 'LocalTilesetProvider' for alternate path to textures
  tileProvider = new TiledStackTilesetProvider(baseAddress);
  tiledLoader = new DTiledLoader(tileProvider);
...

```

Once the JSON map is loaded, other parts need to be initialised. 

```
...
  // a Dart 'Map'
  Map response = JSON.decode(r.responseText); 
  //populate simple Dto
  MapDto mapDto = new MapDto(response); 
  currentMapDto = mapDto;
  // Parse simple Dto
  currentMap = xTiledLoader.LoadMap(currentMapDto); 
  // Create render region for camera
  renderRegion = new Rect(canvas.clientLeft,canvas.clientTop,canvas.clientWidth,canvas.clientHeight); 
  // Create camera
  camera = new Camera(currentMap,renderRegion);
  // Create renderer. This should probably be based on map type in Dto, and will once all maps types are supported
  renderer = new TiledIsometricRenderer(canvas,context2d,tileProvider,camera);
...
```

[See complete simple example.](https://github.com/Layoric/DTiled/wiki/Simple-DTiled-example)

![example](http://3.bp.blogspot.com/-r5wizd17O6o/UqQhv1opKKI/AAAAAAAABjE/pY04lWEXMhc/s1600/dtiled_example.png)
