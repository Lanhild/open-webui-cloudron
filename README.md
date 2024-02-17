# Open WebUI Cloudron App

This repository contains the Cloudron app package source for [Open-WebUI](https://github.com/open-webui/open-webui)

## Installation

Install using the [Cloudron command line tooling](https://cloudron.io/references/cli.html)

```
cloudron install --image registry.tld/image:0.1.0
```

## Building

The app package can be built using the [Cloudron command line tooling](https://cloudron.io/references/cli.html).

```
cd open-webui-cloudron

cloudron build
cloudron install
```

## Update checklist

* [ ] Upgrade `version` in `CloudronManifest.json`

## Known issues

* [ ] HTTP `500` error when uploading documents [#1](https://github.com/Lanhild/open-webui-cloudron/issues/1)
