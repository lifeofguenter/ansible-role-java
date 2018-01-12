#!/usr/bin/env bash

__DIR__="$(dirname "$("${READLINK_PATH:-readlink}" -f "$0")")"

# required libs
source "${__DIR__}/.bash/functions.shlib"

set -E
trap 'throw_exception' ERR

usage() {
cat <<EOF
Usage: ${0##*/} OPTIONS
test role

    -h          display this help and exit
    -i STRING   target host to run against (default: 127.0.0.1)
    -u STRING   connect as this user (default: current user)
    -V STRING   override version to build
EOF
}

OPTIND=1
while getopts "hi:u:V:" opt; do
  case "${opt}" in
    h )
      usage
      exit 0
      ;;
    i )
      TARGET_HOST="${OPTARG}"
      ;;
    u )
      CONNECT_USER="${OPTARG}"
      ;;
    V )
      ORACLE_JAVA_VERSION="${OPTARG}"
      ;;
    '?' )
      usage >&2
      exit 1
      ;;
  esac
done
shift "$((OPTIND-1))"

if [[ -z "${TARGET_HOST}" ]]; then
  TARGET_HOST="127.0.0.1"
  CONNECTION="local"
fi

if [[ -z "${CONNECT_USER}" ]]; then
  CONNECT_USER="$(whoami)"
fi

if [[ -z "${CONNECTION}" ]]; then
  CONNECTION="smart"
fi

if [[ -z "${ORACLE_JAVA_VERSION}" ]]; then
  ORACLE_JAVA_VERSION="$(trim "$(grep -F oracle_java_version: defaults/main.yml | cut -d: -f2)")"
fi

role_root="$(pwd)"

consolelog "running role as playbook #1"
ansible-playbook \
  --inventory="${TARGET_HOST}," \
  --user="${CONNECT_USER}" \
  --extra-vars="role_root=${role_root} oracle_java_version=${ORACLE_JAVA_VERSION} maven_version=${MAVEN_VERSION}" \
  --connection="${CONNECTION}" \
  tests/test.yml

consolelog "running role as playbook #2"
ansible-playbook \
  --inventory="${TARGET_HOST}," \
  --user="${CONNECT_USER}" \
  --extra-vars="role_root=${role_root} oracle_java_version=${ORACLE_JAVA_VERSION} maven_version=${MAVEN_VERSION}" \
  --connection="${CONNECTION}" \
  tests/test.yml

# "test"
if [[ "${CONNECTION}" == "local" ]]; then
  echo ''
  "$(dpkg -L oracle-java${ORACLE_JAVA_VERSION:0:1}-jdk | grep -e 'bin/java$' | tail -n1)" -version
  echo ''
  java -version
fi

if [[ ! -z "${MAVEN_VERSION}" ]]; then
  echo ''
  mvn --version
  /opt/apache-maven/bin/mvn --version
  ls -lh /opt/apache-maven*
fi
