part of dtiled;

class MapResponse {
  Map<String,MapDto> map;
  String MapName;

  MapResponse() {

  }
}

class MapDto {
  String MapName;
  int height;
  List<LayerDto> layers;
  String orientation;
  Map properties;
  int tileheight;
  List<TileSetDto> tilesets;
  int tilewidth;
  num version;
  int width;

  MapDto(Map tiledStackResponse) {
    var mapTemp = tiledStackResponse["Map"];
    this.MapName = tiledStackResponse["MapName"];
    this.height = mapTemp["height"] as int;
    this.orientation = mapTemp["orientation"];
    this.properties = mapTemp["properties"];
    this.tileheight = mapTemp["tileheight"] as int;
    this.tilewidth = mapTemp["tilewidth"] as int;
    this.version = mapTemp["version"] as num;
    this.width = mapTemp["width"];
    this.layers = new List<LayerDto>();
    for(var layer in mapTemp["layers"]) {
      this.layers.add(new LayerDto(layer));
    }
    this.tilesets = new List<TileSetDto>();
    for(var tileset in mapTemp["tilesets"]) {
      this.tilesets.add(new TileSetDto(tileset));
    }
  }
}

class TileSetDto {
  int firstgid;
  String image;
  int imageheight;
  int imagewidth;
  int margin;
  String name;
  Map<String,String> properties;
  int spacing;
  int tileheight;
  List<Map<String,String>> tileproperties;
  int tilewidth;
  String transparentcolor;
  TileoffsetDto tileoffset;
  String guid;

  ImageElement texture;

  TileSetDto(Map tileset) {
    this.firstgid = tileset["firstgid"] as int;
    this.image = tileset["image"];
    this.imageheight = tileset["imageheight"] as int;
    this.imagewidth = tileset["imagewidth"] as int;
    this.margin = tileset["margin"] as int;
    this.name = tileset["name"];
    this.properties = tileset["properties"];
    this.spacing = tileset["spacing"] as int;
    this.tileheight = tileset["tileheight"] as int;
    Map tempTileProps = tileset["tileproperties"];

    if(tempTileProps != null && tempTileProps.length > 0) {
      //tileproperties = new List<Map>();
      //for(var tileProp in tempTileProps) {
        //tileproperties.add(tileProp);
      //}
    }

    this.tilewidth = tileset["tilewidth"] as int;
    this.transparentcolor = tileset["transparentcolor"];
    var tempOffset = tileset["tileoffset"];
    if(tempOffset != null) {
      this.tileoffset = new TileoffsetDto(tempOffset["x"] as int, tempOffset["y"] as int);
    }
    
    this.guid = tileset["guid"];
  }
}

class LayerDto {
  List<int> data;
  List<MapObjectDto> objects;
  Map<String,String> properties;
  int height;
  String name;
  num opacity;
  String type;
  bool visible;
  int width;
  int x;
  int y;
  String guid;

  LayerDto(Map layer) {
    this.properties = layer["properties"];
    this.height = layer["height"] as int;
    this.name = layer["name"];
    this.opacity = layer["opacity"] as num;
    this.type = layer["type"];
    this.visible = layer["visible"] as bool;
    this.width = layer["width"] as int;
    this.x = layer["x"] as int;
    this.y = layer["y"] as int;
    this.guid = layer["guid"];

    //Load tile data if tile layer
    var tempData = layer["data"];
    if(tempData != null) {
      data = new List<int>();
      for(var tileId in tempData) {
        data.add(tileId as int);
      }
    }

    //Load map objects if object group
    var tempMapObjects = layer["objects"];
    if(tempMapObjects != null) {
      objects = new List<MapObjectDto>();
      for(Map mapObject in  tempMapObjects) {
        objects.add(new MapObjectDto(mapObject));
      }
    }

  }
}

class MapObjectDto {

  int gid;
  int height;
  String name;
  Map<String,String> properties;
  List<PolygonDto> polygon;
  List<PolylineDto> polyline;
  String type;
  bool visible;
  int width;
  int x;
  int y;
  num rotation;
  String guid;

  MapObjectDto(Map mapObject) {
    this.gid = mapObject["gid"] as int;
    this.properties = mapObject["properties"];
    this.height = mapObject["height"] as int;
    this.name = mapObject["name"];
    this.type = mapObject["type"];
    this.visible = mapObject["visible"] as bool;
    this.width = mapObject["width"] as int;
    this.x = mapObject["x"] as int;
    this.y = mapObject["y"] as int;
    this.rotation = mapObject["rotation"] as num;
    this.guid = mapObject["guid"];

    var tempPolygon = mapObject["polygon"];
    if(tempPolygon != null) {
      polygon = new List<PolygonDto>();
      for(Map singlePolygon in tempPolygon) {
        polygon.add(new PolygonDto(singlePolygon["x"] as int,singlePolygon["y"] as int));
      }
    }

    var tempPolyline = mapObject["polyline"];
    if(tempPolyline != null) {
      polyline = new List<PolylineDto>();
      for(Map singlePolyline in tempPolyline) {
        polyline.add(new PolylineDto(singlePolyline["x"] as int,singlePolyline["y"] as int));
      }
    }
  }
}

class PolygonDto {
  int x;
  int y;

  PolygonDto(this.x, this.y);
}

class PolylineDto {
  int x;
  int y;

  PolylineDto(this.x, this.y);
}

class TileoffsetDto {
  int x;
  int y;

  TileoffsetDto(this.x, this.y);
}
