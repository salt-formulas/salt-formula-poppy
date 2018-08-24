{%- if pillar.poppy is defined %}
include:
{%- if pillar.poppy.creature is defined %}
- poppy.creature
{%- endif %}
{%- endif %}
