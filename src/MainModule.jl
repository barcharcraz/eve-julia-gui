module MainModule
using Gtk
using Gtk.ShortNames
using eve
using DataFrames

include("GtkUtils/GObjectImpls.jl")
include("GtkUtils/GtkTreeModelIface.jl")
include("MarginDataView.jl")
include("DataFrameStore.jl")
include("DataFrameView.jl")
include("JuliaView.jl")
include("MainWindow.jl")
end
