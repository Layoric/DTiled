part of dtiled;
class TiledIsometricRenderer  extends TiledBaseRenderer{
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  TilesetProviderBase tilesetProvider;
  Camera camera;

  TiledIsometricRenderer(this.canvas,this.context, this.tilesetProvider,this.camera);

  DrawObjectLayer(TiledMap map, TiledLayer tiledLayer, int index) {
    int mapObjectIndex = 0;
    for (TiledMapObject mapObject in tiledLayer.MapObjects)
    {
      if (mapObject != null)
      {
        Vector drawPos;
        if (mapObject.TileID == null || mapObject.TileID < 0)
        {
          return;
        }
        DrawMapObject(map,mapObject,mapObjectIndex);
      }
      mapObjectIndex++;
    }
  }

  DrawTileLayer(TiledMap map, TiledLayer tiledLayer, int index) {
    //TODO reuse, calculate each frame according to camera position
    int xMax = map.Width;
    int yMax = map.Height;
    int xMin = 0;
    int yMin = 0;

    for (int x = xMin; x <= xMax; x++)
    {
      for (int y = yMin; y <= yMax; y++)
      {
        if (x < map.TileLayers[index].Tiles.length && y < map.TileLayers[index].Tiles[x].length)
        {
          if (map.Orientation == "isometric")
          {
            DrawTile(map, tiledLayer, x, y);
          }
        }
      }
    }
  }

  void DrawTile(TiledMap map, TiledLayer tiledLayer, int x, int y) {

    TiledTileData tile = tiledLayer.Tiles[x][y];
    if (tile != null)
    {
      TiledTile sourceTile = map.SourceTiles[tiledLayer.Tiles[x][y].SourceID];
      TiledTileset tileSet = map.Tilesets[sourceTile.TilesetID];
      Vector pos = new Vector(tile.Bounds.x,tile.Bounds.y);
      Rect source = sourceTile.Source;
      //alter tile position for rendering
      //1. Original position
      //2. Add any tile offset
      //3. centre the image
      //4. adjust for camera and screen location
      //5. adjust for zoom
      pos.x = ((tile.Bounds.x + tileSet.TileOffsetX + (map.TileWidth/2) - sourceTile.Origin.x) - (this.camera.Position.x))*this.camera.Zoom;
      pos.y = ((tile.Bounds.y + tileSet.TileOffsetY + (map.TileHeight/2) - sourceTile.Origin.y) - (this.camera.Position.y))*this.camera.Zoom;

      context.drawImageScaledFromSource(tileSet.Texture,
                            source.x,source.y,source.width,source.height,
                            pos.x,pos.y,
                            tile.Bounds.width * this.camera.Zoom,
                            tile.Bounds.height * this.camera.Zoom);
    }
  }

  void DrawMapObject(TiledMap map,TiledMapObject mapObject, int index) {

    TiledTile sourceTile = map.SourceTiles[mapObject.TileID];
    TiledTileset tileSet = map.Tilesets[sourceTile.TilesetID];
    Vector pos = new Vector(sourceTile.Source.x,sourceTile.Source.y);
    Rect source = sourceTile.Source;

    pos.x = ((mapObject.Bounds.x) - (this.camera.Position.x) - sourceTile.Origin.x) * this.camera.Zoom;
    pos.y = ((mapObject.Bounds.y) - (this.camera.Position.y) - sourceTile.Origin.y) * this.camera.Zoom;

    context.drawImageScaledFromSource(tileSet.Texture,
                                      source.x,source.y,source.width,source.height,
                                      pos.x,pos.y,
                                      sourceTile.Source.width * this.camera.Zoom,
                                      sourceTile.Source.height * this.camera.Zoom);
  }

  @override void Draw(TiledMap map, bool drawHiddenLayers)
  {
    if(map.TileLayers == null && map.ObjectLayers == null)
    {
      return;
    }

    if(map.Orientation != "isometric") {
      throw new Exception("Incorrect map orientation. Expceted 'isometric' instead of '" + map.Orientation + "'.");
    }

    for (int l = 0; l < map.TileLayers.length; l++)
    {
      TiledLayer currentLayer = map.TileLayers[l];
      if (currentLayer.Visible || drawHiddenLayers)
      {
        DrawTileLayer(map, currentLayer, l);
      }
    }

    for(int i = 0; i < map.ObjectLayers.length; i++) {
      TiledLayer currentLayer = map.ObjectLayers[i];
      DrawObjectLayer(map, currentLayer,i);
    }
  }
}

class TiledOrthogonalRenderer {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  TilesetProviderBase tilesetProvider;
  Camera camera;

  TiledOrthogonalRenderer(this.canvas,this.context, this.tilesetProvider,this.camera);

  @override void Draw(TiledMap map, bool drawHiddenLayers) {

  }
}

abstract class TiledBaseRenderer {
  void Draw(TiledMap map, bool drawHiddenLayers);
  void DrawTileLayer(TiledMap map, TiledLayer tiledLayer, int index);
  void DrawObjectLayer(TiledMap map, TiledLayer tiledLayer, int index);
  void DrawMapObject(TiledMap map,TiledMapObject mapObject, int index);
  void DrawTile(TiledMap map,TiledLayer layer, int x, int y);
}
