
:- initialization((
    set_logtalk_flag(report, warnings),
    set_logtalk_flag(events, allow),
    set_logtalk_flag(debug, on),
    set_prolog_flag(verbose_load, true),
    logtalk_load(tutor(loader)),
    logtalk_load(tools(loader)), 
    logtalk_load(debugger(loader)), 
    logtalk_load('Set1', [source_data(on), debug(on)]),
    logtalk_load('Set1Tests', [context_switching_calls(allow), source_data(on),debug(on)]),
    tests::run
)).
