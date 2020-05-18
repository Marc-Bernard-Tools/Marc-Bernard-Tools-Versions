CLASS /mbtools/cl_versions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apack_manifest .

    CONSTANTS c_version TYPE string VALUE '1.0.0' ##NO_TEXT.
    CONSTANTS c_title TYPE string VALUE 'Marc Bernard Tools Version' ##NO_TEXT.

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    ALIASES apack_manifest
      FOR if_apack_manifest~descriptor .
ENDCLASS.



CLASS /MBTOOLS/CL_VERSIONS IMPLEMENTATION.


  METHOD constructor.

    DATA:
      name           TYPE string,
      tool           TYPE REF TO object,
      manifest       TYPE REF TO zif_apack_manifest,
      manifest_descr TYPE /mbtools/manifest,
      manifests      TYPE /mbtools/manifests,
      dependency     TYPE zif_apack_manifest=>ty_dependency.

*   APACK
    apack_manifest = /mbtools/cl_tools=>build_apack_manifest( me ).

    manifests = /mbtools/cl_tools=>get_manifests( ).

    LOOP AT manifests INTO manifest_descr.

      CREATE OBJECT tool TYPE (manifest_descr-class).
      CHECK sy-subrc = 0.

      manifest ?= tool.

      dependency = VALUE #(
        group_id    = manifest->descriptor-group_id
        artifact_id = manifest->descriptor-artifact_id
        version     = manifest->descriptor-version
        git_url     = manifest->descriptor-git_url
      ).

      INSERT dependency INTO TABLE apack_manifest-dependencies.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
