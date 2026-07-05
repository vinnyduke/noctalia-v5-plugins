--!nonstrict
-- Launcher provider for Bitwarden vault search via rbw CLI
-- Prefix "/rbw" activates; Enter copies password to clipboard.
-- Uses noctalia.tr() for i18n — see translations/en.json

local cache = {}        -- uuid -> { name, user }
local lastQuery = ""    -- stale async guard
local synced = false    -- fire-and-forget sync done?

local function shq(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function splitQuery(term)
  local space = term:find("%s")
  if space then
    return term:sub(1, space - 1), term:sub(space + 1):match("^%s*(.-)%s*$") or ""
  end
  return term, ""
end

local function matchesUserFilter(entry, filter)
  return filter == "" or ((entry.user or ""):lower():find(filter:lower(), 1, true))
end

local function doSearch(text, term, user_filter)
  user_filter = user_filter or ""
  local cmd = (term == "")
    and "rbw list --raw"
    or  "rbw search " .. shq(term) .. " --raw"

  noctalia.runAsync(cmd, function(res)
    if lastQuery ~= text then return end

    if res.exitCode ~= 0 or res.stdout == "" then
      launcher.setResults(text, {})
      return
    end

    local ok, data = pcall(function() return noctalia.json.decode(res.stdout) end)
    if not ok or not data then
      launcher.setResults(text, {})
      return
    end

    cache = {}
    local results = {}

    for _, entry in ipairs(data) do
      if entry.type == "Login" and matchesUserFilter(entry, user_filter) then
        cache[entry.id] = {
          name = entry.name or "?",
          user = entry.user or "",
        }

        local subtitle = (entry.user and entry.user ~= "") and entry.user or ""
        if subtitle == "" and entry.uris and #entry.uris > 0 then
          subtitle = entry.uris[1]
        end

        -- Password entry (default action)
        table.insert(results, {
          id = entry.id .. ":p",
          title = entry.name or "?",
          subtitle = noctalia.tr("label_password") .. (subtitle ~= "" and " · " .. subtitle or ""),
          glyph = "key",
          category = "Bitwarden",
        })

        -- Username entry (if available)
        if entry.user and entry.user ~= "" then
          table.insert(results, {
            id = entry.id .. ":u",
            title = entry.name or "?",
            subtitle = noctalia.tr("label_username") .. " · " .. entry.user,
            glyph = "person",
            category = "Bitwarden",
          })
        end

        -- TOTP entry
        table.insert(results, {
          id = entry.id .. ":t",
          title = entry.name or "?",
          subtitle = noctalia.tr("label_totp") .. (subtitle ~= "" and " · " .. subtitle or ""),
          glyph = "clock",
          category = "Bitwarden",
        })
      end
    end

    launcher.setResults(text, results)
  end, 15000)
end

local function checkUnlocked(text, term, user_filter)
  noctalia.runAsync("rbw unlocked", function(r)
    if lastQuery ~= text then return end

    if r.exitCode ~= 0 then
      launcher.setResults(text, {{
        id = "unlock",
        title = noctalia.tr("vault_locked_title"),
        subtitle = noctalia.tr("vault_locked_subtitle"),
        glyph = "lock",
        category = "Status",
      }})
      return
    end

    doSearch(text, term, user_filter)
  end, 5000)
end

function onQuery(text)
  lastQuery = text
  local term = noctalia.string.trim(text)
  local search_term, user_filter = splitQuery(term)
  local ok, hasRbw = pcall(function() return noctalia.commandExists("rbw") end)
  if not ok or not hasRbw then
    launcher.setResults(text, {{
      id = "no-rbw",
      title = noctalia.tr("no_rbw_title"),
      subtitle = noctalia.tr("no_rbw_subtitle"),
      glyph = "warning",
      category = "Status",
    }})
    return
  end

  if not synced then
    synced = true
    noctalia.runAsync("rbw sync", function(r)
      if r.exitCode ~= 0 then
        synced = false -- retry on next query
      end
    end, 30000)
  end

  checkUnlocked(text, search_term, user_filter)
end

function onActivate(id)
  if id == "unlock" then
    local search_term, user_filter = splitQuery(noctalia.string.trim(lastQuery))
    doSearch(lastQuery, search_term, user_filter)
    return
  end

  local entry_id, action = id:match("^(.+):([put])$")
  if not entry_id or not action then return end

  local entry = cache[entry_id]

  local cmd
  if action == "p" then
    cmd = "rbw get " .. shq(entry_id) .. " --clipboard"
  elseif action == "u" then
    cmd = "rbw get " .. shq(entry_id) .. " --field username --clipboard"
  else -- "t" — totp
    cmd = "rbw code " .. shq(entry_id) .. " --clipboard"
  end

  local notif_key = (action == "p" and "password_copied")
    or (action == "u" and "username_copied")
    or "totp_copied"

  local name = (entry and entry.name) or "?"
  noctalia.runAsync(cmd, function(r)
    if r.exitCode == 0 then
      pcall(function() noctalia.notify(noctalia.tr("notif_title"), noctalia.tr(notif_key, { name = name })) end)
    end
  end, 10000)
end
