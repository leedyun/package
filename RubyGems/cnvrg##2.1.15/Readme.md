
## Version v1.11.15
2021-03-30
* DEV-208 - Task: Make sure the index name is constant over days
* DEV-7555 - Bug: CLI: Error message is not correct when run a flow after removing the permission from Template.
* DEV-7800 - New Feature: FR - add stdout to CLI logs (for logging in kibana etc.)
* DEV-7928 - Bug: CLI - cnvrg clone doesnt show log message when files not found
* DEV-7956 - Bug: CLI crashes from progressbar
* DEV-8006 - Bug: Cli- cnvrg data put ,slash in the end url path will cause unique index error
* DEV-8007 - Bug: Cli- Cnvrg data clone failed sometimes to load sts, there for clone crashed
* DEV-8159 - New Feature: Oauth Proxy
* DEV-8179 - New Feature: Add auto cache and link files in cache clone
* DEV-8208 - Bug: Cli - cnvrg data put fails
* DEV-8284 - Improvement: Use server instead of docker for agent communication
* DEV-8434 - Bug: Rerun of experiment in git project doesn't show artifacts
* DEV-8539 - Bug: SDK - in windows: e.sync doesnt perform sync
* DEV-8621 - Improvement: Add more metrics 
## Version v1.11.30
2021-04-06
## Version v1.11.31
2021-04-22
## Version v1.11.32
2021-05-05
* DEV-8868 - Bug: SDK - e.sync() in git project only creates empty "output" folder in commit
## Version v2.0.1
2021-06-13
## Version v2.0.2
2021-06-16
* DEV-9694 - Bug: Download artifacts fails on authorization error 
## Version v2.0.3
2021-06-29
* DEV-9919 - Bug: clone artifacts fails on "Not Authorize, Are you logged in?"
## Version v2.0.4
2021-07-08
* DEV-9935 - Bug: CLI - cnvrg sync creates new commit but no blob versions
## Version v2.0.5
2021-07-11
* DEV-10171 - Bug: experiment randomly fails with error- "Couldn't clone artifacts"
* DEV-10189 - Bug: CLI Sync -file/folder with broken symlink will cause sync to fail
## Version v2.0.6
2021-07-18
* DEV-10209 - Bug: some experiments in grid failed on cnvrg-cli commands (docker container id was missing)
## Version v2.0.7
2021-07-27
* DEV-10186 - Bug: CLI/run an experiment with --local tag giver server error
## Version v2.0.8
2021-09-06
* DEV-10697 - Bug: Tensorboard not starting in workspace and experiment.
## Version v2.0.9
2021-09-12
* DEV-10502 - Bug: Periodic sync stuck
## Version v2.0.10
2021-09-12
* DEV-10502 - Bug: Periodic sync stuck
## Version v2.0.11
2021-10-21
## Version v2.0.12
2021-10-25
* DEV-11544 - Sub-bug: local experiment is failing to run 
## Version v2.0.13
2021-10-27
* DEV-11054 - Task: Create organization and user by default
## Version v2.0.14
2021-11-11
* DEV-11834 - Sub-task: add device name to hpu metrics
## Version v2.0.15
2021-12-12
* DEV-12316 - Improvement: cli login should identify saas users automatically
## Version v2.0.16
2021-12-16
* DEV-12316 - Improvement: cli login should identify saas users automatically
## Version v2.0.17
2021-12-19
* DEV-10581 - Bug: CLI - getting 404 response in "cnvrg set_default_owner"
## Version v2.0.18
2022-01-31
* DEV-12637 - Bug: Dataset - creating file from CLI/SDK in a folder with + sign, replaces + with space AND creates 2 folders
## Version v2.0.19
2022-02-22
* DEV-13271 - Bug: CLI - on upload folders in working dir containing .cnvrg, dir not uploading - dir is on .cnvrgignore
## Version v2.0.20
2022-02-27
* DEV-12288 - Bug: wrong error message when upload fails
## Version v2.1.1
2022-05-01
## Version v2.1.2
2022-05-08
* DEV-13815 - Bug: CLI - remove "cnvrg data sync" command
## Version v2.1.3
2022-05-16
* DEV-13981 - Bug: CLI - dataset query clone stuck at 50% then "Killed"
## Version v2.1.4
2022-05-22
* DEV-14182 - Bug: Cli - hide 'data upload' command
## Version v2.1.5
2022-07-31
* DEV-14244 - Bug: CLI - "failed to upload ongoing stats" due to NaN in float
* DEV-14633 - Bug: End sync did not complete, causing the experiment to get stuck in "terminating"
## Version v2.1.6
2022-08-09
* DEV-14682 - Bug: git-Walki: CLI/SDK experiments goes into debug mode for Github+SSH integrated projects
## Version v2.1.7
2022-08-24
* DEV-15229 - Bug: CLI - warnings from faraday gem when running any CLI command
## Version v2.1.8
2022-09-04
* DEV-15473 - Bug: CLI - Errors while cloning a project that has file containing spaces in their names 
## Version v2.1.9
2022-09-06
* DEV-15423 - Bug: Workspace - Jupyter process gets killed
* DEV-15451 - Bug: CLI - sync error "undefined method `encode' for nil:NilClass" on GCP storage
## Version v2.1.10
2022-10-26
* DEV-15858 - Bug: Tensorboard compare - ongoing experiments' artifacts aren't cloned to session
## Version v2.1.11
2022-11-03
* DEV-16090 - Bug: Tensorboard compare - webapp gets stuck in "init" state 
## Version v2.1.12
2022-11-09
* DEV-15972 - Bug: Customer cannot use dataset query due to ssl error
## Version v2.1.13
2023-03-05
* DEV-16372 - Epic: Cli V2 release - phase 1
h2. 🎯 Objective

Release v2 of cnvrg cli and deprecate the old version

h2. 🤔 Assumptions

# *Docs will be released (joint effort of tech writer, support and dev)*
# *cnvrg:v6 image will be released (with updated python version)*
# *All issues on High & Highest priority n sdk-productionize fixVersion will be resolved*
# *QA tests will be performed in different set ups (aks/eks/gke, windows device, mac m1)*


Note: this is not the most detailed epic, as most things already exist in cliv1 or sdkv2. for any questions please contact [~accountid:5fb5461f4a09640069dbf768] 
* DEV-16372 - Epic: Cli V2 release - phase 1
h2. 🎯 Objective

Release v2 of cnvrg cli and deprecate the old version

h2. 🤔 Assumptions

# *Docs will be released (joint effort of tech writer, support and dev)*
# *cnvrg:v6 image will be released (with updated python version)*
# *All issues on High & Highest priority n sdk-productionize fixVersion will be resolved*
# *QA tests will be performed in different set ups (aks/eks/gke, windows device, mac m1)*


Note: this is not the most detailed epic, as most things already exist in cliv1 or sdkv2. for any questions please contact [~accountid:5fb5461f4a09640069dbf768] 
## Version v2.1.14
2023-05-29
* DEV-18350 - Bug: Error occured, undefined method `[]' for false:FalseClass is displayed when running any command inside the debug mode of experiment
## Version v2.1.15
2023-05-31
* DEV-19363 - Bug: cli not compatible with v5