

type DataFrameView <: TreeView
  handle :: Ptr{GObject}
  store :: DataFrameStore
  function DataFrameView(df :: AbstractDataFrame)
    store = DataFrameStore(df)
    view = @TreeView(TreeModel(store))
    renderer = @CellRendererText()
    for i in eachindex(names(df))
      push!(view, @TreeViewColumn(string(names(df)[i]), renderer, Dict("text"=>i-1)))
    end
    Gtk.gobject_move_ref(new(view.handle, df, store), view)
  end
end
