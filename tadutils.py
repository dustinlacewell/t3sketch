import os

from jinja2 import Environment

FLIPS = {
    'north': 'south',
    'south': 'north',
    'east': 'west',
    'west': 'east',
    'northeast': 'southwest',
    'southwest': 'northeast',
    'northwest': 'southeast',
    'southeast': 'northwest',
}

def mkdir(path):
    try:
        os.mkdir(path)
    except:
        print "Could not create path: %s" % path
        exit()

def file_as_lines(filename):
    with open(filename, 'r') as fobj:
        lines = fobj.read().splitlines()
    return lines

def find_class(lines, cls):
    start = None
    for idx, line in enumerate(lines):
        if str(line).strip():
            line = line.replace('+', '')
            parts = line.split()
            if parts[0].endswith(':') and parts[0] == cls + ':':
                start = idx
            if start and line[:1] == ';':
                return start, idx

def insert_into_class(lines, cls, line):
    retval = find_class(lines, cls)
    if retval is not None:
        start, end = retval
        search = line.split()[0]
        for i in range(start, end+1):
            if lines[i].strip():
                if lines[i].split()[0] == search:
                    replaced = lines[i]
                    lines[i] = line
                    return replaced
        lines.insert(end, line)

def insert_after_class(lines, cls, text):
    search = text.splitlines()
    search = search[0]
    search = search.replace('+', '')
    search = search.split()
    search = search[0]
    search = search.strip()
    remove_class(lines, search[:-1])
    lines.append(text)

def remove_class(lines, cls):
    retval = find_class(lines, cls)
    if retval:
        start, end = retval
        del lines[start:end+1]

def get_name_parts(room_name):
    parts = []
    broken = room_name.split()
    for piece in broken:
        _parts = piece.split('-')
        for part in _parts:
            parts.append(part)
    return parts

def name_parts_to_symbol_name(name_parts):
    for idx, part in enumerate(name_parts):
        if idx == 0:
            name_parts[idx] = part.lower()
        else:
            name_parts[idx] = part.capitalize()
    return ''.join(name_parts)

def filenames_to_master_door_name(exit, entry):
    exit_symbol = filename_to_symbol_name(exit)
    entry_symbol = filename_to_symbol_name(entry)
    return "%s%sInsideDoor" % (
        exit_symbol, entry_symbol[0].capitalize() + entry_symbol[1:]
    )

def filenames_to_slave_door_name(exit, entry):
    exit_symbol = filename_to_symbol_name(exit)
    entry_symbol = filename_to_symbol_name(entry)
    return "%s%sOutsideDoor" % (
        exit_symbol, entry_symbol[0].capitalize() + entry_symbol[1:]
    )

def filenames_to_window_name(exit, entry):
    exit_symbol = filename_to_symbol_name(exit)
    entry_symbol = filename_to_symbol_name(entry)
    return "%s%sWindow" % (
        exit_symbol, entry_symbol[0].capitalize() + entry_symbol[1:]
    )

def name_parts_to_room_name(name_parts):
    return ' '.join([p.lower() for p in name_parts])

def name_parts_to_folder_name(name_parts):
    return '-'.join([p.lower() for p in name_parts])

def name_parts_to_file_name(name_parts):
    return ('_'.join([p.lower() for p in name_parts])) + '.t'

def get_template(name):
    with open(name, 'r') as fobj:
        return Environment().from_string(fobj.read())

def render_template(template, context):
    template = get_template(template)
    return template.render(context)

def filename_to_symbol_name(room_filename):
    filename = os.path.basename(room_filename).split('.')[0]
    name_parts = filename.split('_')
    return name_parts_to_symbol_name(name_parts)

# ROOMS

def add_backreference(source_file, direction, destination):
    room_symbol = filename_to_symbol_name(source_file)
    lines = file_as_lines(source_file)    
    insert_into_class(lines, room_symbol, "\n    %s = %s" % (direction, destination))

    with open(source_file, 'w') as fobj:
        fobj.write('\n'.join(lines))

