part of dtiled;

class DTiledLoader {

  DTiledLoader(this.tilesetProvider);

  TilesetProviderBase tilesetProvider;

  List<TiledTile> mapTiles;

  static const int FlippedHorizontallyFlag = 0x80000000;
  static const int FlippedVerticallyFlag = 0x40000000;
  static const int FlippedDiagonallyFlag = 0x20000000;

  TiledMap LoadMap(MapDto mapDto) {
    TiledMap result = new TiledMap();
    result.GidToId = new Map<int,int>();
    result.IdToGid = new Map<int,int>();
    result.Height = mapDto.height;
    result.Width = mapDto.width;
    result.TileHeight = mapDto.tileheight;
    result.TileWidth = mapDto.tilewidth;
    result.Orientation = mapDto.orientation;
    result.Properties = mapDto.properties;
    result.Tilesets = ParseTilesets(mapDto,result.GidToId);
    result.SourceTiles = mapTiles; //mapTiles assigned in ParseTilesets
    result.TileLayers = new List<TiledLayer>();
    result.ObjectLayers = new List<TiledLayer>();
    for (int i = 0; i < result.GidToId.length; i++)
    {
      var value = result.GidToId[i];
      if (!result.IdToGid.containsKey(i))
      {
        result.IdToGid[i] = value;
      }
    }

    int layerCount = 0;
    int tileLayerCount = 0;
    int objectLayerCount = 0;
    for(LayerDto layer in mapDto.layers) {
      if (layer.type == "tilelayer")
      {
        result.TileLayers.add(ParseTileLayer(layer, result));
        tileLayerCount++;
      }

      if (layer.type == "objectgroup")
      {
        result.ObjectLayers.add(ParseObjectLayer(layer, result));
        objectLayerCount++;
      }
      layerCount++;
    }
    return result;
  }

  ParseTileLayer(LayerDto layerDto, TiledMap tiledMap) {
    TiledLayer tileLayer = new TiledLayer();
    tileLayer.Name = layerDto.name;
    tileLayer.Visible = layerDto.visible;
    tileLayer.Opacity = (layerDto.opacity != null ? layerDto.opacity : 1.0);
    tileLayer.Type = "tilelayer";
    List<List<TiledTileData>> tiles = new List<List<TiledTileData>>();
    List<int> gids = new List<int>();
    gids.addAll(layerDto.data);
    //tileLayer.OpacityColor = Color.White;
    //tileLayer.OpacityColor.A = Convert.ToByte(255.0f*tileLayer.Opacity);
    tileLayer.Properties = layerDto.properties;
    tileLayer.Guid = layerDto.guid;

    for (int i = 0; i < tiledMap.Width; i++)
    {
      tiles.add(new List<TiledTileData>());
      for(int j = 0; j < tiledMap.Height; j++)
      {
        tiles[i].add(new TiledTileData());
      }
    }

    print('gid length = ' + gids.length.toString());
    for (int i = 0; i < gids.length; i++)
    {
      //print('gid ' + i.toString());
      TiledTileData tileData = new TiledTileData();
      int id = gids[i] & ~(FlippedHorizontallyFlag | FlippedVerticallyFlag | FlippedDiagonallyFlag);
      tileData.SourceID = tiledMap.GidToId[id];
      if(tileData.SourceID >= 0) {
        //TODO
//        bool flippedHorizontally = (gids[i] & FlippedHorizontallyFlag) != 0;
//        bool flippedVertically = (gids[i] & FlippedVerticallyFlag) != 0;
//        bool flippedDiagonally = (gids[i] & FlippedDiagonallyFlag) != 0;

          switch(tiledMap.Orientation) {
            case "orthogonal":
              {
                int x = i%tiledMap.Width;
                int y = (i/tiledMap.Width).floor();
                tileData.Bounds.x = x*tiledMap.TileWidth + (mapTiles[tileData.SourceID].Origin.x as int)
                                      + tiledMap.Tilesets[mapTiles[tileData.SourceID].TilesetID].TileOffsetX;
                tileData.Bounds.y = y*tiledMap.TileHeight + (mapTiles[tileData.SourceID].Origin.y as int)
                                      + tiledMap.Tilesets[mapTiles[tileData.SourceID].TilesetID].TileOffsetY;
                tileData.Bounds.y += tiledMap.TileHeight - tileData.Bounds.height;
                tiles[x][y] = tileData;
              }
              break;
            case "isometric":
              {
                int x = i%tiledMap.Width;
                int y = (i/tiledMap.Width).floor();
                tileData.MapPosition = new Point(x, y);
                tileData.WorldPosition = IsometricHelper.MapToWorld(tiledMap,tileData.MapPosition);
                Vector pos = IsometricHelper.MapOrthToWorldIso(tileData.MapPosition,tiledMap.TileWidth,tiledMap.TileHeight);
                Rect bounds = new Rect(pos.x,pos.y,0,0);
                tileData.Bounds = bounds;
                tiles[x][y] = tileData;
              }
              break;
          }
          tileData.Bounds.width = mapTiles[tileData.SourceID].Source.width;
          tileData.Bounds.height = mapTiles[tileData.SourceID].Source.height;
      }
    }
    tileLayer.Tiles = tiles;
    return tileLayer;
  }

