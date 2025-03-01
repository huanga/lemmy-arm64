git clone https://github.com/LemmyNet/lemmy-ui.git;
cd lemmy-ui;
git fetch --tags;
git submodule init;
git submodule update --recursive --remote;
# manual updates
cd lemmy-translations/;
git checkout "$TRANSLATION_COMMIT" || exit 1;
cd ../;
git checkout "$LEMMY_VERSION_UI";

# bug fix: https://github.com/nodejs/docker-node/issues/1912
sed -i 's/node:alpine/node:20-alpine3.16/g' Dockerfile;

docker build . --platform linux/arm64 --file ./Dockerfile --tag="$DOCKER_HUB_USER/lemmy-ui:$LEMMY_VERSION_UI-linux-arm64" || exit 1;

echo "Release UI";
docker push "$DOCKER_HUB_USER/lemmy-ui:$LEMMY_VERSION_UI-linux-arm64" || exit 1;
echo "Successfully pushed lemmy-ui $LEMMY_VERSION_UI";
