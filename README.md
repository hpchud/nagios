# nagios

This is the Nagios, Nagvis and Nagiosgraph container built for the QGG, originally based on `loitho/nag-ios-vis-graph`.

It runs in a similar fashion to our `dns` and `ldap` containers. The configuration for both Nagios and Nagvis will be obtained by cloning a git repository on container (re-)start, or alternatively, you can mount Docker volumes over the desired configuration directories. If you do nothing, then the example configuration will be loaded!

# Running it

```
docker run -d -p 80:80 \
    -e CONFIG_REPO=bitbucket.org/hpchud/nagios-config.git \
    -e CONFIG_USER=hpchud
    -e CONFIG_PASS=<api key> \
    hpchud/nagios
```