GitControlView = require './git-control-view'
{CompositeDisposable} = require 'atom'
git = require './git'

CMD_TOGGLE = 'git-control:toggle'
EVT_SWITCH = 'pane-container:active-pane-item-changed'

views = []
view = undefined
pane = undefined
item = undefined

module.exports = GitControl =

  activate: (state) ->
    console.log 'GitControl: activate'

    atom.commands.add 'atom-workspace', CMD_TOGGLE, => @toggleView()
    atom.workspace.onDidChangeActivePaneItem (item) => @updateViews()
    atom.project.onDidChangePaths => @updatePaths()

    atom.workspace.addOpener (uri) ->
      if uri == 'atom://git-control'
        return GitControl.getView()
      return
    return

  deactivate: ->
    console.log 'GitControl: deactivate'
    return

  toggleView: ->
    console.log 'GitControl: toggle'
    atom.workspace.open('atom://git-control', undefined, 0, 0, undefined, true, true, false, true);

  getView: ->
    if !view
      view = new GitControlView();
    return view

  deserializeGitControlView: ->
    return new GitControlView();

  updatePaths: ->
     git.setProjectIndex(0)
     return

  updateViews: ->
    activeView = atom.workspace.getActivePane().getActiveItem()
    for v in views when v is activeView
      v.update()
    return

  updatePaths: ->
    # when projects paths changed restart within 0
    git.setProjectIndex(0);
    return

  serialize: ->

  config:
    showGitFlowButton:
      title: 'Show GitFlow button'
      description: 'Show the GitFlow button in the Git Control toolbar'
      type: 'boolean'
      default: true
    noFastForward:
      title: 'Disable Fast Forward'
      description: 'Disable Fast Forward for default at Git Merge'
      type: 'boolean'
      default: false
