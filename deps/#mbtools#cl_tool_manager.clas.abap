CLASS /mbtools/cl_tool_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

************************************************************************
* Marc Bernard Tools - Tool Manager
*
* Copyright 2021 Marc Bernard <https://marcbernardtools.com/>
* SPDX-License-Identifier: GPL-3.0-or-later
************************************************************************
  PUBLIC SECTION.

    CLASS-METHODS manifests
      RETURNING
        VALUE(rt_manifests) TYPE /mbtools/if_tool=>ty_manifests.
ENDCLASS.



CLASS /mbtools/cl_tool_manager IMPLEMENTATION.
  METHOD manifests.
  ENDMETHOD.
ENDCLASS.
