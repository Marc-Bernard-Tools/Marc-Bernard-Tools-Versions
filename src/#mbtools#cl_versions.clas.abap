CLASS /mbtools/cl_versions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apack_manifest .

    CONSTANTS:
      c_version     TYPE string VALUE '1.0.0' ##NO_TEXT,
      c_title       TYPE string VALUE 'Marc Bernard Tools Version' ##NO_TEXT,
      c_description TYPE string VALUE 'Version Overview for Marc Bernard Tools' ##NO_TEXT,
      c_download_id TYPE i VALUE 0 ##NO_TEXT.

    METHODS constructor .

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA mo_tool TYPE REF TO /mbtools/cl_tools.

    ALIASES apack_manifest
      FOR if_apack_manifest~descriptor .
ENDCLASS.



CLASS /MBTOOLS/CL_VERSIONS IMPLEMENTATION.


  METHOD constructor.

    DATA:
      lo_tool           TYPE REF TO object,
      lo_manifest       TYPE REF TO zif_apack_manifest,
      ls_manifest_descr TYPE /mbtools/manifest,
      ls_dependency     TYPE zif_apack_manifest=>ty_dependency.

    CREATE OBJECT mo_tool EXPORTING io_tool = me.

    apack_manifest = mo_tool->apack_manifest.

    LOOP AT /mbtools/cl_tools=>get_manifests( ) INTO ls_manifest_descr.

      CREATE OBJECT lo_tool TYPE (ls_manifest_descr-class).
      CHECK sy-subrc = 0.

      lo_manifest ?= lo_tool.

      CLEAR ls_dependency.
      ls_dependency-group_id    = lo_manifest->descriptor-group_id.
      ls_dependency-artifact_id = lo_manifest->descriptor-artifact_id.
      ls_dependency-version     = lo_manifest->descriptor-version.
      ls_dependency-git_url     = lo_manifest->descriptor-git_url.
      INSERT ls_dependency INTO TABLE apack_manifest-dependencies.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
