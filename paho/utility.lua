---
-- @module paho.utility
-- ~~~~~~~~~~~
-- Version: 0.3 2014-10-06
-- -------------------------------------------------------------------------- --
-- Copyright (c) 2011-2012 Geekscape Pty. Ltd.
-- All rights reserved. This program and the accompanying materials
-- are made available under the terms of the Eclipse Public License v1.0
-- which accompanies this distribution, and is available at
-- http://www.eclipse.org/legal/epl-v10.html
--
-- Contributors:
--    Andy Gelme - Initial API and implementation
-- -------------------------------------------------------------------------- --
--
-- Notes
-- ~~~~~
-- - Works on the Sony PlayStation Portable (aka Sony PSP) ...
--     See http://en.wikipedia.org/wiki/Lua_Player_HM
--
-- ToDo
-- ~~~~
-- - shift_left() should mask bits past the 8, 16, 32 and 64-bit boundaries.
-- ------------------------------------------------------------------------- --

local function isPsp() return(Socket ~= nil) end

if (isPsp()) then socket = Socket end                        -- Compatibility !

-- ------------------------------------------------------------------------- --

local debug_flag = false

local function set_debug(value) debug_flag = value end

local function debug(message)
  if (debug_flag) then print(message) end
end

-- ------------------------------------------------------------------------- --

local function dump_string(value)
  local index

  for index = 1, string.len(value) do
    print(string.format("%d: %02x", index, string.byte(value, index)))
  end
end

-- ------------------------------------------------------------------------- --

local timer

if (isPsp()) then
  timer = Timer.new()
  timer:start()
end

local function get_time()
  if (isPsp()) then
    return(timer:time() / 1000)
  else
    return(socket.gettime())
  end
end

local function expired(last_time, duration, type)
  local time_expired = get_time() >= (last_time + duration)

  if (time_expired) then debug("Event: " .. type) end
  return(time_expired)
end

-- ------------------------------------------------------------------------- --

local function shift_left(value, shift)
  return(value * 2 ^ shift)
end

local function shift_right(value, shift)
  return(math.floor(value / 2 ^ shift))
end

-- ------------------------------------------------------------------------- --

local function socket_ready(socket_client)
  local ready, read_sockets, write_sockets, error_state = true, nil, nil, nil

  if (not isPsp()) then
    read_sockets, write_sockets, error_state =
      socket.select({socket_client}, nil, 0.001)

    if (#read_sockets == 0) then ready = false end
  end

  return(ready)
end

local function socket_receive(socket_client, byte_count)
  local response, buffer, error_message = nil, nil, nil

  byte_count = byte_count or 128                                     -- default

  if (isPsp()) then
    buffer = socket_client:recv(byte_count)
  else
    response, error_message, buffer = socket_client:receive("*a")

    if (error_message == "timeout") then error_message = nil end
  end

  return(error_message), (buffer)                            -- nil or "closed"
end

local function socket_wait_connected(socket_client)
  if (isPsp()) then
    while (socket_client:isConnected() == false) do
      System.sleep(100)
    end
  else
    socket_client:settimeout(0.001)     -- So that socket.recieve doesn't block
  end
end

-- ------------------------------------------------------------------------- --

local function table_to_string(table)
  local result = ''

  if (type(table) == 'table') then
    result = '{ '

    for index = 1, #table do
      result = result .. table_to_string(table[index])
      if (index ~= #table) then
        result = result .. ', '
      end
    end

    result = result .. ' }'
  else
    result = tostring(table)
  end

  return(result)
end

-- ------------------------------------------------------------------------- --
-- Define Utility "module"
-- ~~~~~~~~~~~~~~~~~~~~~~~

local Utility = {}

---
-- @function [parent = #paho.utility] isPsp
--
Utility.isPsp = isPsp

---
-- @param #boolean flag
-- @function [parent = #paho.utility] set_debug
--
Utility.set_debug = set_debug

---
-- @param #string message
-- @function [parent = #paho.utility] debug
--
Utility.debug = debug

---
-- @param #string value
-- @function [parent = #paho.utility] dump_string
--

Utility.dump_string = dump_string

---
-- @function [parent = #paho.utility] get_time
-- @return #number
--
Utility.get_time = get_time

---
-- @param #number last_time
-- @param #number duration
-- @param #string type
-- @function [parent = #paho.utility] expired
-- @return #number
--
Utility.expired = expired

---
-- @param #number value
-- @param #number shift
-- @function [parent = #paho.utility] shift_left
-- @return #number
--
Utility.shift_left = shift_left

---
-- @param #number value
-- @param #number shift
-- @function [parent = #paho.utility] shift_left
-- @return #number
--
Utility.shift_right = shift_right

---
-- @param socket_client
-- @function [parent = #paho.utility] socket_ready
-- @return #boolean
--
Utility.socket_ready = socket_ready

---
-- @param socket_client
-- @param #number byte_count
-- @function [parent = #paho.utility] socket_receive
-- @return #string,#string
--
Utility.socket_receive = socket_receive

---
-- @param socket_client
-- @function [parent = #paho.utility] socket_wait_connected
--
Utility.socket_wait_connected = socket_wait_connected

---
-- @param #table table
-- @function [parent = #paho.utility] table_to_string
-- @return #string
--
Utility.table_to_string = table_to_string

-- For ... Utility = require 'paho.utility'

return(Utility)

-- ------------------------------------------------------------------------- --
