{%- from "poppy/map.jinja" import creature with context %}

c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.notebook_dir = '{{ creature.dir.notebooks }}'
c.NotebookApp.tornado_settings = {'headers': {'Content-Security-Policy': "frame-ancestors 'self' *"}}
c.NotebookApp.allow_origin = '*'
c.NotebookApp.extra_static_paths = ["static/custom/custom.js"]
c.NotebookApp.token = ''
c.NotebookApp.password = ''
