(defpackage :projector
  (:use :cl :uiop)
  (:export :set-dir-local-projects
           :add-dir-project
           :ensure-linked))

(in-package :projector)

(defvar *local-projects-dir* nil
  "Directory into which project symlinks will be created.")

(defvar *project-dirs* nil
  "List of directories the user has registered with add-dir-project.")

(defun ensure-dir-exists (path)
  "Create PATH and any parent directories using mkdir -p.
This is a portable fallback when UIOP helpers aren't exported."
  (let ((dir (truename path)))
    (unless (probe-file dir)
      (uiop:run-program (list "mkdir" "-p" (namestring dir))
                        :silent t))
    dir))

(defun set-dir-local-projects (path)
  "Remember the directory where local projects should live.
The argument PATH is a string or pathname; it is stored as a
truename and the directory is created if it doesn't already exist."
  (let ((dir (ensure-dir-exists path)))
    (setf *local-projects-dir* dir)
    (format t "[projector] local-projects directory set to ~A~%" dir)))

(defun add-dir-project (path)
  "Register a project directory to be linked later.
The path is stored as a truename with any trailing slash removed."
  (let ((dir (truename path)))
    (unless (member dir *project-dirs* :test #'equal)
      (push dir *project-dirs*))
    (format t "[projector] added project directory ~A~%" dir)))

(defun ensure-linked ()
  "Create symlinks for each registered project inside the
*local-projects-dir*.
Existing links are left alone; if a link points somewhere else it is
replaced.  If the target already exists and is not a symlink, an
error is signaled."
  (unless *local-projects-dir*
    (error "Local projects directory has not been set. Use set-dir-local-projects."))
  (ensure-dir-exists *local-projects-dir*)
  (dolist (src *project-dirs*)
    (when (probe-file src)
      (let* ((tru (truename src))
             (name (or (pathname-name tru)
                       (car (last (pathname-directory tru)))))
             (link (merge-pathnames name *local-projects-dir*)))
        (cond
          ((probe-file link)
           (let ((target (ignore-errors (sb-posix:readlink (namestring link)))))
             (cond
               ((null target)
                ;; exists but not a symlink
                (error "~A already exists and is not a symlink" link))
               ((not (equal (truename target) tru))
                ;; wrong symlink, replace
                (delete-file link)
                (sb-posix:symlink (namestring tru) (namestring link))))))
          (t
           ;; link does not exist at all
           (sb-posix:symlink (namestring tru) (namestring link))))))
  (format t "[projector] ensure-linked finished~%")))
