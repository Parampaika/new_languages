-module(main).
-import(io,[fwrite/1]).
-export([start/0]).


start() ->
    Coefficients = read_coefficients(),
    if 
        Coefficients =/= exit ->
            {Result, Iter} = trial_points(fun calculate_polynomial/2, -9, 10, 0.000001, Coefficients, 0),
            io:format("Minimum x: ~p at ~p iterations~n~n", [Result, Iter]),
            start();
        Coefficients == exit ->
            io:format("Exit~n")
    end.


trial_points(_Fun, A, B, Epsilon, _Coefficients, Iter) when abs(A - B) < Epsilon ->
    {(A + B) / 2, Iter};
trial_points(Fun, A, B, Epsilon, Coefficients, Iter) ->
    NewIter = Iter + 1,
    X1 = A + (B - A) / 4,
    X2 = A + (B - A) * 2 / 4,
    X3 = A + (B - A) * 3 / 4,
    Y1 = Fun(Coefficients, X1),
    Y2 = Fun(Coefficients, X2),
    Y3 = Fun(Coefficients, X3),
    case Y1 =< Y2 of
        true -> trial_points(Fun, A, X2, Epsilon, Coefficients, NewIter);
        false ->
            case Y2 =< Y3 of
                true -> trial_points(Fun, X1, X3, Epsilon, Coefficients, NewIter);
                false -> trial_points(Fun, X2, B, Epsilon, Coefficients, NewIter)
            end
    end.


read_coefficients() ->
    io:format("Enter the coefficients of the polynomial (separated by a space), starting with the lowest degree; enter 'q' to exit: "),
    Line = string:strip(io:get_line(""), right, $\n),
    case Line of
        "q" ->
            exit;
        _ ->
            lists:map(fun parse_number/1, string:tokens(Line, " "))
    end.


parse_number(X) ->
    case string:to_float(X) of
        {error,no_float} ->
            case string:to_integer(X) of
                {error,no_integer} ->
                    io:format("Not a number~n"),
                    erlang:exit(not_a_number);
                {F,_Rest} -> F
            end;
        {F,_Rest} -> F
    end.


calculate_polynomial(Coefficients, X) ->
    lists:foldl(fun(Coefficient, {Sum, Pow}) ->
                    NewSum = Sum + Coefficient * math:pow(X, Pow),
                    {NewSum, Pow + 1}
                end, {0, 0}, Coefficients).
