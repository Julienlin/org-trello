(require 'ert)
(require 'ert-expectations)
(require 'el-mock)

(expectations
  (expect "hello there\nhow are you today\nthis is a hell of a ride" (orgtrello-buffer/filter-out-properties ":PROPERTIES:
:orgtrello-id: 52c945143004d4617c012528
:END:
hello there
how are you today
this is a hell of a ride"))
  (expect "hello there\nhow are you today\nthis is a hell of a ride" (orgtrello-buffer/filter-out-properties "hello there
how are you today
this is a hell of a ride")))

(expectations (desc "orgtrello-buffer/extract-description-from-current-position! - standard org-trello properties without blanks before them.")
  (expect "hello there"
    (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
:PROPERTIES:
:orgtrello-id: 52c945143004d4617c012528
:END:
hello there
"
      (orgtrello-buffer/extract-description-from-current-position!)))

    (expect "hello there"
      (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
:PROPERTIES:
:orgtrello-id: 52c945143004d4617c012528
:END:
hello there
- [-] LISP family   :PROPERTIES: {\"orgtrello-id\":\"52c945140a364c5226007314\"}
  - [X] Emacs-Lisp  :PROPERTIES: {\"orgtrello-id\":\"52c9451784251e1b260127f8\"}
  - [X] Common-Lisp :PROPERTIES: {\"orgtrello-id\":\"52c94518b2c5b28e37012ba4\"}"
       (orgtrello-buffer/extract-description-from-current-position!)))

    (expect "hello there\n"
      (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
:PROPERTIES:
:orgtrello-id: 52c945143004d4617c012528
:END:

hello there

- [-] LISP family   :PROPERTIES: {\"orgtrello-id\":\"52c945140a364c5226007314\"}
  - [X] Emacs-Lisp  :PROPERTIES: {\"orgtrello-id\":\"52c9451784251e1b260127f8\"}
  - [X] Common-Lisp :PROPERTIES: {\"orgtrello-id\":\"52c94518b2c5b28e37012ba4\"}"
       (orgtrello-buffer/extract-description-from-current-position!)))

    (expect nil
      (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES" (orgtrello-buffer/extract-description-from-current-position!)))

    (expect ""
      (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
:PROPERTIES:
:orgtrello-id: 52c945143004d4617c012528
:END:
- [-] LISP family   :PROPERTIES: {\"orgtrello-id\":\"52c945140a364c5226007314\"}"
       (orgtrello-buffer/extract-description-from-current-position!))))

(expectations (desc "orgtrello-buffer/extract-description-from-current-position! - non standard org-trello properties with blanks before them.")
  (expect "hello there"
    (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
 :PROPERTIES:
 :orgtrello-id: 52c945143004d4617c012528
 :END:
hello there
"
      (orgtrello-buffer/extract-description-from-current-position!)))

    (expect "hello there"
      (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
 :PROPERTIES:
 :orgtrello-id: 52c945143004d4617c012528
    :END:
hello there
- [-] LISP family   :PROPERTIES: {\"orgtrello-id\":\"52c945140a364c5226007314\"}
  - [X] Emacs-Lisp  :PROPERTIES: {\"orgtrello-id\":\"52c9451784251e1b260127f8\"}
  - [X] Common-Lisp :PROPERTIES: {\"orgtrello-id\":\"52c94518b2c5b28e37012ba4\"}"
       (orgtrello-buffer/extract-description-from-current-position!)))

    (expect "hello there\n"
      (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
  :PROPERTIES:
         :orgtrello-id: 52c945143004d4617c012528
  :END:

hello there

- [-] LISP family   :PROPERTIES: {\"orgtrello-id\":\"52c945140a364c5226007314\"}
  - [X] Emacs-Lisp  :PROPERTIES: {\"orgtrello-id\":\"52c9451784251e1b260127f8\"}
  - [X] Common-Lisp :PROPERTIES: {\"orgtrello-id\":\"52c94518b2c5b28e37012ba4\"}"
       (orgtrello-buffer/extract-description-from-current-position!)))
    (expect ""
      (orgtrello-tests/with-temp-buffer "* TODO Joy of FUN(ctional) LANGUAGES
  :PROPERTIES:
 :orgtrello-id: 52c945143004d4617c012528
:END:
- [-] LISP family   :PROPERTIES: {\"orgtrello-id\":\"52c945140a364c5226007314\"}"
                                        (orgtrello-buffer/extract-description-from-current-position!))))

(expectations (desc "orgtrello-buffer/filter-out-properties - removing lines starting with org-trello metadata properties.")
  (expect "no filter happens here." (orgtrello-buffer/filter-out-properties "no filter happens here."))
  (expect "no filter happens here." (orgtrello-buffer/filter-out-properties "   no filter happens here."))
  (expect "" (orgtrello-buffer/filter-out-properties ":PROPERTIES: filter happens and blank is left."))
  (expect "" (orgtrello-buffer/filter-out-properties "  :PROPERTIES: filter still happens and blank is left."))
  (expect "multiple lines\n" (orgtrello-buffer/filter-out-properties "  multiple lines\n  :PROPERTIES: filter still happens and blank is left.")))

(expectations
 (expect "some-comments###with-dummy-data"
         (orgtrello-tests/with-temp-buffer
          "* card
:PROPERTIES:
:orgtrello-card-comments: some-comments###with-dummy-data
:END:"
          (orgtrello-buffer/get-card-comments!))))