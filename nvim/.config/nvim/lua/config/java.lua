local M = {}

local keywords = {}
for word in
  (
    "abstract assert boolean break byte case catch char class const continue default do double else enum "
    .. "extends final finally float for goto if implements import instanceof int interface long native new "
    .. "package private protected public return short static strictfp super switch synchronized this throw "
    .. "throws transient try void volatile while true false null _"
  ):gmatch("%S+")
do
  keywords[word] = true
end

local function identifier(value)
  return value:match("^[A-Za-z_$][A-Za-z0-9_$]*$") and not keywords[value]
end

-- Only fill an empty buffer; writing the generated file remains an explicit action.
function M.new_class(buf)
  if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable or vim.bo[buf].readonly then
    return false, "Use a writable Java file buffer."
  end
  if table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"):find("%S") then
    return false, "The buffer already contains text; its contents were preserved."
  end

  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local name = vim.fs.basename(path):match("^(.+)%.java$")
  local restricted_type = { var = true, yield = true, record = true, sealed = true, permits = true }
  if not name or not identifier(name) or restricted_type[name] then
    return false, "Use a regular Java class filename, such as Main.java."
  end

  -- Maven and Gradle's conventional main/test Java source roots.
  local relative = path:match("/src/main/java/(.+)%.java$") or path:match("/src/test/java/(.+)%.java$")
  local package_path = relative and relative:match("^(.*)/")
  local lines = {}
  if package_path then
    for segment in package_path:gmatch("[^/]+") do
      if not identifier(segment) then
        return false, "The source directory contains an unsupported Java package name."
      end
    end
    table.insert(lines, "package " .. package_path:gsub("/", ".") .. ";")
    table.insert(lines, "")
  end

  table.insert(lines, "public class " .. name .. " {")
  table.insert(lines, "")
  table.insert(lines, "}")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  if vim.api.nvim_get_current_buf() == buf then
    vim.api.nvim_win_set_cursor(0, { #lines - 1, 0 })
  end
  return true
end

function M.setup()
  local group = vim.api.nvim_create_augroup("JavaClassTemplate", { clear = true })
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = group,
    pattern = "*.java",
    desc = "Create a Java class and infer its package from the source directory",
    callback = function(event)
      M.new_class(event.buf)
    end,
  })
  vim.api.nvim_create_user_command("JavaNewClass", function()
    local ok, message = M.new_class(vim.api.nvim_get_current_buf())
    if not ok then
      vim.notify(message, vim.log.levels.WARN, { title = "Java template" })
    end
  end, { desc = "Fill an empty Java buffer with a class template", force = true })
end

return M
