image=quay.io/tkdchen/learning-travis-ci:${TRAVIS_TAG#v}
docker build -t $image .
docker login -u="${QUAY_ROBOT_USER}" -p="${QUAY_ROBOT_PASSWORD}" quay.io
docker push $image
