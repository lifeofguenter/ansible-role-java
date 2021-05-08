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
      ORACLE_JAVA_PACKAGE="${OPTARG}"
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

if [[ -z "${ORACLE_JAVA_PACKAGE}" ]]; then
  ORACLE_JAVA_PACKAGE="$(trim "$(grep -F oracle_java_package: defaults/main.yml | cut -d: -f2)")"
fi

role_root="$(pwd)"

consolelog "running role as playbook #1"
ansible-playbook \
  --inventory="${TARGET_HOST}," \
  --user="${CONNECT_USER}" \
  --extra-vars="role_root=${role_root} maven_version=${MAVEN_VERSION} gradle_version=${GRADLE_VERSION}" \
  --connection="${CONNECTION}" \
  tests/test.yml

consolelog "running role as playbook #2"
ansible-playbook \
  --inventory="${TARGET_HOST}," \
  --user="${CONNECT_USER}" \
  --extra-vars="role_root=${role_root} maven_version=${MAVEN_VERSION} gradle_version=${GRADLE_VERSION}" \
  --connection="${CONNECTION}" \
  tests/test.yml

# "test"
if [[ "${CONNECTION}" == "local" ]]; then
  consolelog "java version abs:"
  "$(dpkg -L "${ORACLE_JAVA_PACKAGE}" | grep -e 'bin/java$' | tail -n1)" -version
  consolelog "java version rel:"
  java -version

  update-java-alternatives -l

  if [[ -n "${MAVEN_VERSION}" ]]; then
    consolelog "maven version abs:"
    /opt/apache-maven/bin/mvn --version
    consolelog "maven version rel:"
    mvn --version
    consolelog "maven versions:"
    ls -lh /opt/apache-maven*
  fi

  if [[ -n "${GRADLE_VERSION}" ]]; then
    consolelog "gradle version abs:"
    /opt/gradle/bin/gradle --version
    consolelog "gradle version rel:"
    gradle --version
    consolelog "gradle versions:"
    ls -lh /opt/gradle*
  fi
fi
