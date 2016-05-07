import Gtk.GLib: g_type_from_name
type DataFrameStoreImpl
  parent :: GObjectImpl
  private :: Ptr{Void}
end
type DataFrameStoreClassImpl
  parent :: GObjectClass
end
type DataFrameStore <: Gtk.GLib.GObject
  handle :: Ptr{DataFrameStoreImpl}
  stamp :: Int32
  df :: AbstractDataFrame
  function DataFrameStore()
    obj = g_object_new(DataFrameStoreGetType())
    self = Gtk.gobject_move_ref(new(obj), obj)
    dat = unsafe_load(self.handle)
    dat.private = pointer_from_objref(self)
    self.stamp = rand(Int32)
    self.df = DataFrame()
    self
  end
end
function DataFrameStore(df :: AbstractDataFrame)
  retval = DataFrameStore()
  retval.df = df
  retval
end

function DataFrameStoreTreeModelInit(iface :: Ptr{GtkTreeModelIface})
  i = unsafe_load(iface)
  i.get_flags = cfunction(DataFrameStoreGetFlags, Cint, (Ptr{DataFrameStoreImpl},))
  i.get_n_columns = cfunction(DataFrameStoreGetNColumns, Cint, (Ptr{DataFrameStoreImpl},))
  i.get_column_type = cfunction(DataFrameStoreGetColumnType, Gtk.GLib.GType, (Ptr{DataFrameStoreImpl}, Cint))
  i.get_iter = cfunction(DataFrameStoreGetIter, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}, GtkTreePath))
  i.get_path = cfunction(DataFrameStoreGetPath, GtkTreePath, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}))
  i.get_value = cfunction(DataFrameStoreGetValue, Void, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}, Cint, Ptr{Gtk.GLib.GValue}))
  i.iter_next = cfunction(DataFrameStoreIterNext, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}))
  i.iter_previous = cfunction(DataFrameStoreIterPrev, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}))
  i.iter_children = cfunction(DataFrameStoreIterChildren, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}, Ptr{GtkTreeIterImpl}))
  i.iter_has_child = cfunction(DataFrameStoreIterHasChild, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}))
  i.iter_n_children = cfunction(DataFrameStoreIterNChildren, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}))
  i.iter_nth_child = cfunction(DataFrameStoreIterNthChild, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}, Ptr{GtkTreeIterImpl}))
  i.iter_parent = cfunction(DataFrameStoreIterParent, Cint, (Ptr{DataFrameStoreImpl}, Ptr{GtkTreeIterImpl}, Ptr{GtkTreeIterImpl}))
  unsafe_store!(iface, i)
  return
end
DataFrameStoreType = g_type_from_name(:DataFrameStore) :: Gtk.GLib.GType
function DataFrameStoreGetType()
  #global DataFrameStoreType:: Gtk.GLib.GType
  global DataFrameStoreType
  if DataFrameStoreType == 0
    info = GTypeInfo(
      UInt16(sizeof(DataFrameStoreClassImpl)),
      C_NULL,
      C_NULL,
      C_NULL,
      C_NULL,
      C_NULL,
      UInt16(sizeof(DataFrameStoreImpl)),
      UInt16(0),
      C_NULL
    )
    ifaceInfo = GInterfaceInfo(
      cfunction(DataFrameStoreTreeModelInit, Void, (Ptr{GtkTreeModelIface},)),
      C_NULL,
      C_NULL
    )
    DataFrameStoreType = g_type_register_static(g_type_from_name(:GObject), "DataFrameStore", info, Int32(0))
    modelType = ccall((:gtk_tree_model_get_type, Gtk.libgtk), Gtk.GLib.GType, ())
    g_type_add_interface_static(DataFrameStoreType, modelType, ifaceInfo)
  end
  DataFrameStoreType
end

function DataFrameStoreGetFlags(tree_model :: Ptr{DataFrameStoreImpl})
  Cint(3)
end
function DataFrameStoreGetNColumns(tree_model :: Ptr{DataFrameStoreImpl})
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  Cint(length(self.df))
end
function DataFrameStoreGetColumnType(tree_model :: Ptr{DataFrameStoreImpl}, index :: Cint)
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  typ = elttypes(self.df)[index+1]
  JuliaTypeToGType(typ)

