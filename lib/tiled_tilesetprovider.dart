part of dtiled;

class TiledStackTilesetProvider extends TilesetProviderBase{

  String BaseAddress;
  TiledStackTilesetProvider(this.BaseAddress);

  ImageElement GetTilesetTexture(TileSetDto tilesetDto) {
    return new ImageElement(src: BaseAddress + "api/web/tiled/tilesetimage/id/" + tilesetDto.guid);
  }
}

class LocalTilesetProvider extends TilesetProviderBase {
  String BaseAddress;
  LocalTilesetProvider(this.BaseAddress);
  ImageElement GetTilesetTexture(TileSetDto tilesetDto) {
    return new ImageElement(src:BaseAddress + "/" + tilesetDto.image);
  }
}

abstract class TilesetProviderBase {
ImageElement GetTilesetTexture(TileSetDto tilesetDto);
}
