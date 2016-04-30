type MarginDataView <: Grid
  handle :: Ptr{GObject}
  ItemName :: Label
  MaxBuy :: Label
  MinSell :: Label
  Margin :: Label
  function MarginDataView()
    grid = @Grid()
    self = Gtk.gobject_move_ref(new(grid.handle),grid)
    setproperty!(self, "orientation", 1)
    self.ItemName = @Label("No Item")
    self.MaxBuy = @Label("Max Buy: -")
    self.MinSell = @Label("Min Sell: -")
    self.Margin = @Label("Margin: -")
    push!(self, self.ItemName)
    push!(self, self.MaxBuy)
    push!(self, self.MinSell)
    push!(self, self.Margin)

  end
end
function UpdateMarginDataView(view, data :: eve.ItemSummery)
  setproperty!(view.ItemName, "label", string(data.itemID))
  setproperty!(view.MaxBuy, "label", data.maxbuy)
  setproperty!(view.MinSell, "label", data.minsell)
  setproperty!(view.Margin, "label", data.margin)
end
