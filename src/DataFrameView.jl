

type DataFrameView <: TreeView
  handle :: Ptr{GObject}
  frame :: AbstractDataFrame
  store :: ListStore
  function DataFrameView(df :: AbstractDataFrame)
    store = @ListStore(eltypes(df)...)
    for r in eachrow(df)
      push!(store, (Array(r)...))
    end
    view = @TreeView(TreeModel(store))
    renderer = @CellRendererText()
    for i in eachindex(names(df))
      push!(view, @TreeViewColumn(string(names(df)[i]), renderer, Dict("text"=>i-1)))
    end
    Gtk.gobject_move_ref(new(view.handle, df, store), view)
  end
end
