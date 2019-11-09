
(cl:defpackage #:table-cell-test
  (:use #:clim-extensions #:clim #:clim-lisp))

(cl:in-package #:table-cell-test)

(defun draw-table (stream)
  (draw-rectangle* stream 10 10 400 400 :ink +light-green+)
  (setf (stream-end-of-line-action stream) :wrap*)
  (formatting-table (stream :x-spacing 5)
    (dotimes (row 5)
      (formatting-row (stream)
        (dotimes (cell 5)
          (formatting-cell (stream :min-height 24 :min-width 100)
            (draw-rectangle* stream 10 10 40 40 :ink +lightsalmon+)
            (clime:with-temporary-margins (stream :left 0 :right 100)
              (format stream "This is some very long text that should wrap. row ~s, cell ~s" row cell))))))))

(defclass table-cell-test-pane (application-pane) ())

(defun display-table (frame pane)
  (declare (ignore frame))
  (draw-table pane))

(define-application-frame table-cell-test-app () ()
  (:panes
   (table-cell-test (make-pane 'table-cell-test-pane
                          :width 200
                          :height 200
                          :display-time nil
                          :display-function #'display-table)))
  (:layouts
   (default table-cell-test)))

(defvar *table-cell-test-app*)

(defun table-cell-test-app-main (&key (new-process t))
  (flet ((run ()
           (let ((frame (make-application-frame 'table-cell-test-app)))
             (setf *table-cell-test-app* frame)
             (run-frame-top-level frame))))
    (if new-process
        (clim-sys:make-process #'run :name "Table-Cell-Test App")
        (run))))

(defun table-cell-test-pdf ()
  (let* ((filename "/tmp/table-cell-test.pdf"))
    (with-open-file (out filename :direction :output :if-exists :supersede
                         :element-type '(unsigned-byte 8))
      (clim-pdf:with-output-to-pdf-stream (stream out)
        (draw-table stream)))))

;;
;; To run the app, do:
;;   (table-cell-test::table-cell-test-app-main)
;;
;; To test the pdf, do:
;;   (table-cell-test-pdf)

(table-cell-test-pdf)
