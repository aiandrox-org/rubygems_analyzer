# RubygemsAnalyzer

## usage

run `bin/rubygems_analyzer` with gem name

```sh
$ bin/rubygems_analyzer bundler

bundler has 2071385454 downloads (rank 1/4)

1 bundler      ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 2071385454
2 aws-sdk-core ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 1213342602
3 aws-sigv4    ┤■■■■■■■■■■■■■■■■■■■■■■■■■ 1066372310
4 jmespath     ┤■■■■■■■■■■■■■■■■■■■■■■■■■ 1039051136
```


## calculator weekly data

1. register your rubygems.org API key to `~/.gems/credentials`
2. add 0600 permission to `~/.gems/credentials`
  ```sh
  $ chmod 0600 ~/.gems/credentials
  ```
