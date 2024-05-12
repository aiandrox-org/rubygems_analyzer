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

1. register your rubygems.org API key to `~/.gem/credentials`
2. add 0600 permission to `~/.gem/credentials`

  ```sh
  $ chmod 0600 ~/.gem/credentials
```

3. Register your GitHub API key to `.env`

```sh
  $ cp .env.sample .env
  # ovrwrite GITHUB_OAUTH_CLIENT_ID and GITHUB_OAUTH_CLIENT_SECRET
```
