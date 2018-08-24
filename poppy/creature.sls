{%- from "poppy/map.jinja" import creature with context %}
{%- if creature.enabled %}

poppy_packages:
  pkg.installed:
  - names: {{ creature.pkgs }}

{{ creature.dir.base }}:
  virtualenv.manage:
  - system_site_packages: True
  - requirements: salt://poppy/files/requirements.txt
  - python: /usr/bin/python3
  - require:
    - pkg: poppy_packages

poppy_user:
  user.present:
  - name: poppy
  - system: true
  - home: {{ creature.dir.base }}
  - require:
    - virtualenv: {{ creature.dir.base }}

poppy_dir:
  file.directory:
  - names:
    - {{ creature.dir.logs }}
    - {{ creature.dir.jupyter }}
  - mode: 700
  - makedirs: true
  - user: poppy
  - require:
    - user: poppy_user

poppy_install:
  pip.installed:
  - name: {{ creature.kind }}
  - bin_env: {{ creature.dir.base }}
  - exists_action: w
  - require:
    - virtualenv: {{ creature.dir.base }}

{%- if creature.source.master.engine == 'git' %}

poppy_master_app:
  git.latest:
  - name: {{ creature.source.master.address }}
  - target: {{ creature.dir.master }}
  - rev: {{ creature.source.master.revision }}
  {%- if grains.saltversion >= "2015.8.0" %}
  - branch: {{ creature.source.master.revision }}
  {%- endif %}
  - force_reset: {{ creature.source.master.force_reset|default(False) }}
  - require:
    - pip: poppy_install

{%- endif %}

{%- if creature.source.monitor.engine == 'git' %}

poppy_master_monitor_plugin:
  git.latest:
  - name: {{ creature.source.monitor.address }}
  - target: {{ creature.dir.master }}/monitor
  - rev: {{ creature.source.monitor.revision }}
  {%- if grains.saltversion >= "2015.8.0" %}
  - branch: {{ creature.source.monitor.revision }}
  {%- endif %}
  - force_reset: {{ creature.source.monitor.force_reset|default(False) }}
  - require:
    - git: poppy_master_app

{%- endif %}

{%- if creature.source.snap.engine == 'git' %}

poppy_master_snap_plugin:
  git.latest:
  - name: {{ creature.source.snap.address }}
  - target: {{ creature.dir.master }}/snap
  - rev: {{ creature.source.snap.revision }}
  {%- if grains.saltversion >= "2015.8.0" %}
  - branch: {{ creature.source.snap.revision }}
  {%- endif %}
  - force_reset: {{ creature.source.snap.force_reset|default(False) }}
  - require:
    - git: poppy_master_app

{%- endif %}

{%- if creature.source.notebooks.engine == 'git' %}

poppy_master_notebooks:
  git.latest:
  - name: {{ creature.source.notebooks.address }}
  - target: {{ creature.dir.notebooks }}
  - rev: {{ creature.source.notebooks.revision }}
  {%- if grains.saltversion >= "2015.8.0" %}
  - branch: {{ creature.source.notebooks.revision }}
  {%- endif %}
  - force_reset: {{ creature.source.notebooks.force_reset|default(False) }}
  - require:
    - git: poppy_master_app

{%- endif %}

jupyter_config:
  file.managed:
  - name: {{ creature.dir.base }}/.jupyter/jupyter_notebook_config.py
  - source: salt://poppy/files/jupyter_notebook_config.py
  - template: jinja
  - user: poppy
  - mode: 644
  - require:
    - git: poppy_master_app

jupyter_custom_js:
  file.managed:
  - name: {{ creature.dir.base }}/.jupyter/custom/custom.js
  - source: salt://poppy/files/custom.js
  - user: poppy
  - mode: 644
  - require:
    - git: poppy_master_app

poppy_config:
  file.managed:
  - name: {{ creature.dir.base }}/.poppy_config.yaml
  - source: salt://poppy/files/config.yaml
  - template: jinja
  - user: poppy
  - mode: 644
  - require:
    - git: poppy_master_app
  - watch_in:
    - service: poppy_service

poppy_snap_examples_file:
  file.managed:
  - name: {{ creature.dir.master }}/snap/Examples/poppy-demo.xml
  - source: salt://poppy/files/poppy-demo.xml
  - user: poppy
  - mode: 644
  - require:
    - git: poppy_master_snap_plugin
  - watch_in:
    - service: poppy_service

poppy_snap_examples_config:
  file.managed:
  - name: {{ creature.dir.master }}/snap/Examples/EXAMPLES
  - source: salt://poppy/files/EXAMPLES
  - template: jinja
  - user: poppy
  - mode: 644
  - require:
    - git: poppy_master_snap_plugin
  - watch_in:
    - service: poppy_service

poppy_snap_libraries_file:
  file.managed:
  - name: {{ creature.dir.master }}/snap/libraries/poppy.xml
  - source: salt://poppy/files/pypot-snap-blocks.xml
  - user: poppy
  - mode: 644
  - require:
    - git: poppy_master_snap_plugin
  - watch_in:
    - service: poppy_service

poppy_libraries_config:
  file.managed:
  - name: {{ creature.dir.master }}/snap/libraries/LIBRARIES
  - source: salt://poppy/files/LIBRARIES
  - template: jinja
  - user: poppy
  - mode: 644
  - require:
    - git: poppy_master_snap_plugin
  - watch_in:
    - service: poppy_service

poppy_service_script:
  file.managed:
  - name: /etc/systemd/system/poppy-master.service
  - source: salt://poppy/files/poppy-master.service
  - template: jinja
  - user: root
  - mode: 644
  - watch_in:
    - module: poppy_restart_systemd

poppy_service:
  service.running:
  - name: poppy-master
  - enable: true
  - watch:
    - module: poppy_restart_systemd
    - file: poppy_service_script

jupyter_service_script:
  file.managed:
  - name: /etc/systemd/system/jupyter-notebook.service
  - source: salt://poppy/files/jupyter-notebook.service
  - template: jinja
  - user: root
  - mode: 644
  - watch_in:
    - module: poppy_restart_systemd

jupyter_service:
  service.running:
  - name: jupyter-notebook
  - enable: true
  - watch:
    - module: poppy_restart_systemd
    - file: jupyter_service_script

poppy_restart_systemd:
  module.wait:
  - name: service.systemctl_reload

{%- endif %}
