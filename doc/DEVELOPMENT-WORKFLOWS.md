# Development Workflow #


## Directories ##

* Our own extensions are in subdirectories of `own`.
* 

## Workflow ##

The workflow is supported using vscode tasks defined in .vscode and available in task manager. The shaded areas below reference such tasks.

### Preparations ###
Execute the following **vscodium tasks**:
* `generate image lap` 
* `generate image my-mysql` 
* `generate volume full` 
* `run lap and my-mysql containers` 
* `initialize mediawiki`

### Edit Cycle ###
* **Add** files to `volumes/full/spec/git-init.sh`
* **Execute** task `get dante modifications from github`
* **Edit** directly in directory `full`
* **Save** files & check results in browser
* **Execute** task `push changes to dante modifications on github`


## References ##

* https://stackoverflow.com/questions/4659549/maintain-git-repo-inside-another-git-repo
* https://git-scm.com/book/en/v2/Git-Tools-Submodules


