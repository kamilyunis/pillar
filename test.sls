{% for file in [
  '/usr/share/doc/zabbix-server-mysql-1.8.22/create/schema/mysql.sql',
  '/usr/share/doc/zabbix-server-mysql-1.8.22/create/data/data.sql'
  '/usr/share/doc/zabbix-server-mysql-1.8.22/create/data/images_mysql.sql'
] %}
{{ file }}:
  file:
    - managed
    - makedirs: True
    - source: {{ files_switch('zabbix', [ file ]) }}
  cmd:
    - run
    - name: /usr/bin/mysql -h {{ dbhost }} -u {{ dbuser }} --password={{ dbpass }} {{ dbname }} < {{ file }} && touch {{ file }}.applied
    - unless: test -f {{ file }}.applied
    - require:
      - file: {{ file }}
      - pkg: mysql-client
{% endfor %}
