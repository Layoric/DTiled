part of dtiled;

class TiledMap {
  int Height;
  int Width;
  int TileHeight;
  int TileWidth;
  String Orientation;
  Map Properties;
  num Version;
  List<TiledTileset> Tilesets;
  List<TiledTile> SourceTiles;
  List<TiledLayer> TileLayers;
  List<TiledLayer> ObjectLayers;

  Map<int,int> GidToId;
  Map<int,int> IdToGid;
}

class TiledLayer {
  String Name;
  num Opacity;
  //Color TODO
  bool Visible;
  String Type;
  Map Properties;
  List<List<TiledTileData>> Tiles;
  String Guid;
  List<TiledMapObject> MapObjects;
}

class TiledTileset {
  String Name;
  int TileWidth;
  int TileHeight;
  int Spacing;
  int Margin;
  int TileOffsetX;
  int TileOffsetY;
  Map Properties;
  List<TiledTile> Tiles;
  String ImageFileName;
  //Color TODO
  int ImageWidth;
  int ImageHeight;

  ImageElement Texture;
}

class TiledTile {
  int TilesetID;
  Map Properties;
  Rect Source;
  Vector Origin;
}

class TiledTileData {
  int SourceID;
  Rect Bounds;
  num Rotation;
  Point MapPosition;
  Vector WorldPosition;
}

class TiledMapObject {
  String Name;
  String Type;
  Rect Bounds;
  num Rotation;
  int TileID;
  bool Visible;
  Map Properties;

  //TODO Polygon
  //TODO Polyline

  String Guid;
}
