# TileWorldDart

install dart SDK & flutter with desktop support

git clone git@github.com:joske/TileWorldDart.git

cd TileWorldDart

flutter run

Docker (does not work on macOS due to missing openGL features in XQuartz):

docker build -t tileworld .

docker run -ti -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw --volume="$HOME/.Xauthority:/root/.Xauthority:rw" --network=host --privileged --rm --init tileworld