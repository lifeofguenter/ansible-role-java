# lifeofguenter.java

[![Build Status](https://travis-ci.com/lifeofguenter/ansible-role-java.svg?branch=main)](https://travis-ci.com/lifeofguenter/ansible-role-java)

An Ansible role that installs [Java Corretto](https://docs.aws.amazon.com/corretto/index.html) 8, 11 (LTS) and 16 on
Debian-like systems.

## Requirements

none

## Role Variables

Available variables are listed below, along with default values:

```yaml
default_java_package: java-1.8.0-amazon-corretto-jdk

maven_version: ''

gradle_version: ''
```

## Dependencies

none

## Example Playbook

```yaml
- hosts: webservers
  roles:
    - { role: lifeofguenter.java }
```

## License

Licensed under the MIT License. See the [LICENSE file](LICENSE) for details.

## Author Information

[Gunter Grodotzki](https://lifeofguenter.de)
