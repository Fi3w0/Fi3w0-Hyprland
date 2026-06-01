from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import bold, normal, default_colors

class Scheme(ColorScheme):
    def use(self, context):
        # Default colors from your init.lua
        # Normal Text (#E0D7FF) -> 254, Background -> -1 (Transparent)
        fg, bg, attr = 254, -1, normal

        if context.reset:
            return default_colors

        elif context.in_browser:
            # --- THE FIXED DARK PURPLE SELECTION ---
            if context.selected:
                bg = 91             # Rich Dark Purple background
                fg = 255            # Bright White text (stays visible)
                attr = bold         # Force bold, NO 'reverse'
            
            # --- UI COLORS (Only applied if NOT selected) ---
            if context.directory:
                if not context.selected:
                    fg = 141        # Lavender: #B388EB
                attr |= bold
            elif context.link and not context.selected:
                fg = 117            # Sky Blue
            elif context.executable and not context.selected:
                fg = 149            # Green

        elif context.in_titlebar:
            attr |= bold
            # Title matches Keyword: #CBA6F7
            fg = 183 if context.directory else 141

        elif context.in_statusbar:
            if context.permissions:
                fg = 149 if context.good else 161
            if context.marked:
                attr |= bold
                fg = 219            # Pink String color: #E0B0FF

        return fg, bg, attr
