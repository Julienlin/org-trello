(require 'org-trello-log)

(ert-deftest test-orgtrello-log-msg ()
  ;; no log whatsoever except for error
  (should-not (let ((orgtrello-log-level orgtrello-log-no-log))
                (orgtrello-log-msg orgtrello-log-trace "trace message")))
  (should-not (let ((orgtrello-log-level orgtrello-log-no-log))
                (orgtrello-log-msg orgtrello-log-debug "debug message")))
  (should-not (let ((orgtrello-log-level orgtrello-log-no-log))
                (orgtrello-log-msg orgtrello-log-info "info message")))
  (should-not (let ((orgtrello-log-level orgtrello-log-no-log))
                (orgtrello-log-msg orgtrello-log-warn "warn message")))
  (should (string= "org-trello - error message"
                   (let ((orgtrello-log-level orgtrello-log-no-log))
                     (orgtrello-log-msg orgtrello-log-error "error message"))))
  (should-not (let ((orgtrello-log-level orgtrello-log-debug))
                (orgtrello-log-msg orgtrello-log-trace "trace message")))
  (should (string= "org-trello - debug message"
                   (let ((orgtrello-log-level orgtrello-log-debug))
                     (orgtrello-log-msg orgtrello-log-debug "debug message"))))
  (should (string= "org-trello - info message should not be displayed."
                   (let ((orgtrello-log-level orgtrello-log-debug))
                     (orgtrello-log-msg orgtrello-log-info "info message should not be displayed."))))
  (should (string= "org-trello - warn message"
                   (let ((orgtrello-log-level orgtrello-log-debug))
                     (orgtrello-log-msg orgtrello-log-warn "warn message"))))
  (should (string= "org-trello - error message always"
                   (let ((orgtrello-log-level orgtrello-log-debug))
                     (orgtrello-log-msg orgtrello-log-error "error message always"))))
  ;; edge cases about special character escape (%)
  (should (string= "org-trello - done 95% of work"
                   (let ((orgtrello-log-level orgtrello-log-info))
                     (orgtrello-log-msg orgtrello-log-info "done 95% of work"))))
  (should (string= "org-trello - Hi there! You have done 95% of the work at 2018/03/31 07:34:48"
                   (with-mock
                     (mock (format-time-string "%Y/%m/%d %H:%M:%S") => "2018/03/31 07:34:48")
                     (let ((orgtrello-log-level orgtrello-log-info))
                       (orgtrello-log-msg orgtrello-log-info "Hi there! You have done 95% of the work at %s" (format-time-string "%Y/%m/%d %H:%M:%S")))))))

(provide 'org-trello-log-test)
;;; org-trello-log-test.el ends here
