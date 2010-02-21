% Copyright 2010, Scatterbit, Inc. & Jayson Vantuyl <jvantuyl@scatterbit.com>
%
% This file is part of erlctl.
%
% Erlctl is open source.  See LICENSE.txt for details.
-module (erlctl_err).
-export([format/1,format/2]).
-export([unknown_command/0,networking_failure/0,remote_error/1,
  cannot_start_vm/2, halt_with_error/0, bad_cmdline/2]).

bad_cmdline(Msg,Data) ->
  Opts = erlctl:get_opts(),
  CmdLine = proplists:get_value(cmdline,Opts),
  format("error processing command line: ~p~n  " ++ Msg ++ "~n",
    [CmdLine | Data]),
  halt(249).

unknown_command() ->
  Opts = erlctl:get_opts(),
  App = proplists:get_value(app,Opts),
  Cmd = proplists:get_value(command,Opts),
  format("command ~s not recognized (for application ~s)~n",[Cmd,App]),
  format("  try command \"help\" for instructions~n"),
  halt(250).

networking_failure() ->
  format("Unable to start networking!~n",[]),
  halt(251).

remote_error(Data) ->
  format("Error on remote node: ~p~n",Data),
  halt(252).

cannot_start_vm(Msg,Data) ->
  format("Error starting new Erlang node: " ++ Msg ++ "~n",Data),
  halt(253).

halt_with_error() ->
  format("unspecified fatal error~n",[]),
  halt(255).

format(M) ->
  format(M,[]).

format(M,D) ->
  try
    io:format(standard_error,M,D)
  catch
    _:_ ->
      io:format(M,D)
  end.
