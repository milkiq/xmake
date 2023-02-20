--!A cross-platform build utility based on Lua
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Copyright (C) 2015-present, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        check_targets.lua
--

import("plugins.check.checker", {rootdir = os.programdir()})

function _show(str, opt)
    _g.showed = _g.showed or {}
    local showed = _g.showed
    local infostr
    if str then
        infostr = string.format("%s${clear}: %s", opt.sourcetips, str)
    else
        infostr = string.format("%s${clear}: unknown %s value '%s'", opt.sourcetips, opt.apiname, opt.value)
    end
    if opt.probable_value then
        infostr = string.format("%s, it may be '%s'", infostr, opt.probable_value)
    end
    if not showed[infostr] then
        wprint(infostr)
        showed[infostr] = true
    end
end

function main(target)

    -- get checkers
    local checked_checkers = {}
    local checkers = checker.checkers()
    for name, _ in table.orderpairs(checkers) do
        if name:startswith("api.target.") then
            table.insert(checked_checkers, name)
        end
    end

    -- do checkers
    for _, name in ipairs(checked_checkers) do
        local info = checkers[name]
        import("plugins.check.checkers." .. name, {anonymous = true, rootdir = os.programdir()})({
            target = target, show = _show})
    end
end
