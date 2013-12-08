part of dtiled;

class Vector {
  num x;
  num y;
  Vector(this.x, this.y);

  Vector operator +(Vector v) { // Overrides + (a + b).
    return new Vector(x + v.x, y + v.y);
  }

  Vector operator -(Vector v) { // Overrides - (a - b).
    return new Vector(x - v.x, y - v.y);
  }
}

class Rect {
  num x;
  num y;
  num width;
  num height;

  Rect(this.x,this.y,this.width,this.height);
}

class IsometricHelper {
  static Vector MapToWorld(TiledMap map, Point mapPosition) {
    num X = (mapPosition.x * (map.TileWidth/2)) - (mapPosition.y *(map.TileWidth/2));
    num Y = (mapPosition.y * (map.TileHeight/2)) + (mapPosition.x * (map.TileHeight/2)) - (map.TileHeight/2);
    Vector result = new Vector(X,Y);
    return result;
  }

  static Vector MapOrthToWorldIso(Point mapOrth,num tileWidth,num tileHeight) {
    num X = (mapOrth.x*(tileWidth/2)) - (mapOrth.y*(tileWidth/2));
    num Y = (mapOrth.y*(tileHeight/2)) + (mapOrth.x*(tileHeight/2));
    Vector result = new Vector(X,Y);
    return result;
  }

  static Vector MapObjectToIsometricMapPosition(Point orthogonalPosition,num tileWidth,num tileHeight) {
    num xInMap = orthogonalPosition.x / (tileWidth / 2);
    num yInMap = orthogonalPosition.y / (tileHeight / 2);
    num x = (xInMap * (tileWidth / 2)) - (yInMap * (tileWidth / 2)) + tileWidth / 2;
    num y = (yInMap * (tileHeight / 2)) + (xInMap * (tileHeight/2)) - tileHeight / 2;

    Vector result = new Vector(x,y);
    return result;
  }
}
