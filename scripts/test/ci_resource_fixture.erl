%% Exercise compiler-slot limits with real concurrent BEAM workers in CI.
-module(ci_resource_fixture).
-export([concurrency/1]).

concurrency(Limit) ->
    Counter = atomics:new(2, []),
    Results = ci_native:parallel(lists:seq(1, 8), fun(_) ->
        ci_native:with_slots(<<"fixture-concurrent-compilers">>, Limit, fun() ->
            Active = atomics:add_get(Counter, 1, 1),
            peak(Counter, Active),
            timer:sleep(30),
            atomics:sub(Counter, 1, 1),
            {ok, nil}
        end)
    end),
    {atomics:get(Counter, 2), length([ok || {ok, nil} <- Results])}.

peak(Counter, Active) ->
    Old = atomics:get(Counter, 2),
    case Active > Old of
        false -> ok;
        true ->
            case atomics:compare_exchange(Counter, 2, Old, Active) of
                ok -> ok;
                _ -> peak(Counter, Active)
            end
    end.
