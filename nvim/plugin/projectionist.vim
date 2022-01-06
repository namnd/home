let g:projectionist_heuristics = {
      \   '*': {
      \     '*.c': {
      \       'alternate': '{}.h',
      \       'type': 'source'
      \     },
      \     '*.h': {
      \       'alternate': '{}.c',
      \       'type': 'header'
      \     },
      \     '*.ts': {
      \       'alternate': '{}.test.ts',
      \       'type': 'source'
      \     },
      \     '*.test.ts': {
      \       'alternate': '{}.ts',
      \       'type': 'test',
      \     },
      \     '*.go': {
      \       'alternate': [
      \         '{}_test.go',
      \       ],
      \       'type': 'source'
      \     },
      \     '*_test.go': {
      \       'alternate': [
      \         '{}.go',
      \       ],
      \       'type': 'test'
      \     },
      \     'src/*.py': {
      \       'alternate': [
      \         'tests/test_{}.go',
      \       ],
      \       'type': 'source'
      \     },
      \     'tests/test_*.py': {
      \       'alternate': [
      \         'src/{}.py',
      \       ],
      \       'type': 'test'
      \     }
      \   }
      \ }
