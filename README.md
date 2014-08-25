# README

## List of dependencies

* node.js (v0.10.15)
* npm (1.3.5)
* bower (1.2.5)
* grunt-cli (v0.1.9)
* grunt (v0.4.1)
* sass (3.2.7)


## Project installation

To install the project, simply type:

`` $ npm install ``

…and…

`` $ bower install ``

This should install all dependencies necessary for running the project.


## Running the server for local development

To run the server just type on the shell:

`` $ grunt server ``

This will run the server and also open the home page of the project on ``localhost:9000`` on your browser.


## Commiting code to the codebase

To create the final files for commit, use:

`` $ grunt build ``

**IMPORTANT:** You should always commit all files on the repository, by doing:

`` $ git add . && git commit -a ``

This will add all files and remove all deleted files from the repository at the end of the build process.

## Credits

**Development:** Open Knowledge and Open Knowledge Brasil

**Project by:** FGV-DAPP

## License

See ``LICENSE.txt``.
