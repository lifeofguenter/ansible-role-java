[![Build Status](https://travis-ci.org/lifeofguenter/ansible-role-oracle-java.svg?branch=master)](https://travis-ci.org/lifeofguenter/ansible-role-oracle-java)

# lifeofguenter.oracle-java

An Ansible role that installs Oracle Java8 on Debian-like systems.

_Please note: this is meant for legacy systems and will never go beyond JDK8 or debian jessie/stretch or ubuntu trusty/xenial. Please rather install openjdk in future._

## Requirements

none

## Role Variables

Available variables are listed below, along with default values:

```yaml
oracle_java_package: oracle-java8-jdk

maven_version: ''

gradle_version: ''
```

## Dependencies

none

## Example Playbook

```yaml
- hosts: webservers
  roles:
    - { role: lifeofguenter.oracle-java }
```

## License

Licensed under the MIT License. See the [LICENSE file](LICENSE) for details.

## Author Information

[Gunter Grodotzki](https://lifeofguenter.de)
