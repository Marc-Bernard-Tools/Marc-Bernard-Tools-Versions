CLASS /mbtools/cl_versions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apack_manifest .

    CONSTANTS c_version TYPE string VALUE '1.0.0' ##NO_TEXT.
    CONSTANTS c_title TYPE string VALUE 'Marc Bernard Tools Version' ##NO_TEXT.
    CONSTANTS c_description TYPE string VALUE 'Version Overview for Marc Bernard Tools' ##NO_TEXT.
    CONSTANTS c_download_id TYPE i VALUE 0 ##NO_TEXT.

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mr_tool TYPE REF TO /mbtools/cl_tools.

    ALIASES apack_manifest
      FOR if_apack_manifest~descriptor .
ENDCLASS.



CLASS /MBTOOLS/CL_VERSIONS IMPLEMENTATION.


  METHOD constructor.

    DATA:
      tool           TYPE REF TO object,
      manifest       TYPE REF TO zif_apack_manifest,
      manifest_descr TYPE /mbtools/manifest,
      dependency     TYPE zif_apack_manifest=>ty_dependency.

    CREATE OBJECT mr_tool EXPORTING i_tool = me.

    apack_manifest = mr_tool->apack_manifest.

    LOOP AT /mbtools/cl_tools=>get_manifests( ) INTO manifest_descr.

      CREATE OBJECT tool TYPE (manifest_descr-class).
      CHECK sy-subrc = 0.

      manifest ?= tool.

      CLEAR dependency.
      dependency-group_id    = manifest->descriptor-group_id.
      dependency-artifact_id = manifest->descriptor-artifact_id.
      dependency-version     = manifest->descriptor-version.
      dependency-git_url     = manifest->descriptor-git_url.
      INSERT dependency INTO TABLE apack_manifest-dependencies.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
