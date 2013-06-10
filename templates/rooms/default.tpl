#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

{{ symbol_name }}: {{ room_class }} '{{ room_name }}'
   {% if exit_direction %}{{ exit_direction }} = {{ exit_location }}
    out asExit({{ exit_direction }}){% endif %}
;