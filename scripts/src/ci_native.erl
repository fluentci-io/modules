%% OTP primitives only: no validation, credentials policy or release logic.
-module(ci_native).
-include_lib("kernel/include/file.hrl").
-export([arguments/0, env/1, set_env/2, unset_env/1, cwd/0, absolute/1,
         platform/0, read/1, write/2, append/2, mkdir/1, remove/1,
         rename/2, copy/2, regular/1, size/1, chmod/2, temp/1, nonce/0,
         sha256/1, read_line/0, stderr/1, stdout/1, halt/1, execute/5,
         archive_entries/1, archive_member/2, create_archive/2, list_dir/1, is_directory/1, architecture/0, cpu_cores/0, find_executable/1, parallel/2, serial/1, with_slots/3, tcp/3, execute_timeout/6, open_process/3, read_process/2, signal_process/2, monotonic_ms/0, regex/2]).
text(X) -> unicode:characters_to_binary(X).
error_text(X) -> text(io_lib:format("~tp", [X])).
result(ok) -> {ok, nil};
result({ok, V}) -> {ok, V};
result({error, E}) -> {error, error_text(E)}.
arguments() ->
    io:setopts(standard_io, [{encoding, unicode}]),
    Args = init:get_plain_arguments(),
    UserArgs = try
        Script = filename:absname(escript:script_name()),
        case Args of
            ["--", First | Rest] -> case filename:absname(First) =:= Script of true -> Rest; false -> Args end;
            [First | Rest] -> case filename:absname(First) =:= Script of true -> Rest; false -> Args end;
            [] -> []
        end
    catch _:_ -> Args end,
    [text(X) || X <- UserArgs].
