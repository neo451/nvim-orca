-- keyboard map class
local keycodes = {}

keycodes.chars = {[0] = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}

keycodes.num = { ["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true }

keycodes.base36 = {
  ["0"] = 0,
  ["1"] = 1,
  ["2"] = 2,
  ["3"] = 3,
  ["4"] = 4,
  ["5"] = 5,
  ["6"] = 6,
  ["7"] = 7,
  ["8"] = 8,
  ["9"] = 9,
  ["a"] = 10,
  ["b"] = 11,
  ["c"] = 12,
  ["d"] = 13,
  ["e"] = 14,
  ["f"] = 15,
  ["g"] = 16,
  ["h"] = 17,
  ["i"] = 18,
  ["j"] = 19,
  ["k"] = 20,
  ["l"] = 21,
  ["m"] = 22,
  ["n"] = 23,
  ["o"] = 24,
  ["p"] = 25,
  ["q"] = 26,
  ["r"] = 27,
  ["s"] = 28,
  ["t"] = 29,
  ["u"] = 30,
  ["v"] = 31,
  ["w"] = 32,
  ["x"] = 33,
  ["y"] = 34,
  ["z"] = 35,
}

-- keycodes.keys = {
--   [hid.codes.KEY_1] = "1",
--   [hid.codes.KEY_2] = "2",
--   [hid.codes.KEY_3] = "3",
--   [hid.codes.KEY_4] = "4",
--   [hid.codes.KEY_5] = "5",
--   [hid.codes.KEY_6] = "6",
--   [hid.codes.KEY_7] = "7",
--   [hid.codes.KEY_8] = "8",
--   [hid.codes.KEY_9] = "9",
--   [hid.codes.KEY_0] = "0",
--   [hid.codes.KEY_Q] = "Q",
--   [hid.codes.KEY_W] = "W",
--   [hid.codes.KEY_E] = "E",
--   [hid.codes.KEY_R] = "R",
--   [hid.codes.KEY_T] = "T",
--   [hid.codes.KEY_Y] = "Y",
--   [hid.codes.KEY_U] = "U",
--   [hid.codes.KEY_I] = "I",
--   [hid.codes.KEY_O] = "O",
--   [hid.codes.KEY_P] = "P",
--   [hid.codes.KEY_A] = "A",
--   [hid.codes.KEY_S] = "S",
--   [hid.codes.KEY_D] = "D",
--   [hid.codes.KEY_F] = "F",
--   [hid.codes.KEY_G] = "G",
--   [hid.codes.KEY_H] = "H",
--   [hid.codes.KEY_J] = "J",
--   [hid.codes.KEY_K] = "K",
--   [hid.codes.KEY_L] = "L",
--   [hid.codes.KEY_Z] = "Z",
--   [hid.codes.KEY_X] = "X",
--   [hid.codes.KEY_C] = "C",
--   [hid.codes.KEY_V] = "V",
--   [hid.codes.KEY_B] = "B",
--   [hid.codes.KEY_N] = "N",
--   [hid.codes.KEY_M] = "M",
--
--   [hid.codes.KEY_MINUS] = "-",
--   [hid.codes.KEY_EQUAL] = "=",
--   [hid.codes.KEY_APOSTROPHE] = "'",
--   [hid.codes.KEY_GRAVE] = "`",
--   [hid.codes.KEY_COMMA] = ",",
--   [hid.codes.KEY_DOT] = ".",
--   [hid.codes.KEY_SEMICOLON] = ";",
--   [hid.codes.KEY_SLASH] = "/",
--   [hid.codes.KEY_BACKSLASH] = "\\",
--   [hid.codes.KEY_LEFTBRACE] = "[",
--   [hid.codes.KEY_RIGHTBRACE] = "]",
--   [hid.codes.KEY_SPACE] = " ",
--   [hid.codes.KEY_KPASTERISK] = "*",
--
--   [hid.codes.KEY_KPMINUS] = "-",
--   [hid.codes.KEY_KPPLUS] = "+",
--   [hid.codes.KEY_KPDOT] = ".",
--   [hid.codes.KEY_KPEQUAL] = "] = ",
--   [hid.codes.KEY_KP0] = "0",
--   [hid.codes.KEY_KP1] = "1",
--   [hid.codes.KEY_KP2] = "2",
--   [hid.codes.KEY_KP3] = "3",
--   [hid.codes.KEY_KP4] = "4",
--   [hid.codes.KEY_KP5] = "5",
--   [hid.codes.KEY_KP6] = "6",
--   [hid.codes.KEY_KP7] = "7",
--   [hid.codes.KEY_KP8] = "8",
--   [hid.codes.KEY_KP9] = "9",
--   [hid.codes.KEY_KPENTER] = "Enter",
--   [hid.codes.KEY_KPSLASH] = "Slash",
--   [hid.codes.KEY_102ND] = "102ND",
--   [hid.codes.KEY_TAB] = "  ",
-- }
--
-- keycodes.shifts = {
--   [hid.codes.KEY_1] = "!",
--   [hid.codes.KEY_2] = "@",
--   [hid.codes.KEY_3] = "#",
--   [hid.codes.KEY_4] = "$",
--   [hid.codes.KEY_5] = "%",
--   [hid.codes.KEY_6] = "^",
--   [hid.codes.KEY_7] = "&",
--   [hid.codes.KEY_8] = "*",
--   [hid.codes.KEY_9] = "(",
--   [hid.codes.KEY_0] = ")",
--   [hid.codes.KEY_LEFTBRACE] = "{",
--   [hid.codes.KEY_RIGHTBRACE] = "}",
--   [hid.codes.KEY_COMMA] = "<",
--   [hid.codes.KEY_DOT] = ">",
--   [hid.codes.KEY_SLASH] = "?",
--   [hid.codes.KEY_SEMICOLON] = ":",
--   [hid.codes.KEY_APOSTROPHE] = "\"",
--   [hid.codes.KEY_BACKSLASH] = "|",
--   [hid.codes.KEY_MINUS] = "—",
--   [hid.codes.KEY_EQUAL] = "+",
--   [hid.codes.KEY_GRAVE] = "~",
-- }
--
-- keycodes.cmds = {
--   [hid.codes.KEY_ESC] = "ESC",
--   [hid.codes.KEY_LEFTSHIFT] = "Left Shift",
--   [hid.codes.KEY_RIGHTSHIFT] = "Right Shift",
--   [hid.codes.KEY_LEFTALT] = "Left Alt",
--   [hid.codes.KEY_RIGHTALT] = "Right Alt",
--   [hid.codes.KEY_LEFTCTRL] = "Left CTRL",
--   [hid.codes.KEY_RIGHTCTRL] = "Right CTRL",
--   [hid.codes.KEY_BACKSPACE] = "Backspace",
--   [hid.codes.KEY_DELETE] = "Delete",
--   [hid.codes.KEY_ENTER] = "Enter",
--   [hid.codes.KEY_CAPSLOCK] = "Capslock",
--   [hid.codes.KEY_NUMLOCK] = "Numlock",
--   [hid.codes.KEY_SCROLLLOCK] = "Scroll Lock",
--   [hid.codes.KEY_SYSRQ] = "SYSRQ",
--   [hid.codes.KEY_HOME] = "Home",
--   [hid.codes.KEY_UP] = "Up",
--   [hid.codes.KEY_PAGEUP] = "Pageup",
--   [hid.codes.KEY_LEFT] = "Left",
--   [hid.codes.KEY_RIGHT] = "Right",
--   [hid.codes.KEY_END] = "End",
--   [hid.codes.KEY_DOWN] = "Down",
--   [hid.codes.KEY_PAGEDOWN] = "Page Down",
--   [hid.codes.KEY_INSERT] = "Insert",
--   [hid.codes.KEY_PAUSE] = "Pause",
--   [hid.codes.KEY_LEFTMETA] = "Left Meta",
--   [hid.codes.KEY_RIGHTMETA] = "Right Meta",
--   [hid.codes.KEY_COMPOSE] = "Compose",
-- }

return keycodes