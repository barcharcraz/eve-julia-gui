immutable GTypeInfo
  size :: UInt16
  base_init :: Ptr{Void}
  base_finalize :: Ptr{Void}

  class_init :: Ptr{Void}
  class_finalize :: Ptr{Void}
  class_data :: Ptr{Void}

  instance_size :: UInt16
  n_preallocs :: UInt16
  instance_init :: Ptr{Void}

  #value_table :: Ptr{Void}
end

immutable GInterfaceInfo
  interface_init :: Ptr{Void}
  interface_finalize :: Ptr{Void}
  interface_data :: Ptr{Void}
end
immutable GObjectClass
  typ :: Gtk.GLib.GType
  construct_props :: Ptr{Void}
  constructor :: Ptr{Void}
  set_property :: Ptr{Void}
  get_property :: Ptr{Void}
  dispose :: Ptr{Void}
  finalize :: Ptr{Void}
  dispatch_properties_changed :: Ptr{Void}
  notify :: Ptr{Void}
  constructed :: Ptr{Void}
  flags :: Cssize_t
  p1 :: Ptr{Void}
  p2 :: Ptr{Void}
  p3 :: Ptr{Void}
  p4 :: Ptr{Void}
  p5 :: Ptr{Void}
  p6 :: Ptr{Void}
end
immutable GObjectImpl
  g_type_instance :: Ptr{Void}
  ref_count :: Cuint
  qdata :: Ptr{Void}
end
immutable GTypeInterface
  g_type :: Gtk.GLib.GType
  g_instance_type :: Gtk.GLib.GType
end
function JuliaTypeToGType(typ :: Type)
  if typ <: Int8
    return g_type_from_name(:gchar)
  elseif typ <: UInt8
    return g_type_from_name(:guchar)
  elseif typ <: Bool
    return g_type_from_name(:gboolean)
  elseif typ <: Cint
    return g_type_from_name(:gint)
  elseif typ <: Cuint
    return g_type_from_name(:guint)
  elseif typ <: Clong
    return g_type_from_name(:glong)
  elseif typ <: Culong
    return g_type_from_name(:gulong)
  elseif typ <: Int64
    return g_type_from_name(:gint64)
  elseif typ <: UInt64
    return g_type_from_name(:guint64)
  elseif typ <: Float32
    return g_type_from_name(:gfloat)
  elseif typ <: Float64
    return g_type_from_name(:gdouble)
  elseif typ <: AbstractString
    return g_type_from_name(:gchararray)
  else
    return g_type_from_name(:invalid)
  end
end
function g_type_register_static(parent_type :: Gtk.GLib.GType, typename :: ASCIIString, type_info :: GTypeInfo, flags :: Cint)
  ccall((:g_type_register_static, Gtk.libgobject), Gtk.GLib.GType, (Gtk.GLib.GType, Cstring, Ref{GTypeInfo}, Cint),
        parent_type, typename, type_info, flags)
end
function g_type_add_interface_static(instance_type :: Gtk.GLib.GType, interface_type :: Gtk.GLib.GType, info :: GInterfaceInfo)
  ccall((:g_type_add_interface_static, Gtk.libgobject), Void, (Gtk.GLib.GType, Gtk.GLib.GType, Ref{GInterfaceInfo}),
        instance_type, interface_type, info)
end
function g_object_new(typ :: Gtk.GLib.GType)
  ccall((:g_object_new, Gtk.libgobject), GObject, (Gtk.GLib.GType, Ptr{Void}), typ, C_NULL)
end