env(Name) -> case os:getenv(unicode:characters_to_list(Name)) of false -> <<>>; X -> text(X) end.
set_env(Name, Value) -> os:putenv(unicode:characters_to_list(Name), unicode:characters_to_list(Value)), nil.
unset_env(Name) -> os:unsetenv(unicode:characters_to_list(Name)), nil.
cwd() -> {ok, X} = file:get_cwd(), text(X).
absolute(X) -> text(filename:absname(X)).
platform() -> {_, X} = os:type(), atom_to_binary(X, utf8).
read(Path) -> result(file:read_file(Path)).
write(Path, Data) -> result(file:write_file(Path, Data)).
append(Path, Data) -> result(file:write_file(Path, Data, [append])).
mkdir(Path) -> result(filelib:ensure_dir(filename:join(Path, <<".directory">>))).
remove(Path) ->
    case file:read_link_info(Path) of
        {error, enoent} -> {ok, nil};
        {ok, #file_info{type=directory}} -> result(file:del_dir_r(Path));
        {ok, _} -> result(file:delete(Path));
        E -> result(E)
    end.
rename(A, B) -> result(file:rename(A, B)).
copy(A, B) -> case file:copy(A, B) of {ok, _} -> {ok, nil}; E -> result(E) end.
regular(Path) -> case file:read_link_info(Path) of {ok, #file_info{type=regular}} -> true; _ -> false end.
size(Path) -> case file:read_file_info(Path) of {ok, #file_info{size=N}} -> N; _ -> -1 end.
chmod(Path, Mode) -> result(file:change_mode(Path, Mode)).
nonce() ->
    {ok, _} = application:ensure_all_started(crypto),
    binary:encode_hex(crypto:strong_rand_bytes(16), lowercase).
temp(Prefix) ->
    Base = case os:getenv("TMPDIR") of false -> "/tmp"; Value -> Value end,
    Path = filename:join(text(Base), <<Prefix/binary, (nonce())/binary>>),
    case file:make_dir(Path) of
        ok -> case file:change_mode(Path, 8#700) of ok -> {ok, Path}; E -> result(E) end;
        E -> result(E)
    end.
sha256(Data) ->
    {ok, _} = application:ensure_all_started(crypto),
    binary:encode_hex(crypto:hash(sha256, Data), lowercase).
read_line() -> case io:get_line(standard_io, "") of eof -> {error, nil}; {error, _} -> {error, nil}; X -> {ok, text(X)} end.
stderr(X) -> io:put_chars(standard_error, X), nil.
stdout(X) -> io:put_chars(standard_io, X), nil.
halt(N) -> erlang:halt(N).
execute(Program, Args, Cwd, Stream, MergeStderr) -> execute_timeout(Program,Args,Cwd,Stream,MergeStderr,7200000).
execute_timeout(Program, Args, Cwd, Stream, MergeStderr, Timeout) ->
    case os:find_executable(unicode:characters_to_list(Program)) of
        false -> {127, <<"Executable unavailable: ", Program/binary>>};
        Executable ->
            try
                Errors = case MergeStderr of true -> [stderr_to_stdout]; false -> [] end,
                Port = open_port({spawn_executable, Executable}, [binary, exit_status, use_stdio,
                    {args, [unicode:characters_to_list(A) || A <- Args]}, {cd, unicode:characters_to_list(Cwd)} | Errors]),
                Started = erlang:monotonic_time(millisecond),
                Label = <<Program/binary, " cwd=", Cwd/binary>>,
                collect(Port, Stream, [], 0, Started+Timeout, Label, Started)
            catch _:Reason -> {127, error_text(Reason)} end
    end.
collect(Port, Stream, Chunks, Size, Deadline, Label, Started) ->
    Remaining = max(0, Deadline-erlang:monotonic_time(millisecond)),
    receive
        {Port, {data, Data}} when Size + byte_size(Data) =< 67108864 ->
            case Stream of true -> io:put_chars(standard_error, Data); false -> ok end,
            collect(Port, Stream, [Data | Chunks], Size + byte_size(Data), Deadline, Label, Started);
        {Port, {data, _}} -> port_close(Port), {1, <<"Command output exceeded 64 MiB">>};
        {Port, {exit_status, Code}} -> {Code, iolist_to_binary(lists:reverse(Chunks))}
    after min(Remaining, 30000) ->
        case erlang:monotonic_time(millisecond) >= Deadline of
            true -> port_close(Port), {124, <<"Command timeout">>};
            false ->
                case Stream of
                    true -> io:put_chars(standard_error, io_lib:format("[progress] ~ts elapsed=~Bs; no output for 30 seconds~n", [Label, (erlang:monotonic_time(millisecond)-Started) div 1000]));
                    false -> ok
                end,
                collect(Port, Stream, Chunks, Size, Deadline, Label, Started)
        end
    end.
archive_entries(Path) ->
    case erl_tar:table(unicode:characters_to_list(Path), [compressed, verbose]) of
        {ok, Rows} -> {ok, [{text(Name), atom_to_binary(Type, utf8), Size, Mode}
                           || {Name, Type, Size, _, Mode, _, _} <- Rows]};
        E -> result(E)
    end.
archive_member(Path, Name) ->
    case erl_tar:extract(unicode:characters_to_list(Path), [compressed, memory, {files, [unicode:characters_to_list(Name)]}]) of
        {ok, [{_, Data}]} -> {ok, Data};
        {ok, _} -> {error, <<"Missing archive member: ", Name/binary>>};
        E -> result(E)
    end.

create_archive(Path, Files) ->
    case temp(<<"fluentci-tar-">>) of
        {ok, Directory} ->
            try create_archive(Path, Files, Directory)
            after file:del_dir_r(Directory) end;
        Error -> Error
    end.

create_archive(Path, Files, Directory) ->
    case erl_tar:open(unicode:characters_to_list(Path), [write, compressed]) of
        {ok, Tar} ->
            Written = try
                lists:foldl(fun
                    (Entry, ok) -> add_archive_entry(Tar, Entry, Directory);
                    (_, Error) -> Error
                end, ok, Files)
            catch _:Reason -> {error, Reason} end,
            Closed = erl_tar:close(Tar),
            case Written of ok -> result(Closed); Error -> result(Error) end;
        Error -> result(Error)
    end.

add_archive_entry(Tar, {Name, Bytes, Mode}, Directory) ->
    %% OTP 27 does not apply the mode option to binary entries. File-backed
    %% entries preserve permissions across supported OTP versions. Never use
    %% the archive member name as a staging path (it may contain ../).
    Staged = filename:join(Directory, nonce()),
    try
        case file:write_file(Staged, Bytes, [exclusive]) of
            ok ->
                case file:change_mode(Staged, Mode) of
                    ok -> erl_tar:add(Tar, unicode:characters_to_list(Staged),
                                      unicode:characters_to_list(Name), []);
                    Error -> Error
                end;
            Error -> Error
        end
    after file:delete(Staged) end.

list_dir(Path) ->
    case file:list_dir(Path) of
        {ok, Names} -> {ok, lists:sort([text(N) || N <- Names])};
        E -> result(E)
    end.
is_directory(Path) -> case file:read_link_info(Path) of {ok, #file_info{type=directory}} -> true; _ -> false end.
architecture() -> text(erlang:system_info(system_architecture)).
cpu_cores() ->
    _ = erlang:system_info(update_cpu_info),
    Available = case erlang:system_info(logical_processors_available) of
        N when is_integer(N), N > 0 -> N;
        _ -> max(1, erlang:system_info(schedulers_online))
    end,
    case erlang:system_info(cpu_quota) of
        Quota when is_integer(Quota), Quota > 0 -> min(Available, Quota);
        _ -> Available
    end.
find_executable(Name) -> case os:find_executable(unicode:characters_to_list(Name)) of false -> <<>>; P -> text(P) end.

parallel(Items, Fun) ->
    Workers = [begin
        Owner = self(), Ref = make_ref(),
        {Pid, Monitor} = spawn_monitor(fun() ->
            Value = try Fun(Item) catch Class:Reason -> {error, error_text({Class,Reason})} end,
            Owner ! {Ref, Value}
        end),
        {Pid, Monitor, Ref}
    end || Item <- Items],
    [receive
        {Ref, Value} -> demonitor(Monitor, [flush]), Value;
        {'DOWN', Monitor, process, Pid, Reason} -> {error, error_text(Reason)}
    end || {Pid, Monitor, Ref} <- Workers].
serial(Fun) -> global:trans({fluentci_modules_shared_dependencies, self()}, Fun).

with_slots(Resource, Limit, Fun) when is_integer(Limit), Limit >= 1, Limit =< 32 ->
    Slots = lists:seq(1, Limit),
    acquire_slot(Resource, Slots, Slots, Fun).
acquire_slot(Resource, [], Slots, Fun) ->
    receive after 100 -> acquire_slot(Resource, Slots, Slots, Fun) end;
acquire_slot(Resource, [Slot | Rest], Slots, Fun) ->
    case global:trans({{fluentci_ci_resource, Resource, Slot}, self()},
                      fun() -> {completed, Fun()} end, [node()], 0) of
        {completed, Value} -> Value;
        aborted -> acquire_slot(Resource, Rest, Slots, Fun)
    end.
tcp(Port, Request, Read) ->
    case gen_tcp:connect("127.0.0.1", Port, [binary, {active,false}], 10000) of
        {ok, Socket} ->
            try
                case gen_tcp:send(Socket, Request) of
                    ok when Read -> result(gen_tcp:recv(Socket, 0, 10000));
                    ok -> {ok, <<>>};
                    Error -> result(Error)
                end
            after gen_tcp:close(Socket) end;
        Error -> result(Error)
    end.
open_process(Program, Args, Cwd) ->
    case os:find_executable(unicode:characters_to_list(Program)) of
        false -> {error, <<"Missing executable: ",Program/binary>>};
        Exe -> try {ok,open_port({spawn_executable,Exe},[binary,exit_status,use_stdio,stderr_to_stdout,
                   {args,[unicode:characters_to_list(A)||A<-Args]},{cd,unicode:characters_to_list(Cwd)}])}
               catch _:Reason -> {error,error_text(Reason)} end
    end.
read_process(Port, Timeout) ->
    receive
        {Port,{data,Data}} -> {data,Data};
        {Port,{exit_status,Code}} -> {exited,Code}
    after Timeout -> timed_out end.
signal_process(Port, Signal) ->
    case erlang:port_info(Port,os_pid) of
        {os_pid,Pid} ->
            Args = ["-"++unicode:characters_to_list(Signal), "--", "-"++integer_to_list(Pid)],
            _ = execute(<<"kill">>,[text(A)||A<-Args],cwd(),false,true), nil;
        undefined -> nil
    end.
monotonic_ms() -> erlang:monotonic_time(millisecond).
regex(Pattern, Value) ->
    case re:run(Value, Pattern, [global, unicode, {capture,all_but_first,binary}]) of
        {match, Matches} -> Matches;
        nomatch -> []
    end.
