set -ex
image=quay.io/tkdchen/learning-travis-ci:${TRAVIS_TAG#v}
docker build -t $image .
echo "${QUAY_ROBOT_PASSWORD}" | docker login -u "${QUAY_ROBOT_USER}" --password-stdin quay.io
docker push $image
