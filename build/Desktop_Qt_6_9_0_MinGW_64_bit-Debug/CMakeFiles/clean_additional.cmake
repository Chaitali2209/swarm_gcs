# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appswarm_gcs_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appswarm_gcs_autogen.dir\\ParseCache.txt"
  "appswarm_gcs_autogen"
  )
endif()