def create_room(name_parts, location, source = None, direction = None, room_class='Room', template='templates/rooms/default.tpl'):
    room_parts = []
    for part in name_parts:
        parts = part.split('-')
        for subpart in parts:
            room_parts.append(subpart)

    name_parts = room_parts
    room_name = name_parts_to_room_name(name_parts)
    room_symbol = name_parts_to_symbol_name(name_parts)
    folder_name = name_parts_to_folder_name(name_parts)
    file_name = name_parts_to_file_name(name_parts)
    full_path = os.path.join(location, folder_name)

    if os.path.isdir(full_path):
        print "Room already exists at %s" % full_path
        exit()


    context = {
            'room_name': room_name,
            'room_class': room_class,
            'symbol_name': room_symbol,
    }

    if source and direction:
        context['exit_direction'] = FLIPS[direction]
        context['exit_location'] = filename_to_symbol_name(source)

    code = render_template(template, context)

    mkdir(full_path)

    file_path = os.path.join(full_path, file_name)
    with open(file_path, 'w') as fobj:
        fobj.write(code)

    if source and direction:
        add_backreference(source, direction, room_symbol)

    return file_path

# EXITS
def create_exit(first_file, direction, second_file, out=False):
    first_symbol = filename_to_symbol_name(first_file)
    second_symbol = filename_to_symbol_name(second_file)
    lines = file_as_lines(first_file)

    insert_into_class(lines, first_symbol, "    %s = %s" % (direction, second_symbol))
    if out:
        insert_into_class(lines, first_symbol, "    out asExit(%s)" % (direction, ))

    with open(first_file, 'w') as fobj:
        fobj.write('\n'.join(lines))


# DOORS
def create_master_door(inside_room, outside_room, direction, door_class='Door', template='templates/doors/default.tpl'):
    inside_symbol = filename_to_symbol_name(inside_room)
    outside_symbol = filename_to_symbol_name(outside_room)
    master_door_name = filenames_to_master_door_name(
        inside_room, outside_room
    )
    lines = file_as_lines(inside_room)
    insert_into_class(lines, inside_symbol, "\n    %s = %s" % (direction, master_door_name))

    context = {
        'door_name': master_door_name,
        'door_class': door_class,
        'direction': direction,
    }

    code = render_template(template, context)
    insert_after_class(lines, inside_symbol, code)

    with open(inside_room, 'w') as fobj:
        fobj.write('\n'.join(lines))

def create_slave_door(inside_room, outside_room, direction, door_class='Door', template='templates/doors/default.tpl'):
    inside_symbol = filename_to_symbol_name(inside_room)
    outside_symbol = filename_to_symbol_name(outside_room)
    master_door_name = filenames_to_master_door_name(
        inside_room, outside_room
    )
    slave_door_name = filenames_to_slave_door_name(
        inside_room, outside_room
    )
    direction = FLIPS[direction]
    lines = file_as_lines(outside_room)
    insert_into_class(lines, outside_symbol, "\n    %s = %s" % (direction, slave_door_name))

    context = {
        'door_name': slave_door_name,
        'door_class': door_class,
        'master_door_name': master_door_name,
        'direction': direction,
    }

    code = render_template(template, context)
    insert_after_class(lines, outside_symbol, code)

    with open(outside_room, 'w') as fobj:
        fobj.write('\n'.join(lines))

# WINDOWS
def create_window(inside_room, outside_room, direction, window_class='Window', template='templates/windows/default.tpl'):
    inside_symbol = filename_to_symbol_name(inside_room)
    outside_symbol = filename_to_symbol_name(outside_room)
    window_name = filenames_to_window_name(inside_room, outside_room)
    lines = file_as_lines(inside_room)
    context = {
        'window_name': window_name,
        'inside_symbol': inside_symbol,
        'outside_symbol': outside_symbol,
        'window_class': window_class,
        'direction': direction,
    }

    code = render_template(template, context)
    insert_after_class(lines, inside_symbol, code)

    with open(inside_room, 'w') as fobj:
        fobj.write('\n'.join(lines))
