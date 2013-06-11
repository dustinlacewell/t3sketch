+ {{ window_name }}: {{ window_class }} '{{ direction }} {{ flipped_direction }} window'
    firstLocation = {{ inside_symbol }}
    secondLocation = {{ outside_symbol }}
    locationList = [firstLocation, secondLocation]

    name = getState.name
    allStates = [{{ flipped_direction }}WindowState, {{ direction }}WindowState]
    getState = (gPlayerChar.isIn(firstLocation) ? {{ direction }}WindowState : {{ flipped_direction }}WindowState)
;