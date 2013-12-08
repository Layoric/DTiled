DTiled
======

A Dart package that renders Tiled maps and integrates with TiledStack services

0.0.1 only supports the JSON map format and currently only renders Isometric maps. TMX and Orthogonal support coming.

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

Full example below.

```
import 'dart:html';
import 'dart:math';
import 'package:game_loop/game_loop_html.dart';
import 'package:dtiled/dtiled.dart';
import 'dart:convert';
import 'package:query_string/query_string.dart';

int width = 600;
int height = 360;
int x = 0;
int y = 0;
String AuthorID;
String mapName;
String baseAddress = "/";

CanvasElement canvas;
CanvasRenderingContext2D context2d;
GameLoopHtml gameLoop;
MapDto currentMapDto;
TiledMap currentMap;
List<ImageElement> tilesetImages;
TiledIsometricRenderer renderer;

DTiledLoader xTiledLoader;
TiledStackTilesetProvider tileProvider;
Camera camera;
Rect renderRegion;
bool mapReady = false;


void main() {
  InitialiseMapSettings();
  InitialiseCanvas();
}

void clearContext() {
  context2d.save();
// Use the identity matrix while clearing the canvas
  context2d.setTransform(1, 0, 0, 1, 0, 0);
  context2d.clearRect(0, 0, canvas.width, canvas.height);
// Restore the transform
  context2d.restore();
}

void InitialiseMapSettings() {
  Location currentLocation = window.location;
  String loc = currentLocation.href;
  String queryString = loc.substring(loc.indexOf("?"));
  var r = QueryString.parse(queryString);
  mapName = r["mapName"];
  AuthorID = r["authorId"];
}

void InitialiseCanvas() {
  canvas = new CanvasElement(width:width,height:height);
  gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = ((gameLoop) {
    if(mapReady == true) {
      camera.Update();
    }
    clearContext();
  });
  gameLoop.onRender = ((gameLoop) {
    if(mapReady == true) {
      renderer.Draw(currentMap,false);
    }
  });
  window.onKeyDown.listen((e) {
    print(e.keyCode.toString());
    if(e.keyCode == 37) {

      camera.Target.x -= 5.0;
    }
    if(e.keyCode == 38) {
      camera.Target.y -= 5.0;
    }
    if(e.keyCode == 39) {
      camera.Target.x += 5.0;
    }
    if(e.keyCode == 40) {
      camera.Target.y += 5.0;
    }
  });
  canvas.onMouseWheel.listen((e) {
    if(e.deltaY > 0 && camera.Zoom > 0.2) {
      camera.Zoom -= 0.1;
    }
    if(e.deltaY < 0 && camera.Zoom < 2.5) {
      camera.Zoom += 0.1;
    }
  });
  gameLoop.start();
  query('#canvas').nodes.add(canvas);
  context2d = canvas.getContext('2d');
  // TiledStack tileset provider is for use with TiledStack API. 'LocalTilesetProvider' for alternate path to textures
  tileProvider = new TiledStackTilesetProvider(baseAddress);
  xTiledLoader = new DTiledLoader(tileProvider);
  GetMap();
}

void GetMap() {
//providers JSON Tiled Map
        HttpRequest.request(baseAddress + "api/web/raw/tiled/" + AuthorID + "/maps/" + mapName + "?format=json").then((r) {
          if (r.readyState == HttpRequest.DONE &&
          (r.status == 200)) {
            Map response = JSON.decode(r.responseText);
            MapDto mapDto = new MapDto(response);
            currentMapDto = mapDto;
            currentMap = xTiledLoader.LoadMap(currentMapDto);
            renderRegion = new Rect(canvas.clientLeft,canvas.clientTop,canvas.clientWidth,canvas.clientHeight);
            camera = new Camera(currentMap,renderRegion);
            renderer = new TiledIsometricRenderer(canvas,context2d,tileProvider,camera);
            mapReady = true;
    }
  });
}
```