end

function DataFrameStoreGetIter(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl}, path :: GtkTreePath)
  index = GAccessor.indices(path)[0]
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  it = unsafe_load(iter)
  (rows, cols) = size
  if index > length(self.df)
    it.stamp = 0
    unsafe_store!(iter, it)
    return Cint(false)
  else
    it.stamp = self.stamp
    it.user1 = index + 1
    unsafe_store!(iter, it)
    return Cint(true)
  end
end

function DataFrameStoreGetPath(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl})
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  it = unsafe_load(iter)
  (rows, cols) = size(self.df)
  if it.stamp != self.stamp
    return C_NULL
  elseif it.user1 > rows
    return C_NULL
  end
  path = ccall((:gtk_tree_path_new, Gtk.libgtk), GtkTreePath, ())
  ccall((:gtk_tree_path_append_index, Gtk.libgtk), Void, (GtkTreePath, Cint), path, Cint(it.user1))
  path
end

function DataFrameStoreGetValue(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl}, col :: Cint, value :: Ptr{Gtk.GLib.GValue})
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  it = unsafe_load(iter)
  row = it.user1
  (rows, cols) = size(self.df)
  if col+1 > cols
    return
  end
  if it.stamp != self.stamp
    return
  end
  item = self.df[row, col+1]
  gv = gvalue(item)
  unsafe_store!(value, gv)
end

function DataFrameStoreIterNext(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl})
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  it = unsafe_load(iter)
  (rows, cols) = size(self.df)
  if it.stamp != self.stamp
    return Cint(false)
  end
  it.user1 = it.user1 + 1
  if it.user1 > rows
    it.stamp = 0
    unsafe_store!(iter, it)
    return Cint(false)
  end
  unsafe_store!(iter, it)
  return Cint(true)
end
function DataFrameStoreIterPrev(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl})
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  it = unsafe_load(iter)
  if it.stamp != self.stamp
    return Cint(false)
  end
  it.user1 = it.user1 - 1
  if it.user1 <= 0
    it.stamp = 0
    unsafe_store!(iter, it)
    return Cint(false)
  end
  unsafe_store!(iter, it)
  return Cint(true)
end

function DataFrameStoreIterChildren(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl}, parent :: Ptr{GtkTreeIterImpl})
  it = unsafe_load(iter)
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  if parent != C_NULL
    it.stamp = 0
    unsafe_store!(iter, it)
    return Cint(false)
  end
  (rows, cols) = size(self.df)
  if rows > 0
    it.stamp = self.stamp
    it.user1 = 1
    unsafe_store(iter, it)
    return Cint(true)
  end
  it.stamp = 0
  unsafe_store!(iter, it)
  return Cint(false)
end

function DataFrameStoreIterHasChild(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl})
  return Cint(false)
end

function DataFrameStoreIterNChildren(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl})
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  (rows, cols) = size(self.df)
  if iter == C_NULL
    return Cint(rows)
  end
  it = unsafe_load(iter)
  if self.stamp != it.stamp
    return Cint(-1)
  end
  return Cint(0)
end

function DataFrameStoreIterNthChild(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl}, parent :: Ptr{GtkTreeIterImpl}, n :: Cint)
  if parent != C_NULL
    return Cint(false)
  end
  self = unsafe_pointer_to_objref(unsafe_load(tree_model).private)
  (rows, cols) = size(self.df)
  if n+1 < 1 || n+1 > rows
    return Cint(false)
  end
  it = unsafe_load(iter)
  it.stamp = self.stamp
  it.user1 = n+1
  unsafe_store!(iter, it)
  return Cint(true)
end
function DataFrameStoreIterParent(tree_model :: Ptr{DataFrameStoreImpl}, iter :: Ptr{GtkTreeIterImpl}, child :: Ptr{GtkTreeIterImpl})
  it = unsafe_load(iter)
  it.stamp = 0
  unsafe_store!(iter, it)
  return Cint(false)
end
