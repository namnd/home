config.load_autoconfig(True)

# Default settings
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

# Customized
c.fonts.default_size = '16pt'
c.fonts.tabs.selected = '16pt default_family'
c.fonts.tabs.unselected = '16pt default_family'
c.fonts.web.size.minimum = 16
c.url.searchengines = {
        'DEFAULT': 'https://duckduckgo.com/?q={}',
        'g': 'https://google.com/search?q={}',
        'gh': 'https://github.com/search?q={}',
        'r': 'https://www.reddit.com/search/?q={}',
        'y': 'https://www.youtube.com/results?search_query={}'
        }
c.bindings.key_mappings = {
        '<Ctrl-j>': '<Tab>',
        }
config.bind('<Super-w>', 'tab-close')
config.bind('<Super-t>', 'set-cmd-text -s :open -t')
config.bind('<Super-1>', 'tab-focus 1')
config.bind('<Super-2>', 'tab-focus 2')
config.bind('<Super-3>', 'tab-focus 3')
config.bind('<Super-4>', 'tab-focus 4')
config.bind('<Super-5>', 'tab-focus 5')
config.bind('<Super-6>', 'tab-focus 6')
config.bind('<Super-7>', 'tab-focus 7')
config.bind('<Super-8>', 'tab-focus 8')

c.auto_save.session = True
c.auto_save.interval = 15000
