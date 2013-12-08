part of dtiled;

class TilesetProvider extends TilesetProviderBase{

  String BaseAddress;
  TilesetProvider(this.BaseAddress);

  ImageElement GetTilesetTexture(String tilesetGuid) {
    return new ImageElement(src: BaseAddress + "api/web/tiled/tilesetimage/id/" + tilesetGuid);
  }
}

abstract class TilesetProviderBase {
ImageElement GetTilesetTexture(String tilesetGuid);
}
