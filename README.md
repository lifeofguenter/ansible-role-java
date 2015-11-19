# Ansible Role: Oracle Java

An Ansible role that installs Oracle Java on Debian like systems.

## Requirements

none

## Role Variables

Available variables are listed below, along with default values:

    oracle_java_version: 8u66-b17

## Dependencies

none

## Example Playbook

    - hosts: webservers
      roles:
        - { role: lifeofguenter.oracle-java }

## License

MIT