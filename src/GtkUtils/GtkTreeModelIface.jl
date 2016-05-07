type GtkTreeModelIface
  g_iface :: GTypeInterface
  row_changed :: Ptr{Void}
  row_inserted :: Ptr{Void}
  row_has_child_toggled :: Ptr{Void}
  row_deleted :: Ptr{Void}
  rows_reordered :: Ptr{Void}

  get_flags :: Ptr{Void}
  get_n_columns :: Ptr{Void}
  get_column_type :: Ptr{Void}
  get_iter :: Ptr{Void}
  get_path :: Ptr{Void}
  get_value :: Ptr{Void}
  iter_next :: Ptr{Void}
  iter_previous :: Ptr{Void}
  iter_children :: Ptr{Void}
  iter_has_child :: Ptr{Void}
  iter_n_children :: Ptr{Void}
  iter_nth_child :: Ptr{Void}
  iter_parent :: Ptr{Void}
  ref_node :: Ptr{Void}
  unref_node :: Ptr{Void}
end
type GtkTreeIterImpl
  stamp :: Cint
  user1 :: Ptr{Void}
  user2 :: Ptr{Void}
  user3 :: Ptr{Void}
end
