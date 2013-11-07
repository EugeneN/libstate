_AppState = window.AppState # FIXME FIXME FIXME
MY_STATE = '_state'

# XXX this module is in proof-of-concept stage currently

lazy_init_my_state = ->
    _AppState.modstate or= {}
    _AppState.modstate[MY_STATE] or= {}
    _AppState.modstate[MY_STATE].watchers or= {}

get_state = (key, __AppState) ->
    if key and key isnt MY_STATE
        lazy_init_my_state()
        _AppState.modstate[key]
    else
        undefined

swap_state = (key, mutator) ->
    if key and key isnt MY_STATE
        lazy_init_my_state()

        old_state = _AppState.modstate[key]
        new_state = mutator old_state
        _AppState.modstate[key] = new_state
        _AppState.modstate[MY_STATE].watchers[key]?.map (h) ->
            h old_state, new_state

watch_state = (key, handler) ->
    lazy_init_my_state()
    _AppState.modstate[MY_STATE].watchers[key] or= []
    unless handler in _AppState.modstate[MY_STATE].watchers[key]
        _AppState.modstate[MY_STATE].watchers[key].push handler

unwatch_state = (key, handler) ->
    lazy_init_my_state()
    _AppState.modstate[MY_STATE].watchers[key] or= []
    if handler in _AppState.modstate[MY_STATE].watchers[key]
        _AppState.modstate[MY_STATE].watchers[key] = \
            _AppState.modstate[MY_STATE].watchers[key].filter (h) -> h isnt handler


module.exports = {get_state, swap_state, watch_state, unwatch_state}