  ParseObjectLayer(LayerDto layerDto, TiledMap map) {
    TiledLayer objLayer = new TiledLayer();
    objLayer.Type = "objectgroup";
    objLayer.Name = layerDto.name;
    objLayer.Visible = layerDto.visible;
    objLayer.Opacity = (layerDto.opacity != null ? layerDto.opacity : 1.0);
    //objLayer.OpacityColor = Color.White;
    //objLayer.OpacityColor.A = Convert.ToByte(255.0f*objLayer.Opacity);
    objLayer.Properties = layerDto.properties;
    objLayer.Guid = layerDto.guid;
    objLayer.MapObjects = new List<TiledMapObject>();
    if(layerDto.objects != null) {
      for(MapObjectDto mapObjectDto in layerDto.objects) {
        objLayer.MapObjects.add(ParseMapObject(mapObjectDto,map));
      }
    }

    return objLayer;
  }

  TiledMapObject ParseMapObject(MapObjectDto mapObjectDto, TiledMap map) {
    TiledMapObject result = new TiledMapObject();
    Point tempPoint = new Point(mapObjectDto.x,mapObjectDto.y);
    Vector mapObjectPos = IsometricHelper.MapObjectToIsometricMapPosition(tempPoint,map.TileWidth,map.TileHeight);
    result.Name = mapObjectDto.name;
    result.Type = mapObjectDto.type;
    result.Guid = mapObjectDto.guid;
    result.Rotation = mapObjectDto.rotation;
    result.Bounds = new Rect(mapObjectPos.x,
                             mapObjectPos.y,
                             mapObjectDto.width,
                             mapObjectDto.height);
    result.Properties = mapObjectDto.properties;

    if(mapObjectDto.gid != null) {
      result.TileID = map.GidToId[mapObjectDto.gid];
    }

    //TODO Polyline
    //TODO Polygon;

    return result;
  }

  List<TiledTileset> ParseTilesets(MapDto mapDto, Map<int,int> gid2Id)
  {
    List<TiledTileset> tileSets = new List<TiledTileset>();
    List<TiledTile> mTiles = new List<TiledTile>();
    if(mapDto.tilesets != null && mapDto.tilesets.length > 0) {
      for(int i = 0; i < mapDto.tilesets.length; i++) {
        TileSetDto tileSetDto = mapDto.tilesets[i];
        int firstGid = tileSetDto.firstgid;
        TiledTileset tileset = new TiledTileset();
        tileset.Name = tileSetDto.name;
        tileset.Margin = tileSetDto.margin;
        tileset.Spacing = tileSetDto.spacing;
        tileset.TileHeight = tileSetDto.tileheight;
        tileset.TileWidth = tileSetDto.tilewidth;
        tileset.ImageFileName = tileSetDto.image;
        tileset.ImageHeight = tileSetDto.imageheight;
        tileset.ImageWidth = tileSetDto.imagewidth;
        tileset.Properties = tileSetDto.properties;
        tileset.Texture = tilesetProvider.GetTilesetTexture(tileSetDto);
        if(tileSetDto.tileoffset != null) {
          tileset.TileOffsetX = tileSetDto.tileoffset.x;
          tileset.TileOffsetY = tileSetDto.tileoffset.y;
        } else {
          tileset.TileOffsetX = 0;
          tileset.TileOffsetY = 0;
        }

        List<TiledTile> tileSetTiles = new List<TiledTile>();
        int gid = firstGid;
        for (int y = tileset.Margin;
        y < tileset.ImageHeight - tileset.Margin;
        y += tileset.TileHeight + tileset.Spacing)
        {
          if (y + tileset.TileHeight > tileset.ImageHeight - tileset.Margin)
            continue;

          for (int x = tileset.Margin;
          x < tileset.ImageWidth - tileset.Margin;
          x += tileset.TileWidth + tileset.Spacing)
          {
            if (x + tileset.TileWidth > tileset.ImageWidth - tileset.Margin)
              continue;

            var tile = new TiledTile();

            tile.Source = new Rect(x, y, tileset.TileWidth, tileset.TileHeight);
            tile.Origin = new Vector(tileset.TileWidth, tileset.TileHeight);
            tile.TilesetID = i;
            tile.Properties = new Map();


            mTiles.add(tile);
            tileSetTiles.add(tile);

//Add gid/id mapping
            gid2Id[gid] = mTiles.length - 1;

//apply property to tile if id matches
            if (tileSetDto.tileproperties != null && tileSetDto.tileproperties.length > 0)
            {
              //Map prop = tileSetDto.tileproperties[gid2Id[gid]]; //TODO tile properties are different to normal properties
//              if (prop != null)
//              {
//                for (var keyValuePair in prop)
//                {
//                  tile.Properties.Add(keyValuePair.Key, new Property {Value = keyValuePair.Value});
//                }
//              }
            }
//increment gid ready for next tile processing
            gid++;
          }
        }
        tileset.Tiles = tileSetTiles;
        tileSets.add(tileset);
      }

      mapTiles = mTiles;
    }
    return tileSets;
  }
}

