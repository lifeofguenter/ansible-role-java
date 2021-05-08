# lifeofguenter.oracle-java

[![Build Status](https://travis-com.org/lifeofguenter/ansible-role-java8.svg?branch=master)](https://travis-ci.com/lifeofguenter/ansible-role-java8)

An Ansible role that installs Java8 ([Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html)) on Debian-like systems.

## Requirements

none

## Role Variables

Available variables are listed below, along with default values:

```yaml
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
