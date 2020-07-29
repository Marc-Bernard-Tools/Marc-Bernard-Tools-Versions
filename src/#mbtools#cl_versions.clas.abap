CLASS /mbtools/cl_versions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
************************************************************************
* MBT Versions
*
* This class is used for showing the versions of all Marc Bernard Tools
* in a public repository on Github:
* https://github.com/mbtools/Marc_Bernard_Tools_Versions
*
* (c) MBT 2020 https://marcbernardtools.com/
************************************************************************

  PUBLIC SECTION.

    INTERFACES if_apack_manifest .

    CONSTANTS:
      BEGIN OF c_tool,
        version     TYPE string VALUE '1.0.0' ##NO_TEXT,
        title       TYPE string VALUE 'Marc Bernard Tools Version' ##NO_TEXT,
        description TYPE string VALUE 'Version Overview for Marc Bernard Tools' ##NO_TEXT,
        bundle_id   TYPE i VALUE 0,
        download_id TYPE i VALUE 0,
      END OF c_tool.

    METHODS constructor .

  PROTECTED SECTION.

  PRIVATE SECTION.

    ALIASES apack_manifest
      FOR if_apack_manifest~descriptor .
ENDCLASS.



CLASS /MBTOOLS/CL_VERSIONS IMPLEMENTATION.


  METHOD constructor.

    DATA:
      ls_manifest   TYPE /mbtools/manifest,
      lt_manifest   TYPE /mbtools/manifests,
      ls_dependency TYPE zif_apack_manifest=>ty_dependency.

    apack_manifest-group_id        = 'github.com/mbtools'.
    apack_manifest-artifact_id     = replace( val = c_tool-title sub = ` ` with = '_' ).
    apack_manifest-version         = c_tool-version.
    apack_manifest-repository_type = 'abapGit'.
    apack_manifest-git_url         = 'https://github.com/mbtools/Marc_Bernard_Tools_Version.git'.
    apack_manifest-target_package  = '/MBTOOLS/BC_VERS'.

    lt_manifest = /mbtools/cl_tools=>get_manifests( ).

    LOOP AT lt_manifest INTO ls_manifest.

      CLEAR ls_dependency.

      IF ls_manifest-is_bundle = abap_true.
        ls_dependency-group_id    = 'github.com/mbtools'.
        ls_dependency-artifact_id = ls_manifest-name.
      ELSE.
        ls_dependency-group_id    = ls_manifest-group_id.
        ls_dependency-artifact_id = ls_manifest-artifact_id.
      ENDIF.
      ls_dependency-version        = ls_manifest-version.
      ls_dependency-git_url        = ls_manifest-git_url.
      ls_dependency-target_package = ls_manifest-package.
      INSERT ls_dependency INTO TABLE apack_manifest-dependencies.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
