# Projector

This tiny utility, a quick-and-dirty helper for setting up your 
`local-projects` to projects outside it -- with the help of symlinks.

Usage is demonstrated below what you can append to your quicklisp enabled
 `~/.sbclrc` file, after you've cloned projector into local-projects.

```shell
#+sbcl
(ql:quickload :projector)
(projector:set-dir-local-projects "~/quicklisp/local-projects")

(projector:add-dir-project "~/code/project-A")
(projector:add-dir-project "~/code/project-B")
(projector:add-dir-project "~/code/project-C")

(projector:ensure-linked)

```

---


## Install

#### 1. Git clone into your quicklisp's local-project directory.

```shell
cd quicklisp/local-projects
```

```shell
git clone https://github.com/grantsform/projector
```

#### 2. Install via Ultralisp.

Assuming you already have Quicklisp up-and-running, make sure you setup [Ultralisp](https://ultralisp.org) --


Then the following should be ran from your quicklisp enabled repl:

```lisp
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
```

```lisp
(ql:update-all-dists)
```

```lisp
(ql:quickload :projector)