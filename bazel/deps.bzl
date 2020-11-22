load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_dependencies():
    go_repository(
        name = "co_honnef_go_tools",
        build_file_proto_mode = "disable",
        importpath = "honnef.co/go/tools",
        sum = "h1:3JgtbtFHMiCmsznwGVTUWbgGov+pVqnlf1dEJTNAXeM=",
        version = "v0.0.1-2019.2.3",
    )
    go_repository(
        name = "com_github_aead_siphash",
        build_file_proto_mode = "disable",
        importpath = "github.com/aead/siphash",
        sum = "h1:FwHfE/T45KPKYuuSAKyyvE+oPWcaQ+CUmFW0bPlM+kg=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_alangpierce_go_forceexport",
        build_file_proto_mode = "disable",
        importpath = "github.com/alangpierce/go-forceexport",
        sum = "h1:3ILjVyslFbc4jl1w5TWuvvslFD/nDfR2H8tVaMVLrEY=",
        version = "v0.0.0-20160317203124-8f1d6941cd75",
    )
    go_repository(
        name = "com_github_alecthomas_template",
        build_file_proto_mode = "disable",
        importpath = "github.com/alecthomas/template",
        sum = "h1:JYp7IbQjafoB+tBA3gMyHYHrpOtNuDiK/uB5uXxq5wM=",
        version = "v0.0.0-20190718012654-fb15b899a751",
    )
    go_repository(
        name = "com_github_alecthomas_units",
        build_file_proto_mode = "disable",
        importpath = "github.com/alecthomas/units",
        sum = "h1:Hs82Z41s6SdL1CELW+XaDYmOH4hkBN4/N9og/AsOv7E=",
        version = "v0.0.0-20190717042225-c3de453c63f4",
    )
    go_repository(
        name = "com_github_alexbrainman_goissue34681",
        build_file_proto_mode = "disable",
        importpath = "github.com/alexbrainman/goissue34681",
        sum = "h1:iW0a5ljuFxkLGPNem5Ui+KBjFJzKg4Fv2fnxe4dvzpM=",
        version = "v0.0.0-20191006012335-3fc7a47baff5",
    )
    go_repository(
        name = "com_github_andreasbriese_bbloom",
        build_file_proto_mode = "disable",
        importpath = "github.com/AndreasBriese/bbloom",
        sum = "h1:cTp8I5+VIoKjsnZuH8vjyaysT/ses3EvZeaV/1UkF2M=",
        version = "v0.0.0-20190825152654-46b345b51c96",
    )
    go_repository(
        name = "com_github_anmitsu_go_shlex",
        build_file_proto_mode = "disable",
        importpath = "github.com/anmitsu/go-shlex",
        sum = "h1:kFOfPq6dUM1hTo4JG6LR5AXSUEsOjtdm0kw0FtQtMJA=",
        version = "v0.0.0-20161002113705-648efa622239",
    )
    go_repository(
        name = "com_github_armon_consul_api",
        build_file_proto_mode = "disable",
        importpath = "github.com/armon/consul-api",
        sum = "h1:G1bPvciwNyF7IUmKXNt9Ak3m6u9DE1rF+RmtIkBpVdA=",
        version = "v0.0.0-20180202201655-eb2c6b5be1b6",
    )
    go_repository(
        name = "com_github_aws_aws_sdk_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/aws/aws-sdk-go",
        sum = "h1:S2LuRnfC8X05zgZLC8gy/Sb82TGv2Cpytzbzz7tkeHc=",
        version = "v1.35.28",
    )
    go_repository(
        name = "com_github_azure_azure_sdk_for_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/Azure/azure-sdk-for-go",
        sum = "h1:KnPIugL51v3N3WwvaSmZbxukD1WuWXOiE9fRdu32f2I=",
        version = "v16.2.1+incompatible",
    )
    go_repository(
        name = "com_github_azure_go_autorest",
        build_file_proto_mode = "disable",
        importpath = "github.com/Azure/go-autorest",
        sum = "h1:viZ3tV5l4gE2Sw0xrasFHytCGtzYCrT+um/rrSQ1BfA=",
        version = "v11.1.2+incompatible",
    )
    go_repository(
        name = "com_github_benbjohnson_clock",
        build_file_proto_mode = "disable",
        importpath = "github.com/benbjohnson/clock",
        sum = "h1:vkLuvpK4fmtSCuo60+yC63p7y0BmQ8gm5ZXGuBCJyXg=",
        version = "v1.0.3",
    )
    go_repository(
        name = "com_github_beorn7_perks",
        build_file_proto_mode = "disable",
        importpath = "github.com/beorn7/perks",
        sum = "h1:VlbKKnNfV8bJzeqoa4cOKqO6bYr3WgKZxO8Z16+hsOM=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_bitly_go_simplejson",
        build_file_proto_mode = "disable",
        importpath = "github.com/bitly/go-simplejson",
        sum = "h1:6IH+V8/tVMab511d5bn4M7EwGXZf9Hj6i2xSwkNEM+Y=",
        version = "v0.5.0",
    )
    go_repository(
        name = "com_github_blang_semver",
        build_file_proto_mode = "disable",
        importpath = "github.com/blang/semver",
        sum = "h1:cQNTCjp13qL8KC3Nbxr/y2Bqb63oX6wdnnjpJbkM4JQ=",
        version = "v3.5.1+incompatible",
    )
    go_repository(
        name = "com_github_bmizerany_assert",
        build_file_proto_mode = "disable",
        importpath = "github.com/bmizerany/assert",
        sum = "h1:DDGfHa7BWjL4YnC6+E63dPcxHo2sUxDIu8g3QgEJdRY=",
        version = "v0.0.0-20160611221934-b7ed37b82869",
    )
    go_repository(
        name = "com_github_bradfitz_go_smtpd",
        build_file_proto_mode = "disable",
        importpath = "github.com/bradfitz/go-smtpd",
        sum = "h1:ckJgFhFWywOx+YLEMIJsTb+NV6NexWICk5+AMSuz3ss=",
        version = "v0.0.0-20170404230938-deb6d6237625",
    )
    go_repository(
        name = "com_github_bren2010_proquint",
        build_file_proto_mode = "disable",
        importpath = "github.com/bren2010/proquint",
        sum = "h1:QgeLLoPD3kRVmeu/1al9iIpIANMi9O1zXFm8BnYGCJg=",
        version = "v0.0.0-20160323162903-38337c27106d",
    )
    go_repository(
        name = "com_github_bshuster_repo_logrus_logstash_hook",
        build_file_proto_mode = "disable",
        importpath = "github.com/bshuster-repo/logrus-logstash-hook",
        sum = "h1:pgAtgj+A31JBVtEHu2uHuEx0n+2ukqUJnS2vVe5pQNA=",
        version = "v0.4.1",
    )
    go_repository(
        name = "com_github_btcsuite_btcd",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/btcd",
        sum = "h1:Ik4hyJqN8Jfyv3S4AGBOmyouMsYE3EdYODkMbQjwPGw=",
        version = "v0.20.1-beta",
    )
    go_repository(
        name = "com_github_btcsuite_btclog",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/btclog",
        sum = "h1:bAs4lUbRJpnnkd9VhRV3jjAVU7DJVjMaK+IsvSeZvFo=",
        version = "v0.0.0-20170628155309-84c8d2346e9f",
    )
    go_repository(
        name = "com_github_btcsuite_btcutil",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/btcutil",
        sum = "h1:yJzD/yFppdVCf6ApMkVy8cUxV0XrxdP9rVf6D87/Mng=",
        version = "v0.0.0-20190425235716-9e5f4b9a998d",
    )
    go_repository(
        name = "com_github_btcsuite_go_socks",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/go-socks",
        sum = "h1:R/opQEbFEy9JGkIguV40SvRY1uliPX8ifOvi6ICsFCw=",
        version = "v0.0.0-20170105172521-4720035b7bfd",
    )
    go_repository(
        name = "com_github_btcsuite_goleveldb",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/goleveldb",
        sum = "h1:qdGvebPBDuYDPGi1WCPjy1tGyMpmDK8IEapSsszn7HE=",
        version = "v0.0.0-20160330041536-7834afc9e8cd",
    )
    go_repository(
        name = "com_github_btcsuite_snappy_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/snappy-go",
        sum = "h1:ZA/jbKoGcVAnER6pCHPEkGdZOV7U1oLUedErBHCUMs0=",
        version = "v0.0.0-20151229074030-0bdef8d06723",
    )
    go_repository(
        name = "com_github_btcsuite_websocket",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/websocket",
        sum = "h1:R8vQdOQdZ9Y3SkEwmHoWBmX1DNXhXZqlTpq6s4tyJGc=",
        version = "v0.0.0-20150119174127-31079b680792",
    )
    go_repository(
        name = "com_github_btcsuite_winsvc",
        build_file_proto_mode = "disable",
        importpath = "github.com/btcsuite/winsvc",
        sum = "h1:J9B4L7e3oqhXOcm+2IuNApwzQec85lE+QaikUcCs+dk=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_buger_jsonparser",
        build_file_proto_mode = "disable",
        importpath = "github.com/buger/jsonparser",
        sum = "h1:D21IyuvjDCshj1/qq+pCNd3VZOAEI9jy6Bi131YlXgI=",
        version = "v0.0.0-20181115193947-bf1c66bbce23",
    )
    go_repository(
        name = "com_github_bugsnag_bugsnag_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/bugsnag/bugsnag-go",
        sum = "h1:rFt+Y/IK1aEZkEHchZRSq9OQbsSzIT/OrI8YFFmRIng=",
        version = "v0.0.0-20141110184014-b1d153021fcd",
    )
    go_repository(
        name = "com_github_bugsnag_osext",
        build_file_proto_mode = "disable",
        importpath = "github.com/bugsnag/osext",
        sum = "h1:otBG+dV+YK+Soembjv71DPz3uX/V/6MMlSyD9JBQ6kQ=",
        version = "v0.0.0-20130617224835-0dd3f918b21b",
    )
    go_repository(
        name = "com_github_bugsnag_panicwrap",
        build_file_proto_mode = "disable",
        importpath = "github.com/bugsnag/panicwrap",
        sum = "h1:nvj0OLI3YqYXer/kZD8Ri1aaunCxIEsOst1BVJswV0o=",
        version = "v0.0.0-20151223152923-e2c28503fcd0",
    )
    go_repository(
        name = "com_github_burntsushi_toml",
        build_file_proto_mode = "disable",
        importpath = "github.com/BurntSushi/toml",
        sum = "h1:WXkYYl6Yr3qBf1K79EBnL4mak0OimBfB0XUf9Vl28OQ=",
        version = "v0.3.1",
    )
    go_repository(
        name = "com_github_burntsushi_xgb",
        build_file_proto_mode = "disable",
        importpath = "github.com/BurntSushi/xgb",
        sum = "h1:1BDTz0u9nC3//pOCMdNH+CiXJVYJh5UQNCOBG7jbELc=",
        version = "v0.0.0-20160522181843-27f122750802",
    )
    go_repository(
        name = "com_github_cenkalti_backoff",
        build_file_proto_mode = "disable",
        importpath = "github.com/cenkalti/backoff",
        sum = "h1:tNowT99t7UNflLxfYYSlKYsBpXdEet03Pg2g16Swow4=",
        version = "v2.2.1+incompatible",
    )
    go_repository(
        name = "com_github_census_instrumentation_opencensus_proto",
        build_file_proto_mode = "disable",
        importpath = "github.com/census-instrumentation/opencensus-proto",
        sum = "h1:glEXhBS5PSLLv4IXzLA5yPRVX4bilULVyxxbrfOtDAk=",
        version = "v0.2.1",
    )
    go_repository(
        name = "com_github_cespare_xxhash",
        build_file_proto_mode = "disable",
        importpath = "github.com/cespare/xxhash",
        sum = "h1:a6HrQnmkObjyL+Gs60czilIUGqrzKutQD6XZog3p+ko=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_cespare_xxhash_v2",
        build_file_proto_mode = "disable",
        importpath = "github.com/cespare/xxhash/v2",
        sum = "h1:6MnRN8NT7+YBpUIWxHtefFZOKTAPgGjpQSxqLNn0+qY=",
        version = "v2.1.1",
    )
    go_repository(
        name = "com_github_cheekybits_genny",
        build_file_proto_mode = "disable",
        importpath = "github.com/cheekybits/genny",
        sum = "h1:uGGa4nei+j20rOSeDeP5Of12XVm7TGUd4dJA9RDitfE=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_cheekybits_is",
        build_file_proto_mode = "disable",
        importpath = "github.com/cheekybits/is",
        sum = "h1:SKI1/fuSdodxmNNyVBR8d7X/HuLnRpvvFO0AgyQk764=",
        version = "v0.0.0-20150225183255-68e9c0620927",
    )
    go_repository(
        name = "com_github_chzyer_logex",
        build_file_proto_mode = "disable",
        importpath = "github.com/chzyer/logex",
        sum = "h1:Swpa1K6QvQznwJRcfTfQJmTE72DqScAa40E+fbHEXEE=",
        version = "v1.1.10",
    )
    go_repository(
        name = "com_github_chzyer_readline",
        build_file_proto_mode = "disable",
        importpath = "github.com/chzyer/readline",
        sum = "h1:fY5BOSpyZCqRo5OhCuC+XN+r/bBCmeuuJtjz+bCNIf8=",
        version = "v0.0.0-20180603132655-2972be24d48e",
    )
    go_repository(
        name = "com_github_chzyer_test",
        build_file_proto_mode = "disable",
        importpath = "github.com/chzyer/test",
        sum = "h1:q763qf9huN11kDQavWsoZXJNW3xEE4JJyHa5Q25/sd8=",
        version = "v0.0.0-20180213035817-a1ea475d72b1",
    )
    go_repository(
        name = "com_github_client9_misspell",
        build_file_proto_mode = "disable",
        importpath = "github.com/client9/misspell",
        sum = "h1:ta993UF76GwbvJcIo3Y68y/M3WxlpEHPWIGDkJYwzJI=",
        version = "v0.3.4",
    )
    go_repository(
        name = "com_github_cncf_udpa_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/cncf/udpa/go",
        sum = "h1:WBZRG4aNOuI15bLRrCgN8fCq8E5Xuty6jGbmSNEvSsU=",
        version = "v0.0.0-20191209042840-269d4d468f6f",
    )
    go_repository(
        name = "com_github_coreos_etcd",
        build_file_proto_mode = "disable",
        importpath = "github.com/coreos/etcd",
        sum = "h1:jFneRYjIvLMLhDLCzuTuU4rSJUjRplcJQ7pD7MnhC04=",
        version = "v3.3.10+incompatible",
    )
    go_repository(
        name = "com_github_coreos_go_etcd",
        build_file_proto_mode = "disable",
        importpath = "github.com/coreos/go-etcd",
        sum = "h1:bXhRBIXoTm9BYHS3gE0TtQuyNZyeEMux2sDi4oo5YOo=",
        version = "v2.0.0+incompatible",
    )
    go_repository(
        name = "com_github_coreos_go_semver",
        build_file_proto_mode = "disable",
        importpath = "github.com/coreos/go-semver",
        sum = "h1:wkHLiw0WNATZnSG7epLsujiMCgPAc9xhjJ4tgnAxmfM=",
        version = "v0.3.0",
    )
    go_repository(
        name = "com_github_coreos_go_systemd",
        build_file_proto_mode = "disable",
        importpath = "github.com/coreos/go-systemd",
        sum = "h1:t5Wuyh53qYyg9eqn4BbnlIT+vmhyww0TatL+zT3uWgI=",
        version = "v0.0.0-20181012123002-c6f51f82210d",
    )
    go_repository(
        name = "com_github_coreos_go_systemd_v22",
        build_file_proto_mode = "disable",
        importpath = "github.com/coreos/go-systemd/v22",
        sum = "h1:XJIw/+VlJ+87J+doOxznsAWIdmWuViOVhkQamW5YV28=",
        version = "v22.0.0",
    )
    go_repository(
        name = "com_github_cpuguy83_go_md2man",
        build_file_proto_mode = "disable",
        importpath = "github.com/cpuguy83/go-md2man",
        sum = "h1:BSKMNlYxDvnunlTymqtgONjNnaRV1sTpcovwwjF22jk=",
        version = "v1.0.10",
    )
    go_repository(
        name = "com_github_crackcomm_go_gitignore",
        build_file_proto_mode = "disable",
        importpath = "github.com/crackcomm/go-gitignore",
        sum = "h1:HVTnpeuvF6Owjd5mniCL8DEXo7uYXdQEmOP4FJbV5tg=",
        version = "v0.0.0-20170627025303-887ab5e44cc3",
    )
    go_repository(
        name = "com_github_cskr_pubsub",
        build_file_proto_mode = "disable",
        importpath = "github.com/cskr/pubsub",
        sum = "h1:vlOzMhl6PFn60gRlTQQsIfVwaPB/B/8MziK8FhEPt/0=",
        version = "v1.0.2",
    )
    go_repository(
        name = "com_github_datadog_sketches_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/DataDog/sketches-go",
        sum = "h1:qELHH0AWCvf98Yf+CNIJx9vOZOfHFDDzgDRYsnNk/vs=",
        version = "v0.0.0-20190923095040-43f19ad77ff7",
    )
    go_repository(
        name = "com_github_davecgh_go_spew",
        build_file_proto_mode = "disable",
        importpath = "github.com/davecgh/go-spew",
        sum = "h1:vj9j/u1bqnvCEfJOwUhtlOARqs3+rkHYY13jYWTU97c=",
        version = "v1.1.1",
    )
    go_repository(
        name = "com_github_davidlazar_go_crypto",
        build_file_proto_mode = "disable",
        importpath = "github.com/davidlazar/go-crypto",
        sum = "h1:BOaYiTvg8p9vBUXpklC22XSK/mifLF7lG9jtmYYi3Tc=",
        version = "v0.0.0-20190912175916-7055855a373f",
    )
    go_repository(
        name = "com_github_denverdino_aliyungo",
        build_file_proto_mode = "disable",
        importpath = "github.com/denverdino/aliyungo",
        sum = "h1:p6poVbjHDkKa+wtC8frBMwQtT3BmqGYBjzMwJ63tuR4=",
        version = "v0.0.0-20190125010748-a747050bb1ba",
    )
    go_repository(
        name = "com_github_dgraph_io_badger",
        build_file_proto_mode = "disable",
        importpath = "github.com/dgraph-io/badger",
        sum = "h1:w9pSFNSdq/JPM1N12Fz/F/bzo993Is1W+Q7HjPzi7yg=",
        version = "v1.6.1",
    )
    go_repository(
        name = "com_github_dgraph_io_ristretto",
        build_file_proto_mode = "disable",
        importpath = "github.com/dgraph-io/ristretto",
        sum = "h1:a5WaUrDa0qm0YrAAS1tUykT5El3kt62KNZZeMxQn3po=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_dgrijalva_jwt_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/dgrijalva/jwt-go",
        sum = "h1:KJAnOBuY9cTKVqB5cfbynpvFgeHRTREkRk8C977oFu4=",
        version = "v0.0.0-20170104182250-a601269ab70c",
    )
    go_repository(
        name = "com_github_dgryski_go_farm",
        build_file_proto_mode = "disable",
        importpath = "github.com/dgryski/go-farm",
        sum = "h1:tdlZCpZ/P9DhczCTSixgIKmwPv6+wP5DGjqLYw5SUiA=",
        version = "v0.0.0-20190423205320-6a90982ecee2",
    )
    go_repository(
        name = "com_github_dnaeon_go_vcr",
        build_file_proto_mode = "disable",
        importpath = "github.com/dnaeon/go-vcr",
        sum = "h1:r8L/HqC0Hje5AXMu1ooW8oyQyOFv4GxqpL0nRP7SLLY=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_docker_distribution",
        build_file_proto_mode = "disable",
        importpath = "github.com/docker/distribution",
        sum = "h1:WhVldn4LROIhMl7x0YV7HHlLSgucXkeKBU2Wqr9yj9E=",
        version = "v0.0.0-20201029003056-f5cdc24dd3d8",
    )
    go_repository(
        name = "com_github_docker_go_events",
        build_file_proto_mode = "disable",
        importpath = "github.com/docker/go-events",
        sum = "h1:+pKlWGMw7gf6bQ+oDZB4KHQFypsfjYlq/C4rfL7D3g8=",
        version = "v0.0.0-20190806004212-e31b211e4f1c",
    )
    go_repository(
        name = "com_github_docker_go_metrics",
        build_file_proto_mode = "disable",
        importpath = "github.com/docker/go-metrics",
        sum = "h1:AgB/0SvBxihN0X8OR4SjsblXkbMvalQ8cjmtKQ2rQV8=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_docker_libtrust",
        build_file_proto_mode = "disable",
        importpath = "github.com/docker/libtrust",
        sum = "h1:ZClxb8laGDf5arXfYcAtECDFgAgHklGI8CxgjHnXKJ4=",
        version = "v0.0.0-20150114040149-fa567046d9b1",
    )
    go_repository(
        name = "com_github_dustin_go_humanize",
        build_file_proto_mode = "disable",
        importpath = "github.com/dustin/go-humanize",
        sum = "h1:VSnTsYCnlFHaM2/igO1h6X3HA71jcobQuxemgkq4zYo=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_elgris_jsondiff",
        build_file_proto_mode = "disable",
        importpath = "github.com/elgris/jsondiff",
        sum = "h1:QV0ZrfBLpFc2KDk+a4LJefDczXnonRwrYrQJY/9L4dA=",
        version = "v0.0.0-20160530203242-765b5c24c302",
    )
    go_repository(
        name = "com_github_envoyproxy_go_control_plane",
        build_file_proto_mode = "disable",
        importpath = "github.com/envoyproxy/go-control-plane",
        sum = "h1:rEvIZUSZ3fx39WIi3JkQqQBitGwpELBIYWeBVh6wn+E=",
        version = "v0.9.4",
    )
    go_repository(
        name = "com_github_envoyproxy_protoc_gen_validate",
        build_file_proto_mode = "disable",
        importpath = "github.com/envoyproxy/protoc-gen-validate",
        sum = "h1:EQciDnbrYxy13PgWoY8AqoxGiPrpgBZ1R8UNe3ddc+A=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_facebookgo_atomicfile",
        build_file_proto_mode = "disable",
        importpath = "github.com/facebookgo/atomicfile",
        sum = "h1:BBso6MBKW8ncyZLv37o+KNyy0HrrHgfnOaGQC2qvN+A=",
        version = "v0.0.0-20151019160806-2de1f203e7d5",
    )
    go_repository(
        name = "com_github_fatih_color",
        build_file_proto_mode = "disable",
        importpath = "github.com/fatih/color",
        sum = "h1:8xPHl4/q1VyqGIPif1F+1V3Y3lSmrq01EabUW3CoW5s=",
        version = "v1.9.0",
    )
    go_repository(
        name = "com_github_fd_go_nat",
        build_file_proto_mode = "disable",
        importpath = "github.com/fd/go-nat",
        sum = "h1:DPyQ97sxA9ThrWYRPcWUz/z9TnpTIGRYODIQc/dy64M=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_flynn_go_shlex",
        build_file_proto_mode = "disable",
        importpath = "github.com/flynn/go-shlex",
        sum = "h1:BHsljHzVlRcyQhjrss6TZTdY2VfCqZPbv5k3iBFa2ZQ=",
        version = "v0.0.0-20150515145356-3f9db97f8568",
    )
    go_repository(
        name = "com_github_flynn_noise",
        build_file_proto_mode = "disable",
        importpath = "github.com/flynn/noise",
        sum = "h1:u/UEqS66A5ckRmS4yNpjmVH56sVtS/RfclBAYocb4as=",
        version = "v0.0.0-20180327030543-2492fe189ae6",
    )
    go_repository(
        name = "com_github_francoispqt_gojay",
        build_file_proto_mode = "disable",
        importpath = "github.com/francoispqt/gojay",
        sum = "h1:d2m3sFjloqoIUQU3TsHBgj6qg/BVGlTBeHDUmyJnXKk=",
        version = "v1.2.13",
    )
    go_repository(
        name = "com_github_fsnotify_fsnotify",
        build_file_proto_mode = "disable",
        importpath = "github.com/fsnotify/fsnotify",
        sum = "h1:hsms1Qyu0jgnwNXIxa+/V/PDsU6CfLf6CNO8H7IWoS4=",
        version = "v1.4.9",
    )
    go_repository(
        name = "com_github_gabriel_vasile_mimetype",
        build_file_proto_mode = "disable",
        importpath = "github.com/gabriel-vasile/mimetype",
        sum = "h1:+ahX+MvQPFve4kO9Qjjxf3j49i0ACdV236kJlOCRAnU=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_garyburd_redigo",
        build_file_proto_mode = "disable",
        importpath = "github.com/garyburd/redigo",
        sum = "h1:LofdAjjjqCSXMwLGgOgnE+rdPuvX9DxCqaHwKy7i/ko=",
        version = "v0.0.0-20150301180006-535138d7bcd7",
    )
    go_repository(
        name = "com_github_ghodss_yaml",
        build_file_proto_mode = "disable",
        importpath = "github.com/ghodss/yaml",
        sum = "h1:wQHKEahhL6wmXdzwWG11gIVCkOv05bNOh+Rxn0yngAk=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_gliderlabs_ssh",
        build_file_proto_mode = "disable",
        importpath = "github.com/gliderlabs/ssh",
        sum = "h1:j3L6gSLQalDETeEg/Jg0mGY0/y/N6zI2xX1978P0Uqw=",
        version = "v0.1.1",
    )
    go_repository(
        name = "com_github_go_bindata_go_bindata_v3",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-bindata/go-bindata/v3",
        sum = "h1:F0nVttLC3ws0ojc7p60veTurcOm//D4QBODNM7EGrCI=",
        version = "v3.1.3",
    )
    go_repository(
        name = "com_github_go_check_check",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-check/check",
        sum = "h1:0gkP6mzaMqkmpcJYCFOLkIBwI7xFExG03bbkOkCvUPI=",
        version = "v0.0.0-20180628173108-788fd7840127",
    )
    go_repository(
        name = "com_github_go_errors_errors",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-errors/errors",
        sum = "h1:LUHzmkK3GUKUrL/1gfBUxAHzcev3apQlezX/+O7ma6w=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_go_gl_glfw",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-gl/glfw",
        sum = "h1:QbL/5oDUmRBzO9/Z7Seo6zf912W/a6Sr4Eu0G/3Jho0=",
        version = "v0.0.0-20190409004039-e6da0acd62b1",
    )
    go_repository(
        name = "com_github_go_gl_glfw_v3_3_glfw",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-gl/glfw/v3.3/glfw",
        sum = "h1:b+9H1GAsx5RsjvDFLoS5zkNBzIQMuVKUYQDmxU3N5XE=",
        version = "v0.0.0-20191125211704-12ad95a8df72",
    )
    go_repository(
        name = "com_github_go_kit_kit",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-kit/kit",
        sum = "h1:wDJmvq38kDhkVxi50ni9ykkdUr1PKgqKOoi01fa0Mdk=",
        version = "v0.9.0",
    )
    go_repository(
        name = "com_github_go_logfmt_logfmt",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-logfmt/logfmt",
        sum = "h1:MP4Eh7ZCb31lleYCFuwm0oe4/YGak+5l1vA2NOE80nA=",
        version = "v0.4.0",
    )
    go_repository(
        name = "com_github_go_sql_driver_mysql",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-sql-driver/mysql",
        sum = "h1:ozyZYNQW3x3HtqT1jira07DN2PArx2v7/mN66gGcHOs=",
        version = "v1.5.0",
    )
    go_repository(
        name = "com_github_go_stack_stack",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-stack/stack",
        sum = "h1:5SgMzNM5HxrEjV0ww2lTmX6E2Izsfxas4+YHWRs3Lsk=",
        version = "v1.8.0",
    )
    go_repository(
        name = "com_github_godbus_dbus_v5",
        build_file_proto_mode = "disable",
        importpath = "github.com/godbus/dbus/v5",
        sum = "h1:ZqHaoEF7TBzh4jzPmqVhE/5A1z9of6orkAe5uHoAeME=",
        version = "v5.0.3",
    )
    go_repository(
        name = "com_github_gogo_protobuf",
        build_file_proto_mode = "disable",
        importpath = "github.com/gogo/protobuf",
        sum = "h1:DqDEcV5aeaTmdFBePNpYsp3FlcVH/2ISVVM9Qf8PSls=",
        version = "v1.3.1",
    )
    go_repository(
        name = "com_github_golang_collections_go_datastructures",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang-collections/go-datastructures",
        sum = "h1:ZHJ7+IGpuOXtVf6Zk/a3WuHQgkC+vXwaqfUBDFwahtI=",
        version = "v0.0.0-20150211160725-59788d5eb259",
    )
    go_repository(
        name = "com_github_golang_glog",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/glog",
        sum = "h1:VKtxabqXZkF25pY9ekfRL6a582T4P37/31XEstQ5p58=",
        version = "v0.0.0-20160126235308-23def4e6c14b",
    )
    go_repository(
        name = "com_github_golang_groupcache",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/groupcache",
        sum = "h1:1r7pUrabqp18hOBcwBwiTsbnFeTZHV9eER/QT5JVZxY=",
        version = "v0.0.0-20200121045136-8c9f03a8e57e",
    )
    go_repository(
        name = "com_github_golang_lint",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/lint",
        sum = "h1:2hRPrmiwPrp3fQX967rNJIhQPtiGXdlQWAxKbKw3VHA=",
        version = "v0.0.0-20180702182130-06c8688daad7",
    )
    go_repository(
        name = "com_github_golang_mock",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/mock",
        sum = "h1:l75CXGRSwbaYNpl/Z2X1XIIAMSCquvXgpVZDhwEIJsc=",
        version = "v1.4.4",
    )
    go_repository(
        name = "com_github_golang_protobuf",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/protobuf",
        sum = "h1:+Z5KGCizgyZCbGh1KZqA0fcLLkwbsjIzS4aV2v7wJX0=",
        version = "v1.4.2",
    )
    go_repository(
        name = "com_github_golang_snappy",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/snappy",
        sum = "h1:Qgr9rKW7uDUkrbSmQeiDsGa8SjGyCOGtuasMWwvp2P4=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_google_btree",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/btree",
        sum = "h1:0udJVsspx3VBr5FwtLhQQtuAsVc79tTq0ocGIPAU6qo=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_google_go_cmp",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/go-cmp",
        sum = "h1:/QaMHBdZ26BB3SSst0Iwl10Epc+xhTquomWX0oZEB6w=",
        version = "v0.5.0",
    )
    go_repository(
        name = "com_github_google_go_github",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/go-github",
        sum = "h1:N0LgJ1j65A7kfXrZnUDaYCs/Sf4rEjNlfyDHW9dolSY=",
        version = "v17.0.0+incompatible",
    )
    go_repository(
        name = "com_github_google_go_querystring",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/go-querystring",
        sum = "h1:Xkwi/a1rcvNg1PPYe5vI8GbeBY/jrVuDX5ASuANWTrk=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_google_gofuzz",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/gofuzz",
        sum = "h1:A8PeW59pxE9IoFRqBp37U+mSNaQoZ46F1f0f863XSXw=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_google_gopacket",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/gopacket",
        sum = "h1:lum7VRA9kdlvBi7/v2p7/zcbkduHaCH/SVVyurs7OpY=",
        version = "v1.1.18",
    )
    go_repository(
        name = "com_github_google_martian",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/martian",
        sum = "h1:/CP5g8u/VJHijgedC/Legn3BAbAaWPgecwXBIDzw5no=",
        version = "v2.1.0+incompatible",
    )
    go_repository(
        name = "com_github_google_pprof",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/pprof",
        sum = "h1:TgXhFz35pKlZuUz1pNlOKk1UCSXPpuUIc144Wd7SxCA=",
        version = "v0.0.0-20200212024743-f11f1df84d12",
    )
    go_repository(
        name = "com_github_google_renameio",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/renameio",
        sum = "h1:GOZbcHa3HfsPKPlmyPyN2KEohoMXOhdMbHrvbpl2QaA=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_google_uuid",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/uuid",
        sum = "h1:Gkbcsh/GbpXz7lPftLA3P6TYMwjCLYm83jiFQZF/3gY=",
        version = "v1.1.1",
    )
    go_repository(
        name = "com_github_googleapis_gax_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/googleapis/gax-go",
        sum = "h1:j0GKcs05QVmm7yesiZq2+9cxHkNK9YM6zKx4D2qucQU=",
        version = "v2.0.0+incompatible",
    )
    go_repository(
        name = "com_github_googleapis_gax_go_v2",
        build_file_proto_mode = "disable",
        importpath = "github.com/googleapis/gax-go/v2",
        sum = "h1:sjZBwGj9Jlw33ImPtvFviGYvseOtDM7hkSKB7+Tv3SM=",
        version = "v2.0.5",
    )
    go_repository(
        name = "com_github_gopherjs_gopherjs",
        build_file_proto_mode = "disable",
        importpath = "github.com/gopherjs/gopherjs",
        sum = "h1:7lF+Vz0LqiRidnzC1Oq86fpX1q/iEv2KJdrCtttYjT4=",
        version = "v0.0.0-20190430165422-3e4dfb77656c",
    )
    go_repository(
        name = "com_github_gorilla_handlers",
        build_file_proto_mode = "disable",
        importpath = "github.com/gorilla/handlers",
        sum = "h1:893HsJqtxp9z1SF76gg6hY70hRY1wVlTSnC/h1yUDCo=",
        version = "v0.0.0-20150720190736-60c7bfde3e33",
    )
    go_repository(
        name = "com_github_gorilla_mux",
        build_file_proto_mode = "disable",
        importpath = "github.com/gorilla/mux",
        sum = "h1:gnP5JzjVOuiZD07fKKToCAOjS0yOpj/qPETTXCCS6hw=",
        version = "v1.7.3",
    )
    go_repository(
        name = "com_github_gorilla_websocket",
        build_file_proto_mode = "disable",
        importpath = "github.com/gorilla/websocket",
        sum = "h1:+/TMaTYc4QFitKJxsQ7Yye35DkWvkdLcvGKqM+x0Ufc=",
        version = "v1.4.2",
    )
    go_repository(
        name = "com_github_gregjones_httpcache",
        build_file_proto_mode = "disable",
        importpath = "github.com/gregjones/httpcache",
        sum = "h1:pdN6V1QBWetyv/0+wjACpqVH+eVULgEjkurDLq3goeM=",
        version = "v0.0.0-20180305231024-9cad4c3443a7",
    )
    go_repository(
        name = "com_github_grpc_ecosystem_grpc_gateway",
        build_file_proto_mode = "disable",
        importpath = "github.com/grpc-ecosystem/grpc-gateway",
        sum = "h1:WcmKMm43DR7RdtlkEXQJyo5ws8iTp98CyhCCbOHMvNI=",
        version = "v1.5.0",
    )
    go_repository(
        name = "com_github_gxed_go_shellwords",
        build_file_proto_mode = "disable",
        importpath = "github.com/gxed/go-shellwords",
        sum = "h1:2TP32H4TAklZUdz84oj95BJhVnIrRasyx2j1cqH5K38=",
        version = "v1.0.3",
    )
    go_repository(
        name = "com_github_gxed_hashland_keccakpg",
        build_file_proto_mode = "disable",
        importpath = "github.com/gxed/hashland/keccakpg",
        sum = "h1:wrk3uMNaMxbXiHibbPO4S0ymqJMm41WiudyFSs7UnsU=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_gxed_hashland_murmur3",
        build_file_proto_mode = "disable",
        importpath = "github.com/gxed/hashland/murmur3",
        sum = "h1:SheiaIt0sda5K+8FLz952/1iWS9zrnKsEJaOJu4ZbSc=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_gxed_pubsub",
        build_file_proto_mode = "disable",
        importpath = "github.com/gxed/pubsub",
        sum = "h1:TF4mX7zXpeyz/xintezebSa7ZDxAGBnqDwcoobvaz2o=",
        version = "v0.0.0-20180201040156-26ebdf44f824",
    )
    go_repository(
        name = "com_github_hashicorp_errwrap",
        build_file_proto_mode = "disable",
        importpath = "github.com/hashicorp/errwrap",
        sum = "h1:hLrqtEDnRye3+sgx6z4qVLNuviH3MR5aQ0ykNJa/UYA=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_hashicorp_go_multierror",
        build_file_proto_mode = "disable",
        importpath = "github.com/hashicorp/go-multierror",
        sum = "h1:B9UzwGQJehnUY1yNrnwREHc3fGbC2xefo8g4TbElacI=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_hashicorp_golang_lru",
        build_file_proto_mode = "disable",
        importpath = "github.com/hashicorp/golang-lru",
        sum = "h1:YDjusn29QI/Das2iO9M0BHnIbxPeyuCHsjMW+lJfyTc=",
        version = "v0.5.4",
    )
    go_repository(
        name = "com_github_hashicorp_hcl",
        build_file_proto_mode = "disable",
        importpath = "github.com/hashicorp/hcl",
        sum = "h1:0Anlzjpi4vEasTeNFn2mLJgTSwt0+6sfsiTG8qcWGx4=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_hpcloud_tail",
        build_file_proto_mode = "disable",
        importpath = "github.com/hpcloud/tail",
        sum = "h1:nfCOvKYfkgYP8hkirhJocXT2+zOD8yUNjXaWfTlyFKI=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_huin_goupnp",
        build_file_proto_mode = "disable",
        importpath = "github.com/huin/goupnp",
        sum = "h1:wg75sLpL6DZqwHQN6E1Cfk6mtfzS45z8OV+ic+DtHRo=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_huin_goutil",
        build_file_proto_mode = "disable",
        importpath = "github.com/huin/goutil",
        sum = "h1:vlNjIqmUZ9CMAWsbURYl3a6wZbw7q5RHVvlXTNS/Bs8=",
        version = "v0.0.0-20170803182201-1ca381bf3150",
    )
    go_repository(
        name = "com_github_iancoleman_orderedmap",
        build_file_proto_mode = "disable",
        importpath = "github.com/iancoleman/orderedmap",
        sum = "h1:i462o439ZjprVSFSZLZxcsoAe592sZB1rci2Z8j4wdk=",
        version = "v0.0.0-20190318233801-ac98e3ecb4b0",
    )
    go_repository(
        name = "com_github_ianlancetaylor_demangle",
        build_file_proto_mode = "disable",
        importpath = "github.com/ianlancetaylor/demangle",
        sum = "h1:UDMh68UUwekSh5iP2OMhRRZJiiBccgV7axzUG8vi56c=",
        version = "v0.0.0-20181102032728-5e5cf60278f6",
    )
    go_repository(
        name = "com_github_inconshreveable_mousetrap",
        build_file_proto_mode = "disable",
        importpath = "github.com/inconshreveable/mousetrap",
        sum = "h1:Z8tu5sraLXCXIcARxBp/8cbvlwVa7Z1NHg9XEKhtSvM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_ipfs_bbloom",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/bbloom",
        sum = "h1:Gi+8EGJ2y5qiD5FbsbpX/TMNcJw8gSqr7eyjHa4Fhvs=",
        version = "v0.0.4",
    )
    go_repository(
        name = "com_github_ipfs_go_bitswap",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-bitswap",
        sum = "h1:EhgRz8gqWQIBADY9gpqJOrfs5E1MtVfQFy1Vq8Z+Fq8=",
        version = "v0.2.19",
    )
    go_repository(
        name = "com_github_ipfs_go_block_format",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-block-format",
        sum = "h1:qPDvcP19izTjU8rgo6p7gTXZlkMkF5bz5G3fqIsSCPE=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_ipfs_go_blockservice",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-blockservice",
        sum = "h1:9XgsPMwwWJSC9uVr2pMDsW2qFTBSkxpGMhmna8mIjPM=",
        version = "v0.1.3",
    )
    go_repository(
        name = "com_github_ipfs_go_cid",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-cid",
        sum = "h1:ysQJVJA3fNDF1qigJbsSQOdjhVLsOEoPdh0+R97k3jY=",
        version = "v0.0.7",
    )
    go_repository(
        name = "com_github_ipfs_go_cidutil",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-cidutil",
        sum = "h1:CNOboQf1t7Qp0nuNh8QMmhJs0+Q//bRL1axtCnIB1Yo=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_ipfs_go_datastore",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-datastore",
        sum = "h1:rjvQ9+muFaJ+QZ7dN5B1MSDNQ0JVZKkkES/rMZmA8X8=",
        version = "v0.4.4",
    )
    go_repository(
        name = "com_github_ipfs_go_detect_race",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-detect-race",
        sum = "h1:qX/xay2W3E4Q1U7d9lNs1sU9nvguX0a7319XbyQ6cOk=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ds_badger",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ds-badger",
        sum = "h1:UPGB0y7luFHk+mY/tUZrif/272M8o+hFsW+avLUeWrM=",
        version = "v0.2.4",
    )
    go_repository(
        name = "com_github_ipfs_go_ds_flatfs",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ds-flatfs",
        sum = "h1:DmGZ4qOYQLNgu8Mltuz1DtUHpm+BjWMcVN3F3H3VJzQ=",
        version = "v0.4.4",
    )
    go_repository(
        name = "com_github_ipfs_go_ds_leveldb",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ds-leveldb",
        sum = "h1:QmQoAJ9WkPMUfBLnu1sBVy0xWWlJPg0m4kRAiJL9iaw=",
        version = "v0.4.2",
    )
    go_repository(
        name = "com_github_ipfs_go_ds_measure",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ds-measure",
        sum = "h1:vE4TyY4aeLeVgnnPBC5QzKIjKrqzha0NCujTfgvVbVQ=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_ipfs_go_filestore",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-filestore",
        sum = "h1:MhZ1jT5K3NewZwim6rS/akcJLm1xM+r6nz6foeB9EwE=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_ipfs_go_fs_lock",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-fs-lock",
        sum = "h1:nlKE27N7hlvsTXT3CSDkM6KRqgXpnaDjvyCHjAiZyK8=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_ipfs_go_graphsync",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-graphsync",
        sum = "h1:5U9iC58JgYfUSZI55oRXe22Cj6Ln0Xjd5VF4Eoo3foc=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs",
        sum = "h1:pRIIjnHL8cnRHvePPUSUoWD02xVniPXczk0PcFOu59g=",
        version = "v0.6.0",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_api",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-api",
        sum = "h1:BXRctUU8YOUOQT/jW1s56d9wLa85ntOqK6bptvCKb8c=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_blockstore",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-blockstore",
        sum = "h1:2SGI6U1B44aODevza8Rde3+dY30Pb+lbcObe1LETxOQ=",
        version = "v0.1.4",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_blocksutil",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-blocksutil",
        sum = "h1:Eh/H4pc1hsvhzsQoMEP3Bke/aW5P5rVM1IWFJMcGIPQ=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_chunker",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-chunker",
        sum = "h1:ojCf7HV/m+uS2vhUGWcogIIxiO5ubl5O57Q7NapWLY8=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_cmds",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-cmds",
        sum = "h1:mi9oYrSCox5aBhutqAYqw6/9crlyGbw4E/aJtwS4zI4=",
        version = "v0.3.0",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_config",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-config",
        sum = "h1:4Tc7DC3dz4e7VadOjxXxFQGTQ1g7EYZClJ/ih8qOrxE=",
        version = "v0.8.0",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_delay",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-delay",
        sum = "h1:r/UXYyRcddO6thwOnhiznIAiSvxMECGgtv35Xs1IeRQ=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_ds_help",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-ds-help",
        sum = "h1:IW/bXGeaAZV2VH0Kuok+Ohva/zHkHmeLFBxC1k7mNPc=",
        version = "v0.1.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_exchange_interface",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-exchange-interface",
        sum = "h1:LJXIo9W7CAmugqI+uofioIpRb6rY30GUu7G6LUfpMvM=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_exchange_offline",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-exchange-offline",
        sum = "h1:P56jYKZF7lDDOLx5SotVh5KFxoY6C81I1NSHW1FxGew=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_files",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-files",
        sum = "h1:8o0oFJkJ8UkO/ABl8T6ac6tKF3+NIpj67aAB6ZpusRg=",
        version = "v0.0.8",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_flags",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-flags",
        sum = "h1:OH5cEkJYL0QgA+bvD55TNG9ud8HA2Nqaav47b2c/UJk=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_http_client",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-http-client",
        sum = "h1:YrJ+/vqmZF1ignpxfHUaJEax7e4tgbaFCTLfIS5yFZY=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_pinner",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-pinner",
        sum = "h1:EmxhS3vDsCK/rZrsgxX0Le9m2drBcGlUd7ah/VyFYVE=",
        version = "v0.0.4",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_posinfo",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-posinfo",
        sum = "h1:Esoxj+1JgSjX0+ylc0hUmJCOv6V2vFoZiETLR6OtpRs=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_pq",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-pq",
        sum = "h1:e1vOOW6MuOwG2lqxcLA+wEn93i/9laCY8sXAw76jFOY=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_provider",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-provider",
        sum = "h1:k54OHXZcFBkhL6l3GnPS9PfpaLeLqZjVASG1bgfBdfQ=",
        version = "v0.4.3",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_routing",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-routing",
        sum = "h1:gAJTT1cEeeLj6/DlLX6t+NxD9fQe2ymTO6qWRDI/HQQ=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_ipfs_go_ipfs_util",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipfs-util",
        sum = "h1:59Sswnk1MFaiq+VcaknX7aYEyGyGDAA73ilhEK2POp8=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_ipfs_go_ipld_cbor",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipld-cbor",
        sum = "h1:Aw3KPOKXjvrm6VjwJvFf1F1ekR/BH3jdof3Bk7OTiSA=",
        version = "v0.0.4",
    )
    go_repository(
        name = "com_github_ipfs_go_ipld_format",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipld-format",
        sum = "h1:xGlJKkArkmBvowr+GMCX0FEZtkro71K1AwiKnL37mwA=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_ipfs_go_ipld_git",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipld-git",
        sum = "h1:/YjkjCyo5KYRpW+suby8Xh9Cm/iH9dAgGV6qyZ1dGus=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_ipfs_go_ipns",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-ipns",
        sum = "h1:oq4ErrV4hNQ2Eim257RTYRgfOSV/s8BDaf9iIl4NwFs=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_ipfs_go_log",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-log",
        sum = "h1:6nLQdX4W8P9yZZFH7mO+X/PzjN8Laozm/lMJ6esdgzY=",
        version = "v1.0.4",
    )
    go_repository(
        name = "com_github_ipfs_go_log_v2",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-log/v2",
        sum = "h1:G4TtqN+V9y9HY9TA6BwbCVyyBZ2B9MbCjR2MtGx8FR0=",
        version = "v2.1.1",
    )
    go_repository(
        name = "com_github_ipfs_go_merkledag",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-merkledag",
        sum = "h1:MRqj40QkrWkvPswXs4EfSslhZ4RVPRbxwX11js0t1xY=",
        version = "v0.3.2",
    )
    go_repository(
        name = "com_github_ipfs_go_metrics_interface",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-metrics-interface",
        sum = "h1:j+cpbjYvu4R8zbleSs36gvB7jR+wsL2fGD6n0jO4kdg=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_metrics_prometheus",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-metrics-prometheus",
        sum = "h1:9i2iljLg12S78OhC6UAiXi176xvQGiZaGVF1CUVdE+s=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_ipfs_go_mfs",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-mfs",
        sum = "h1:DlelNSmH+yz/Riy0RjPKlooPg0KML4lXGdLw7uZkfAg=",
        version = "v0.1.2",
    )
    go_repository(
        name = "com_github_ipfs_go_path",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-path",
        sum = "h1:H06hKMquQ0aYtHiHryOMLpQC1qC3QwXwkahcEVD51Ho=",
        version = "v0.0.7",
    )
    go_repository(
        name = "com_github_ipfs_go_peertaskqueue",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-peertaskqueue",
        sum = "h1:2cSr7exUGKYyDeUyQ7P/nHPs9P7Ht/B+ROrpN1EJOjc=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_ipfs_go_todocounter",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-todocounter",
        sum = "h1:kITWA5ZcQZfrUnDNkRn04Xzh0YFaDFXsoO2A81Eb6Lw=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_go_unixfs",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-unixfs",
        sum = "h1:6NwppOXefWIyysZ4LR/qUBPvXd5//8J3jiMdvpbw6Lo=",
        version = "v0.2.4",
    )
    go_repository(
        name = "com_github_ipfs_go_verifcid",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/go-verifcid",
        sum = "h1:m2HI7zIuR5TFyQ1b79Da5N9dnnCP1vcu2QqawmWlK2E=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_ipfs_interface_go_ipfs_core",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/interface-go-ipfs-core",
        sum = "h1:+mUiamyHIwedqP8ZgbCIwpy40oX7QcXUbo4CZOeJVJg=",
        version = "v0.4.0",
    )
    go_repository(
        name = "com_github_ipfs_iptb",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/iptb",
        sum = "h1:YFYTrCkLMRwk/35IMyC6+yjoQSHTEcNcefBStLJzgvo=",
        version = "v1.4.0",
    )
    go_repository(
        name = "com_github_ipfs_iptb_plugins",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipfs/iptb-plugins",
        sum = "h1:C1rpq1o5lUZtaAOkLIox5akh6ba4uk/3RwWc6ttVxw0=",
        version = "v0.3.0",
    )
    go_repository(
        name = "com_github_ipld_go_car",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipld/go-car",
        sum = "h1:AaIEA5ITRnFA68uMyuIPYGM2XXllxsu8sNjFJP797us=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_ipld_go_ipld_prime",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipld/go-ipld-prime",
        sum = "h1:fASnkvtR+SmB2y453RxmDD3Uvd4LonVUgFGk9JoDaZs=",
        version = "v0.0.2-0.20191108012745-28a82f04c785",
    )
    go_repository(
        name = "com_github_ipld_go_ipld_prime_proto",
        build_file_proto_mode = "disable",
        importpath = "github.com/ipld/go-ipld-prime-proto",
        sum = "h1:lSip43rAdyGA+yRQuy6ju0ucZkWpYc1F2CTQtZTVW/4=",
        version = "v0.0.0-20191113031812-e32bd156a1e5",
    )
    go_repository(
        name = "com_github_jackpal_gateway",
        build_file_proto_mode = "disable",
        importpath = "github.com/jackpal/gateway",
        sum = "h1:qzXWUJfuMdlLMtt0a3Dgt+xkWQiA5itDEITVJtuSwMc=",
        version = "v1.0.5",
    )
    go_repository(
        name = "com_github_jackpal_go_nat_pmp",
        build_file_proto_mode = "disable",
        importpath = "github.com/jackpal/go-nat-pmp",
        sum = "h1:KzKSgb7qkJvOUTqYl9/Hg/me3pWgBmERKrTGD7BdWus=",
        version = "v1.0.2",
    )
    go_repository(
        name = "com_github_jbenet_go_cienv",
        build_file_proto_mode = "disable",
        importpath = "github.com/jbenet/go-cienv",
        sum = "h1:Vc/s0QbQtoxX8MwwSLWWh+xNNZvM3Lw7NsTcHrvvhMc=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_jbenet_go_is_domain",
        build_file_proto_mode = "disable",
        importpath = "github.com/jbenet/go-is-domain",
        sum = "h1:r92uiHbMEJo9Fkey5pMBtZAzjPQWic0ieo7Jw1jEuQQ=",
        version = "v1.0.5",
    )
    go_repository(
        name = "com_github_jbenet_go_random",
        build_file_proto_mode = "disable",
        importpath = "github.com/jbenet/go-random",
        sum = "h1:uUx61FiAa1GI6ZmVd2wf2vULeQZIKG66eybjNXKYCz4=",
        version = "v0.0.0-20190219211222-123a90aedc0c",
    )
    go_repository(
        name = "com_github_jbenet_go_temp_err_catcher",
        build_file_proto_mode = "disable",
        importpath = "github.com/jbenet/go-temp-err-catcher",
        sum = "h1:zpb3ZH6wIE8Shj2sKS+khgRvf7T7RABoLk/+KKHggpk=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_jbenet_goprocess",
        build_file_proto_mode = "disable",
        importpath = "github.com/jbenet/goprocess",
        sum = "h1:DRGOFReOMqqDNXwW70QkacFW0YN9QnwLV0Vqk+3oU0o=",
        version = "v0.1.4",
    )
    go_repository(
        name = "com_github_jellevandenhooff_dkim",
        build_file_proto_mode = "disable",
        importpath = "github.com/jellevandenhooff/dkim",
        sum = "h1:ujPKutqRlJtcfWk6toYVYagwra7HQHbXOaS171b4Tg8=",
        version = "v0.0.0-20150330215556-f50fe3d243e1",
    )
    go_repository(
        name = "com_github_jessevdk_go_flags",
        build_file_proto_mode = "disable",
        importpath = "github.com/jessevdk/go-flags",
        sum = "h1:4IU2WS7AumrZ/40jfhf4QVDMsQwqA7VEHozFRrGARJA=",
        version = "v1.4.0",
    )
    go_repository(
        name = "com_github_jmespath_go_jmespath",
        build_file_proto_mode = "disable",
        importpath = "github.com/jmespath/go-jmespath",
        sum = "h1:BEgLn5cpjn8UN1mAw4NjwDrS35OdebyEtFe+9YPoQUg=",
        version = "v0.4.0",
    )
    go_repository(
        name = "com_github_jmespath_go_jmespath_internal_testify",
        build_file_proto_mode = "disable",
        importpath = "github.com/jmespath/go-jmespath/internal/testify",
        sum = "h1:shLQSRRSCCPj3f2gpwzGwWFoC7ycTf1rcQZHOlsJ6N8=",
        version = "v1.5.1",
    )
    go_repository(
        name = "com_github_jrick_logrotate",
        build_file_proto_mode = "disable",
        importpath = "github.com/jrick/logrotate",
        sum = "h1:lQ1bL/n9mBNeIXoTUoYRlK4dHuNJVofX9oWqBtPnSzI=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_json_iterator_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/json-iterator/go",
        sum = "h1:9yzud/Ht36ygwatGx56VwCZtlI/2AD15T1X2sjSuGns=",
        version = "v1.1.9",
    )
    go_repository(
        name = "com_github_jstemmer_go_junit_report",
        build_file_proto_mode = "disable",
        importpath = "github.com/jstemmer/go-junit-report",
        sum = "h1:6QPYqodiu3GuPL+7mfx+NwDdp2eTkp9IfEUpgAwUN0o=",
        version = "v0.9.1",
    )
    go_repository(
        name = "com_github_jtolds_gls",
        build_file_proto_mode = "disable",
        importpath = "github.com/jtolds/gls",
        sum = "h1:xdiiI2gbIgH/gLH7ADydsJ1uDOEzR8yvV7C0MuV77Wo=",
        version = "v4.20.0+incompatible",
    )
    go_repository(
        name = "com_github_julienschmidt_httprouter",
        build_file_proto_mode = "disable",
        importpath = "github.com/julienschmidt/httprouter",
        sum = "h1:TDTW5Yz1mjftljbcKqRcrYhd4XeOoI98t+9HbQbYf7g=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_kami_zh_go_capturer",
        build_file_proto_mode = "disable",
        importpath = "github.com/kami-zh/go-capturer",
        sum = "h1:cVtBfNW5XTHiKQe7jDaDBSh/EVM4XLPutLAGboIXuM0=",
        version = "v0.0.0-20171211120116-e492ea43421d",
    )
    go_repository(
        name = "com_github_kisielk_errcheck",
        build_file_proto_mode = "disable",
        importpath = "github.com/kisielk/errcheck",
        sum = "h1:reN85Pxc5larApoH1keMBiu2GWtPqXQ1nc9gx+jOU+E=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_kisielk_gotool",
        build_file_proto_mode = "disable",
        importpath = "github.com/kisielk/gotool",
        sum = "h1:AV2c/EiW3KqPNT9ZKl07ehoAGi4C5/01Cfbblndcapg=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_kkdai_bstream",
        build_file_proto_mode = "disable",
        importpath = "github.com/kkdai/bstream",
        sum = "h1:FOOIBWrEkLgmlgGfMuZT83xIwfPDxEI2OHu6xUmJMFE=",
        version = "v0.0.0-20161212061736-f391b8402d23",
    )
    go_repository(
        name = "com_github_konsorten_go_windows_terminal_sequences",
        build_file_proto_mode = "disable",
        importpath = "github.com/konsorten/go-windows-terminal-sequences",
        sum = "h1:CE8S1cTafDpPvMhIxNJKvHsGVBgn1xWYf1NbHQhywc8=",
        version = "v1.0.3",
    )
    go_repository(
        name = "com_github_koron_go_ssdp",
        build_file_proto_mode = "disable",
        importpath = "github.com/koron/go-ssdp",
        sum = "h1:68u9r4wEvL3gYg2jvAOgROwZ3H+Y3hIDk4tbbmIjcYQ=",
        version = "v0.0.0-20191105050749-2e1c40ed0b5d",
    )
    go_repository(
        name = "com_github_kr_logfmt",
        build_file_proto_mode = "disable",
        importpath = "github.com/kr/logfmt",
        sum = "h1:T+h1c/A9Gawja4Y9mFVWj2vyii2bbUNDw3kt9VxK2EY=",
        version = "v0.0.0-20140226030751-b84e30acd515",
    )
    go_repository(
        name = "com_github_kr_pretty",
        build_file_proto_mode = "disable",
        importpath = "github.com/kr/pretty",
        sum = "h1:s5hAObm+yFO5uHYt5dYjxi2rXrsnmRpJx4OYvIWUaQs=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_kr_pty",
        build_file_proto_mode = "disable",
        importpath = "github.com/kr/pty",
        sum = "h1:/Um6a/ZmD5tF7peoOJ5oN5KMQ0DrGVQSXLNwyckutPk=",
        version = "v1.1.3",
    )
    go_repository(
        name = "com_github_kr_text",
        build_file_proto_mode = "disable",
        importpath = "github.com/kr/text",
        sum = "h1:45sCR5RtlFHMR4UwH9sdQ5TC8v0qDQCHnXt+kaKSTVE=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_kubuxu_go_os_helper",
        build_file_proto_mode = "disable",
        importpath = "github.com/Kubuxu/go-os-helper",
        sum = "h1:EJiD2VUQyh5A9hWJLmc6iWg6yIcJ7jpBcwC8GMGXfDk=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_libp2p_go_addr_util",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-addr-util",
        sum = "h1:7cWK5cdA5x72jX0g8iLrQWm5TRJZ6CzGdPEhWj7plWU=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_libp2p_go_buffer_pool",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-buffer-pool",
        sum = "h1:QNK2iAFa8gjAe1SPz6mHSMuCcjs+X1wlHzeOSqcmlfs=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_libp2p_go_conn_security",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-conn-security",
        sum = "h1:4kMMrqrt9EUNCNjX1xagSJC+bq16uqjMe9lk1KBMVNs=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_libp2p_go_conn_security_multistream",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-conn-security-multistream",
        sum = "h1:uNiDjS58vrvJTg9jO6bySd1rMKejieG7v45ekqHbZ1M=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_libp2p_go_eventbus",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-eventbus",
        sum = "h1:VanAdErQnpTioN2TowqNcOijf6YwhuODe4pPKSDpxGc=",
        version = "v0.2.1",
    )
    go_repository(
        name = "com_github_libp2p_go_flow_metrics",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-flow-metrics",
        sum = "h1:8tAs/hSdNvUiLgtlSy3mxwxWP4I9y/jlkPFT7epKdeM=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p",
        sum = "h1:VQOo/Pbj9Ijco9jiMYN5ImAg236IjTXfnUPJ2OvbpLM=",
        version = "v0.10.2",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_autonat",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-autonat",
        sum = "h1:60sc3NuQz+RxEb4ZVCRp/7uPtD7gnlLcOIKYNulzSIo=",
        version = "v0.3.1",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_autonat_svc",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-autonat-svc",
        sum = "h1:28IM7iWMDclZeVkpiFQaWVANwXwE7zLlpbnS7yXxrfs=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_blankhost",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-blankhost",
        sum = "h1:3EsGAi0CBGcZ33GwRuXEYJLLPoVWyXJ1bcJzAJjINkk=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_circuit",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-circuit",
        sum = "h1:69ENDoGnNN45BNDnBd+8SXSetDuw0eJFcGmOvvtOgBw=",
        version = "v0.3.1",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_connmgr",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-connmgr",
        sum = "h1:TMS0vc0TCBomtQJyWr7fYxcVYYhx+q/2gF++G5Jkl/w=",
        version = "v0.2.4",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_core",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-core",
        sum = "h1:XS+Goh+QegCDojUZp00CaPMfiEADCrLjNZskWE7pvqs=",
        version = "v0.6.1",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_crypto",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-crypto",
        sum = "h1:k9MFy+o2zGDNGsaoZl0MA3iZ75qXxr9OOoAZF+sD5OQ=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_daemon",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-daemon",
        sum = "h1:qKcrv0c4XEcdV9LzY+2IDUxS8xMsTVzxUD1K3i1Bdgg=",
        version = "v0.2.2",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_discovery",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-discovery",
        sum = "h1:Qfl+e5+lfDgwdrXdu4YNCWyEo3fWuP+WgN9mN0iWviQ=",
        version = "v0.5.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_gostream",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-gostream",
        sum = "h1:JjA9roGokaR2BgWmaI/3HQu1/+jSbVVDLatQGnVdGjI=",
        version = "v0.2.1",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_host",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-host",
        sum = "h1:BB/1Z+4X0rjKP5lbQTmjEjLbDVbrcmLOlA6QDsN5/j4=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_http",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-http",
        sum = "h1:FfLnzjlEzV4/6UCXCpPXRYZNoGCfogqCFjd7eF0Jbm8=",
        version = "v0.1.5",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_interface_connmgr",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-interface-connmgr",
        sum = "h1:KG/KNYL2tYzXAfMvQN5K1aAGTYSYUMJ1prgYa2/JI1E=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_interface_pnet",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-interface-pnet",
        sum = "h1:7GnzRrBTJHEsofi1ahFdPN9Si6skwXQE9UqR2S+Pkh8=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_kad_dht",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-kad-dht",
        sum = "h1:ceK5ML6s/I8UAcw6veoNsuEHdHvfo88leU/5uWOIFWs=",
        version = "v0.8.3",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_kbucket",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-kbucket",
        sum = "h1:wg+VPpCtY61bCasGRexCuXOmEmdKjN+k1w+JtTwu9gA=",
        version = "v0.4.2",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_loggables",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-loggables",
        sum = "h1:h3w8QFfCt2UJl/0/NW4K829HX/0S4KD31PQ7m8UXXO8=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_metrics",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-metrics",
        sum = "h1:yumdPC/P2VzINdmcKZd0pciSUCpou+s0lwYCjBbzQZU=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_mplex",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-mplex",
        sum = "h1:XFFXaN4jhqnIuJVjYOR3k6bnRj0mFfJOlIuDVww+4Zo=",
        version = "v0.2.4",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_nat",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-nat",
        sum = "h1:wMWis3kYynCbHoyKLPBEMu4YRLltbm8Mk08HGSfvTkU=",
        version = "v0.0.6",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_net",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-net",
        sum = "h1:qP06u4TYXfl7uW/hzqPhlVVTSA2nw1B/bHBJaUnbh6M=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_netutil",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-netutil",
        sum = "h1:zscYDNVEcGxyUpMd0JReUZTrpMfia8PmLKcKF72EAMQ=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_noise",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-noise",
        sum = "h1:vqYQWvnIcHpIoWJKC7Al4D6Hgj0H012TuXRhPwSMGpQ=",
        version = "v0.1.1",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_peer",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-peer",
        sum = "h1:EQ8kMjaCUwt/Y5uLgjT8iY2qg0mGUT0N1zUjer50DsY=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_peerstore",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-peerstore",
        sum = "h1:2ACefBX23iMdJU9Ke+dcXt3w86MIryes9v7In4+Qq3U=",
        version = "v0.2.6",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_pnet",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-pnet",
        sum = "h1:J6htxttBipJujEjz1y0a5+eYoiPcFHhSYHH6na5f0/k=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_protocol",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-protocol",
        sum = "h1:HdqhEyhg0ToCaxgMhnOmUO8snQtt/kQlcjVk3UoJU3c=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_pubsub",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-pubsub",
        sum = "h1:/AzOAmjDc+IJWybEzhYj1UaV1HErqmo4v3pQVepbgi8=",
        version = "v0.3.3",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_pubsub_router",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-pubsub-router",
        sum = "h1:ghpHApTMXN+aZ+InYvpJa/ckBW4orypzNI0aWQDth3s=",
        version = "v0.3.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_quic_transport",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-quic-transport",
        sum = "h1:mHA94K2+TD0e9XtjWx/P5jGGZn0GdQ4OFYwNllagv4E=",
        version = "v0.8.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_record",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-record",
        sum = "h1:R27hoScIhQf/A8XJZ8lYpnqh9LatJ5YbHs28kCIfql0=",
        version = "v0.1.3",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_routing",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-routing",
        sum = "h1:hFnj3WR3E2tOcKaGpyzfP4gvFZ3t8JkQmbapN0Ct+oU=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_routing_helpers",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-routing-helpers",
        sum = "h1:xY61alxJ6PurSi+MXbywZpelvuU4U4p/gPTxjqCqTzY=",
        version = "v0.2.3",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_secio",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-secio",
        sum = "h1:rLLPvShPQAcY6eNurKNZq3eZjPWfU9kXF2eI9jIYdrg=",
        version = "v0.2.2",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_swarm",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-swarm",
        sum = "h1:cIUUvytBzNQmGSjnXFlI6UpoBGsaud82mJPIJVfkDlg=",
        version = "v0.2.8",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_testing",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-testing",
        sum = "h1:v4dvk7YEW8buwCdIVWnhpv0Hp/AAJKRWIxBhmLRZrsk=",
        version = "v0.1.2-0.20200422005655-8775583591d8",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_tls",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-tls",
        sum = "h1:twKMhMu44jQO+HgQK9X8NHO5HkeJu2QbhLzLJpa8oNM=",
        version = "v0.1.3",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_transport",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-transport",
        sum = "h1:pV6+UlRxyDpASSGD+60vMvdifSCby6JkJDfi+yUMHac=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_transport_upgrader",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-transport-upgrader",
        sum = "h1:q3ULhsknEQ34eVDhv4YwKS8iet69ffs9+Fir6a7weN4=",
        version = "v0.3.0",
    )
    go_repository(
        name = "com_github_libp2p_go_libp2p_yamux",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-libp2p-yamux",
        sum = "h1:0s3ELSLu2O7hWKfX1YjzudBKCP0kZ+m9e2+0veXzkn4=",
        version = "v0.2.8",
    )
    go_repository(
        name = "com_github_libp2p_go_maddr_filter",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-maddr-filter",
        sum = "h1:4ACqZKw8AqiuJfwFGq1CYDFugfXTOos+qQ3DETkhtCE=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_mplex",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-mplex",
        sum = "h1:noyLUCtHtSsPOLACCo0AO0q79H4pba1UHlLxbfBPv2w=",
        version = "v0.1.3",
    )
    go_repository(
        name = "com_github_libp2p_go_msgio",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-msgio",
        sum = "h1:lQ7Uc0kS1wb1EfRxO2Eir/RJoHkHn7t6o+EiwsYIKJA=",
        version = "v0.0.6",
    )
    go_repository(
        name = "com_github_libp2p_go_nat",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-nat",
        sum = "h1:qxnwkco8RLKqVh1NmjQ+tJ8p8khNLFxuElYG/TwqW4Q=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_libp2p_go_netroute",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-netroute",
        sum = "h1:1ngWRx61us/EpaKkdqkMjKk/ufr/JlIFYQAxV2XX8Ig=",
        version = "v0.1.3",
    )
    go_repository(
        name = "com_github_libp2p_go_openssl",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-openssl",
        sum = "h1:eCAzdLejcNVBzP/iZM9vqHnQm+XyCEbSSIheIPRGNsw=",
        version = "v0.0.7",
    )
    go_repository(
        name = "com_github_libp2p_go_reuseport",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-reuseport",
        sum = "h1:7PhkfH73VXfPJYKQ6JwS5I/eVcoyYi9IMNGc6FWpFLw=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_libp2p_go_reuseport_transport",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-reuseport-transport",
        sum = "h1:zzOeXnTooCkRvoH+bSXEfXhn76+LAiwoneM0gnXjF2M=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_libp2p_go_sockaddr",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-sockaddr",
        sum = "h1:Y4s3/jNoryVRKEBrkJ576F17CPOaMIzUeCsg7dlTDj0=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_socket_activation",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-socket-activation",
        sum = "h1:VLU3IbrUUqu4DMhxA9857Q63qUpEAbCz5RqSnLCx5jE=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_libp2p_go_stream_muxer",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-stream-muxer",
        sum = "h1:3ToDXUzx8pDC6RfuOzGsUYP5roMDthbUKRdMRRhqAqY=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_stream_muxer_multistream",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-stream-muxer-multistream",
        sum = "h1:TqnSHPJEIqDEO7h1wZZ0p3DXdvDSiLHQidKKUGZtiOY=",
        version = "v0.3.0",
    )
    go_repository(
        name = "com_github_libp2p_go_tcp_transport",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-tcp-transport",
        sum = "h1:YoThc549fzmNJIh7XjHVtMIFaEDRtIrtWciG5LyYAPo=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_libp2p_go_testutil",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-testutil",
        sum = "h1:4QhjaWGO89udplblLVpgGDOQjzFlRavZOjuEnz2rLMc=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_libp2p_go_ws_transport",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-ws-transport",
        sum = "h1:ZX5rWB8nhRRJVaPO6tmkGI/Xx8XNboYX20PW5hXIscw=",
        version = "v0.3.1",
    )
    go_repository(
        name = "com_github_libp2p_go_yamux",
        build_file_proto_mode = "disable",
        importpath = "github.com/libp2p/go-yamux",
        sum = "h1:v40A1eSPJDIZwz2AvrV3cxpTZEGDP11QJbukmEhYyQI=",
        version = "v1.3.7",
    )
    go_repository(
        name = "com_github_lucas_clemente_quic_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/lucas-clemente/quic-go",
        sum = "h1:JhQDdqxdwdmGdKsKgXi1+coHRoGhvU6z0rNzOJqZ/4o=",
        version = "v0.18.0",
    )
    go_repository(
        name = "com_github_lunixbochs_vtclean",
        build_file_proto_mode = "disable",
        importpath = "github.com/lunixbochs/vtclean",
        sum = "h1:xu2sLAri4lGiovBDQKxl5mrXyESr3gUr5m5SM5+LVb8=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_magiconair_properties",
        build_file_proto_mode = "disable",
        importpath = "github.com/magiconair/properties",
        sum = "h1:LLgXmsheXeRoUOBOjtwPQCWIYqM/LU1ayDtDePerRcY=",
        version = "v1.8.0",
    )
    go_repository(
        name = "com_github_mailru_easyjson",
        build_file_proto_mode = "disable",
        importpath = "github.com/mailru/easyjson",
        sum = "h1:W/GaMY0y69G4cFlmsC6B9sbuo2fP8OFP1ABjt4kPz+w=",
        version = "v0.0.0-20190312143242-1de009706dbe",
    )
    go_repository(
        name = "com_github_marstr_guid",
        build_file_proto_mode = "disable",
        importpath = "github.com/marstr/guid",
        sum = "h1:/M4H/1G4avsieL6BbUwCOBzulmoeKVP5ux/3mQNnbyI=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_marten_seemann_qpack",
        build_file_proto_mode = "disable",
        importpath = "github.com/marten-seemann/qpack",
        sum = "h1:/r1rhZoOmgxVKBqPNnYilZBDEyw+6OUHCbBzA5jc2y0=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_marten_seemann_qtls",
        build_file_proto_mode = "disable",
        importpath = "github.com/marten-seemann/qtls",
        sum = "h1:ECsuYUKalRL240rRD4Ri33ISb7kAQ3qGDlrrl55b2pc=",
        version = "v0.10.0",
    )
    go_repository(
        name = "com_github_marten_seemann_qtls_go1_15",
        build_file_proto_mode = "disable",
        importpath = "github.com/marten-seemann/qtls-go1-15",
        sum = "h1:i/YPXVxz8q9umso/5y474CNcHmTpA+5DH+mFPjx6PZg=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_mattn_go_colorable",
        build_file_proto_mode = "disable",
        importpath = "github.com/mattn/go-colorable",
        sum = "h1:snbPLB8fVfU9iwbbo30TPtbLRzwWu6aJS6Xh4eaaviA=",
        version = "v0.1.4",
    )
    go_repository(
        name = "com_github_mattn_go_isatty",
        build_file_proto_mode = "disable",
        importpath = "github.com/mattn/go-isatty",
        sum = "h1:FxPOTFNqGkuDUGi3H/qkUbQO4ZiBa2brKq5r0l8TGeM=",
        version = "v0.0.11",
    )
    go_repository(
        name = "com_github_mattn_go_runewidth",
        build_file_proto_mode = "disable",
        importpath = "github.com/mattn/go-runewidth",
        sum = "h1:Lm995f3rfxdpd6TSmuVCHVb/QhupuXlYr8sCI/QdE+0=",
        version = "v0.0.9",
    )
    go_repository(
        name = "com_github_matttproud_golang_protobuf_extensions",
        build_file_proto_mode = "disable",
        importpath = "github.com/matttproud/golang_protobuf_extensions",
        sum = "h1:4hp9jkHxhMHkqkrB3Ix0jegS5sx/RkqARlsWZ6pIwiU=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_mgutz_ansi",
        build_file_proto_mode = "disable",
        importpath = "github.com/mgutz/ansi",
        sum = "h1:j7+1HpAFS1zy5+Q4qx1fWh90gTKwiN4QCGoY9TWyyO4=",
        version = "v0.0.0-20170206155736-9520e82c474b",
    )
    go_repository(
        name = "com_github_microcosm_cc_bluemonday",
        build_file_proto_mode = "disable",
        importpath = "github.com/microcosm-cc/bluemonday",
        sum = "h1:SIYunPjnlXcW+gVfvm0IlSeR5U3WZUOLfVmqg85Go44=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_miekg_dns",
        build_file_proto_mode = "disable",
        importpath = "github.com/miekg/dns",
        sum = "h1:Qww6FseFn8PRfw07jueqIXqodm0JKiiKuK0DeXSqfyo=",
        version = "v1.1.30",
    )
    go_repository(
        name = "com_github_minio_blake2b_simd",
        build_file_proto_mode = "disable",
        importpath = "github.com/minio/blake2b-simd",
        sum = "h1:lYpkrQH5ajf0OXOcUbGjvZxxijuBwbbmlSxLiuofa+g=",
        version = "v0.0.0-20160723061019-3f5f724cb5b1",
    )
    go_repository(
        name = "com_github_minio_sha256_simd",
        build_file_proto_mode = "disable",
        importpath = "github.com/minio/sha256-simd",
        sum = "h1:5QHSlgo3nt5yKOJrC7W8w7X+NFl8cMPZm96iu8kKUJU=",
        version = "v0.1.1",
    )
    go_repository(
        name = "com_github_mitchellh_go_homedir",
        build_file_proto_mode = "disable",
        importpath = "github.com/mitchellh/go-homedir",
        sum = "h1:lukF9ziXFxDFPkA1vsr5zpc1XuPDn/wFntq5mG+4E0Y=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_mitchellh_mapstructure",
        build_file_proto_mode = "disable",
        importpath = "github.com/mitchellh/mapstructure",
        sum = "h1:fmNYVwqnSfB9mZU6OS2O6GsXM+wcskZDuKQzvN1EDeE=",
        version = "v1.1.2",
    )
    go_repository(
        name = "com_github_mitchellh_osext",
        build_file_proto_mode = "disable",
        importpath = "github.com/mitchellh/osext",
        sum = "h1:2+myh5ml7lgEU/51gbeLHfKGNfgEQQIWrlbdaOsidbQ=",
        version = "v0.0.0-20151018003038-5e2d6d41470f",
    )
    go_repository(
        name = "com_github_modern_go_concurrent",
        build_file_proto_mode = "disable",
        importpath = "github.com/modern-go/concurrent",
        sum = "h1:TRLaZ9cD/w8PVh93nsPXa1VrQ6jlwL5oN8l14QlcNfg=",
        version = "v0.0.0-20180306012644-bacd9c7ef1dd",
    )
    go_repository(
        name = "com_github_modern_go_reflect2",
        build_file_proto_mode = "disable",
        importpath = "github.com/modern-go/reflect2",
        sum = "h1:9f412s+6RmYXLWZSEzVVgPGK7C2PphHj5RJrvfx9AWI=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_mr_tron_base58",
        build_file_proto_mode = "disable",
        importpath = "github.com/mr-tron/base58",
        sum = "h1:T/HDJBh4ZCPbU39/+c3rRvE0uKBQlU27+QI8LJ4t64o=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_multiformats_go_base32",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-base32",
        sum = "h1:tw5+NhuwaOjJCC5Pp82QuXbrmLzWg7uxlMFp8Nq/kkI=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_multiformats_go_base36",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-base36",
        sum = "h1:JR6TyF7JjGd3m6FbLU2cOxhC0Li8z8dLNGQ89tUg4F4=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_multiformats_go_multiaddr",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-multiaddr",
        sum = "h1:1bxa+W7j9wZKTZREySx1vPMs2TqrYWjVZ7zE6/XLG1I=",
        version = "v0.3.1",
    )
    go_repository(
        name = "com_github_multiformats_go_multiaddr_dns",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-multiaddr-dns",
        sum = "h1:YWJoIDwLePniH7OU5hBnDZV6SWuvJqJ0YtN6pLeH9zA=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_multiformats_go_multiaddr_fmt",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-multiaddr-fmt",
        sum = "h1:WLEFClPycPkp4fnIzoFoV9FVd49/eQsuaL3/CWe167E=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_multiformats_go_multiaddr_net",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-multiaddr-net",
        sum = "h1:MSXRGN0mFymt6B1yo/6BPnIRpLPEnKgQNvVfCX5VDJk=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_multiformats_go_multibase",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-multibase",
        sum = "h1:l/B6bJDQjvQ5G52jw4QGSYeOTZoAwIO77RblWplfIqk=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_multiformats_go_multihash",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-multihash",
        sum = "h1:QoBceQYQQtNUuf6s7wHxnE2c8bhbMqhfGzNI032se/I=",
        version = "v0.0.14",
    )
    go_repository(
        name = "com_github_multiformats_go_multistream",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-multistream",
        sum = "h1:knyamLYMPFPngQjGQ0lhnlys3jtVR/3xV6TREUJr+fE=",
        version = "v0.1.2",
    )
    go_repository(
        name = "com_github_multiformats_go_varint",
        build_file_proto_mode = "disable",
        importpath = "github.com/multiformats/go-varint",
        sum = "h1:gk85QWKxh3TazbLxED/NlDVv8+q+ReFJk7Y2W/KhfNY=",
        version = "v0.0.6",
    )
    go_repository(
        name = "com_github_mwitkow_go_conntrack",
        build_file_proto_mode = "disable",
        importpath = "github.com/mwitkow/go-conntrack",
        sum = "h1:F9x/1yl3T2AeKLr2AMdilSD8+f9bvMnNN8VS5iDtovc=",
        version = "v0.0.0-20161129095857-cc309e4a2223",
    )
    go_repository(
        name = "com_github_ncw_swift",
        build_file_proto_mode = "disable",
        importpath = "github.com/ncw/swift",
        sum = "h1:4DQRPj35Y41WogBxyhOXlrI37nzGlyEcsforeudyYPQ=",
        version = "v1.0.47",
    )
    go_repository(
        name = "com_github_neelance_astrewrite",
        build_file_proto_mode = "disable",
        importpath = "github.com/neelance/astrewrite",
        sum = "h1:D6paGObi5Wud7xg83MaEFyjxQB1W5bz5d0IFppr+ymk=",
        version = "v0.0.0-20160511093645-99348263ae86",
    )
    go_repository(
        name = "com_github_neelance_sourcemap",
        build_file_proto_mode = "disable",
        importpath = "github.com/neelance/sourcemap",
        sum = "h1:eFXv9Nu1lGbrNbj619aWwZfVF5HBrm9Plte8aNptuTI=",
        version = "v0.0.0-20151028013722-8c68805598ab",
    )
    go_repository(
        name = "com_github_nxadm_tail",
        build_file_proto_mode = "disable",
        importpath = "github.com/nxadm/tail",
        sum = "h1:DQuhQpB1tVlglWS2hLQ5OV6B5r8aGxSrPc5Qo6uTN78=",
        version = "v1.4.4",
    )
    go_repository(
        name = "com_github_oneofone_xxhash",
        build_file_proto_mode = "disable",
        importpath = "github.com/OneOfOne/xxhash",
        sum = "h1:KMrpdQIwFcEqXDklaen+P1axHaj9BSKzvpUUfnHldSE=",
        version = "v1.2.2",
    )
    go_repository(
        name = "com_github_onsi_ginkgo",
        build_file_proto_mode = "disable",
        importpath = "github.com/onsi/ginkgo",
        sum = "h1:8mVmC9kjFFmA8H4pKMUhcblgifdkOIXPvbhN1T36q1M=",
        version = "v1.14.2",
    )
    go_repository(
        name = "com_github_onsi_gomega",
        build_file_proto_mode = "disable",
        importpath = "github.com/onsi/gomega",
        sum = "h1:gph6h/qe9GSUw1NhH1gp+qb+h8rXD8Cy60Z32Qw3ELA=",
        version = "v1.10.3",
    )
    go_repository(
        name = "com_github_opencontainers_go_digest",
        build_file_proto_mode = "disable",
        importpath = "github.com/opencontainers/go-digest",
        sum = "h1:apOUWs51W5PlhuyGyz9FCeeBIOUDA/6nW8Oi/yOhh5U=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_opencontainers_image_spec",
        build_file_proto_mode = "disable",
        importpath = "github.com/opencontainers/image-spec",
        sum = "h1:JMemWkRwHx4Zj+fVxWoMCFm/8sYGGrUVojFA6h/TRcI=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_opentracing_opentracing_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/opentracing/opentracing-go",
        sum = "h1:uEJPy/1a5RIPAJ0Ov+OIO8OxWu77jEv+1B0VhjKrZUs=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_openzipkin_zipkin_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/openzipkin/zipkin-go",
        sum = "h1:A/ADD6HaPnAKj3yS7HjGHRK77qi41Hi0DirOOIQAeIw=",
        version = "v0.1.1",
    )
    go_repository(
        name = "com_github_pelletier_go_toml",
        build_file_proto_mode = "disable",
        importpath = "github.com/pelletier/go-toml",
        sum = "h1:T5zMGML61Wp+FlcbWjRDT7yAxhJNAiPPLOFECq181zc=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_pkg_errors",
        build_file_proto_mode = "disable",
        importpath = "github.com/pkg/errors",
        sum = "h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4=",
        version = "v0.9.1",
    )
    go_repository(
        name = "com_github_pmezard_go_difflib",
        build_file_proto_mode = "disable",
        importpath = "github.com/pmezard/go-difflib",
        sum = "h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_polydawn_refmt",
        build_file_proto_mode = "disable",
        importpath = "github.com/polydawn/refmt",
        sum = "h1:CskT+S6Ay54OwxBGB0R3Rsx4Muto6UnEYTyKJbyRIAI=",
        version = "v0.0.0-20190807091052-3d65705ee9f1",
    )
    go_repository(
        name = "com_github_prometheus_client_golang",
        build_file_proto_mode = "disable",
        importpath = "github.com/prometheus/client_golang",
        sum = "h1:YVPodQOcK15POxhgARIvnDRVpLcuK8mglnMrWfyrw6A=",
        version = "v1.6.0",
    )
    go_repository(
        name = "com_github_prometheus_client_model",
        build_file_proto_mode = "disable",
        importpath = "github.com/prometheus/client_model",
        sum = "h1:uq5h0d+GuxiXLJLNABMgp2qUWDPiLvgCzz2dUR+/W/M=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_prometheus_common",
        build_file_proto_mode = "disable",
        importpath = "github.com/prometheus/common",
        sum = "h1:KOMtN28tlbam3/7ZKEYKHhKoJZYYj3gMH4uc62x7X7U=",
        version = "v0.9.1",
    )
    go_repository(
        name = "com_github_prometheus_procfs",
        build_file_proto_mode = "disable",
        importpath = "github.com/prometheus/procfs",
        sum = "h1:DhHlBtkHWPYi8O2y31JkK0TF+DGM+51OopZjH/Ia5qI=",
        version = "v0.0.11",
    )
    go_repository(
        name = "com_github_rogpeppe_go_internal",
        build_file_proto_mode = "disable",
        importpath = "github.com/rogpeppe/go-internal",
        sum = "h1:RR9dF3JtopPvtkroDZuVD7qquD0bnHlKSqaQhgwt8yk=",
        version = "v1.3.0",
    )
    go_repository(
        name = "com_github_rs_cors",
        build_file_proto_mode = "disable",
        importpath = "github.com/rs/cors",
        sum = "h1:+88SsELBHx5r+hZ8TCkggzSstaWNbDvThkVK8H6f9ik=",
        version = "v1.7.0",
    )
    go_repository(
        name = "com_github_russross_blackfriday",
        build_file_proto_mode = "disable",
        importpath = "github.com/russross/blackfriday",
        sum = "h1:HyvC0ARfnZBqnXwABFeSZHpKvJHJJfPz81GNueLj0oo=",
        version = "v1.5.2",
    )
    go_repository(
        name = "com_github_rwcarlsen_goexif",
        build_file_proto_mode = "disable",
        importpath = "github.com/rwcarlsen/goexif",
        sum = "h1:CmH9+J6ZSsIjUK3dcGsnCnO41eRBOnY12zwkn5qVwgc=",
        version = "v0.0.0-20190401172101-9e8deecbddbd",
    )
    go_repository(
        name = "com_github_satori_go_uuid",
        build_file_proto_mode = "disable",
        importpath = "github.com/satori/go.uuid",
        sum = "h1:0uYX9dsZ2yD7q2RtLRtPSdGDWzjeM3TbMJP9utgA0ww=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_sergi_go_diff",
        build_file_proto_mode = "disable",
        importpath = "github.com/sergi/go-diff",
        sum = "h1:Kpca3qRNrduNnOQeazBd0ysaKrUJiIuISHxogkT9RPQ=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_shopify_logrus_bugsnag",
        build_file_proto_mode = "disable",
        importpath = "github.com/Shopify/logrus-bugsnag",
        sum = "h1:UrqY+r/OJnIp5u0s1SbQ8dVfLCZJsnvazdBP5hS4iRs=",
        version = "v0.0.0-20171204204709-577dee27f20d",
    )
    go_repository(
        name = "com_github_shurcool_component",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/component",
        sum = "h1:Fth6mevc5rX7glNLpbAMJnqKlfIkcTjZCSHEeqvKbcI=",
        version = "v0.0.0-20170202220835-f88ec8f54cc4",
    )
    go_repository(
        name = "com_github_shurcool_events",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/events",
        sum = "h1:vabduItPAIz9px5iryD5peyx7O3Ya8TBThapgXim98o=",
        version = "v0.0.0-20181021180414-410e4ca65f48",
    )
    go_repository(
        name = "com_github_shurcool_github_flavored_markdown",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/github_flavored_markdown",
        sum = "h1:qb9IthCFBmROJ6YBS31BEMeSYjOscSiG+EO+JVNTz64=",
        version = "v0.0.0-20181002035957-2122de532470",
    )
    go_repository(
        name = "com_github_shurcool_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/go",
        sum = "h1:MZM7FHLqUHYI0Y/mQAt3d2aYa0SiNms/hFqC9qJYolM=",
        version = "v0.0.0-20180423040247-9e1955d9fb6e",
    )
    go_repository(
        name = "com_github_shurcool_go_goon",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/go-goon",
        sum = "h1:llrF3Fs4018ePo4+G/HV/uQUqEI1HMDjCeOf2V6puPc=",
        version = "v0.0.0-20170922171312-37c2f522c041",
    )
    go_repository(
        name = "com_github_shurcool_gofontwoff",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/gofontwoff",
        sum = "h1:Yoy/IzG4lULT6qZg62sVC+qyBL8DQkmD2zv6i7OImrc=",
        version = "v0.0.0-20180329035133-29b52fc0a18d",
    )
    go_repository(
        name = "com_github_shurcool_gopherjslib",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/gopherjslib",
        sum = "h1:UOk+nlt1BJtTcH15CT7iNO7YVWTfTv/DNwEAQHLIaDQ=",
        version = "v0.0.0-20160914041154-feb6d3990c2c",
    )
    go_repository(
        name = "com_github_shurcool_highlight_diff",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/highlight_diff",
        sum = "h1:vYEG87HxbU6dXj5npkeulCS96Dtz5xg3jcfCgpcvbIw=",
        version = "v0.0.0-20170515013008-09bb4053de1b",
    )
    go_repository(
        name = "com_github_shurcool_highlight_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/highlight_go",
        sum = "h1:7pDq9pAMCQgRohFmd25X8hIH8VxmT3TaDm+r9LHxgBk=",
        version = "v0.0.0-20181028180052-98c3abbbae20",
    )
    go_repository(
        name = "com_github_shurcool_home",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/home",
        sum = "h1:MPblCbqA5+z6XARjScMfz1TqtJC7TuTRj0U9VqIBs6k=",
        version = "v0.0.0-20181020052607-80b7ffcb30f9",
    )
    go_repository(
        name = "com_github_shurcool_htmlg",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/htmlg",
        sum = "h1:crYRwvwjdVh1biHzzciFHe8DrZcYrVcZFlJtykhRctg=",
        version = "v0.0.0-20170918183704-d01228ac9e50",
    )
    go_repository(
        name = "com_github_shurcool_httperror",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/httperror",
        sum = "h1:eHRtZoIi6n9Wo1uR+RU44C247msLWwyA89hVKwRLkMk=",
        version = "v0.0.0-20170206035902-86b7830d14cc",
    )
    go_repository(
        name = "com_github_shurcool_httpfs",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/httpfs",
        sum = "h1:SWV2fHctRpRrp49VXJ6UZja7gU9QLHwRpIPBN89SKEo=",
        version = "v0.0.0-20171119174359-809beceb2371",
    )
    go_repository(
        name = "com_github_shurcool_httpgzip",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/httpgzip",
        sum = "h1:fxoFD0in0/CBzXoyNhMTjvBZYW6ilSnTw7N7y/8vkmM=",
        version = "v0.0.0-20180522190206-b1c53ac65af9",
    )
    go_repository(
        name = "com_github_shurcool_issues",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/issues",
        sum = "h1:T4wuULTrzCKMFlg3HmKHgXAF8oStFb/+lOIupLV2v+o=",
        version = "v0.0.0-20181008053335-6292fdc1e191",
    )
    go_repository(
        name = "com_github_shurcool_issuesapp",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/issuesapp",
        sum = "h1:Y+TeIabU8sJD10Qwd/zMty2/LEaT9GNDaA6nyZf+jgo=",
        version = "v0.0.0-20180602232740-048589ce2241",
    )
    go_repository(
        name = "com_github_shurcool_notifications",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/notifications",
        sum = "h1:TQVQrsyNaimGwF7bIhzoVC9QkKm4KsWd8cECGzFx8gI=",
        version = "v0.0.0-20181007000457-627ab5aea122",
    )
    go_repository(
        name = "com_github_shurcool_octicon",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/octicon",
        sum = "h1:bu666BQci+y4S0tVRVjsHUeRon6vUXmsGBwdowgMrg4=",
        version = "v0.0.0-20181028054416-fa4f57f9efb2",
    )
    go_repository(
        name = "com_github_shurcool_reactions",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/reactions",
        sum = "h1:LneqU9PHDsg/AkPDU3AkqMxnMYL+imaqkpflHu73us8=",
        version = "v0.0.0-20181006231557-f2e0b4ca5b82",
    )
    go_repository(
        name = "com_github_shurcool_sanitized_anchor_name",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/sanitized_anchor_name",
        sum = "h1:/vdW8Cb7EXrkqWGufVMES1OH2sU9gKVb2n9/1y5NMBY=",
        version = "v0.0.0-20170918181015-86672fcb3f95",
    )
    go_repository(
        name = "com_github_shurcool_users",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/users",
        sum = "h1:YGaxtkYjb8mnTvtufv2LKLwCQu2/C7qFB7UtrOlTWOY=",
        version = "v0.0.0-20180125191416-49c67e49c537",
    )
    go_repository(
        name = "com_github_shurcool_webdavfs",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/webdavfs",
        sum = "h1:JtcyT0rk/9PKOdnKQzuDR+FSjh7SGtJwpgVpfZBRKlQ=",
        version = "v0.0.0-20170829043945-18c3829fa133",
    )
    go_repository(
        name = "com_github_sirupsen_logrus",
        build_file_proto_mode = "disable",
        importpath = "github.com/sirupsen/logrus",
        sum = "h1:UBcNElsrwanuuMsnGSlYmtmgbb23qDR5dG+6X6Oo89I=",
        version = "v1.6.0",
    )
    go_repository(
        name = "com_github_smartystreets_assertions",
        build_file_proto_mode = "disable",
        importpath = "github.com/smartystreets/assertions",
        sum = "h1:UVQPSSmc3qtTi+zPPkCXvZX9VvW/xT/NsRvKfwY81a8=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_smartystreets_goconvey",
        build_file_proto_mode = "disable",
        importpath = "github.com/smartystreets/goconvey",
        sum = "h1:N8Bg45zpk/UcpNGnfJt2y/3lRWASHNTUET8owPYCgYI=",
        version = "v0.0.0-20190710185942-9d28bd7c0945",
    )
    go_repository(
        name = "com_github_smola_gocompat",
        build_file_proto_mode = "disable",
        importpath = "github.com/smola/gocompat",
        sum = "h1:6b1oIMlUXIpz//VKEDzPVBK8KG7beVwmHIUEBIs/Pns=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_sourcegraph_annotate",
        build_file_proto_mode = "disable",
        importpath = "github.com/sourcegraph/annotate",
        sum = "h1:yKm7XZV6j9Ev6lojP2XaIshpT4ymkqhMeSghO5Ps00E=",
        version = "v0.0.0-20160123013949-f4cad6c6324d",
    )
    go_repository(
        name = "com_github_sourcegraph_syntaxhighlight",
        build_file_proto_mode = "disable",
        importpath = "github.com/sourcegraph/syntaxhighlight",
        sum = "h1:qpG93cPwA5f7s/ZPBJnGOYQNK/vKsaDaseuKT5Asee8=",
        version = "v0.0.0-20170531221838-bd320f5d308e",
    )
    go_repository(
        name = "com_github_spacemonkeygo_openssl",
        build_file_proto_mode = "disable",
        importpath = "github.com/spacemonkeygo/openssl",
        sum = "h1:/eS3yfGjQKG+9kayBkj0ip1BGhq6zJ3eaVksphxAaek=",
        version = "v0.0.0-20181017203307-c2dcc5cca94a",
    )
    go_repository(
        name = "com_github_spacemonkeygo_spacelog",
        build_file_proto_mode = "disable",
        importpath = "github.com/spacemonkeygo/spacelog",
        sum = "h1:RC6RW7j+1+HkWaX/Yh71Ee5ZHaHYt7ZP4sQgUrm6cDU=",
        version = "v0.0.0-20180420211403-2296661a0572",
    )
    go_repository(
        name = "com_github_spaolacci_murmur3",
        build_file_proto_mode = "disable",
        importpath = "github.com/spaolacci/murmur3",
        sum = "h1:7c1g84S4BPRrfL5Xrdp6fOJ206sU9y293DDHaoy0bLI=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_spf13_afero",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/afero",
        sum = "h1:m8/z1t7/fwjysjQRYbP0RD+bUIF/8tJwPdEZsI83ACI=",
        version = "v1.1.2",
    )
    go_repository(
        name = "com_github_spf13_cast",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/cast",
        sum = "h1:oget//CVOEoFewqQxwr0Ej5yjygnqGkvggSE/gB35Q8=",
        version = "v1.3.0",
    )
    go_repository(
        name = "com_github_spf13_cobra",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/cobra",
        sum = "h1:f0B+LkLX6DtmRH1isoNA9VTtNUK9K8xYd28JNNfOv/s=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_spf13_jwalterweatherman",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/jwalterweatherman",
        sum = "h1:XHEdyB+EcvlqZamSM4ZOMGlc93t6AcsBEu9Gc1vn7yk=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_spf13_pflag",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/pflag",
        sum = "h1:zPAT6CGy6wXeQ7NtTnaTerfKOsV6V6F8agHXFiazDkg=",
        version = "v1.0.3",
    )
    go_repository(
        name = "com_github_spf13_viper",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/viper",
        sum = "h1:VUFqw5KcqRf7i70GOzW7N+Q7+gxVBkSSqiXB12+JQ4M=",
        version = "v1.3.2",
    )
    go_repository(
        name = "com_github_src_d_envconfig",
        build_file_proto_mode = "disable",
        importpath = "github.com/src-d/envconfig",
        sum = "h1:/AJi6DtjFhZKNx3OB2qMsq7y4yT5//AeSZIe7rk+PX8=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_stebalien_go_bitfield",
        build_file_proto_mode = "disable",
        importpath = "github.com/Stebalien/go-bitfield",
        sum = "h1:X3kbSSPUaJK60wV2hjOPZwmpljr6VGCqdq4cBLhbQBo=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_stretchr_objx",
        build_file_proto_mode = "disable",
        importpath = "github.com/stretchr/objx",
        sum = "h1:2vfRuCMp5sSVIDSqO8oNnWJq7mPa6KVP3iPIwFBuy8A=",
        version = "v0.1.1",
    )
    go_repository(
        name = "com_github_stretchr_testify",
        build_file_proto_mode = "disable",
        importpath = "github.com/stretchr/testify",
        sum = "h1:hDPOHmpOpP40lSULcqw7IrRb/u7w6RpDC9399XyoNd0=",
        version = "v1.6.1",
    )
    go_repository(
        name = "com_github_syndtr_goleveldb",
        build_file_proto_mode = "disable",
        importpath = "github.com/syndtr/goleveldb",
        sum = "h1:fBdIW9lB4Iz0n9khmH8w27SJ3QEJ7+IgjPEwGSZiFdE=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_tarm_serial",
        build_file_proto_mode = "disable",
        importpath = "github.com/tarm/serial",
        sum = "h1:UyzmZLoiDWMRywV4DUYb9Fbt8uiOSooupjTq10vpvnU=",
        version = "v0.0.0-20180830185346-98f6abe2eb07",
    )
    go_repository(
        name = "com_github_texttheater_golang_levenshtein",
        build_file_proto_mode = "disable",
        importpath = "github.com/texttheater/golang-levenshtein",
        sum = "h1:T5PdfK/M1xyrHwynxMIVMWLS7f/qHwfslZphxtGnw7s=",
        version = "v0.0.0-20180516184445-d188e65d659e",
    )
    go_repository(
        name = "com_github_tv42_httpunix",
        build_file_proto_mode = "disable",
        importpath = "github.com/tv42/httpunix",
        sum = "h1:u6SKchux2yDvFQnDHS3lPnIRmfVJ5Sxy3ao2SIdysLQ=",
        version = "v0.0.0-20191220191345-2ba4b9c3382c",
    )
    go_repository(
        name = "com_github_ugorji_go_codec",
        build_file_proto_mode = "disable",
        importpath = "github.com/ugorji/go/codec",
        sum = "h1:3SVOIvH7Ae1KRYyQWRjXWJEA9sS/c/pjvH++55Gr648=",
        version = "v0.0.0-20181204163529-d75b2dcb6bc8",
    )
    go_repository(
        name = "com_github_urfave_cli",
        build_file_proto_mode = "disable",
        importpath = "github.com/urfave/cli",
        sum = "h1:fDqGv3UG/4jbVl/QkFwEdddtEDjh/5Ov6X+0B/3bPaw=",
        version = "v1.20.0",
    )
    go_repository(
        name = "com_github_viant_assertly",
        build_file_proto_mode = "disable",
        importpath = "github.com/viant/assertly",
        sum = "h1:5x1GzBaRteIwTr5RAGFVG14uNeRFxVNbXPWrK2qAgpc=",
        version = "v0.4.8",
    )
    go_repository(
        name = "com_github_viant_toolbox",
        build_file_proto_mode = "disable",
        importpath = "github.com/viant/toolbox",
        sum = "h1:6TteTDQ68CjgcCe8wH3D3ZhUQQOJXMTbj/D9rkk2a1k=",
        version = "v0.24.0",
    )
    go_repository(
        name = "com_github_wangjia184_sortedset",
        build_file_proto_mode = "disable",
        importpath = "github.com/wangjia184/sortedset",
        sum = "h1:kZiWylALnUy4kzoKJemjH8eqwCl3RjW1r1ITCjjW7G8=",
        version = "v0.0.0-20160527075905-f5d03557ba30",
    )
    go_repository(
        name = "com_github_warpfork_go_wish",
        build_file_proto_mode = "disable",
        importpath = "github.com/warpfork/go-wish",
        sum = "h1:8kxMKmKzXXL4Ru1nyhvdms/JjWt+3YLpvRb/bAjO/y0=",
        version = "v0.0.0-20190328234359-8b3e70f8e830",
    )
    go_repository(
        name = "com_github_whyrusleeping_base32",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/base32",
        sum = "h1:BCPnHtcboadS0DvysUuJXZ4lWVv5Bh5i7+tbIyi+ck4=",
        version = "v0.0.0-20170828182744-c30ac30633cc",
    )
    go_repository(
        name = "com_github_whyrusleeping_cbor_gen",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/cbor-gen",
        sum = "h1:LHFlP/ktDvOnCap7PsT87cs7Gwd0p+qv6Qm5g2ZPR+I=",
        version = "v0.0.0-20200715143311-227fab5a2377",
    )
    go_repository(
        name = "com_github_whyrusleeping_chunker",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/chunker",
        sum = "h1:jQa4QT2UP9WYv2nzyawpKMOCl+Z/jW7djv2/J50lj9E=",
        version = "v0.0.0-20181014151217-fe64bd25879f",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_ctrlnet",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-ctrlnet",
        sum = "h1:c23eYhe7i8MG6dUSPzyIDDy5+cWOoZMovPamBKqrjYQ=",
        version = "v0.0.0-20180313164037-f564fbbdaa95",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_keyspace",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-keyspace",
        sum = "h1:EKhdznlJHPMoKr0XTrX+IlJs1LH3lyx2nfr1dOlZ79k=",
        version = "v0.0.0-20160322163242-5b898ac5add1",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_logging",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-logging",
        sum = "h1:fwpzlmT0kRC/Fmd0MdmGgJG/CXIZ6gFq46FQZjprUcc=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_notifier",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-notifier",
        sum = "h1:M/lL30eFZTKnomXY6huvM6G0+gVquFNf6mxghaWlFUg=",
        version = "v0.0.0-20170827234753-097c5d47330f",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_smux_multiplex",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-smux-multiplex",
        sum = "h1:iqksILj8STw03EJQe7Laj4ubnw+ojOyik18cd5vPL1o=",
        version = "v3.0.16+incompatible",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_smux_multistream",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-smux-multistream",
        sum = "h1:BdYHctE9HJZLquG9tpTdwWcbG4FaX6tVKPGjCGgiVxo=",
        version = "v2.0.2+incompatible",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_smux_yamux",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-smux-yamux",
        sum = "h1:nVkExQ7pYlN9e45LcqTCOiDD0904fjtm0flnHZGbXkw=",
        version = "v2.0.9+incompatible",
    )
    go_repository(
        name = "com_github_whyrusleeping_go_sysinfo",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/go-sysinfo",
        sum = "h1:ctS9Anw/KozviCCtK6VWMz5kPL9nbQzbQY4yfqlIV4M=",
        version = "v0.0.0-20190219211824-4a357d4b90b1",
    )
    go_repository(
        name = "com_github_whyrusleeping_mafmt",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/mafmt",
        sum = "h1:TCghSl5kkwEE0j+sU/gudyhVMRlpBin8fMBBHg59EbA=",
        version = "v1.2.8",
    )
    go_repository(
        name = "com_github_whyrusleeping_mdns",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/mdns",
        sum = "h1:Y1/FEOpaCpD21WxrmfeIYCFPuVPRCY2XZTWzTNHGw30=",
        version = "v0.0.0-20190826153040-b9b60ed33aa9",
    )
    go_repository(
        name = "com_github_whyrusleeping_multiaddr_filter",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/multiaddr-filter",
        sum = "h1:E9S12nwJwEOXe2d6gT6qxdvqMnNq+VnSsKPgm2ZZNds=",
        version = "v0.0.0-20160516205228-e903e4adabd7",
    )
    go_repository(
        name = "com_github_whyrusleeping_tar_utils",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/tar-utils",
        sum = "h1:GGsyl0dZ2jJgVT+VvWBf/cNijrHRhkrTjkmp5wg7li0=",
        version = "v0.0.0-20180509141711-8c6c8ba81d5c",
    )
    go_repository(
        name = "com_github_whyrusleeping_timecache",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/timecache",
        sum = "h1:lYbXeSvJi5zk5GLKVuid9TVjS9a0OmLIDKTfoZBL6Ow=",
        version = "v0.0.0-20160911033111-cfcb2f1abfee",
    )
    go_repository(
        name = "com_github_whyrusleeping_yamux",
        build_file_proto_mode = "disable",
        importpath = "github.com/whyrusleeping/yamux",
        sum = "h1:4CK3aUUJQu0qpKZv5gEWJjNOQtdbdDhVVS6PJ+HimdE=",
        version = "v1.1.5",
    )
    go_repository(
        name = "com_github_x_cray_logrus_prefixed_formatter",
        build_file_proto_mode = "disable",
        importpath = "github.com/x-cray/logrus-prefixed-formatter",
        sum = "h1:00txxvfBM9muc0jiLIEAkAcIMJzfthRT6usrui8uGmg=",
        version = "v0.5.2",
    )
    go_repository(
        name = "com_github_xenolf_lego",
        build_file_proto_mode = "disable",
        importpath = "github.com/xenolf/lego",
        sum = "h1:aGxxYqhnQLQ71HsvEAjJVw6ao14APwPpRk0mpFroPXk=",
        version = "v2.7.2+incompatible",
    )
    go_repository(
        name = "com_github_xordataexchange_crypt",
        build_file_proto_mode = "disable",
        importpath = "github.com/xordataexchange/crypt",
        sum = "h1:ESFSdwYZvkeru3RtdrYueztKhOBCSAAzS4Gf+k0tEow=",
        version = "v0.0.3-0.20170626215501-b2862e3d0a77",
    )
    go_repository(
        name = "com_github_yuin_goldmark",
        build_file_proto_mode = "disable",
        importpath = "github.com/yuin/goldmark",
        sum = "h1:5tjfNdR2ki3yYQ842+eX2sQHeiwpKJ0RnHO4IYOc4V8=",
        version = "v1.1.32",
    )
    go_repository(
        name = "com_github_yvasiyarov_go_metrics",
        build_file_proto_mode = "disable",
        importpath = "github.com/yvasiyarov/go-metrics",
        sum = "h1:+lm10QQTNSBd8DVTNGHx7o/IKu9HYDvLMffDhbyLccI=",
        version = "v0.0.0-20140926110328-57bccd1ccd43",
    )
    go_repository(
        name = "com_github_yvasiyarov_gorelic",
        build_file_proto_mode = "disable",
        importpath = "github.com/yvasiyarov/gorelic",
        sum = "h1:hlE8//ciYMztlGpl/VA+Zm1AcTPHYkHJPbHqE6WJUXE=",
        version = "v0.0.0-20141212073537-a9bba5b9ab50",
    )
    go_repository(
        name = "com_github_yvasiyarov_newrelic_platform_go",
        build_file_proto_mode = "disable",
        importpath = "github.com/yvasiyarov/newrelic_platform_go",
        sum = "h1:ERexzlUfuTvpE74urLSbIQW0Z/6hF9t8U4NsJLaioAY=",
        version = "v0.0.0-20140908184405-b21fdbd4370f",
    )
    go_repository(
        name = "com_google_cloud_go",
        build_file_proto_mode = "disable",
        importpath = "cloud.google.com/go",
        sum = "h1:MZQCQQaRwOrAcuKjiHWHrgKykt4fZyuwF2dtiG3fGW8=",
        version = "v0.53.0",
    )
    go_repository(
        name = "com_google_cloud_go_bigquery",
        build_file_proto_mode = "disable",
        importpath = "cloud.google.com/go/bigquery",
        sum = "h1:sAbMqjY1PEQKZBWfbu6Y6bsupJ9c4QdHnzg/VvYTLcE=",
        version = "v1.3.0",
    )
    go_repository(
        name = "com_google_cloud_go_datastore",
        build_file_proto_mode = "disable",
        importpath = "cloud.google.com/go/datastore",
        sum = "h1:Kt+gOPPp2LEPWp8CSfxhsM8ik9CcyE/gYu+0r+RnZvM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_google_cloud_go_pubsub",
        build_file_proto_mode = "disable",
        importpath = "cloud.google.com/go/pubsub",
        sum = "h1:9/vpR43S4aJaROxqQHQ3nH9lfyKKV0dC3vOmnw8ebQQ=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_google_cloud_go_storage",
        build_file_proto_mode = "disable",
        importpath = "cloud.google.com/go/storage",
        sum = "h1:RPUcBvDeYgQFMfQu1eBMq6piD1SXmLH+vK3qjewZPus=",
        version = "v1.5.0",
    )
    go_repository(
        name = "com_shuralyov_dmitri_app_changes",
        build_file_proto_mode = "disable",
        importpath = "dmitri.shuralyov.com/app/changes",
        sum = "h1:hJiie5Bf3QucGRa4ymsAUOxyhYwGEz1xrsVk0P8erlw=",
        version = "v0.0.0-20180602232624-0a106ad413e3",
    )
    go_repository(
        name = "com_shuralyov_dmitri_gpu_mtl",
        build_file_proto_mode = "disable",
        importpath = "dmitri.shuralyov.com/gpu/mtl",
        sum = "h1:VpgP7xuJadIUuKccphEpTJnWhS2jkQyMt6Y7pJCD7fY=",
        version = "v0.0.0-20190408044501-666a987793e9",
    )
    go_repository(
        name = "com_shuralyov_dmitri_html_belt",
        build_file_proto_mode = "disable",
        importpath = "dmitri.shuralyov.com/html/belt",
        sum = "h1:SPOUaucgtVls75mg+X7CXigS71EnsfVUK/2CgVrwqgw=",
        version = "v0.0.0-20180602232347-f7d459c86be0",
    )
    go_repository(
        name = "com_shuralyov_dmitri_service_change",
        build_file_proto_mode = "disable",
        importpath = "dmitri.shuralyov.com/service/change",
        sum = "h1:GvWw74lx5noHocd+f6HBMXK6DuggBB1dhVkuGZbv7qM=",
        version = "v0.0.0-20181023043359-a85b471d5412",
    )
    go_repository(
        name = "com_shuralyov_dmitri_state",
        build_file_proto_mode = "disable",
        importpath = "dmitri.shuralyov.com/state",
        sum = "h1:ivON6cwHK1OH26MZyWDCnbTRZZf0IhNsENoNAKFS1g4=",
        version = "v0.0.0-20180228185332-28bcc343414c",
    )
    go_repository(
        name = "com_sourcegraph_sourcegraph_go_diff",
        build_file_proto_mode = "disable",
        importpath = "sourcegraph.com/sourcegraph/go-diff",
        sum = "h1:eTiIR0CoWjGzJcnQ3OkhIl/b9GJovq4lSAVRt0ZFEG8=",
        version = "v0.5.0",
    )
    go_repository(
        name = "com_sourcegraph_sqs_pbtypes",
        build_file_proto_mode = "disable",
        importpath = "sourcegraph.com/sqs/pbtypes",
        sum = "h1:JPJh2pk3+X4lXAkZIk2RuE/7/FoK9maXw+TNPJhVS/c=",
        version = "v0.0.0-20180604144634-d3ebe8f20ae4",
    )
    go_repository(
        name = "in_gopkg_alecthomas_kingpin_v2",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/alecthomas/kingpin.v2",
        sum = "h1:jMFz6MfLP0/4fUyZle81rXUoxOBFi19VUFKVDOQfozc=",
        version = "v2.2.6",
    )
    go_repository(
        name = "in_gopkg_check_v1",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/check.v1",
        sum = "h1:YR8cESwS4TdDjEe65xsg0ogRM/Nc3DYOhEAlW+xobZo=",
        version = "v1.0.0-20190902080502-41f04d3bba15",
    )
    go_repository(
        name = "in_gopkg_cheggaaa_pb_v1",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/cheggaaa/pb.v1",
        sum = "h1:n1tBJnnK2r7g9OW2btFH91V92STTUevLXYFb8gy9EMk=",
        version = "v1.0.28",
    )
    go_repository(
        name = "in_gopkg_errgo_v2",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/errgo.v2",
        sum = "h1:0vLT13EuvQ0hNvakwLuFZ/jYrLp5F3kcWHXdRggjCE8=",
        version = "v2.1.0",
    )
    go_repository(
        name = "in_gopkg_fsnotify_v1",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/fsnotify.v1",
        sum = "h1:xOHLXZwVvI9hhs+cLKq5+I5onOuwQLhQwiu63xxlHs4=",
        version = "v1.4.7",
    )
    go_repository(
        name = "in_gopkg_inf_v0",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/inf.v0",
        sum = "h1:73M5CoZyi3ZLMOyDlQh031Cx6N9NDJ2Vvfl76EDAgDc=",
        version = "v0.9.1",
    )
    go_repository(
        name = "in_gopkg_src_d_go_cli_v0",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/src-d/go-cli.v0",
        sum = "h1:mXa4inJUuWOoA4uEROxtJ3VMELMlVkIxIfcR0HBekAM=",
        version = "v0.0.0-20181105080154-d492247bbc0d",
    )
    go_repository(
        name = "in_gopkg_src_d_go_log_v1",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/src-d/go-log.v1",
        sum = "h1:heWvX7J6qbGWbeFS/aRmiy1eYaT+QMV6wNvHDyMjQV4=",
        version = "v1.0.1",
    )
    go_repository(
        name = "in_gopkg_tomb_v1",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/tomb.v1",
        sum = "h1:uRGJdciOHaEIrze2W8Q3AKkepLTh2hOroT7a+7czfdQ=",
        version = "v1.0.0-20141024135613-dd632973f1e7",
    )
    go_repository(
        name = "in_gopkg_yaml_v2",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/yaml.v2",
        sum = "h1:clyUAQHOM3G0M3f5vQj7LuJrETvjVot3Z5el9nffUtU=",
        version = "v2.3.0",
    )
    go_repository(
        name = "in_gopkg_yaml_v3",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/yaml.v3",
        sum = "h1:tQIYjPdBoyREyB9XMu+nnTclpTYkz2zFM+lzLJFO4gQ=",
        version = "v3.0.0-20200615113413-eeeca48fe776",
    )
    go_repository(
        name = "io_opencensus_go",
        build_file_proto_mode = "disable",
        importpath = "go.opencensus.io",
        sum = "h1:LYy1Hy3MJdrCdMwwzxA/dRok4ejH+RwNGbuoD9fCjto=",
        version = "v0.22.4",
    )
    go_repository(
        name = "io_opentelemetry_go_otel",
        build_file_proto_mode = "disable",
        importpath = "go.opentelemetry.io/otel",
        sum = "h1:he/8j/EBlKjENVtDvFalawIUcQ+1E3uHRsvJZWLIa7M=",
        version = "v0.8.0",
    )
    go_repository(
        name = "io_rsc_binaryregexp",
        build_file_proto_mode = "disable",
        importpath = "rsc.io/binaryregexp",
        sum = "h1:HfqmD5MEmC0zvwBuF187nq9mdnXjXsSivRiXN7SmRkE=",
        version = "v0.2.0",
    )
    go_repository(
        name = "io_rsc_letsencrypt",
        build_file_proto_mode = "disable",
        importpath = "rsc.io/letsencrypt",
        sum = "h1:CWRvaqcmyyWMhhhGes73TvuIjf7O3Crq6F+Xid/cWNI=",
        version = "v0.0.2",
    )
    go_repository(
        name = "io_rsc_quote_v3",
        build_file_proto_mode = "disable",
        importpath = "rsc.io/quote/v3",
        sum = "h1:9JKUTTIUgS6kzR9mK1YuGKv6Nl+DijDNIc0ghT58FaY=",
        version = "v3.1.0",
    )
    go_repository(
        name = "io_rsc_sampler",
        build_file_proto_mode = "disable",
        importpath = "rsc.io/sampler",
        sum = "h1:7uVkIFmeBqHfdjD+gZwtXXI+RODJ2Wc4O7MPEh/QiW4=",
        version = "v1.3.0",
    )
    go_repository(
        name = "org_apache_git_thrift_git",
        build_file_proto_mode = "disable",
        importpath = "git.apache.org/thrift.git",
        sum = "h1:OR8VhtwhcAI3U48/rzBsVOuHi0zDPzYI1xASVcdSgR8=",
        version = "v0.0.0-20180902110319-2566ecd5d999",
    )
    go_repository(
        name = "org_bazil_fuse",
        build_file_proto_mode = "disable",
        importpath = "bazil.org/fuse",
        sum = "h1:utDghgcjE8u+EBjHOgYT+dJPcnDF05KqWMBcjuJy510=",
        version = "v0.0.0-20200117225306-7b5117fecadc",
    )
    go_repository(
        name = "org_go4",
        build_file_proto_mode = "disable",
        importpath = "go4.org",
        sum = "h1:BNJlw5kRTzdmyfh5U8F93HA2OwkP7ZGwA51eJ/0wKOU=",
        version = "v0.0.0-20200411211856-f5505b9728dd",
    )
    go_repository(
        name = "org_go4_grpc",
        build_file_proto_mode = "disable",
        importpath = "grpc.go4.org",
        sum = "h1:tmXTu+dfa+d9Evp8NpJdgOy6+rt8/x4yG7qPBrtNfLY=",
        version = "v0.0.0-20170609214715-11d0a25b4919",
    )
    go_repository(
        name = "org_golang_google_api",
        build_file_proto_mode = "disable",
        importpath = "google.golang.org/api",
        sum = "h1:0q95w+VuFtv4PAx4PZVQdBMmYbaCHbnfKaEiDIcVyag=",
        version = "v0.17.0",
    )
    go_repository(
        name = "org_golang_google_appengine",
        build_file_proto_mode = "disable",
        importpath = "google.golang.org/appengine",
        sum = "h1:tycE03LOZYQNhDpS27tcQdAzLCVMaj7QT2SXxebnpCM=",
        version = "v1.6.5",
    )
    go_repository(
        name = "org_golang_google_cloud",
        build_file_proto_mode = "disable",
        importpath = "google.golang.org/cloud",
        sum = "h1:Cpp2P6TPjujNoC5M2KHY6g7wfyLYfIWRZaSdIKfDasA=",
        version = "v0.0.0-20151119220103-975617b05ea8",
    )
    go_repository(
        name = "org_golang_google_genproto",
        build_file_proto_mode = "disable",
        importpath = "google.golang.org/genproto",
        sum = "h1:1mbrb1tUU+Zmt5C94IGKADBTJZjZXAd+BubWi7r9EiI=",
        version = "v0.0.0-20200212174721-66ed5ce911ce",
    )
    go_repository(
        name = "org_golang_google_grpc",
        build_file_proto_mode = "disable",
        importpath = "google.golang.org/grpc",
        sum = "h1:M5a8xTlYTxwMn5ZFkwhRabsygDY5G8TYLyQDBxJNAxE=",
        version = "v1.30.0",
    )
    go_repository(
        name = "org_golang_google_protobuf",
        build_file_proto_mode = "disable",
        importpath = "google.golang.org/protobuf",
        sum = "h1:4MY060fB1DLGMB/7MBTLnwQUY6+F09GEiz6SsrNqyzM=",
        version = "v1.23.0",
    )
    go_repository(
        name = "org_golang_x_build",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/build",
        sum = "h1:E2M5QgjZ/Jg+ObCQAudsXxuTsLj7Nl5RV/lZcQZmKSo=",
        version = "v0.0.0-20190111050920-041ab4dc3f9d",
    )
    go_repository(
        name = "org_golang_x_crypto",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/crypto",
        sum = "h1:DZhuSZLsGlFL4CmhA8BcRA0mnthyA/nZ00AqCUo7vHg=",
        version = "v0.0.0-20200709230013-948cd5f35899",
    )
    go_repository(
        name = "org_golang_x_exp",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/exp",
        sum = "h1:zkO/Lhoka23X63N9OSzpSeROEUQ5ODw47tM3YWjygbs=",
        version = "v0.0.0-20200207192155-f17229e696bd",
    )
    go_repository(
        name = "org_golang_x_image",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/image",
        sum = "h1:+qEpEAPhDZ1o0x3tHzZTQDArnOixOzGD9HUJfcg0mb4=",
        version = "v0.0.0-20190802002840-cff245a6509b",
    )
    go_repository(
        name = "org_golang_x_lint",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/lint",
        sum = "h1:Wh+f8QHJXR411sJR8/vRBTZ7YapZaRvUcLFFJhusH0k=",
        version = "v0.0.0-20200302205851-738671d3881b",
    )
    go_repository(
        name = "org_golang_x_mobile",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/mobile",
        sum = "h1:4+4C/Iv2U4fMZBiMCc98MG1In4gJY5YRhtpDNeDeHWs=",
        version = "v0.0.0-20190719004257-d2bd2a29d028",
    )
    go_repository(
        name = "org_golang_x_mod",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/mod",
        sum = "h1:RM4zey1++hCTbCVQfnWeKs9/IEsaBLA8vTkd0WVtmH4=",
        version = "v0.3.0",
    )
    go_repository(
        name = "org_golang_x_net",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/net",
        sum = "h1:wBouT66WTYFXdxfVdz9sVWARVd/2vfGcmI45D2gj45M=",
        version = "v0.0.0-20201006153459-a7d1128ccaa0",
    )
    go_repository(
        name = "org_golang_x_oauth2",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/oauth2",
        sum = "h1:TzXSXBo42m9gQenoE3b9BGiEpg5IG2JkU5FkPIawgtw=",
        version = "v0.0.0-20200107190931-bf48bf16ab8d",
    )
    go_repository(
        name = "org_golang_x_perf",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/perf",
        sum = "h1:xYq6+9AtI+xP3M4r0N1hCkHrInHDBohhquRgx9Kk6gI=",
        version = "v0.0.0-20180704124530-6e6d33e29852",
    )
    go_repository(
        name = "org_golang_x_sync",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/sync",
        sum = "h1:qwRHBd0NqMbJxfbotnDhm2ByMI1Shq4Y6oRJo21SGJA=",
        version = "v0.0.0-20200625203802-6e8e738ad208",
    )
    go_repository(
        name = "org_golang_x_sys",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/sys",
        sum = "h1:+Nyd8tzPX9R7BWHguqsrbFdRx3WQ/1ib8I44HXV5yTA=",
        version = "v0.0.0-20200930185726-fdedc70b468f",
    )
    go_repository(
        name = "org_golang_x_text",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/text",
        sum = "h1:cokOdA+Jmi5PJGXLlLllQSgYigAEfHXJAERHVMaCc2k=",
        version = "v0.3.3",
    )
    go_repository(
        name = "org_golang_x_time",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/time",
        sum = "h1:SvFZT6jyqRaOeXpc5h/JSfZenJ2O330aBsf7JfSUXmQ=",
        version = "v0.0.0-20190308202827-9d24e82272b4",
    )
    go_repository(
        name = "org_golang_x_tools",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/tools",
        sum = "h1:onHykNOjYYTQ3AMcREXdnzWl4I4CIs9BMiMkJ7ctODc=",
        version = "v0.0.0-20200716134326-a8f9df4c9543",
    )
    go_repository(
        name = "org_golang_x_xerrors",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/xerrors",
        sum = "h1:E7g+9GITq07hpfrRu66IVDexMakfv52eLZ2CXBWiKr4=",
        version = "v0.0.0-20191204190536-9bdfabe68543",
    )
    go_repository(
        name = "org_uber_go_atomic",
        build_file_proto_mode = "disable",
        importpath = "go.uber.org/atomic",
        sum = "h1:Ezj3JGmsOnG1MoRWQkPBsKLe9DwWD9QeXzTRzzldNVk=",
        version = "v1.6.0",
    )
    go_repository(
        name = "org_uber_go_dig",
        build_file_proto_mode = "disable",
        importpath = "go.uber.org/dig",
        sum = "h1:pJTDXKEhRqBI8W7rU7kwT5EgyRZuSMVSFcZolOvKK9U=",
        version = "v1.9.0",
    )
    go_repository(
        name = "org_uber_go_fx",
        build_file_proto_mode = "disable",
        importpath = "go.uber.org/fx",
        sum = "h1:+1+3Cz9M0dFMPy9SW9XUIUHye8bnPUm7q7DroNGWYG4=",
        version = "v1.12.0",
    )
    go_repository(
        name = "org_uber_go_goleak",
        build_file_proto_mode = "disable",
        importpath = "go.uber.org/goleak",
        sum = "h1:qsup4IcBdlmsnGfqyLl4Ntn3C2XCCuKAE7DwHpScyUo=",
        version = "v1.0.0",
    )
    go_repository(
        name = "org_uber_go_multierr",
        build_file_proto_mode = "disable",
        importpath = "go.uber.org/multierr",
        sum = "h1:KCa4XfM8CWFCpxXRGok+Q0SS/0XBhMDbHHGABQLvD2A=",
        version = "v1.5.0",
    )
    go_repository(
        name = "org_uber_go_tools",
        build_file_proto_mode = "disable",
        importpath = "go.uber.org/tools",
        sum = "h1:0mgffUl7nfd+FpvXMVz4IDEaUSmT1ysygQC7qYo7sG4=",
        version = "v0.0.0-20190618225709-2cfd321de3ee",
    )
    go_repository(
        name = "org_uber_go_zap",
        build_file_proto_mode = "disable",
        importpath = "go.uber.org/zap",
        sum = "h1:ZZCA22JRF2gQE5FoNmhmrf7jeJJ2uhqDUNRYKm8dvmM=",
        version = "v1.15.0",
    )
    go_repository(
        name = "tech_berty_go_ipfs_log",
        build_file_proto_mode = "disable",
        importpath = "berty.tech/go-ipfs-log",
        sum = "h1:VBdyZgdkeIt17LS4UX6rJjmskqvfIHaOAEH9Z8aqvIM=",
        version = "v1.2.6",
    )
    go_repository(
        name = "tech_berty_go_orbit_db",
        build_file_proto_mode = "disable",
        importpath = "berty.tech/go-orbit-db",
        sum = "h1:4wljpof6+aICgDWVI9whyop99zF2SoWUT8dt/32JSfs=",
        version = "v1.10.10",
    )
