include("MainModule.jl")
import Gtk
function main()
  win = MainModule.MainWindow()
  Gtk.showall(win)
  if !isinteractive()
    c = Condition()
    Gtk.signal_connect(win, :destroy) do widget
      notify(c)
    end
    wait(c)
  end
end
