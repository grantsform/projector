# Projector

This tiny utility, a quick-and-dirty helper for setting up your 
`local-projects` to projects outside it -- with the help of symlinks.

Usage is demonstrated below what you can append to your quicklisp enabled
 `~/.sbclrc` file, after you've cloned projector into local-projects.


```
#+sbcl
(ql:quickload :projector)
(projector:set-dir-local-projects "~/quicklisp/local-projects")

(projector:add-dir-project "~/code/project-A")
(projector:add-dir-project "~/code/project-B")
(projector:add-dir-project "~/code/project-C")

(projector:ensure-linked)

```