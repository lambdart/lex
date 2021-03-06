;;; lex-eval.el --- eval extensions -*- lexical-binding: t -*-
;;
;; Author: lambdart <lambdart@protonmail.com>
;; Maintainer: lambdart
;; Version: 0.0.4 Alpha
;; URL: https://github.com/lambdart/lex
;; Keywords: command-history elisp eval
;;
;; This file is NOT part of GNU Emacs.
;;
;;; MIT License
;;
;; Copyright (c) 2020 lambdart
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
;;
;;; Commentary:
;;
;; This library provides a way to interact with the `command-history',
;; using the `minibuffer' (command prompt) directly, its a mistake to
;; hide the lisp (elisp dialect) from its user, this simple approach
;; brings a lot of weariness of what is really goin' on inside your
;; lisp machine.
;;
;; 'Simple and powerful.'
;;
;;; Code:

(require 'subr-x)

(defun command-history-collection ()
  "Return \\[command-history] completion table (collection)."
  (let ((size (length command-history))
        (command nil)
        (collection '()))
    ;; get collection loop
    (dotimes (i size)
      (setq command (prin1-to-string (nth i command-history)))
      (when (not (or (string-empty-p command)
                     ;; ignore closure commands
                     (equal (string-match "^((" command) 0)))
        (push command collection)))
    ;; return collection
    collection))

;;;###autoload
(defun eval-command-history ()
  "Eval previous command using `command-history'."
  (interactive)
  (let ((command
         (completing-read
          "Eval: " (command-history-collection) nil 'confirm "(" `(command-history))))
    ;; necessary?
    (save-restriction
      ;; save point
      (push-mark (point))
      ;; read and eval the command
      (eval (read command)))))

(provide 'lex-eval)

;;; lex-eval.el ends here
