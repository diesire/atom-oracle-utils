{CompositeDisposable} = require 'atom'

module.exports = AtomOracleUtils =
  subscriptions: null

  config:
    sdcliPath:
      title: 'Path to sdcli'
      description: 'Full path to sdcli.exe or sdcli64.exe'
      type: 'string'
      default: 'C:\\Program Files (x86)\\Oracle\\Product\\SQLDeveloper\\4.0\\sqldeveloper\\sqldeveloper\\bin\\sdcli.exe'

  activate: (state) ->
    console.log 'Activate AtomOracleUtils'

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-oracle-utils:format': => @format()

  deactivate: ->
    @subscriptions.dispose()

  format: ->
    console.log 'AtomOracleUtils.format was called!'
    editor = atom.workspace.getActiveTextEditor()
    if editor.getGrammar().scopeName isnt 'source.sql'
      console.log 'This is not an SQL file'
      return

    file = editor?.getBuffer()?.getPath()
    console.log "file #{file}"
    editor?.getBuffer()?.save()

    @formatFile(file, file)

  formatFile: (inputFile, outputFile)->
    # See https://github.com/karan/atom-terminal/blob/master/lib/atom-terminal.coffee
    {BufferedProcess} = require 'atom'
    command = atom.config.get('atom-oracle-utils.sdcliPath')
    console.log command
    args = ['format', "input=#{inputFile}", "output=#{outputFile}"]
    stdout = (output) -> console.log(output)
    exit = (code) -> console.log("sdcli  with #{code}")
    process = new BufferedProcess({command, args, stdout, exit})
