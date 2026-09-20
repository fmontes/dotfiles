# herdr-automatic-rename configuration.
#
# Sourced by automatic-rename.sh before naming.sh, so anything set here wins
# over the plugin's defaults. Every setting has a working default; this file
# only carries the ones that differ. The full annotated set of knobs is in the
# plugin's own config.example.sh.

# Number tabs, not spaces.
#
# AUTO_INDEX is the one knob for "number everything" and defaults to 1; the
# per-kind settings default to it and override it when set. Tabs and agents are
# therefore left alone and keep their "[2] " prefix, which is what alt+1..9
# jumps to and the only place the number earns its four columns.
#
# The sidebar spaces rows do not need it. They are the workspace list, already
# ordered top to bottom, and the number was repeating position the eye can
# read off the row's place in the list.
#
# Heads up: setting this to 0 also strips the "[N] " prefixes already on those
# rows at the next herdr event, and that cleanup cannot tell its own prefixes
# from one you typed. A workspace you named "[1] incident" by hand loses the
# bracket too. Anything non-numeric in brackets ("[wip] foo") is left alone.
AUTO_INDEX_WORKSPACES=0
