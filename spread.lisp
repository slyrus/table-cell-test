
(cl:in-package #:table-cell-test)

(defun show-data-frame (clim-stream data-frame)
  (formatting-table (clim-stream)
    (formatting-row (clim-stream)
      (surrounding-output-with-border (clim-stream :background +grey+
                                                   :padding-top 0
                                                   :padding-bottom 0)
        (formatting-cell (clim-stream)
          (princ "id" clim-stream))
        (map nil (lambda (column-name)
                   (formatting-cell (clim-stream)
                     (princ column-name clim-stream)))
             (eu.turtleware.polyclot:cols data-frame))))
    (eu.turtleware.polyclot:map-data-frame-rows
     data-frame t
     (lambda (row-index row)
       (formatting-row (clim-stream)
         (formatting-cell (clim-stream)
           (print row-index clim-stream))
         (eu.turtleware.polyclot:map-data-frame-cols
          data-frame row t
          (lambda (col-index col-name value)
            (declare (ignore col-index col-name))
            (formatting-cell (clim-stream)
              (print value clim-stream)))))))))

(define-application-frame poor-mans-spreadsheet ()
  ((dataframe :initarg :dataframe :reader dataframe))
  (:pane :application :text-margins '(:left 10 :top 5)
   :display-function (lambda (frame pane)
                       (show-data-frame pane (dataframe frame)))))

(run-frame-top-level
 (make-application-frame
  'poor-mans-spreadsheet
  :dataframe
  (eu.turtleware.polyclot:make-data-frame
   '("name" "col1" "col2" "col3")
   '("row1" value1 value2 value3)
   '("row2" value1 value2 value3))))

(defun poor-mans-spreadsheet-pdf ()
  (let* ((filename "/tmp/poor-mans-spreadsheet.pdf"))
    (with-open-file (out filename :direction :output :if-exists :supersede
                         :element-type '(unsigned-byte 8))
      (clim-pdf:with-output-to-pdf-stream (stream out)
        (show-data-frame stream
                         (eu.turtleware.polyclot:make-data-frame
                          '("name" "col1" "col2" "col3")
                          '("row1" value1 value2 value3)
                          '("row2" value1 value2 value3)))))))
