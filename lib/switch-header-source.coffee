module.exports =
  activate: ->
    atom.workspaceView.command "switch-header-source:switch", => @switch()

  switch: ->
    # This assumes the active pane item is an editor
    editor = atom.workspace.activePaneItem
    #path = editor.buffer.file.path
    path = editor.getUri()

    src_path = /\/[Ss]rc\//
    inc_path = /\/[Ii]nclude\//

    csuffix = /\.(c|cc|c\+\+)$/i
    hsuffix = /\.(h|hh|h\+\+)$/i

    if csuffix.test path
      # construct header file path
      new_path = path.replace(csuffix, '.h').replace(src_path, '/include/')

    else if hsuffix.test path
      # construct src file path
      new_path = path.replace(hsuffix, '.C').replace(inc_path, '/src/')
    else
      # nothing to do here
      return

    # let's see if the file is already open in the current pane
    if atom.workspace.activePane.activateItemForUri(new_path)
      return

    # otherwise just load it
    atom.workspaceView.open(new_path, {
      allowActiveEditorChange: this.allowActiveEditorChange
    })
