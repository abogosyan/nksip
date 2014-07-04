%% -------------------------------------------------------------------
%%
%% Copyright (c) 2013 Carlos Gonzalez Florido.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

%% @doc NkSIP Registrar Plugin Callbacks
-module(nksip_uac_auto_auth_callbacks).
-author('Carlos Gonzalez <carlosj.gf@gmail.com>').

-include("../../../include/nksip.hrl").
-include("../../../include/nksip_call.hrl").


-export([nkcb_parse_uac_opt/3, nkcb_uac_response/4]).


%%%%%%%%%%%%%%%% Implemented core plugin callbacks %%%%%%%%%%%%%%%%%%%%%%%%%

%% @doc Called to parse specific UAC options
-spec nkcb_parse_uac_opt(nksip:optslist(), nksip:request(), nksip:optslist()) ->
    {continue, list()}.

nkcb_parse_uac_opt(#sipmsg{app_id=AppId}=Req, Opts) ->
    % Opts1 = case nksip_sipapp_srv:config(AppId, passes) of
    %     undefined -> Opts;
    %     AppPasses -> [{passes, AppPasses}|Opts]
    % end,
    case nksip_uac_auto_auth:parse_config(PluginOpts, [], Opts1) of
        {ok, Unknown, Opts2} ->
            {continue, [Unknown, Req, Opts2]};
        {error, Error} ->
            {error, Error}
    end.


% @doc Called after the UAC processes a response
-spec nkcb_uac_response(nksip:request(), nksip:response(), 
                        nksip_call:trans(), nksip:call()) ->
    continue | {ok, nksip:call()}.

nkcb_uac_response(Req, Resp, UAC, Call) ->
    nksip_uac_auto_auth:check_auth(Req, Resp, UAC, Call).


