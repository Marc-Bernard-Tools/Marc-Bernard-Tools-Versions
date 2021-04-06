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

    INTERFACES if_apack_manifest.

    CONSTANTS:
      BEGIN OF c_tool,
        version     TYPE string VALUE '1.0.0' ##NO_TEXT,
        title       TYPE string VALUE 'Marc Bernard Tools Version' ##NO_TEXT,
        description TYPE string VALUE 'Version Overview for Marc Bernard Tools' ##NO_TEXT,
      END OF c_tool.

    METHODS constructor .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS /mbtools/cl_versions IMPLEMENTATION.


  METHOD constructor.

    DATA:
      lv_name       TYPE string,
      ls_manifest   TYPE /mbtools/cl_tools=>ty_manifest,
      lt_manifest   TYPE /mbtools/cl_tools=>ty_manifests,
      ls_dependency TYPE zif_apack_manifest=>ty_dependency.

    lv_name = replace(
      val  = c_tool-title
      sub  = ` `
      with = '-'
      occ  = 0 ).

    if_apack_manifest~descriptor-group_id        = /mbtools/if_definitions=>c_github.
    if_apack_manifest~descriptor-artifact_id     = lv_name.
    if_apack_manifest~descriptor-version         = c_tool-version.
    if_apack_manifest~descriptor-repository_type = 'abapGit'.
    if_apack_manifest~descriptor-git_url         = 'https://' && /mbtools/if_definitions=>c_github && '/' && lv_name.
    if_apack_manifest~descriptor-target_package  = '/MBTOOLS/BC_VERS'.

    lt_manifest = /mbtools/cl_tools=>manifests( ).

    LOOP AT lt_manifest INTO ls_manifest.

      CLEAR ls_dependency.

      ls_dependency-group_id = /mbtools/if_definitions=>c_github.
      ls_dependency-artifact_id = replace(
        val  = ls_manifest-title
        sub  = ` `
        with = '-'
        occ  = 0 ).
      ls_dependency-version        = ls_manifest-version.
      IF ls_manifest-is_bundle IS INITIAL.
        ls_dependency-git_url        = ls_manifest-git_url.
        ls_dependency-target_package = ls_manifest-package.
      ENDIF.
      INSERT ls_dependency INTO TABLE if_apack_manifest~descriptor-dependencies.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
