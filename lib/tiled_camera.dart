part of dtiled;

class Camera {

  Vector Position;
  int Width;
  int Height;
  Vector Target;
  Rect ClampRect;
  num Zoom;
  num Rotation;
  num Momentum = 0.15;
  num Speed = 2.5;
  Rect ViewPort;
  Rect WorldRect;

Camera(TiledMap map, Rect viewPort) {
    num clampX = -1 * ((map.Width) * map.TileWidth) /2;
    num clampY = -500;//-1 * ((map.TileHeight) * map.Height) / 2;
    num clampWidth = (map.Width*map.TileWidth/2) * 3;
    num clampHeight = (map.Height*map.TileHeight/2) * 3;
    Rect clampRect = new Rect(clampX.floor(),clampY.floor(),clampWidth.floor(),clampHeight.floor());
    Width = viewPort.width;
    Height = viewPort.height;
    Rotation = 0.0;
    ClampRect = clampRect;
    Zoom = 1.00;
    Position = new Vector(0,0);
    Target = new Vector(0,0);
  }

  void Update() {
    Position.x = Target.x;
    Position.y = Target.y;
  }
}
