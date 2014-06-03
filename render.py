#!/usr/bin/env python
import json
from jinja2 import Template

with open("config.json") as f:
    config = json.load(f)

with open("nginx.conf.tmpl") as f:
    template = f.read()

t = Template(template)
print t.render(config=config)
