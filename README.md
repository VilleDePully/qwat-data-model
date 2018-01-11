# qwat-data-model

[![Build Status](https://travis-ci.org/qwat/qwat-data-model.svg?branch=master)](https://travis-ci.org/qwat/qwat-data-model)

This repository contains the definition of the data model used by [QWAT](https://github.com/qwat/QWAT) project, a module aimed at managing a water network in QGIS.

A full web data model documentation with diagrams and relations is available [here](https://rawgit.com/qwat/qwat-data-model/master/diagram/index.html).

# Model changelog

- v1.3.0 : Switch from custom version control to generic Postgres Update Manager
- v1.2.9 : fix z computation logic for valves
- v1.2.8 : add hardcoded schema_visible field to pipes and valves for enhanced performance on QGIS
- v1.2.7 : AutoPrint Mapview
- v1.2.6 : Fixes issue 177. Pipes where not audited by audit log system.
- V1.2.5 : Adds a scale field to print maps
- v1.2.4 : Fixes bugs when deleting objects https://github.com/qwat/QWAT/issues/174
- v1.2.2 : Integrates the new audit history system. Fixes an issue with multiple primary keys in conformity check procedure
- v1.2.1 : Allow installation type change (done in trigger function generated by submodule meta-project generator).
- v1.2.0 : Simplification of the trigger on views, ie there are no more triggers in cascade generated by the inheritance model. That modification does not affect the data-model code, but the change deserves a change in QWAT version number.
- v1.1.1 : Adds the ability to use post delta files to check auto generated triggers in model
- v1.1.0 : Remove valve inheritance from nodes.
- v1.0.1 : Add functionnal to vl status (meaning the object is ready to be used). This is useful to allow finer printing (print inactive but functional objects)
- v1.0.0 : First version (3 june 2016)
- v0.1 : Proof of concept model
