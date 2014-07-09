#!/usr/bin/env python
import json
import base64
from jinja2 import Environment

with open("config.json") as f:
    config = json.load(f)

with open("nginx.conf.j2") as f:
    template = f.read()

environment = Environment()
environment.filters['b64encode'] = base64.b64encode
t = environment.from_string(template)
print t.render(config=config)
