global active_repl
global active_repl_backend

type JuliaView <: TextView
  handle :: Ptr{GObject}
  function JuliaView()
    view = @TextView()
    Gtk.gobject_move_ref(new(view.handle), view)
  end
end
immutable REPLManager <: ClusterManager
  np :: Integer
end

function launch(manager :: REPLManager, params :: Dict, launched :: Array, c :: Condition)

end

function testREPELInit()
  global active_repl
  global active_repl_backend
  sin = Base.TTY(fd(STDIN))
  sout = Base.TTY(fd(STDOUT))
  serr = Base.TTY(fd(STDERR))
  term = Base.Terminals.TTYTerminal("", sin, sout, serr)
  Base.REPL.banner(term, term)
  active_repl = Base.REPL.LineEditREPL(term, true)
  active_repl.hascolor = false
  Base._atreplinit(active_repl)
  Base.REPL.run_repl(active_repl, backend -> (global active_repl_backend = backend))
end
